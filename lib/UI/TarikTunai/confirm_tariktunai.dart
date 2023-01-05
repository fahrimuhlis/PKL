import 'package:Edimu/UI/TarikTunai/tariktransfer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/HomePage/home_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Edimu/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class Confirm_TarikTunai extends StatefulWidget {
  MainModel model;
  int jumlah;
  Confirm_TarikTunai(this.model, this.jumlah);

  @override
  _Confirm_TarikTunaiState createState() => _Confirm_TarikTunaiState();
}

class _Confirm_TarikTunaiState extends State<Confirm_TarikTunai> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Penarikan Dana"),
              centerTitle: true,
              bottom: TabBar(
                indicatorColor: Colors.white,
                indicator: BoxDecoration(
                    color: Warna.accent,
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.white,
                            width: 3,
                            style: BorderStyle.solid))),
                tabs: [
                  Tab(
                    text: 'Transfer',
                  ),
                  Tab(text: 'Tunai/Cash')
                ],
              ),
            ),
            body: TabBarView(children: [
              TarikTransferPage(model, widget.jumlah),
              tarikCashTab(model),
            ])),
      );
    });
  }

  Widget tarikCashTab(MainModel model) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 75,
                  ),
                  ListTile(
                    title: Text(
                      "Dana yang akan di tarik :",
                      style: TextStyle(
                        color: Colors.green[800],
                      ),
                    ),
                    subtitle: Text(rupiah(widget.jumlah.toString()),
                        style: TextStyle(fontSize: 45, color: Colors.green)),
                  ),
                  Container(
                    height: 55,
                  ),
                  Container(
                      padding: EdgeInsets.all(11),
                      color: Colors.amber[200],
                      // width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        children: [
                          Text(
                            "Dana dapat anda ambil di :",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            widget.model.namaKomunitas,
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.model.alamatKomunitas,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text(
                          //   "Surabaya - Jawa Timur",
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: Colors.black54,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  // Container(
                  //   child: Center(
                  //     child: Text(
                  //       "atau",
                  //       style: TextStyle(
                  //           // decoration: TextDecoration.underline,
                  //           fontSize: 25,
                  //           fontWeight: FontWeight.w500),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 25,
                  // ),
                  // SizedBox(
                  //   height: 95,
                  // ),
                ],
              ),
            ),
          ),
          Positioned(bottom: 0, child: tombolKonfirmasi(model))
        ],
      ),
    );
  }

  Widget tombolHubungiTeller() {
    return SizedBox(
      // width: MediaQuery.of(context).size.width * 0.75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
        ),
        // color: Colors.green[700],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/whatsapp.png",
                width: 25,
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                "Hubungi Teller",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        onPressed: () async {
          EasyLoading.show(
            dismissOnTap: true,
            status: 'sedang diproses',
            maskType: EasyLoadingMaskType.black,
          );

          String response = await widget.model.getTeller();

          if (response == 'sukses') {
            EasyLoading.dismiss();

            Alert(
                type: AlertType.none,
                context: context,
                title: "Konfirmasi ke Teller",
                desc: "Silahkan hubungi salah satu Teller berikut:",
                content: ContentListTeller(),
                buttons: []).show();
          }
        },
      ),
    );
  }

  Widget tombolKonfirmasi(model) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        child: Text(
          "KONFIRMASI",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Warna.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // <-- Radius
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
        // color: Warna.accent,
        onPressed: () async {
          TextEditingController isianPIN = TextEditingController();

          Alert(
              context: context,
              title: "Masukkan PIN anda",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    autofocus: true,
                    controller: isianPIN,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "PIN",
                      labelStyle: TextStyle(fontSize: 25),
                      icon: Icon(Icons.vpn_key),
                    ),
                  )
                ],
              ),
              buttons: [
                DialogButton(
                  color: Colors.blue[800],
                  child:
                      Text("Konfirmasi", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    EasyLoading.show(
                      dismissOnTap: true,
                      status: 'sedang diproses',
                      maskType: EasyLoadingMaskType.black,
                    );

                    Map responseTarik =
                        await model.tarikTunai(isianPIN.text, widget.jumlah);

                    // if (responseTarik['kode'] == 'sukses') {
                    //   //debugPrint('tarik tunai sukses');

                    //   EasyLoading.dismiss();
                    //   Alert(
                    //       type: AlertType.success,
                    //       context: context,
                    //       title: "SUKSES",
                    //       desc: "Pengajuan tarik dana berhasil.",
                    //       content: Container(
                    //         padding: EdgeInsets.symmetric(vertical: 9),
                    //         child: Column(
                    //           children: [tombolHubungiTeller()],
                    //         ),
                    //       ),
                    //       buttons: [
                    //         DialogButton(
                    //           color: Colors.blue[800],
                    //           child: Text(
                    //             "OK",
                    //             style: TextStyle(color: Colors.white),
                    //           ),
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //             Navigator.pop(context);
                    //             Navigator.pop(context);
                    //             Navigator.pop(context);
                    //           },
                    //         )
                    //       ]).show();
                    // } else {
                    //   //debugPrint(responseTarik.toString());
                    //   EasyLoading.dismiss();
                    //   Alert(
                    //       type: AlertType.error,
                    //       context: context,
                    //       title: "Penarikan gagal",
                    //       desc:
                    //           "Pengajuan tarik dana gagal, silahkan cek kembali jaringan internet anda",
                    //       buttons: [
                    //         DialogButton(
                    //           color: Colors.blue[800],
                    //           child: Text(
                    //             "OK",
                    //             style: TextStyle(color: Colors.white),
                    //           ),
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //           },
                    //         )
                    //       ]).show();
                    // }

                    try {
                      if (responseTarik['kode'] == 'sukses') {
                        //debugPrint('tarik tunai sukses');

                        EasyLoading.dismiss();
                        Alert(
                            type: AlertType.success,
                            context: context,
                            title: "SUKSES",
                            desc: "Pengajuan tarik dana berhasil.",
                            content: Container(
                              padding: EdgeInsets.symmetric(vertical: 9),
                              child: Column(
                                children: [tombolHubungiTeller()],
                              ),
                            ),
                            closeFunction: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            buttons: [
                              DialogButton(
                                color: Colors.blue[800],
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  EasyLoading.show(
                                    dismissOnTap: true,
                                    status: 'sedang diproses',
                                    maskType: EasyLoadingMaskType.black,
                                  );

                                  String response =
                                      await widget.model.getTeller();

                                  if (response == 'sukses') {
                                    EasyLoading.dismiss();

                                    Alert(
                                        type: AlertType.none,
                                        context: context,
                                        title: "Konfirmasi ke Teller",
                                        desc:
                                            "Silahkan hubungi salah satu Teller berikut:",
                                        content: ContentListTeller(),
                                        buttons: []).show();
                                  }
                                },
                              )
                            ]).show();
                      } else if (responseTarik['kode'] == 'pin salah') {
                        EasyLoading.dismiss();
                        Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "PIN SALAH",
                            desc: "Maaf, PIN yang anda masukkan salah",
                            buttons: [
                              DialogButton(
                                  child: Text(
                                    "coba lagi",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ]).show();
                      }
                      //
                    } catch (e) {
                      EasyLoading.dismiss();
                      Alert(
                          type: AlertType.error,
                          context: context,
                          title: "Penarikan gagal",
                          desc: "Pengajuan tarik dana gagal",
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
                )
              ]).show();
          // model.topup(widget.jumlah);

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => topupOKPage()),
          // );

          // Navigator.pushNamed(context, '/');

//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) =>
//
//                          konfirmTopUp(int.parse(amount.text))),
//                );
        },
      ),
    );
  }

  Widget ContentListTeller() {
    Widget listTile(int index) {
      return ListTile(
        onTap: () {
          launchWhatsApp(widget.model.listTeller[index]['nohape']);
        },
        title: Text(widget.model.listTeller[index]['name']),
        // subtitle: Text(widget.model.listTeller[index]['nohape']),
        trailing: Container(
          width: 115,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
            ),
            // height: 45,
            // color: Colors.green[600],
            child: Row(
              children: [
                Image.asset('lib/assets/whatsapp.png', width: 25),
                SizedBox(width: 5),
                Text('Hubungi', style: TextStyle(color: Colors.white))
              ],
            ),
            onPressed: () async {
              launchWhatsApp(widget.model.listTeller[index]['nohape']);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
      );
    }

    return Container(
        child: widget.model.listTeller.length == 1
            ? Column(children: [SizedBox(height: 25), listTile(0)])
            : widget.model.listTeller.length == 2
                ? Column(
                    children: [SizedBox(height: 25), listTile(0), listTile(1)])
                : widget.model.listTeller.length == 3
                    ? Column(children: [
                        SizedBox(height: 25),
                        listTile(0),
                        listTile(1),
                        listTile(2)
                      ])
                    : widget.model.listTeller.length == 4
                        ? Column(children: [
                            SizedBox(height: 25),
                            listTile(0),
                            listTile(1),
                            listTile(2),
                            listTile(3)
                          ])
                        : widget.model.listTeller.length > 4
                            ? Column(children: [
                                SizedBox(height: 25),
                                listTile(0),
                                listTile(1),
                                listTile(2),
                                listTile(3),
                                listTile(4)
                              ])
                            : Container());
  }

  Widget tarikTransferBelumSiap() {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Center(
        child: Text(
          "Fitur Tarik Dana via Transfer bank sedang dalam perbaikan",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  launchWhatsApp(nomerWA) async {
    nomerWA = nomerWA.substring(1);

    final link = WhatsAppUnilink(
      phoneNumber: '+62' + nomerWA,
      text: """
Assalamualaikum, saya *${widget.model.nama}* dari komunitas *${widget.model.namaKomunitas}* telah mengajukan penarikan dana sebesar :\n
*${rupiah(widget.jumlah)}*\n
Jenis penarikan : *Tunai*\n
    """,
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }
}
