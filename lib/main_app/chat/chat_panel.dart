import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../main_app_theme.dart';
import '../models/loading.dart';
import 'chat.dart';
import 'chat_group.dart';

class ChatPanel extends StatefulWidget {
  const ChatPanel({Key key, this.animationController, this.currentUserId})
      : super(key: key);

  final AnimationController animationController;
  final String currentUserId;
  @override
  _ChatPanelState createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchcontroller = TextEditingController();

  double topBarOpacity = 0.0;
  String filter;
  bool isLoading = false;

  CollectionReference _db_fs = Firestore.instance.collection('users');
  String msgGroup01, msgGroup02, msgGroup03, msgUser;

  @override
  void initState() {
    searchcontroller.addListener(() {
      setState(() {
        filter = searchcontroller.text;
      });
    });

    @override
    void dispose() {
      searchcontroller.dispose();
      super.dispose();
    }

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    /*scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });*/   
    //print(widget.currentUserId);
    setState(() {
      getMsgNotRead();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        primary: true,
        backgroundColor: MainAppTheme.nearlyDarkBlue,
        title: Text('Chat Screen'),
      ),
      body: Stack(
        children: <Widget>[
          groupChatPanel(),
          getSearchScreen(),
          //getUserListViewUI(),  // gabung dgn getSearchScreen()
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  Future getMsgNotRead() async {
    var document = await _db_fs.document(widget.currentUserId);
    document.get().then((document) {
      var pesan = document.data["msgrcv"];
      setState(() {
      if (pesan == null){ msgGroup01 = '0'; msgGroup02 = '0'; msgGroup03 = '0'; }
      else {
        //msgGroup01 = pesan['gen01'].toString() == null ? '0' : pesan['gen01'].toString();
        //msgGroup02 = pesan['gen02'].toString() == null ? '0' : pesan['gen02'].toString();
        //msgGroup03 = pesan['gen03'].toString() == null ? '0' : pesan['gen03'].toString();
        //msgGroup03 = pesan['gen03'].toString() ?? '0';
        if (pesan['gen01'] == null) { msgGroup01 = '0'; } else { msgGroup01 = pesan['gen01'].toString(); }
        if (pesan['gen02'] == null) { msgGroup02 = '0'; } else { msgGroup02 = pesan['gen02'].toString(); }
        if (pesan['gen03'] == null) { msgGroup03 = '0'; } else { msgGroup03 = pesan['gen03'].toString(); }
        }
      });
    });
  }

  Widget groupChatPanel() {
    return Positioned(
      top: 5.0,
      left: 10.0,
      height: 90,
      width: MediaQuery.of(context).size.width -
          20, // harus diisi agar teks-nya bisa kelihatan
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: MainAppTheme.nearlyBlue,
          border: new Border.all(
              color: Colors.grey[200], width: 1.0, style: BorderStyle.solid),
          borderRadius: new BorderRadius.all(new Radius.circular(12.0)),
        ),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: null,
                          child: Badge(
                            badgeColor: Colors.red[600],
                            animationType: BadgeAnimationType.scale,
                            toAnimate: true,
                            badgeContent: Text(
                              '$msgGroup01',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            child: new Image.asset(
                              'assets/main_app/group1.png',
                              width: 50.0,
                              height: 50.0,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            // HARUS cek dulu apakah user ini member dari Grup01 ??
                            var isMember = await Firestore.instance
                                .collection('group')
                                .document('gen01')
                                .collection('memberID')
                                .where('member',
                                    isEqualTo: widget.currentUserId)
                                .getDocuments();
                            isMember.documents.forEach((res) {
                              //print(res.data);
                              if (res.data['member'] == widget.currentUserId) {
                                //print('betul member grup01');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatGroup(
                                              peerId: 'gen01',
                                              peerAvatar:
                                                  'assets/main_app/group1.png',
                                            )));
                              } else {
                                //print('bukan member grup01');
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "PESAN KESALAHAN",
                                  desc: "Antum bukan anggota group ini...",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        " TUTUP ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(116, 116, 191, 1.0),
                                        Color.fromRGBO(52, 138, 199, 1.0)
                                      ]),
                                    )
                                  ],
                                ).show();
                              }
                            });
                            //print('click01');
                          },
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        FloatingActionButton(
                          heroTag: null,
                          child: Badge(
                            badgeColor: Colors.red[600],
                            animationType: BadgeAnimationType.scale,
                            toAnimate: true,
                            badgeContent: Text(
                              '$msgGroup02',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            child: Image.asset(
                            'assets/main_app/group2.png',
                            width: 50.0,
                            height: 50.0,
                          ),
                          ),
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            // HARUS cek dulu apakah user ini member dari Grup02 ??
                            var isMember = await Firestore.instance
                                .collection('group')
                                .document('gen02')
                                .collection('memberID')
                                .where('member',
                                    isEqualTo: widget.currentUserId)
                                .getDocuments();
                            isMember.documents.forEach((res) {
                              //print(res.data);
                              if (res.data['member'] == widget.currentUserId) {
                                //print('betul member grup02');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatGroup(
                                              peerId: 'gen02',
                                              peerAvatar:
                                                  'assets/main_app/group2.png',
                                            )));
                              } else {
                                //print('bukan member grup02');
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "PESAN KESALAHAN",
                                  desc: "Antum bukan anggota group ini...",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        " TUTUP ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(116, 116, 191, 1.0),
                                        Color.fromRGBO(52, 138, 199, 1.0)
                                      ]),
                                    )
                                  ],
                                ).show();
                              }
                            });
                            //print('click02');
                          },
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        FloatingActionButton(
                          heroTag: null,
                          child: Badge(
                            badgeColor: Colors.red[600],
                            animationType: BadgeAnimationType.scale,
                            toAnimate: true,
                            badgeContent: Text(
                              '$msgGroup03',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            child: Image.asset(
                            'assets/main_app/group3.png',
                            width: 50.0,
                            height: 50.0,
                          ),
                          ),
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            // HARUS cek dulu apakah user ini member dari Grup03 ??
                            var isMember = await Firestore.instance
                                .collection('group')
                                .document('gen03')
                                .collection('memberID')
                                .where('member',
                                    isEqualTo: widget.currentUserId)
                                .getDocuments();
                            isMember.documents.forEach((res) {
                              //print(res.data);
                              if (res.data['member'] == widget.currentUserId) {
                                //print('betul member grup03');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatGroup(
                                              peerId: 'gen03',
                                              peerAvatar:
                                                  'assets/main_app/group3.png',
                                            )));
                              } else {
                                //print('bukan member grup03');
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "PESAN KESALAHAN",
                                  desc: "Antum bukan anggota group ini...",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        " TUTUP ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(116, 116, 191, 1.0),
                                        Color.fromRGBO(52, 138, 199, 1.0)
                                      ]),
                                    )
                                  ],
                                ).show();
                              }
                            });
                            //print('click03');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchScreen() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10, top: 100, right: 10),
          child: TextField(
            //autofocus: true,
            onChanged: (value) {},
            controller: searchcontroller,
            decoration: InputDecoration(
                labelText: "Cari",
                hintText: "Cari Anggota keluarga",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 0, top: 165, right: 0),
          child: getUserListViewUI(),
        )
      ],
    );
  }

  Widget getUserListViewUI() {
    return Stack(
      children: <Widget>[
        Container(
          child: StreamBuilder(
            stream: filter == null || filter == ""
                ? _db_fs.snapshots()
                : _db_fs
                    .where('nickname', isGreaterThanOrEqualTo: filter)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        MainAppTheme.nearlyDarkBlue),
                  ),
                );
              } else {
                return ListView.builder(
                  controller: scrollController,
                  itemBuilder: (context, index) =>
                      buildItem(context, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          ),
        ),
        Positioned(
          child: isLoading ? const Loading() : Container(),
        ),
      ],
    );
  }

  Future getMsgUser(String userID) async {
    /*var document = _db_fs.document(widget.currentUserId);
    document.get().then((document) {
      var pesan = document.data["msgrcv"];
      if (pesan[userID] == null) { msgUser = '0'; } else { msgUser = pesan[userID].toString(); }
      return msgUser;
    });*/
    _db_fs.document(widget.currentUserId).get().then((value){
      String hasil = value.data["msgrcv"]["'$userID'"];
      //print(value.data["msgrcv"]["$userID"]);
      return hasil;
    });
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    // ambil pesan belum terbaca
    String srcMsg;
    //String psnOrgLain = 'msg-'+document['id'];
    //String srcMsg = document['msg-i7VNFBUE48VNJHdxEOqITltwPep2'].toString();
    //print(psnOrgLain);
    //print('$psnOrgLain');
    //print(document['id']+' : '+srcMsg);
    var idUser = document['id'];
    if (document['msgrcv'] == null) { srcMsg = '0'; } 
    else {
      //if (document['msgrcv']['${document['id']}'] == null) { srcMsg = '0'; }
      //else { srcMsg = document['msgrcv']['${document['id']}'].toString(); }
      if (document['msgrcv'][idUser] == null) { srcMsg = '0'; }
      else { srcMsg = document['msgrcv'][idUser].toString(); }
    }
    /*List<dynamic> msgRcv = List.from(document['msgrcv']);
    if (document['msgrcv'] == null) { srcMsg = '0'; } 
    else {
      if (msgRcv[document['id']] == null) { srcMsg = '0'; }
      else { srcMsg = msgRcv[document['id']].toString(); }
    }*/
    print(document['id'].toString()+' => '+srcMsg);
    // generate bar chat masing2 user
    if (document['id'] == widget.currentUserId) {
      return Container();
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MainAppTheme.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: MainAppTheme.grey.withOpacity(0.4),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 100,
                                      right: 16,
                                      top: 16,
                                    ),
                                    child: Text(
                                      '${document['nickname']}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: MainAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: MainAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 100,
                                  bottom: 12,
                                  top: 4,
                                  right: 16,
                                ),
                                child: Text(
                                  'About me: ${document['aboutMe'] ?? 'Not available'}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: MainAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    letterSpacing: 0.0,
                                    color: MainAppTheme.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    left: 10,
                    child: Material(
                      child: document['photoUrl'] != null
                          ? CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      MainAppTheme.nearlyBlue),
                                ),
                                width: 75.0,
                                height: 75.0,
                                padding: EdgeInsets.all(15.0),
                              ),
                              imageUrl: document['photoUrl'],
                              width: 75.0,
                              height: 75.0,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 70.0,
                              color: MainAppTheme.dark_grey,
                            ),
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      clipBehavior: Clip.hardEdge,
                      shadowColor: MainAppTheme.nearlyDarkBlue,
                      elevation: 5.0,
                    ),
                  ),
                  /*Positioned(
                    top: -6,
                    left: 70,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset("assets/main_app/heart_small.png"),
                    ),
                  ),*/
                  Positioned(
                    top: 0,
                    left: MediaQuery.of(context).size.width - 120,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chat(
                                      peerId: document.documentID,
                                      peerAvatar: document['photoUrl'],
                                    )));
                      },
                      child: Badge(
                        badgeColor: Colors.red[500],
                        toAnimate: true,
                        position: BadgePosition.topRight(top: 3, right: 0),
                        badgeContent: Text('$srcMsg',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        child: Image.asset(
                          "assets/main_app/chat.png",
                          scale: 0.8,
                        ),
                      ),
                      shape: CircleBorder(),
                      elevation: 1.0,
                      //fillColor: Colors.orange[300],
                      padding: const EdgeInsets.all(10.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        //),
        //);
        //},
      );
    }
  }
}
