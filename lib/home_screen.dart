import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'daftar_baru.dart';
import 'main_app/main_app_home_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_app/models/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  dynamic _userData;
  String _token;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainAppHomeScreen(currentUserId: prefs.getString('id'))),
      );
    } else {
      _checkIfIsLogged();
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result =
          await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(firebaseUser.uid).setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => MainAppHomeScreen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  _printCredentials(LoginResult result) {
    _token = result.accessToken.token;
    print("userId: ${result.accessToken.userId}");
    print("token: $_token");
    print("expires: ${result.accessToken.expires}");
    print("grantedPermission: ${result.grantedPermissions}");
    print("declinedPermissions: ${result.declinedPermissions}");
  }

  _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.isLogged;
    if (accessToken != null) {
      print("is Logged");
      _token = accessToken.token;
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields:"email,birthday");
      setState(() {
        _userData = userData;
      });
    }
  }

  _login() async {
     final result = await FacebookAuth.instance.login();
    // final result = await FacebookAuth.instance.login(permissions:['email','user_birthday']);

    switch (result.status) {
      case FacebookAuthLoginResponse.ok: // result.status == 200
        _printCredentials(result);
        // get the user data
        final userData = await FacebookAuth.instance.getUserData();
        // final userData = await _fb.getUserData(fields:"email,birthday");
        setState(() {
          _userData = userData;
        });
        break;
      case FacebookAuthLoginResponse.cancelled: // result.status == 403
        print("login cancelled");
        break;
      default: // result.status == 500
        print("login failed");
    }
  }

  _logOut() async {
    await FacebookAuth.instance.logOut();
    _token = null;
    setState(() {
      _userData = null;
    });
  }

  _checkPermissions() async {
   final FacebookAuthPermissions response =
        await FacebookAuth.instance.permissions(_token);
    print("permissions granted: ${response.granted}");
    print("permissions declined: ${response.declined}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        left: 16,
                        right: 16),
                    child: Image.asset('assets/images/inviteImage.png', height: 300,),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'FAMILY HUB V.0.0.1',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: const Text(
                      'silahkan login dulu bro & sis ...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  //_buildLogin(),
                  //_buildPassw(),
                  /*Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                offset: const Offset(4, 4),
                                blurRadius: 8.0),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              //FocusScope.of(context).requestFocus(FocusNode());
                              /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MainAppHomeScreen()));*/
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'MASUK',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                */
              SignInButtonBuilder(
            text: 'Sign In with Email',
            icon: Icons.email,
            onPressed: () {
              //
            },
            backgroundColor: Colors.blueGrey[700],
            width: 220.0,
          ),
          Divider(),
          SignInButton(
            Buttons.GoogleDark,
            onPressed: handleSignIn,
          ),
          Divider(),
          SignInButton(
            Buttons.Facebook,
            onPressed: (){} //facebookLogin,
          ),
          Divider(),
          SignInButton(
            Buttons.Twitter,
            text: "Sign in with Twitter",
            onPressed: () {
              //
            },
          ),
                  FlatButton(
              child: Text(
                "belum punya akun ?\n[ klik disini untuk mendaftar ]",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.withOpacity(0.6)),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
              color: Colors.transparent,
              onPressed: () {
                /*Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return DaftarBaru();
                    },
                    fullscreenDialog: true));*/
              })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                //offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.only(left:10, right:10, top:4, bottom:4),
            //constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            //child: SingleChildScrollView(
            //  padding:
            //      const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: 1,
                onChanged: (String txt) {},
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.dark_grey,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Isikan Email Anda yg terdaftar ...'),
              ),
            //),
          ),
        ),
      ),
    );
  }

  Widget _buildPassw() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                //offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.only(left:10, right:10, top:4, bottom:4),
            //constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            //child: SingleChildScrollView(
            //  padding:
            //      const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: 1,
                onChanged: (String txt) {},
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.dark_grey,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'isikan Password yg sesuai ...'),
              ),
            //),
          ),
        ),
      ),
    );
  }
}
