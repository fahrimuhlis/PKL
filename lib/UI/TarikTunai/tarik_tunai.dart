import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:Edimu/UI/TarikTunai/confirm_tariktunai.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vibration/vibration.dart';

class TarikTunai extends StatefulWidget {
  MainModel model;

  TarikTunai(this.model);

  @override
  _TarikTunaiState createState() => _TarikTunaiState();
}

class _TarikTunaiState extends State<TarikTunai> {
  TextEditingController amount = MoneyMaskedTextController(
      thousandSeparator: '.', decimalSeparator: "", precision: 0);

  final formKey = GlobalKey<FormState>(); //untuk validasi

  tambahUang(int tambah) {
    amount.text = tambah.toString();
  }

  double _lebar = 301;

  static double lebarUang_besar = 147;
  static double lebarUang_kecil = 95;

  static double uang10 = lebarUang_besar;
  static double uang20 = lebarUang_besar;
  static double uang50 = lebarUang_besar;
  static double uang100 = lebarUang_besar;

  bool _canVibrate = true;

  FocusNode myFocusNode;

  bisaGetar() async {
    _canVibrate = await Vibration.hasVibrator();
  }

  void initState() {
    myFocusNode = FocusNode();
    bisaGetar();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          backgroundColor: Warna.hijauBG2,
          appBar: AppBar(
            title: Text("Tarik Tunai"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(5),
              decoration: Warna.bgGradient(Warna.warnaTunai),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Saldo : ' + rupiah(widget.model.formatedBalance)),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    "Masukkan jumlah uang yang ingin diambil :",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: TextFormField(
                      focusNode: myFocusNode,
                      keyboardType: TextInputType.number,
                      controller: amount,
                      // validator: (value){
                      //   int angka = int.parse(amount.text);
                      //   if (angka > int.parse(model.formatedBalance)){
                      //     return "Saldo anda tidak cukup";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      style: TextStyle(fontSize: 30),
                      decoration: InputDecoration(
                          prefixText: "Rp. ",
                          labelText: "Jumlah",
                          hintText: "Jumlah"),
                    ),
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Row(
                    //baris ke-1
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      tombolUang(10000, "10ribu", "Rp 10 ribu"),
                      tombolUang(20000, "20ribu", "Rp 20 ribu"),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    //baris ke-1
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      tombolUang(50000, "50ribu", "Rp 50 ribu"),
                      tombolUang(100000, "100ribu", "Rp 100 ribu"),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  tombolMasukkanAngka(),
                  SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 57,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Warna.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(9), // <-- Radius
                          ),
                        ),
                        // color: Warna.accent,
                        child: Text(
                          "Lanjut",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(9.0)),
                        onPressed: () async {
                          String modifString = amount.text.replaceAll(".", "");
                          modifString = modifString.replaceAll(",", "");

                          if (amount.text.isEmpty) {
                            Alert(
                                    type: AlertType.warning,
                                    context: context,
                                    title: "Info",
                                    desc: "Silahkan masukkan angka yang benar")
                                .show();
                          } else if (int.parse(modifString) > 0 &&
                              int.parse(modifString) < 10000) {
                            Alert(
                                    type: AlertType.warning,
                                    context: context,
                                    title: "Info",
                                    desc:
                                        "Minimum penarikan dana adalah Rp 10.000")
                                .show();
                          } else if (int.parse(modifString) >
                              int.parse(model.formatedBalance)) {
                            Alert(
                                    type: AlertType.warning,
                                    context: context,
                                    title: "Info",
                                    desc: "Saldo anda kurang")
                                .show();
                          } else if (int.parse(modifString) > 9999 &&
                              int.parse(modifString) <=
                                  int.parse(model.formatedBalance)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Confirm_TarikTunai(
                                        widget.model, int.parse(modifString))));
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        );
      },
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
                pattern: [0, 75],
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

  Widget tombolUang(int nominal, String gambar, String tampilanRupiah) {
    return GestureDetector(
      // enableFeedback: true,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 155),
        curve: Curves.easeIn,
        width: nominal == 10000
            ? uang10
            : nominal == 20000
                ? uang20
                : nominal == 50000
                    ? uang50
                    : nominal == 100000
                        ? uang100
                        : 185,
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset("lib/assets/$gambar.jpg")),
                Container(
                  height: 25,
                  child: Center(
                    child: Text(tampilanRupiah,
                        style: TextStyle(color: Colors.grey[600])),
                  ),
                )
              ],
            )),
      ),
      onTap: () {
        //debugPrint("tap tap mantap");
        _canVibrate
            ? Vibration.vibrate(
                pattern: [0, 75],
              )
            : null;
        tambahUang(nominal);
      },
      onTapDown: (_) {
        setState(() {
          // lebarUang = (MediaQuery.of(context).size.width - 251);
          if (nominal == 10000) {
            uang10 = lebarUang_kecil;
          } else if (nominal == 20000) {
            uang20 = lebarUang_kecil;
          } else if (nominal == 50000) {
            uang50 = lebarUang_kecil;
          } else if (nominal == 100000) {
            uang100 = lebarUang_kecil;
          }
          //debugPrint("uang50 setelah diupdate = ${uang50.toString()}");
        });
        //debugPrint("ini tapdown");
      },
      onTapUp: (hoy) {
        setState(() {
          if (nominal == 10000) {
            uang10 = lebarUang_besar;
          } else if (nominal == 20000) {
            uang20 = lebarUang_besar;
          } else if (nominal == 50000) {
            uang50 = lebarUang_besar;
          } else if (nominal == 100000) {
            uang100 = lebarUang_besar;
          }
        });
        //debugPrint("haloooo ini tapUp");
      },
      onTapCancel: () {
        setState(() {
          if (nominal == 10000) {
            uang10 = lebarUang_besar;
          } else if (nominal == 20000) {
            uang20 = lebarUang_besar;
          } else if (nominal == 50000) {
            uang50 = lebarUang_besar;
          } else if (nominal == 100000) {
            uang100 = lebarUang_besar;
          }
        });
      },
    );
  }
}
