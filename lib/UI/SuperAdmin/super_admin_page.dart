import 'dart:convert';
import 'package:Edimu/konfigurasi/api.dart';
import 'package:Edimu/models/pradaftar_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SuperAdmin_Page extends StatefulWidget {
  MainModel model;
  SuperAdmin_Page(this.model);

  @override
  _SuperAdmin_PageState createState() => _SuperAdmin_PageState();
}

class _SuperAdmin_PageState extends State<SuperAdmin_Page> {
  TextEditingController namaKomunitas = TextEditingController();
  TextEditingController teleponKomunitas = TextEditingController();
  TextEditingController rekeningKomunitas = TextEditingController();
  TextEditingController alamatKomunitas = TextEditingController();
  TextEditingController jenisKomunitas = TextEditingController();

  TextEditingController namaLembaga = TextEditingController();
  TextEditingController teleponLembaga = TextEditingController();
  TextEditingController akunSistemLembaga = TextEditingController();
  TextEditingController alamatLembaga = TextEditingController();

  int selectedKomunitas;

  String selectedNamaKomunitas;

  List _dataLembaga;
  List _dataKomunitas;

  void getKomunitas() async {
    final response = await http.get(UrlAPI.pradaftar);
    var listData = json.decode(response.body);
    //debugPrint('isi dari var listData = ${listData['komunitas'].toString()}');

    setState(() {
      _dataKomunitas = listData["komunitas"];
    });
    //debugPrint('=========================================');
    //debugPrint('isi dari var _dataKomunitas = ${_dataKomunitas.toString()}');
  }

