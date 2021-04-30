import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  final TextEditingController controller = TextEditingController();

  double topBarOpacity = 0.0;
  String filter;
  bool isLoading = false;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });

    /*getDataList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });*/

    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
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
    });
    super.initState();
  }

  /*Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: MainAppTheme.nearlyDarkBlue,
        title: Text('Chat Screen'),
      ),
      body: Stack(
        children: <Widget>[
          groupChatPanel(),
          getSearchScreen(),
          getUserListViewUI(),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
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
                          child: new Image.asset(
                            'assets/main_app/group1.png',
                            width: 50.0,
                            height: 50.0,
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
                              print(res.data);
                            });
                            print('click01');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatGroup(
                                          peerId: 'gen01',
                                          peerAvatar:
                                              'assets/main_app/group1.png',
                                        )));
                          },
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        FloatingActionButton(
                          heroTag: null,
                          child: new Image.asset(
                            'assets/main_app/group2.png',
                            width: 50.0,
                            height: 50.0,
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
                              print(res.data);
                            });
                            print('click02');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatGroup(
                                          peerId: 'gen02',
                                          peerAvatar:
                                              'assets/main_app/group2.png',
                                        )));
                          },
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        FloatingActionButton(
                          heroTag: null,
                          child: new Image.asset(
                            'assets/main_app/group3.png',
                            width: 50.0,
                            height: 50.0,
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
                              print(res.data);
                            });
                            print('click03');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatGroup(
                                          peerId: 'gen03',
                                          peerAvatar:
                                              'assets/main_app/group3.png',
                                        )));
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
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 100, right: 10),
      child: TextField(
        //autofocus: true,
        onChanged: (value) {
         //
        },
        controller: controller,
        decoration: InputDecoration(
            labelText: "Cari",
            hintText: "Cari Anggota keluarga",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
      ),
    );
  }

  /*Future getList() async {    // -> ini utk ambil array dari field collection-document
    DocumentReference docRef =
        Firestore.instance.collection('users').document();
    var data;
    docRef.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        data = datasnapshot.data['id'];
      }
    });
    return data;
  }*/

  Future getDataList() async {
    return await Firestore.instance.collection('users').getDocuments();
  }

  Future getUsers() async {
    final QuerySnapshot result = await Firestore.instance
      .collection('users')
      .where('nickname', isGreaterThanOrEqualTo: filter)
      .limit(10)
      .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents;
  }

  Widget getUserListViewUI() {
    return Stack(
      children: <Widget>[
        Container(
          /*/*child: StreamBuilder(
            stream: filter == null || filter == "" ? Firestore.instance.collection('users').snapshots()
            : Firestore.instance.collection('users').where('nickname', isGreaterThanOrEqualTo: filter).snapshots(),
            //stream: Firestore.instance.collection('users').orderBy("nickname").startAt(filter).endAt(filter + "\uf8ff").snapshots(),
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
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        110,
                    //bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          /*child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  110,
              //bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: querySnapshot.documents.length,
            itemBuilder: (context, index) =>
                buildItem(context, querySnapshot.documents[index]),
          ),*/
        ),*/*/
        child: FutureBuilder(
              future: Firestore.instance.collection('users').getDocuments(),
              builder: (context, snapshot) {
              /*if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        MainAppTheme.nearlyDarkBlue),
                  ),
                );
              } else {*/
                return ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        110,
                    //bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  //itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
                  itemBuilder: (context, index) {},
                  itemCount: snapshot.data.documents.length,
                );
              //}
            },),
        ),
        /*Positioned(
          child: isLoading ? const Loading() : Container(),
        ),*/
      ],
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == widget.currentUserId) {
      return Container();
    } else {
      return Container(
        /*AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: new Transform(
              transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),*/
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
                  Positioned(
                    top: -6,
                    left: 70,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset("assets/main_app/heart_small.png"),
                    ),
                  ),
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
                      child: Image.asset(
                        "assets/main_app/chat.png",
                        scale: 0.8,
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
