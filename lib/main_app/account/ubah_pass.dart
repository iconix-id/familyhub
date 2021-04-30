import 'package:flutter/material.dart';
//import '././networkpass.dart';
import '../main_app_theme.dart';

class UbahPassDialog extends StatefulWidget {
  final String user;
  final String norm;
  UbahPassDialog(this.user, this.norm);
  @override
  UbahPassDialogState createState() => new UbahPassDialogState();
}

class UbahPassDialogState extends State<UbahPassDialog> {
  String _passOld, _passNew, _passNew2;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: MainAppTheme.background,
        appBar: new AppBar(
          title: const Text('UBAH PASSWORD', style: TextStyle(color: Colors.black, fontFamily: MainAppTheme.fontName, fontWeight: FontWeight.w700,)),
          backgroundColor: MainAppTheme.nearlyWhite,
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Silahkan Ubah Password yg mudah diingat tapi sulit ditebak !",
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset("assets/main_app/key.png"),
                      ),
                      Container(
                        //padding: EdgeInsets.only(left:10.0),  --> bikin ada gap antara container dan textFormField
                        width: MediaQuery.of(context).size.width - 90,
                        decoration: BoxDecoration(
                          color: MainAppTheme.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 8),
                          ],
                        ),
                        child: TextFormField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Password Lama Anda',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          onSaved: (String value) {
                            _passOld = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset("assets/main_app/data_enc.png"),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 90,
                        decoration: BoxDecoration(
                          color: MainAppTheme.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 8),
                          ],
                        ),
                        child: TextFormField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Password Baru Anda',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          onSaved: (String value) {
                            _passNew = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          "assets/main_app/private.png",
                          width: 30.0,
                          height: 30.0,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 90,
                        decoration: BoxDecoration(
                          color: MainAppTheme.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 8),
                          ],
                        ),
                        child: TextFormField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Konfirmasi Password Baru',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          onSaved: (String value) {
                            _passNew2 = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: Center(
                    child: Container(
                      width: 120,
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
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              " SIMPAN ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          _formKey.currentState.save();
                          /*setState(() {
                              getJSONPass(widget.user, _passOld, _passNew, _passNew2)
                                  .then((data){
                                //print(data);
                                if (data == 'ok') {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('UBAH PASSWORD'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('Password berhasil diubah !'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          RaisedButton(
                                            child: Text(
                                              '   OKE, SIIP  ',
                                              style: TextStyle(
                                                  color: Colors.yellow[100]),
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
                                  //Navigator.pop(context);
                                } else if (data == 'gagal1') {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('ERROR WARNING'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('Password Lama Salah !'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          RaisedButton(
                                            child: Text(
                                              '   ULANGI   ',
                                              style: TextStyle(
                                                  color: Colors.yellow[100]),
                                            ),
                                            color: Colors.red,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (data == 'gagal2') {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('ERROR WARNING'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('Password Baru Berbeda dgn Password Konfirmasi !'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          RaisedButton(
                                            child: Text(
                                              '   ULANGI   ',
                                              style: TextStyle(
                                                  color: Colors.yellow[100]),
                                            ),
                                            color: Colors.red,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            });*/
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
