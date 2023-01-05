import 'package:flutter/material.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:Edimu/konfigurasi/api.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegistrationConfirmation_Page extends StatefulWidget {
  String email;
  String nama;
  String noHape;
  String password;
  int idGrup;

  int idKomunitas;
  String namaKomunitas;
  String alamatKomunitas;
  String teleponKomunitas;

  RegistrationConfirmation_Page(
      this.noHape,
      this.nama,
      this.email,
      this.password,
      this.idGrup,
      this.idKomunitas,
      this.namaKomunitas,
      this.alamatKomunitas,
      this.teleponKomunitas);

  @override
  _RegistrationConfirmation_PageState createState() =>
      _RegistrationConfirmation_PageState();
}

class _RegistrationConfirmation_PageState
    extends State<RegistrationConfirmation_Page> {
  Map responseRegister;
  int statusCode;

  Future<Map> register(
      String noHape, String name, String email, String password) async {
    final bodyJSON = jsonEncode({
      "nohape": noHape,
      "name": name,
      "email": email,
      "password": password,
      "confirmation": password,
      "grup": widget.idGrup,
      "komunitas": widget.idKomunitas
    });

    Map<String, String> headerJSON = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final response =
        await http.post(UrlAPI.register, headers: headerJSON, body: bodyJSON);

    //debugPrint(response.body.toString());

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      //debugPrint(
          // 'Registrasi sukses, dibawah ini adalah response dari API register :');
      //debugPrint(data.toString());
      responseRegister = data;
      statusCode = 200;
      return data;
    } else if (response.statusCode == 422) {
      //debugPrint(data.toString());
      statusCode = 422;
      return data;
    }
  }

  Widget childTombol = textTulisan();

  static Widget textTulisan() {
    return Text(
      "DAFTARKAN",
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  static Widget loadingBunder() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white),
      strokeWidth: 5.9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hijauBG2,
      appBar: AppBar(
        title: Text('Konfirmasi Pendaftaran'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                // margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[700],
                    borderRadius: BorderRadius.all(Radius.circular(9))),
                width: 351,
                child: Text(
                  '''Pastikan data diri anda
sudah lengkap dan benar''',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 19),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  widget.nama,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone_android),
                title: Text(widget.noHape,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text(widget.email,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.account_balance),
                title: Text(widget.namaKomunitas,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text(widget.idGrup == 1 ? "Nasabah Umum" : "Wali Murid",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                // color: Colors.white,
                //minWidth: 50,
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                ),

                child: ElevatedButton(
                    // color: Colors.white,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9), // <-- Radius
                      ),
                    ),
                    // color: Colors.blue[800],
                    // shape: new RoundedRectangleBorder(
                    //     borderRadius: new BorderRadius.circular(9.0)),
                    child: childTombol,
                    //, Colors.white,
                    onPressed: () async {
                      // await register(widget.noHape, widget.nama, widget.email,
                      //     widget.password, widget.idGrup);

                      EasyLoading.show(
                          status: 'sedang diproses',
                          maskType: EasyLoadingMaskType.black,
                          dismissOnTap: true);

                      Map response = await register(widget.noHape, widget.nama,
                          widget.email, widget.password);

                      //debugPrint(response.toString());
                      if (statusCode == 200) {
                        EasyLoading.dismiss();
                        await Alert(
                            type: AlertType.success,
                            context: context,
                            title: "Pendaftaran Sukses",
                            desc: "Silahkan login & lakukan verifikasi",
                            content: Column(
                              children: [
                                SizedBox(
                                  height: 13,
                                ),
                                Text(widget.namaKomunitas),
                                SizedBox(
                                  height: 13,
                                ),
                                Text(widget.alamatKomunitas,
                                    textAlign: TextAlign.center),
                                SizedBox(
                                  height: 13,
                                ),
                                Text("Telpon : " + widget.teleponKomunitas),
                                SizedBox(height: 9),
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ]).show();
                      } else if (response["errors"]["nohape"] != null &&
                          response["errors"]["email"] != null) {
                        await Alert(
                          type: AlertType.error,
                          context: context,
                          title: "Email & No. HP anda sudah terdaftar",
                          // desc: "Periksa kembali Email & Password anda",
                        ).show();
                      } else if (response["errors"]["nohape"] != null) {
                        await Alert(
                          type: AlertType.error,
                          context: context,
                          title: "No. HP anda sudah terdaftar",
                          // desc: "Periksa kembali Email & Password anda",
                        ).show();
                      } else if (response["errors"]["email"] != null) {
                        await Alert(
                          type: AlertType.error,
                          context: context,
                          title: "email anda sudah terdaftar",
                          // desc: "Periksa kembali Email & Password anda",
                        ).show();
                      } else {
                        await Alert(
                          type: AlertType.error,
                          context: context,
                          title: "Periksa kembali jaringan internet anda",
                          // desc: "Periksa kembali Email & Password anda",
                        ).show();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
