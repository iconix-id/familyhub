//import 'dart:html';
import 'package:flutter/material.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'main_app/models/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';
import 'daftar_baru.dart';
import 'main_app/main_app_home_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //final FacebookLogin facebookSignIn = FacebookLogin();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

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
        MaterialPageRoute(
            builder: (context) =>
                MainAppHomeScreen(currentUserId: prefs.getString('id'))),
      );
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

    //suksesLogin(credential);
    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainAppHomeScreen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  /*Future<Null> facebookLogin() async {
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        /*final AuthResult authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        FirebaseUser user = authResult.user;*/
        //suksesLogin(credential);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }*/

  void suksesLogin(AuthCredential credential) async {
      FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainAppHomeScreen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
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
                    child: Image.asset(
                      'assets/images/inviteImage.png',
                      height: 300,
                    ),
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
                      'silahkan Login dulu bro & sis...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  /*_buildLogin(),
                  _buildPassw(),
                  Padding(
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
                  ),*/
                  SizedBox(height: 8.0,),
                  /*Center(
                    child: FlatButton(
                        onPressed: handleSignIn,
                        child: Text(
                          'SIGN IN WITH GOOGLE',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        color: Color(0xffdd4b39),
                        highlightColor: Color(0xffff7f7f),
                        splashColor: Colors.transparent,
                        textColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
                  ),*/
                  SignInButtonBuilder(
            text: 'Get going with Email',
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5.0),
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
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
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
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
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
