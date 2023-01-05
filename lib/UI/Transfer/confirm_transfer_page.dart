import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/Transfer/transfer_ok_page.dart';
import 'package:Edimu/models/contacts_model.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

class confirmTransferPage extends StatefulWidget {
  String nama;
  String idPenerima;
  String note;
  int amount;
  confirmTransferPage(this.nama, this.idPenerima, this.note, this.amount);
  @override
  _confirmTransferPageState createState() => _confirmTransferPageState();
}

class _confirmTransferPageState extends State<confirmTransferPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: hijauMain,
          title: Text("Konfirmasi Transfer"),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Nama Pengguna"),
              trailing: Text(widget.nama),
            ),
            ListTile(
              title: Text("No. Rekening Penerima"),
              trailing: Text(widget.idPenerima),
            ),
            ListTile(
              title: Text("Nominal"),
              trailing: Text(rupiah(widget.amount.toString())),
            ),
            ListTile(
              title: Text("Catatan"),
              trailing: Text(widget.note),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Masukkan Pin Transaksi",
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff63a4ff), width: 3.0))),
                controller: passwordController,
                obscureText: true,
                autofocus: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (passwordController.text.length < 1) {
                    return "masukkan password";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 9),
                width: MediaQuery.of(context).size.width - 250,
                height: 50,
                child: ElevatedButton(
                  // padding: EdgeInsets.only(left: 50, right: 50),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Warna.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // <-- Radius
                      ),
                    ),
                  // color: Warna.accent,
                  child: Text(
                    "TRANSFER",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(4.0)),
                  onPressed: () async {
                    EasyLoading.show(
                      dismissOnTap: true,
                      status: 'sedang diproses',
                      maskType: EasyLoadingMaskType.black,
                    );

                    String responseTransfer = await model.transfer(
                        widget.idPenerima,
                        widget.amount,
                        widget.note,
                        passwordController.text
                        // int.parse(passwordController.text)
                        );

                    if (responseTransfer == 'sukses') {
                      EasyLoading.dismiss();
                      Alert(
                          type: AlertType.success,
                          context: context,
                          title: "SUKSES",
                          desc: "Transfer anda berhasil",
                          content: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 35,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 95,
                                      child: Text("Penerima :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300)),
                                    ),
                                    Flexible(child: Text(widget.nama)),
                                  ],
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 95,
                                      child: Text("Jumlah :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300)),
                                    ),
                                    Flexible(
                                        child: Text(
                                            rupiah(widget.amount.toString()))),
                                  ],
                                ),

                                // ListTile(
                                //   title: Container(
                                //     width: 350,
                                //     child: Text('Penerima')),
                                //   trailing: Text(widget.nama),
                                // ),
                                // ListTile(
                                //     title: Text('Jumlah'),
                                //     trailing:
                                //         Text(rupiah(widget.amount.toString())))
                              ],
                            ),
                          ),
                          buttons: [
                            DialogButton(
                              color: Colors.blue[800],
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ]).show();
                    } else if (responseTransfer == 'pin salah') {
                      EasyLoading.dismiss();
                      Alert(
                          type: AlertType.warning,
                          context: context,
                          title: "PIN SALAH",
                          desc: "masukkan kembali PIN yang benar",
                          buttons: [
                            DialogButton(
                              color: Colors.blue[800],
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ]).show();
                    } else {
                      EasyLoading.dismiss();
                      Alert(
                          type: AlertType.warning,
                          context: context,
                          title: "ERROR",
                          desc: "Periksa Kembali Jaringan Internet Anda",
                          buttons: [
                            DialogButton(
                              color: Colors.blue[800],
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ]).show();
                    }
                  },
                )),
          ],
        ),
      );
    });
  }
}
