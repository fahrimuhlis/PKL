import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'dart:math';
import 'confirm_topup.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:vibration/vibration.dart';
import 'package:indonesia/indonesia.dart';
import 'package:qr_flutter/qr_flutter.dart';

class topUpPage extends StatefulWidget {
  MainModel model;

  topUpPage(this.model);

  @override
  _topUpPageState createState() => _topUpPageState();
}

class _topUpPageState extends State<topUpPage> {
  int uang = 0;
  String dropdownValue = 'BSM';

  Random random = new Random();
  int total;
  int kirimUangTotal;

  bool _canVibrate = false;

  FocusNode myFocusNode;

  double _lebar = 301;

  tesGetar() async {
    _canVibrate = await Vibration.hasVibrator();
  }

  void initState() {
    myFocusNode = FocusNode();
    tesGetar();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

//  List<DropdownMenuItem> listBank;
//
//
//  DropdownMenuItem a = DropdownMenuItem();

  TextEditingController amount = MoneyMaskedTextController(
      thousandSeparator: '.', decimalSeparator: "", precision: 0);

  tambahUang(int tambah) {
    amount.text = tambah.toString();
  }

  hitung() {
    int angka = random.nextInt(499);
    //debugPrint("isi var angka = ${angka.toString()}");

    String modifString = amount.text.replaceAll(".", "");
    modifString = modifString.replaceAll(",", "");

    //debugPrint("isi var modifString = ${modifString}");

    kirimUangTotal = int.parse(modifString) + angka;
    //debugPrint(kirimUangTotal.toString());
    // setState(() {});
  }

  double elevasi = 5;

  static double lebarUang_besar = 159;
  static double lebarUang_kecil = 121;
  static double tinggiUang_besar = 75;
  static double tinggiUang_kecil = 55;

  static double uang10 = lebarUang_besar;
  static double uang20 = lebarUang_besar;
  static double uang50 = lebarUang_besar;
  static double uang100 = lebarUang_besar;

  static double tinggiUang10 = tinggiUang_besar;
  static double tinggiUang20 = tinggiUang_besar;
  static double tinggiUang50 = tinggiUang_besar;
  static double tinggiUang100 = tinggiUang_besar;

  @override
  Widget build(BuildContext context) {
    // double lebarUang = MediaQuery.of(context).size.width - 185;

    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Isi Saldo'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
//                Text("Rp. "),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: TextField(
                    focusNode: myFocusNode,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    controller: amount,
                    style: TextStyle(fontSize: 30),
                    decoration: InputDecoration(
                        prefixText: "Rp ",
                        suffix: Padding(
                          padding:
                              EdgeInsets.only(right: 5, bottom: 0, top: 10),
                          child: InkWell(
                            onTap: () {
                              amount.text = "0";
                            },
                            child: Container(
                                width: 75,
                                height: 25,
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red[800],
                                )),
                          ),
                        )),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 10, left: 10),
                //   child: Wrap(
                //     children: <Widget>[
                //       tombolUang("Rp.10 rb", 10000),
                //       tombolUang("Rp.50 rb", 50000),
                //       tombolUang("Rp.100 rb", 100000),
                //       tombolUang("Rp.200 rb", 200000),
                //       tombolUang("Rp.300 rb", 300000),
                //       tombolUang("Rp.1 Juta", 1000000),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 9,
                ),

                Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(9.0)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  child: Column(
                    children: [
                      Text("Konfirmasi saldo hanya dapat dilayani pada:",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(height: 5),
                      Text("senin - jum'at",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(height: 5),
                      Text("07.00-20.00 WIB",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                Row(
                  //baris ke-1
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tombolUang2(100000, "100 rb"),
                    tombolUang2(200000, "200 rb"),
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                Row(
                  //baris ke-2
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tombolUang2(500000, "500 rb"),
                    tombolUang2(1000000, "1 juta")
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                tombolMasukkanAngka(),
                // Container(
                //   width: MediaQuery.of(context).size.width - 185,
                //   child: ElevatedButton(
                //       padding: EdgeInsets.all(0),
                //       elevation: 9,
                //       onPressed: () {},
                //       child: Image.asset("lib/assets/50ribu.jpg")),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10),
                  child: Text("Isi saldo dengan transfer ke bank:"),
                ),
                Container(
                  height: 30,
                  // alignment: AlignmentDirectional.centerStart,
                  margin: EdgeInsets.only(top: 5, left: 10),
                  child: DropdownButton<String>(
                      focusColor: Color(0xff00D6AB),
                      value: widget.model.dataBank['namaBank'],
                      elevation: 16,
                      items: <String>[widget.model.dataBank['namaBank']]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      }),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                //   child: Text("Atau isi saldo dengan QRIS"),
                // ),
                // ElevatedButton.icon(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue,
                //   ),
                //   onPressed: () {
                //     hitung();
                //     if (kirimUangTotal > 24999) {
                //       showQRISImage();
                //     } else {
                //       Alert(
                //           context: context,
                //           title: "Mohon Maaf",
                //           type: AlertType.info,
                //           desc: "Minimum topup adalah Rp 25.000",
                //           buttons: [
                //             DialogButton(
                //                 child: Text(
                //                   "OK",
                //                   style: TextStyle(color: Colors.white),
                //                 ),
                //                 onPressed: () {
                //                   Navigator.pop(context);
                //                 })
                //           ]).show();
                //     }
                //   },
                //   label: Text("Show QRIS"),
                //   icon: Icon(Icons.qr_code_scanner_rounded),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text(
                      "LANJUT",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // <-- Radius
                      ),
                    ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(4.0),
                    // ),
                    // color: Colors.blue[800],
                    onPressed: () async {
                      hitung();

                      // Map a = await model.confirmTopUp(
                      //   kirimUangTotal,
                      // );

                      // //debugPrint(".......mmm");
                      // //debugPrint(a['id'].toString());
                      // //debugPrint(".......");
                      // //debugPrint("=========  a length ${a.length.toString()}");

                      if (kirimUangTotal > 24999) {
                        //debugPrint(
                        // "isi dari kirimUangTotal adalah $kirimUangTotal");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  konfirmTopUp(kirimUangTotal, widget.model)),
                        );
                      } else {
                        Alert(
                            context: context,
                            title: "Mohon Maaf",
                            type: AlertType.info,
                            desc: "Minimum topup adalah Rp 25.000",
                            buttons: [
                              DialogButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ]).show();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.71,
                child: SingleChildScrollView(
                  child: Container(
                    height: 490,
                    child: Column(
                      children: [
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: QrImage(
                            data:
                                "00020101021226620017WWW.BANKDKI.CO.ID01189360011100000357230208000357230303UMI51400017WWW.BANKDKI.CO.ID0208000357230303UMI520454995303360540710000005802ID5909EDIMU25016011Kota Bekasi61051714562340112hoejygsLzXCw02140812345678901663042C22",
                            version: QrVersions.auto,

                            size: 300,
                            gapless: true,
                            // gambar error
                            // embeddedImage: AssetImage("lib/assets/logo.png"),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.24,
                            color: Colors.white,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("silahkan isi saldo sejumlah :"),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  rupiah(kirimUangTotal),
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
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          TextSpan(
                                              text: " LANJUT ",
                                              style: TextStyle(
                                                  color: Colors.blue[800],
                                                  fontWeight: FontWeight.bold)),
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
                            ))
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
        onPressed: () async {},
      ),
    );
  }

  Widget tombolMasukkanAngka() {
    return GestureDetector(
      // enableFeedback: true,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 155),
        curve: Curves.easeIn,
        height: 71,
        width: _lebar,
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Card(
            elevation: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline,
                    size: 25, color: Colors.grey[600]),
                SizedBox(width: 9),
                Text(
                  "Masukkan angka",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            )),
      ),
      onTap: () {
        setState(() {
          _lebar = 301;
        });
        _canVibrate
            ? Vibration.vibrate(
                pattern: [
                  0,
                  75,
                ],
              )
            : null;
        //debugPrint("tap tap mantap");
        myFocusNode.requestFocus();
        amount.text = "0";
      },
      onTapDown: (_) {
        setState(() {
          _lebar = 171;
        });
        //debugPrint("ini tapdown");
      },
      onTapUp: (hoy) {
        setState(() {
          _lebar = 301;
        });
        //debugPrint("haloooo ini tapUp");
      },
      onTapCancel: () {
        setState(() {
          _lebar = 301;
        });
      },
    );
  }

  // Widget tombolUang(int nominal, String gambar, String tampilanRupiah) {
  //   return GestureDetector(
  //     // enableFeedback: true,
  //     child: AnimatedContainer(
  //       duration: Duration(milliseconds: 155),
  //       curve: Curves.easeIn,
  //       width: nominal == 10000
  //           ? uang10
  //           : nominal == 20000
  //               ? uang20
  //               : nominal == 50000
  //                   ? uang50
  //                   : nominal == 100000
  //                       ? uang100
  //                       : 185,
  //       margin: EdgeInsets.symmetric(horizontal: 15),
  //       child: Card(
  //           elevation: 15,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(5))),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               ClipRRect(
  //                   borderRadius: BorderRadius.circular(5),
  //                   child: Image.asset("lib/assets/$gambar.jpg")),
  //               Container(
  //                 height: 25,
  //                 child: Center(
  //                   child: Text(tampilanRupiah,
  //                       style: TextStyle(color: Colors.grey[600])),
  //                 ),
  //               )
  //             ],
  //           )),
  //     ),
  //     onTap: () {
  //       //debugPrint("tap tap mantap");
  //       tambahUang(nominal);
  //       _canVibrate ? Vibrate.feedback(FeedbackType.medium) : null;
  //     },
  //     onTapDown: (_) {
  //       setState(() {
  //         // lebarUang = (MediaQuery.of(context).size.width - 251);
  //         if (nominal == 10000) {
  //           uang10 = lebarUang_kecil;
  //         } else if (nominal == 20000) {
  //           uang20 = lebarUang_kecil;
  //         } else if (nominal == 50000) {
  //           uang50 = lebarUang_kecil;
  //         } else if (nominal == 100000) {
  //           uang100 = lebarUang_kecil;
  //         }
  //         //debugPrint("uang50 setelah diupdate = ${uang50.toString()}");
  //       });
  //       //debugPrint("ini tapdown");
  //     },
  //     onTapUp: (hoy) {
  //       setState(() {
  //         if (nominal == 10000) {
  //           uang10 = lebarUang_besar;
  //         } else if (nominal == 20000) {
  //           uang20 = lebarUang_besar;
  //         } else if (nominal == 50000) {
  //           uang50 = lebarUang_besar;
  //         } else if (nominal == 100000) {
  //           uang100 = lebarUang_besar;
  //         }
  //       });
  //       //debugPrint("haloooo ini tapUp");
  //     },
  //     onTapCancel: () {
  //       setState(() {
  //         if (nominal == 10000) {
  //           uang10 = lebarUang_besar;
  //         } else if (nominal == 20000) {
  //           uang20 = lebarUang_besar;
  //         } else if (nominal == 50000) {
  //           uang50 = lebarUang_besar;
  //         } else if (nominal == 100000) {
  //           uang100 = lebarUang_besar;
  //         }
  //       });
  //     },
  //   );
  // }

  Widget tombolUang2(int nominal, String tampilanRupiah) {
    return GestureDetector(
      // enableFeedback: true,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 255),
        curve: Curves.easeIn,
        height: nominal == 100000
            ? tinggiUang10
            : nominal == 200000
                ? tinggiUang20
                : nominal == 500000
                    ? tinggiUang50
                    : nominal == 1000000
                        ? tinggiUang100
                        : 55,
        width: nominal == 100000
            ? uang10
            : nominal == 200000
                ? uang20
                : nominal == 500000
                    ? uang50
                    : nominal == 1000000
                        ? uang100
                        : 185,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Rp "),
                  ),
                ),
                Text(
                  tampilanRupiah,
                  style: TextStyle(fontSize: 29),
                )
              ],
            ))),
      ),
      onTap: () {
        //debugPrint("tap tap mantap");
        _canVibrate
            ? Vibration.vibrate(
                pattern: [
                  0,
                  50,
                ],
              )
            : null;
        tambahUang(nominal);
      },
      onTapDown: (_) {
        setState(() {
          // lebarUang = (MediaQuery.of(context).size.width - 251);
          if (nominal == 100000) {
            uang10 = lebarUang_kecil;
            tinggiUang10 = tinggiUang_kecil;
          } else if (nominal == 200000) {
            uang20 = lebarUang_kecil;
            tinggiUang20 = tinggiUang_kecil;
          } else if (nominal == 500000) {
            uang50 = lebarUang_kecil;
            tinggiUang50 = tinggiUang_kecil;
          } else if (nominal == 1000000) {
            uang100 = lebarUang_kecil;
            tinggiUang100 = tinggiUang_kecil;
          }
          //debugPrint("uang50 setelah diupdate = ${uang50.toString()}");
        });
        //debugPrint("ini tapdown");
      },
      onTapUp: (hoy) {
        setState(() {
          if (nominal == 100000) {
            uang10 = lebarUang_besar;
            tinggiUang10 = tinggiUang_besar;
          } else if (nominal == 200000) {
            uang20 = lebarUang_besar;
            tinggiUang20 = tinggiUang_besar;
          } else if (nominal == 500000) {
            uang50 = lebarUang_besar;
            tinggiUang50 = tinggiUang_besar;
          } else if (nominal == 1000000) {
            uang100 = lebarUang_besar;
            tinggiUang100 = tinggiUang_besar;
          }
        });
        //debugPrint("haloooo ini tapUp");
      },
      onTapCancel: () {
        setState(() {
          if (nominal == 100000) {
            uang10 = lebarUang_besar;
            tinggiUang10 = tinggiUang_besar;
          } else if (nominal == 200000) {
            uang20 = lebarUang_besar;
            tinggiUang20 = tinggiUang_besar;
          } else if (nominal == 500000) {
            uang50 = lebarUang_besar;
            tinggiUang50 = tinggiUang_besar;
          } else if (nominal == 1000000) {
            uang100 = lebarUang_besar;
            tinggiUang100 = tinggiUang_besar;
          }
        });
      },
    );
  }
}
