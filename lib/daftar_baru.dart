import 'main_app/main_app_theme.dart';
import 'package:flutter/material.dart';
import 'main_app/main_app_theme.dart';
import 'package:http/http.dart' as http;

class DaftarBaru extends StatefulWidget {
  DaftarBaru();
  @override
  DaftarBaruState createState() => new DaftarBaruState();
}

class DaftarBaruState extends State<DaftarBaru> {
  String _email, _nama, _nohp, _alamat, _kota, _tgllhr, _pekerjaan;
  var _isLoading = false;
  String _error;

  final String _phpEndPoint = remoteURL + 'daftar_baru_dart.php';

  void _prsNewReg() async {
    _isLoading = true;
    await http.post(_phpEndPoint, body: {
      "email": _email,
      "nama": _nama,
      "nohp": _nohp,
      "alamat": _alamat,
      "kota": _kota,
      "tgllhr": _tgllhr,
      "pekerjaan": _pekerjaan,
    }).then((res) {
      _isLoading = false;
      Center(
        child: CircularProgressIndicator(),
      );
      print(res.body);
      if (res.body != 'ok') {
        _error =
            'Email Anda sudah terdaftar,\nProses Pendaftaran Gagal!\nSilahkan Login pakai Email Anda tsb...';
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('PENDAFTARAN BARU'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(_error),
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
                    //Navigator.pop(context, 'ocre');
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('PROSES PENDAFTARAN BARU'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Pendaftaran Berhasil!\nSilahkan cek Email Anda untuk mengetahui password (sementara) Anda.\nSelanjutnya silahkan Login menggunakan Email dan Password tsb, setelah berhasil masuk silahkan mengganti password sesuai keinginan Anda...'),
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MainAppTheme.background,
      appBar: new AppBar(
        title: const Text('PENDAFTARAN BARU',
            style: TextStyle(
              color: Colors.black,
              fontFamily: MainAppTheme.fontName,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: MainAppTheme.nearlyWhite,
      ),
      body: Form(
        child: ListView(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  color: Colors.yellow[100],
                ),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                child: Text(
                  "Silahkan mendaftarkan disini gratis... :)",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue[800]),
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
                      child: Image.asset("assets/main_app/user.png"),
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
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person_outline),
                          labelText: 'Nama Lengkap Anda',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {
                          _nama = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
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
                      child: Image.asset("assets/main_app/email.png"),
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
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.alternate_email),
                          labelText: 'Email Anda yg valid',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {
                          _email = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
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
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            //icon: const Icon(Icons.calendar_today),
                            labelText: 'Tgl Lahir Anda (yyyy-mm-dd)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value) {
                            _tgllhr = value;
                          },
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 5.0,
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
                      child: Image.asset("assets/main_app/address.png"),
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
                height: 5.0,
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
                height: 5.0,
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
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.phone_in_talk),
                          labelText: 'No.Telp/HP',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {
                          _nohp = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
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
                      child: Image.asset("assets/main_app/workers.png"),
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
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.layers_clear),
                          labelText: 'Pekerjaan Anda',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {
                          _pekerjaan = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                alignment: Alignment.center,
                child: Container(
                  width: 260,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          offset: const Offset(4, 4),
                          blurRadius: 8),
                    ],
                  ),
                  child: new RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30.0),
                      color: Colors.orange[600],
                      child: Text(
                        " SIMPAN ",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _prsNewReg();
                          //Navigator.pop(context);
                        });
                      }),
                ),
              ),
            ]),
      ),
    );
  }
}
