import 'package:Edimu/Widgets/EasyLoadingWidgget.dart';
import 'package:Edimu/Widgets/WhatsappBox.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class KonfirmasiTarikTransfer extends StatefulWidget {
  MainModel model;
  Map dataBank;
  int jumlah;
  //
  KonfirmasiTarikTransfer(this.model, this.dataBank, this.jumlah);
  //
  @override
  KonfirmasiTarikTransferState createState() => KonfirmasiTarikTransferState();
}

class KonfirmasiTarikTransferState extends State<KonfirmasiTarikTransfer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Tarik Transfer"),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Image.asset(
                      "lib/assets/bank_icons/${widget.dataBank['gambar']}",
                      width: 131,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ListTile(
                      title: Container(child: Text("nama rekening")),
                      trailing: Text(widget.dataBank["rekening_atas_nama"]),
                    ),
                    ListTile(
                      title: Container(child: Text("nama bank")),
                      trailing: Text(widget.dataBank["nama_bank"]),
                    ),
                    ListTile(
                      title: Container(child: Text("jumlah")),
                      trailing: Text(rupiah(widget.jumlah)),
                    ),
                    // ElevatedButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       "Cairkan",
                    //       style: TextStyle(color: Colors.white),
                    //     ))
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: tombolKonfirmasiTarikTransfer(widget.model),
                )
              ],
            )));
  }

  Widget tombolKonfirmasiTarikTransfer(model) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        child: Text(
          "Cairkan",
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
          popupPin();
        },
      ),
    );
  }

  popupPin() async {
    var pinController = TextEditingController();
    String pesanWA = """
Assalamualaikum, saya *${widget.model.nama}* dari komunitas *${widget.model.namaKomunitas}* telah mengajukan penarikan dana sebesar :\n
*${rupiah(widget.jumlah)}*\n
Jenis penarikan : *Transfer*\n
berikut detail Rekening Tujuan penarikan dana :
Nama Bank : *${widget.dataBank['nama_bank']}*\nNo. Rekening : *${widget.dataBank['norek_bank']}*\nAtas Nama : *${widget.dataBank['rekening_atas_nama']}*\n
    """;
    //
    Alert(
        context: context,
        title: "PIN",
        desc: "Masukkan PIN anda",
        content: TextField(
          autofocus: true,
          obscureText: true,
          controller: pinController,
          keyboardType: TextInputType.number,
        ),
        buttons: [
          DialogButton(
              color: Colors.red[800],
              child: Text(
                "batal",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.pop(context);
              }),
          DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                EdimuLoading.munculkan();
                String respon = await widget.model.requestTarikTransfer(
                    widget.jumlah,
                    widget.dataBank['id_bank_nasabah'],
                    pinController.text);
                //
                EdimuLoading.tutup();
                if (respon == "sukses") {
                  Alert(
                      context: context,
                      title: "Sukses",
                      type: AlertType.success,
                      closeFunction: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      desc: "Permohonan tarik transfer berhasil.",
                      content: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                              ),
                              // height: 45,
                              // color: Colors.green[600],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('lib/assets/whatsapp.png',
                                      width: 25),
                                  SizedBox(width: 7),
                                  Text('Ingatkan Teller',
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                              onPressed: () async {
                                launchWhatsApp(
                                    widget.model.nohpTeller1, pesanWA);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              launchWhatsApp(widget.model.nohpTeller1, pesanWA);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            })
                      ]).show();
                } else if (respon == "pin salah") {
                  Alert(
                      context: context,
                      type: AlertType.info,
                      title: "pin salah",
                      desc: "silahkan masukkan PIN yang benar",
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
                } else {
                  Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Error",
                      desc: "Maaf, sistem sedang error.",
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
              })
        ]).show();
  }

  launchWhatsApp(String nomerWA, String pesan) async {
    nomerWA = nomerWA.substring(1);

    final link = WhatsAppUnilink(
      phoneNumber: '+62' + nomerWA,
      text: pesan,
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }
}