  Future tambahKomunitas(namaKomunitas, teleponKomunitas, akunSistemKomunitas,
      alamatKomunitas, jenisLembaga) async {
    Map<String, String> headerJSON = {
      // "Authorization": authVaue64,
      "Content-Type": "application/json",
      // "Accept": "application/json",
    };

    final bodyJSON = jsonEncode({
      'nohape': widget.model.usernameUser,
      'password': widget.model.passwordUser,
      'namaKomunitas': namaKomunitas,
      'teleponKomunitas': teleponKomunitas,
      'akunSistemKomunitas': akunSistemKomunitas,
      'alamatKomunitas': alamatKomunitas,
      'jenisLembaga': jenisLembaga
    });

    final response = await http.post(UrlAPI.tambahKomunitas,
        headers: headerJSON, body: bodyJSON);

    //debugPrint('isi model.usernameUser = ${widget.model.usernameUser}');
    //debugPrint('isi model.passwordUser = ${widget.model.passwordUser}');
    bool _sukses;

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      //debugPrint('POST DATA SUKSESSSSS');
      //debugPrint(data.toString());
      _sukses = true;
      return _sukses;
    } else if (response.statusCode > 399 && response.statusCode < 500) {
      //debugPrint('TOPUP Edimu GAGAL');
      //debugPrint(data.toString());
      _sukses = false;
      return _sukses;
    }
  }

  Future tambahLembaga(
      namaLembaga, teleponLembaga, akunSistemLembaga, alamatLembaga) async {
    Map<String, String> headerJSON = {
      // "Authorization": authVaue64,
      "Content-Type": "application/json",
      // "Accept": "application/json",
    };

    final bodyJSON = jsonEncode({
      'nohape': widget.model.usernameUser,
      'password': widget.model.passwordUser,
      'idKomunitas': selectedKomunitas.toString(),
      'namaLembaga': namaLembaga,
      'teleponLembaga': teleponLembaga,
      'akunSistemLembaga': akunSistemLembaga,
      'alamatLembaga': alamatLembaga,
    });

    final response = await http.post(UrlAPI.tambahLembaga,
        headers: headerJSON, body: bodyJSON);

    //debugPrint('isi model.usernameUser = ${widget.model.usernameUser}');
    //debugPrint('isi model.passwordUser = ${widget.model.passwordUser}');

    //debugPrint("selectedKomunitas = ${selectedKomunitas.toString()}");
    //debugPrint("nama lembaga = $namaLembaga");
    //debugPrint("teleponLembaga = $teleponLembaga");
    //debugPrint("akunSistemLembaga = $akunSistemLembaga");
    //debugPrint("alamatLembaga = $alamatLembaga");
    bool _sukses;

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      //debugPrint('POST DATA SUKSESSSSS');
      //debugPrint(data.toString());
      _sukses = true;
      return _sukses;
    } else if (response.statusCode > 399 && response.statusCode < 500) {
      //debugPrint('TOPUP Edimu GAGAL');
      //debugPrint(data.toString());
      _sukses = false;
      return _sukses;
    }
  }

  @override
  void initState() {
    super.initState();
    getKomunitas();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Super Admin Edimu"),
            centerTitle: true,
            bottom: TabBar(
              tabs: [Tab(text: "Komunitas"), Tab(text: "Lembaga")],
            ),
          ),
          body: TabBarView(
            children: [komunitas_page(), lembaga_page()],
          )),
    );
  }

  Widget komunitas_page() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(9),
          padding: EdgeInsets.all(7),
          child: Column(
            children: [
              Text("TAMBAH KOMUNITAS",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: namaKomunitas,
                // keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "Nama Komunitas",
                    icon: Icon(Icons.account_balance)),
              ),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: teleponKomunitas,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "Telepon",
                    icon: Icon(Icons.phone)),
              ),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: rekeningKomunitas,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "No.rek Akun Sistem",
                    icon: Icon(Icons.account_balance_wallet)),
              ),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: alamatKomunitas,
                // keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "Alamat",
                    icon: Icon(Icons.place)),
              ),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: jenisKomunitas,
                // keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "Jenis Lembaga",
                    icon: Icon(Icons.check_box)),
              ),
              SizedBox(
                height: 57,
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
                    child: Text(
                      "TAMBAHKAN",
                      style: TextStyle(color: Colors.white),
                    ),
                    //, Colors.white,

                    onPressed: () async {
                      EasyLoading.show(
                        status: 'sedang diproses',
                        maskType: EasyLoadingMaskType.black,
                      );

                      bool response = await tambahKomunitas(
                          namaKomunitas.text,
                          teleponKomunitas.text,
                          rekeningKomunitas.text,
                          alamatKomunitas.text,
                          jenisKomunitas.text);

                      if (response) {
                        EasyLoading.dismiss();
                        Alert(
                            type: AlertType.success,
                            context: context,
                            title: "SUKSES",
                            desc: "Data Komunitas berhasil dimasukkan",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ]).show();
                        setState(() {});
                      } else {
                        EasyLoading.dismiss();
                        Alert(
                            type: AlertType.error,
                            context: context,
                            title: "GAGAL",
                            desc: "Data Komunitas tidak berhasil dimasukkan",
                            buttons: [
                              DialogButton(
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
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lembaga_page() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(9),
          padding: EdgeInsets.all(7),
          child: Column(
            children: [
              SizedBox(height: 7),
              Text("TAMBAH LEMBAGA",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
              SizedBox(height: 9),
              dropdownLembaga(),
              SizedBox(height: 9),
              TextField(
                controller: namaLembaga,
                // keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "Nama Lembaga",
                    icon: Icon(Icons.account_balance)),
              ),
              SizedBox(height: 9),
              TextField(
                controller: teleponLembaga,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "No. Telpon Lembaga",
                    icon: Icon(Icons.phone)),
              ),
              SizedBox(height: 9),
              TextField(
                controller: akunSistemLembaga,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "No. Rekening Sistem",
                    icon: Icon(Icons.account_balance_wallet)),
              ),
              SizedBox(height: 9),
              TextField(
                controller: alamatLembaga,
                // keyboardType: TextInputType.number,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    // hintText: "contoh : 0813xxxxxx",
                    labelText: "Alamat Lembaga",
                    icon: Icon(Icons.place)),
              ),
              SizedBox(
                height: 61,
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
                    child: Text(
                      "TAMBAHKAN",
                      style: TextStyle(color: Colors.white),
                    ),
                    //, Colors.white,

                    onPressed: () async {
                      EasyLoading.show(
                        status: 'sedang diproses',
                        maskType: EasyLoadingMaskType.black,
                      );

                      bool response = await tambahLembaga(
                          namaLembaga.text,
                          teleponLembaga.text,
                          akunSistemLembaga.text,
                          alamatLembaga.text);

                      if (response) {
                        EasyLoading.dismiss();
                        Alert(
                            type: AlertType.success,
                            context: context,
                            title: "SUKSES",
                            desc: "Data Lembaga berhasil dimasukkan",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ]).show();
                        setState(() {});
                      } else {
                        EasyLoading.dismiss();
                        Alert(
                            type: AlertType.error,
                            context: context,
                            title: "GAGAL",
                            desc: "Data Lembaga tidak berhasil dimasukkan",
                            buttons: [
                              DialogButton(
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
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropdownLembaga() {
    return DropdownButton(
      isExpanded: true,
      hint: Text(selectedNamaKomunitas ?? "Pilih Komunitas",
          style: TextStyle(fontWeight: FontWeight.bold)),
      items: _dataKomunitas.map((item) {
        return DropdownMenuItem(
          child: Text(item['nama_komunitas']),
          value: item['id'],
          onTap: () {
            setState(() {
              selectedNamaKomunitas = item['nama_komunitas'];
              selectedKomunitas = item['id'];
            });
            //debugPrint(
                // 'isi dari selectedNamaKomunitas = $selectedNamaKomunitas');
            //debugPrint(
                // "ID yang dipilih adalah ${selectedKomunitas.toString()}");
          },
        );
      }).toList(),
      onChanged: (value) {},
      // onChanged: (value) {
      //   setState(() {
      //     selectedKomunitas = value;
      //   });
      //   //debugPrint("ID yang dipilih adalah ${value.toString()}");
      // },
    );
  }
}
