import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../main_app_theme.dart';
import '../post/calendar_popup_view.dart';

class UbahProfilDialog extends StatefulWidget {
  final List<String> userData;
  UbahProfilDialog(this.userData);
  @override
  UbahProfilDialogState createState() => new UbahProfilDialogState();
}

class UbahProfilDialogState extends State<UbahProfilDialog> {
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  String _alamat, _kota, _telp, _tmplhr, _tgllhr;
  File _image;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tmplhr = widget.userData[4];
    _tgllhr = widget.userData[5];
    _alamat = widget.userData[8];
    _kota = widget.userData[9];
    _telp = widget.userData[10];
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(image.path);
    File compressedFile = await FlutterNativeImage.compressImage(image.path,
        quality: 80,
        targetWidth: 600,
        targetHeight: (properties.height * 600 / properties.width).round());
    setState(() {
      //_image = image;
      _image = compressedFile;
    });
  }

  Future _getAlbum() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(image.path);
    File compressedFile = await FlutterNativeImage.compressImage(image.path,
        quality: 80,
        targetWidth: 600,
        targetHeight: (properties.height * 600 / properties.width).round());
    setState(() {
      //_image = image;
      _image = compressedFile;
    });
  }

  final String _phpEndPoint = remoteURL + 'update_profil_dart.php';

  void _upload(alamat, kota, telp, tmplhr, tgllhr, user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jnsuser = prefs.getString('jnsuser');
    _isLoading = true;
    if (_image == null) return;
    String base64Image = base64Encode(_image.readAsBytesSync());
    String fileName = _image.path.split("/").last;
    await http.post(_phpEndPoint, body: {
      "jenis": 'ubahprof',
      "jnsuser": jnsuser,
      "image_photo": base64Image,
      "name_photo": fileName,
      "alamat": alamat,
      "kota": kota,
      "telp": telp,
      "tmplhr": tmplhr,
      "tgllhr": tgllhr,
      "email": user,
    }).then((res) {
      _isLoading = false;
      Center(
        child: CircularProgressIndicator(),
      );
      //print(res.body);
      if (res.body != 'ok') {
        Center(
          child: CircularProgressIndicator(),
        );
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('EDIT DATA PRIBADI'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Data Pribadi berhasil diubah,\nSilahkan Logout agar Data yg terbaru bisa ditampilkan...'),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    '   TUTUP   ',
                    style: TextStyle(color: Colors.yellow[100]),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    //Navigator.pop(context, 'ocre');
                  },
                ),
              ],
            );
          },
        );
      }
      //print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Data Pribadi',
            style: TextStyle(
              color: Colors.black,
              fontFamily: MainAppTheme.fontName,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: MainAppTheme.nearlyWhite,
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey2,
              //autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: <Widget>[
                  SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset("assets/main_app/country.png"),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 95,
                          decoration: BoxDecoration(
                            color: MainAppTheme.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 8),
                            ],
                          ),
                          child: TextField(
                            textAlign: TextAlign.left,
                            controller: TextEditingController(text: '$_tmplhr'),
                            decoration: InputDecoration(
                              //icon: const Icon(Icons.place),
                              labelText: 'Tempat Lahir Anda',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              _tmplhr = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset("assets/main_app/calendar.png"),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 95,
                          decoration: BoxDecoration(
                            color: MainAppTheme.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 8),
                            ],
                          ),
                          child: TextField(
                            textAlign: TextAlign.left,
                            //controller: TextEditingController(text: '$_tgllhr'),
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              //icon: const Icon(Icons.calendar_today),
                              labelText: 'Tgl Lahir Anda (yyyy-mm-dd)',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              _tgllhr = value;
                            },
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              // setState(() {
                              //   isDatePopupOpen = true;
                              // });
                              showDemoDialog(context: context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset("assets/main_app/home.png"),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 95,
                          decoration: BoxDecoration(
                            color: MainAppTheme.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 8),
                            ],
                          ),
                          child: TextField(
                            maxLines: 6,
                            autocorrect: false,
                            controller: TextEditingController(text: '$_alamat'),
                            decoration: const InputDecoration(
                              //icon: const Icon(Icons.filter_frames),
                              labelText: 'Alamat Lengkap',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              _alamat = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset("assets/main_app/city.png"),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 95,
                          decoration: BoxDecoration(
                            color: MainAppTheme.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 8),
                            ],
                          ),
                          child: TextField(
                            textAlign: TextAlign.left,
                            controller: TextEditingController(text: '$_kota'),
                            decoration: InputDecoration(
                              //icon: const Icon(Icons.business),
                              labelText: 'Kota',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              _kota = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset("assets/main_app/phone.png"),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 95,
                          decoration: BoxDecoration(
                            color: MainAppTheme.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 8),
                            ],
                          ),
                          child: TextField(
                            textAlign: TextAlign.left,
                            controller: TextEditingController(text: '$_telp'),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              //icon: const Icon(Icons.phone_in_talk),
                              labelText: 'No.Telp/HP',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              _telp = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.all(10.0),
                    child: _image == null
                        ? Text(
                            '... photo profil belum diambil ...',
                            textAlign: TextAlign.center,
                          )
                        : Image.file(_image),
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new RaisedButton.icon(
                            onPressed: _getImage,
                            color: Colors.green,
                            icon: Icon(Icons.add_a_photo),
                            label: Text('Kamera'),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0))),
                        new SizedBox(
                          width: 20.0,
                          height: 10.0,
                        ),
                        new RaisedButton.icon(
                            onPressed: _getAlbum,
                            color: Colors.blue,
                            icon: Icon(Icons.camera_roll),
                            label: Text('Album'),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0))),
                      ]),
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 16.0),
                    alignment: Alignment.center,
                    child: Center(
                      child: Container(
                          width: 260,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  //offset: const Offset(4, 4),
                                  blurRadius: 8),
                            ],
                          ),
                          child: new InkWell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Text(
                                  ' UPDATE DATA ',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              _formKey2.currentState.save();
                              _upload(_alamat, _kota, _telp, _tmplhr, _tgllhr,
                                  widget.userData[3]);
                              //Navigator.pop(context);
                            },
                          )),
                    ),
                  ),
                ],
              ))),
      //},
      //),
    );
  }
}
