import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/Marketplace/marketplace_bikinlapak_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BukaTokoPage extends StatefulWidget {
  MainModel model;

  BukaTokoPage(this.model);

  @override
  _BukaTokoPageState createState() => _BukaTokoPageState();
}

class _BukaTokoPageState extends State<BukaTokoPage> {
  TextEditingController isianNamaToko = TextEditingController();
  TextEditingController isianDeskripsiToko = TextEditingController();
  TextEditingController isianAlamatToko = TextEditingController();
  TextEditingController isianNohapeToko = TextEditingController();

  bool isKonfirmasi = false;

  @override
  void initState() {
    isianNohapeToko.text = widget.model.nohapeAktif;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buka Toko"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                  color: Colors.amber[400],
                  height: 75,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Center(
                      child: Text(
                    "Harap isi dengan data yang benar",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  )),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: isianNamaToko,
                  enabled: !isKonfirmasi,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      labelText: "nama toko", icon: Icon(Icons.store)),
                ),
                SizedBox(
                  height: 11,
                ),
                TextField(
                  controller: isianAlamatToko,
                  maxLines: null,
                  enabled: !isKonfirmasi,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      labelText: "alamat toko", icon: Icon(Icons.location_pin)),
                ),
                SizedBox(
                  height: 11,
                ),
                TextField(
                  controller: isianNohapeToko,
                  enabled: !isKonfirmasi,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      labelText: "no. hp", icon: Icon(Icons.call)),
                ),
                SizedBox(
                  height: 11,
                ),
                TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: isianDeskripsiToko,
                  enabled: !isKonfirmasi,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      labelText: "Deskripsi Toko",
                      icon: Icon(Icons.description)),
                ),
                SizedBox(
                  height: 25,
                ),

                //pembatas bawah
                Container(
                  height: 91,
                  child: !isKonfirmasi
                      ? Container()
                      : Container(
                          height: 91,
                          color: Colors.amber[100],
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: Colors.amber,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Apakah anda sudah yakin"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("dengan informasi di atas?"),
                              ],
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 65,
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              child: isKonfirmasi
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            height: 65,
                            width: MediaQuery.of(context).size.width * 0.25,
                            color: Colors.red,
                            child: ElevatedButton(
                                // height: 65,
                                // minWidth:
                                //     MediaQuery.of(context).size.width * 0.25,
                                // color: Colors.red[800],
                                onPressed: () {
                                  setState(() {
                                    isKonfirmasi = false;
                                  });
                                },
                                child: Text(
                                  "Batalkan",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          Container(
                            height: 65,
                            width: MediaQuery.of(context).size.width * 0.75,
                            color: Colors.blue[800],
                            child: ElevatedButton(
                                // height: 65,
                                // minWidth:
                                //     MediaQuery.of(context).size.width * 0.75,
                                // color: Colors.blue[800],
                                onPressed: () async {
                                  if (isianNamaToko.text.isNotEmpty &&
                                      isianDeskripsiToko.text.isNotEmpty &&
                                      isianAlamatToko.text.isNotEmpty &&
                                      isianNohapeToko.text.length > 9) {
                                    EasyLoading.show(
                                      status: 'sedang diproses',
                                      maskType: EasyLoadingMaskType.black,
                                    );

                                    String response = await widget.model
                                        .bukaToko(
                                            isianNamaToko.text,
                                            isianDeskripsiToko.text,
                                            isianAlamatToko.text,
                                            isianNohapeToko.text);

                                    if (response == "sukses") {
                                      EasyLoading.dismiss();
                                      Alert(
                                          type: AlertType.success,
                                          context: context,
                                          title: "Berhasil",
                                          desc:
                                              "Toko ${isianNamaToko.text} berhasil dibuka.",
                                          buttons: [
                                            DialogButton(
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                })
                                          ],
                                          content: Column(
                                            children: [
                                              Text(
                                                  "sekarang anda sudah bisa menjual barang di marketplace"),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BikinLapak_Page(
                                                                  widget
                                                                      .model)));
                                                },
                                                child: Text(
                                                  "Klik disini untuk menjual barang",
                                                  style: TextStyle(
                                                      color: Colors.blue[800],
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              )
                                            ],
                                          )).show();
                                    }
                                  } else if (isianNohapeToko.text.length < 10) {
                                    Alert(
                                            type: AlertType.error,
                                            context: context,
                                            title:
                                                "Nomor Handphone tidak valid",
                                            desc:
                                                "Nomor handphone harus minimal 10 digit")
                                        .show();
                                    isianNohapeToko.clear();
                                  } else {
                                    EasyLoading.dismiss();
                                    Alert(
                                        title: "Informasi Toko belum lengkap",
                                        desc:
                                            "Silahkan lengkapi informasi toko diatas terlebih dahulu",
                                        type: AlertType.warning,
                                        context: context,
                                        buttons: [
                                          DialogButton(
                                            color: Colors.blue[800],
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ]).show();
                                  }
                                },
                                child: Text(
                                  "Iya, saya yakin",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 57,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue[800],
                      child: ElevatedButton(
                          // height: 57,
                          // color: Colors.blue[800],
                          // minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            setState(() {
                              isKonfirmasi = true;
                            });

                            //debugPrint("isian deskripsiToko");
                            //debugPrint(isianDeskripsiToko.text);
                          },
                          child: Text(
                            "Konfirmasi",
                            style: TextStyle(color: Colors.white),
                          )),
                    ))
        ],
      ),
    );
  }
}
