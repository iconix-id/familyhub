import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import '../../main.dart';
import '../main_app_theme.dart';
import 'ubah_pass.dart';
import 'ubah_profil.dart';
//import 'package:date_format/date_format.dart';
//import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';
//import 'dart:convert';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:location/location.dart';
import './task_row.dart';

class AccountInfoScreen extends StatefulWidget {
  final List<String> userData;
  final String currentUserId;
  AccountInfoScreen(this.userData, this.currentUserId);
  
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class UserLocation {
  double latitude;
  double longitude;

  UserLocation({this.latitude, this.longitude});
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static UserLocation currentLocation;
  //static var location = Location();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;
  final double _imageHeight = 256.0;
  String deposit, poinx, poinz;
  String stail1, stail2;
  var sisapaket;
  String norm;

  @override
  void initState() {
    getLocation();
    setUser();
    super.initState();
    //initPushNotif();
    //loadDpsPr();
    //loadSisaPkt();
  }

  void setUser() async {
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    //final String jnsuser = prefs.getString('jnsuser');
  }

  void initPushNotif(jnsuser){
    /*_firebaseMessaging.getToken().then((token){
      print('Device Token after Login : '+token);
      saveDeviceToken(token,jnsuser);
    });
    _firebaseMessaging.subscribeToTopic("semua_topik");*/
  }

  void saveDeviceToken(String token, String jnsuser) async {
    /*await http.post(remoteURL + 'simpan_token_dart.php', body: {
      "token": token,
      "norm": widget.userData[1],
      "jnsuser": jnsuser,
      "loklat": currentLocation.latitude.toString(),
      "loklgt": currentLocation.longitude.toString(),
    }).then((res){
      String isres = res.body;
      print('$isres -> token device berhasil disimpan');
      //print(currentLocation.latitude.toString()+' -> lokasi berhasil disimpan');
    }).catchError((err) {
      print(err);
    });*/
  }

  static Future<UserLocation> getLocation() async {
    /*try {
      var userLocation = await location.getLocation();
      currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    //print('lokasi lat : '+currentLocation.latitude.toString());
    return currentLocation;*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainAppTheme.white.withOpacity(0.8),
      appBar: AppBar(
        title: Text("Data Pribadi", style: TextStyle(color: Colors.black, fontFamily: MainAppTheme.fontName, fontWeight: FontWeight.w700,)),
        backgroundColor: MainAppTheme.nearlyWhite,
      ),
      body: Stack(
        children: <Widget>[
          _buildTimeline(),
          _buildImage(),
          _buildProfileRow(),
          _buildBottomPart(),
          //_buildButtonEdit()
        ],
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: <Widget>[
            float1(), float2(), float3(), float4(), float5()
        ],
        colorStartAnimation: Colors.red,
        colorEndAnimation: Colors.yellow,
        animatedIconData: AnimatedIcons.menu_close
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildImage() {
    return Container(
        decoration: BoxDecoration(
          color: MainAppTheme.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 3,
                offset: const Offset(2, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipPath(
      //clipper: DialogonalClipper(),
      child: Image.asset(
        'assets/main_app/bg-anggrek.jpg',
        fit: BoxFit.fitHeight,
        height: _imageHeight,
        colorBlendMode: BlendMode.luminosity,
        color: Color.fromARGB(180, 164, 170, 160),
      ),
    )
    );
  }

  Widget _buildProfileRow() {
    var jnsgbr;
      if (widget.userData[6] == 'L') {
        jnsgbr = AssetImage('assets/main_app/male2.png');
      } else {
        jnsgbr = AssetImage('assets/main_app/female.png');
      }
      //jnsgbr = AssetImage('assets/main_app/male2.png');
    
    List nampas = widget.userData[2].split(" ");
    String teksnama;
    if (nampas.length==1){ teksnama = nampas[0]; }
    else { teksnama = nampas[0]+' '+nampas[1]; }  

    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: _imageHeight/8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            minRadius: 68.0,
            maxRadius: 68.0,
            backgroundImage: jnsgbr,
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  teksnama.toUpperCase(),
                  style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'Terdaftar sejak : ' + widget.userData[7],
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyTasksHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 64.0, top: 20, bottom: 20,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Assalamualaikum,',
            style: TextStyle(
                fontSize: 24.0, fontWeight: FontWeight.w400, color: Colors.red),
          ),
          Text('Bogor, 04 Juni 2020 - 08.30 WIB',
            //formatDate(new DateTime.now(),
            //    [d, ' ', MM, ' ', yyyy, ' ', HH, ':', nn, ':', ss]),
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
        
  Widget _buildTasksList() {
    List<Task> tasks = [
      Task(
        name: widget.userData[0],
        category: "Keturunan",
        color: Colors.red,
      ),
      Task(
        name: widget.userData[4] + " / " + widget.userData[5],
        category: "Tempat/Tgl Lahir",
        color: Colors.orange,
      ),
      Task(
        name: widget.userData[8] + ", " + widget.userData[9],
        category: "Alamat Rumah",
        color: Colors.yellow,
      ),
      Task(
        name: widget.userData[10],
        category: "No.Telpon/HP",
        color: Colors.cyan,
      ),
      Task(
        name: widget.userData[3],
        category: "Email Terdaftar",
        color: Colors.lightBlue,
      ),
      Task(
        name: 'Sudah Menikah',
        category: "Status Nikah",
        color: Colors.blueGrey,
      ),
      Task(
        name: 'Wiraswasta',
        category: "Pekerjaan",
        color: Colors.grey,
      ),
    ];

    return Expanded(
      child: ListView(
        children: tasks.map((task) => TaskRow(task: task)).toList(),
      ),
    );
  }

  Widget _buildBottomPart() {
    return Padding(
      padding: EdgeInsets.only(top: _imageHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Positioned(
      top: 0.0,
      bottom: 10.0,
      left: 32.0,
      child: Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  Widget float1() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,  // biar gak bikin error saat diklik
        onPressed: null,
        tooltip: 'Setting',
        child: Icon(Icons.settings),
        backgroundColor: Colors.red,
      ),
    );
  }
  Widget float2() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return UbahPassDialog(widget.userData[3],widget.userData[1]);
                  },
                  fullscreenDialog: true));
            },
        tooltip: 'Ubah Password',
        child: Icon(Icons.https),
        backgroundColor: Colors.red,
      ),
    );
  }
  Widget float3() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return UbahProfilDialog(widget.userData);
                  },
                  fullscreenDialog: true));
            },
        tooltip: 'Edit Profil',
        child: Icon(Icons.face),
        backgroundColor: Colors.red,
      ),
    );
  }
  Widget float4() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: null,
        tooltip: 'Share Info',
        child: Icon(Icons.share),
        backgroundColor: Colors.red,
      ),
    );
  }
  Widget float5() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: (){
          openDialog();
        },
        tooltip: 'Logout',
        child: Icon(Icons.exit_to_app),
        backgroundColor: Colors.red,
      ),
    );
  }

  /*Widget _buildButtonEdit() {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: MediaQuery.of(context).size.width-90),
      child: Column(
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              //
            },
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            shape: CircleBorder(),
            elevation: 1.0,
            fillColor: Colors.red[800],
            padding: const EdgeInsets.all(10.0),
          ),
          SizedBox(
            width: 2.0,
            height: 5.0,
          ),
          RawMaterialButton(
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return UbahPassDialog(widget.userData[3],widget.userData[1]);
                  },
                  fullscreenDialog: true));
            },
            child: Icon(
              Icons.https,
              color: Colors.white,
              size: 25.0,
            ),
            shape: CircleBorder(),
            elevation: 1.0,
            fillColor: Colors.red[800],
            padding: const EdgeInsets.all(10.0),
          ),
          SizedBox(
            width: 2.0,
            height: 5.0,
          ),
          RawMaterialButton(
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return UbahProfilDialog(widget.userData);
                  },
                  fullscreenDialog: true));
            },
            child: Icon(
              Icons.face,
              color: Colors.white,
              size: 25.0,
            ),
            shape: CircleBorder(),
            elevation: 1.0,
            fillColor: Colors.red[800],
            padding: const EdgeInsets.all(10.0),
          ),
          SizedBox(
            width: 2.0,
            height: 5.0,
          ),
          RawMaterialButton(
            onPressed: () {
              //
            },
            child: Icon(
              Icons.share,
              color: Colors.white,
              size: 25.0,
            ),
            shape: CircleBorder(),
            elevation: 1.0,
            fillColor: Colors.red[800],
            padding: const EdgeInsets.all(10.0),
          ),
          SizedBox(
            width: 2.0,
            height: 5.0,
          ),
          RawMaterialButton(
            onPressed: () {
              //handleSignOut();
              openDialog();
            },
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 25.0,
            ),
            shape: CircleBorder(),
            elevation: 1.0,
            fillColor: Colors.red[800],
            padding: const EdgeInsets.all(10.0),
          ),
        ],
      ),
    );
  }*/


  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: MainAppTheme.nearlyBlue,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Log Out',
                      style: TextStyle(color: Colors.yellowAccent, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Yakin Ingin LogOut ?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      ' BATAL ',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      ' YUP ',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        handleSignOut();
        break;
    }
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
  }

}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
