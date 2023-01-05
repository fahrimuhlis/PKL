import 'package:Edimu/konfigurasi/KonfigurasiAplikasi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:math';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:clipboard/clipboard.dart';
import 'package:Edimu/konfigurasi/KonfigurasiAplikasi.dart';
import 'package:Edimu/UI/HomePage/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
//import 'package:clipboard_manager/clipboard_manager.dart';

class konfirmTopUp extends StatefulWidget {
  int jumlah;
  MainModel model;

  konfirmTopUp(this.jumlah, this.model);
  @override
  _konfirmTopUpState createState() => _konfirmTopUpState();
}

class _konfirmTopUpState extends State<konfirmTopUp> {
//  Random random = new Random();
//  int total;

//  hitung(){
//     int angka = random.nextInt(999);
//     int a = widget.jumlah;
//
//     total = widget.jumlah + angka;
//     //debugPrint('ooooooooo');
//     //debugPrint(total.toString());
//     setState(() {
//
//     });
//  }

  String norekBank;
  String atasNamaRekening;
  String namaBank;

  String linkGambarQRIS = "";

  void initState() {
    norekBank = widget.model.dataBank['norekBank'];
    atasNamaRekening = widget.model.dataBank['atasNama'];
    namaBank = widget.model.dataBank['namaBank'];
    //
    getLinkQRIS();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getLinkQRIS() async {
    EasyLoading.show(
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
    );
    linkGambarQRIS = await widget.model.getQRIS();
    setState(() {});
    //debugPrint("isi link QRIS");
    //debugPrint(linkGambarQRIS);
    EasyLoading.dismiss();
  }

  copyToClipBoard(norek, jenis) {
    FlutterClipboard.copy(norek);
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 24,
            title: Text('Berhasil'),
            content: Row(
              children: [
                Icon(
                  Icons.thumb_up,
                  size: 29,
                ),
                SizedBox(
                  width: 21,
                ),
                Flexible(child: Text('$jenis telah anda copy'))
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  showQRISImage() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Dialog(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.71,
                child: SingleChildScrollView(
                  child: Container(
                    height: 600,
                    // height: MediaQuery.of(context).size.height * 0.77,
                    // width: MediaQuery.of(context).size.width * 0.6,
                    child: Stack(
                      children: [
                        Container(
                            // width: MediaQuery.of(context).size.width * 0.6,
                            // height: MediaQuery.of(context).size.height,
                            height: 502,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        TemplateAplikasi.publicDomain +
                                            '/data_file/qris/' +
                                            linkGambarQRIS),
                                    fit: BoxFit.fitHeight))),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.24,
                              color: Colors.white,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("silahkan transfer sejumlah :"),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    rupiah(widget.jumlah),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.orange[900]),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: "Klik tombol",
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            TextSpan(
                                                text: " LANJUT ",
                                                style: TextStyle(
                                                    color: Colors.blue[800],
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    " jika sudah melakukan transfer")
                                          ])),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_downward_outlined,
                                    size: 29,
                                    color: Colors.orange[900],
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            
              tombolLanjut(widget.model)
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Isi Saldo"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, top: 5),
                  child:
                      Text('SILAHKAN TRANSFER KE NO. REKENING/QRIS BERIKUT :'),
                ),
                SizedBox(height: 3),
                ListTile(
                  title: Text(
                    "Nama Bank :",
                    style: TextStyle(
                      color: Colors.greenAccent[700],
                    ),
                  ),
                  subtitle: Text(model.dataBank['namaBank']),
                ),
                ListTile(
                    title: Text(
                      "Atas Nama :",
                      style: TextStyle(
                        color: Colors.greenAccent[700],
                      ),
                    ),
                    trailing: SizedBox(
                      width: 81,
                      child: tombolShowQRIS(),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              model.dataBank['atasNama'],
                            ),
                          ],
                        ),
                        // ElevatedButton(
                        //   child: Text("Salin",
                        //       style: TextStyle(
                        //           decoration: TextDecoration.underline)),
                        //   onPressed: () {
                        //     //   ClipboardManager.copyToClipBoard('Nur Hayati QQ Syirkah Permata U.');
                        //     // ClipboardManager()
                        //   },
                        // ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(vertical: 11),
                  color: Color(0xffD9FFED),
                  child: ListTile(
                      onTap: () {
                        copyToClipBoard(
                            model.dataBank['norekBank'], 'no. rekening');
                      },
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.dataBank['norekBank'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                              SizedBox(
                                height: 7,
                              ),
                              textShowQRIS()
                            ],
                          ),
                          Container(
                            height: 20,
                            child: ElevatedButton(
                              // height: 20,
                              child: Text("Salin",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline)),
                              onPressed: () {
                                copyToClipBoard(
                                    model.dataBank['norekBank'], 'no. rekening');
                              },
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 21),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('sejumlah :',
                        style: TextStyle(
                            // fontSize: 17,
                            // fontWeight: FontWeight.bold,
                            color: Colors.greenAccent[700])),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  color: Color(0xffD9FFED),
                  child: ListTile(
                      onTap: () {
                        copyToClipBoard(
                            widget.jumlah.toString(), 'Angka nominal');
                      },
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(rupiah(widget.jumlah.toString()),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25)),
                          Container(
                            height: 20,
                            child: ElevatedButton(
                              // height: 20,
                              child: Text("Salin",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline)),
                              onPressed: () {
                                copyToClipBoard(
                                    widget.jumlah.toString(), 'Angka Nominal');
                              },
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 15),
                // Container(
                //   color: Color(0xffFFEEC7),
                //   margin: EdgeInsets.symmetric(horizontal: 15),
                //   padding: EdgeInsets.all(5),
                //   child: Text(
                //       "Pastikan nominal transfer tepat beserta kode unik di 3 digit terahir",
                //       style: TextStyle(
                //         color: Colors.black54,
                //       )),
                // ),
                // Container(
                //   height: 7,
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    "Pastikan nominal sesuai hingga 3 digit terakhir.",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(height: 7),
                Container(
                  color: Color(0xffFFEEC7),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(11),
                  child: RichText(
                      text: TextSpan(
                          text:
                              "klik 'LANJUT' untuk melanjutkan proses isi saldo Edimu.",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                          children: [
                        // TextSpan(
                        //     text: "'KONFIRMASI ISI SALDO'",
                        //     style: TextStyle(
                        //         color: Colors.black,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 16)),
                        // TextSpan(
                        //     text: " dibawah ini.",
                        //     style: TextStyle(
                        //         color: Colors.black54,
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: 16))
                      ])),
                ),
                tombolLanjut(widget.model)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget textShowQRIS() {
    if (linkGambarQRIS != "belum") {
      return InkWell(
          onTap: () {
            showQRISImage();
          },
          child: Text(
            "Munculkan QRCode QRIS",
            style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ));
    } else {
      return InkWell(
          onTap: () {
            //
          },
          child: Text(
            "kode QRIS belum tersedia",
            style: TextStyle(
              color: Colors.red[800],
              fontWeight: FontWeight.bold,
            ),
          ));
    }
  }

  Widget tombolShowQRIS() {
    //debugPrint("isi linkGambarQRIS = ${linkGambarQRIS}");

    return linkGambarQRIS != "belum"
        ? InkWell(
            onTap: () {
              showQRISImage();
            },
            child: Container(
                padding: EdgeInsets.all(7),
                color: Colors.blue[800],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "QRIS",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
          )
        : Container();
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
            // height: 45,
              style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      
                    ),
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

  Widget tombolLanjut(MainModel model) {
    return Container(
      height: 49,
      width: MediaQuery.of(context).size.width - 17,
      margin: EdgeInsets.only(top: 5),
      child: ElevatedButton(
        child: Text(
          "LANJUT",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
          style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // <-- Radius
                      ),
                    ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
        // color: Colors.blue[800],
        onPressed: () async {
          EasyLoading.show(
            status: 'sedang diproses',
            maskType: EasyLoadingMaskType.black,
          );

          Map responseTopup = await model.topup(widget.jumlah);

          if (responseTopup['success'] == true) {
            await widget.model.getTeller();
            EasyLoading.dismiss();
            Alert(
                type: AlertType.success,
                context: context,
                title: "TERIMA KASIH",
                desc:
                    "silahkan transfer sebesar ${rupiah(widget.jumlah)} ke : ",
                content: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      SizedBox(
                        height: 11,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 7),
                        decoration: BoxDecoration(
                            color: Colors.greenAccent[100],
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            Row(
                              children: [Text(namaBank)],
                            ),
                            SizedBox(
                              height: 11,
                            ),
                            Row(
                              children: [Text(norekBank)],
                            ),
                            SizedBox(
                              height: 11,
                            ),
                            Row(
                              children: [Text(atasNamaRekening)],
                            ),
                            SizedBox(
                              height: 11,
                            ),
                            Row(
                              children: [Text(rupiah(widget.jumlah))],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Text(
                      //   "silahkan konfirmasi melalui whatsapp berikut :",
                      //   textAlign: TextAlign.center,
                      // ),
                      // SizedBox(
                      //   height: 0,
                      // ),
                      // ContentListTeller(),
                      SizedBox(
                        height: 19,
                      ),
                      DialogButton(
                          color: Colors.grey[300],
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("kembali")),
                      SizedBox(
                        height: 5,
                      ),
                      DialogButton(
                        color: Colors.blue[800],
                        child: Text(
                          "OK, Sudah Transfer",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);

                          launchWhatsApp(widget.model.listTeller[0]['nohape']);
                        },
                      )
                    ])),
                buttons: []).show();
          } else {
            EasyLoading.dismiss();
            Alert(
                type: AlertType.error,
                context: context,
                title: "Top-up gagal",
                desc:
                    "Pengajuan Top-up saldo gagal, silahkan cek kembali jaringan internet anda",
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
          // model.topup(widget.jumlah);

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) =>
          //       topupOKPage()

          //   ),
          // );

          // Navigator.pushNamed(context, '/');
        },
      ),
    );
  }

  launchWhatsApp(nomerWA) async {
    nomerWA = nomerWA.substring(1);

    final link = WhatsAppUnilink(
      phoneNumber: '+62' + nomerWA,
      text: """
          Assalamualaikum, saya *${widget.model.nama}* dari komunitas *${widget.model.namaKomunitas}* sudah melakukan isi saldo Edimu sebesar *${rupiah(widget.jumlah)}*. mohon dicek terlebih dahulu.
          Berikut saya kirimkan bukti transfer saya
          """,
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }
}
