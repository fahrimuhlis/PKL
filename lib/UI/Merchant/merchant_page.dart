import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/Merchant/merchant_confirmation_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
// import 'package:majascan/majascan.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:rflutter_alert/rflutter_alert.dart';

class MerchantPage extends StatefulWidget {
  MainModel model;
  MerchantPage(this.model);

  @override
  _MerchantPageState createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  var textOnQR = "";
  var infoUser = {};

  String idUser;
  String nohapeWali;

  var isianTotalHarga = TextEditingController();
  var isianCatatan = TextEditingController();
  String catatan = "";

  void initState() {
    isianCatatan.text = "";
    isianTotalHarga.text = "";
    super.initState();
  }

  initScan() async {
    await Permission.camera.request();
    // textOnQR = await MajaScan.startScan(
    //     title: "Silahkan scan kartu",
    //     barColor: Warna.primary,
    //     qRCornerColor: Colors.blue[800],
    //     qRScannerColor: Colors.deepPurple,
    //     scanAreaScale: 0.7);

    infoUser = await widget.model.getUserById(textOnQR);

    setState(() {});

    EasyLoading.show(
        status: 'sedang diproses',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);

    infoUser = await widget.model.getUserById(textOnQR);

    idUser = textOnQR;

    //debugPrint("isi data infoUser yang tertangkap :");
    //debugPrint(infoUser["saldo"]);

    EasyLoading.dismiss();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Merchant Edimu"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            setelahTambahBelanja(),
            SizedBox(
              height: 11,
            ),
          ],
        )),
      ),
    );
  }

  Widget informasiUserContainer() {
    if (infoUser.length > 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Center(
              child: Text("Data Pembeli"),
            ),
            SizedBox(
              height: 25,
            ),
            Icon(
              Icons.person,
              size: 125,
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text("Nama :"),
              trailing: Text(infoUser["name"]),
            ),
            ListTile(
              title: Text("No .HP :"),
              trailing: Text(infoUser['nohape']),
            ),
            ListTile(
              title: Text("Saldo :"),
              trailing: Text(rupiah(infoUser["saldo"])),
            ),
            SizedBox(
              height: 45,
            ),
            Container(
              width: 301,
              height: 51,
              color: Colors.blue,
              child: ElevatedButton(
                  // minWidth: 301,
                  // height: 51,
                  // color: Colors.blue,
                  onPressed: () async {
                    alertTotalHarga();
                  },
                  child:
                      Text("Lanjutkan", style: TextStyle(color: Colors.white))),
            ),
            SizedBox(
              height: 13,
            ),
            InkWell(
              onTap: () {
                initScan();
              },
              child: Text(
                "scan lagi",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.blue[800],
                    decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(11),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            // Text(
            //   "Tidak ada data belanja",
            //   style: TextStyle(color: Colors.red[800]),
            // ),
            // SizedBox(
            //   height: 7,
            // ),
            // Text(
            //   "Silahkan scan kembali QR-Code dengan posisi yang benar",
            //   textAlign: TextAlign.center,
            // ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
                // color: Colors.blue,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(100)),
                onPressed: () async {
                  alertTotalHarga();
                },
                child: SizedBox(
                  height: 55,
                  width: 215,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text("Masukkan belanjaan",
                          style: TextStyle(fontSize: 17, color: Colors.white))
                    ],
                  ),
                ))
          ],
        ),
      );
    }
  }

  Widget setelahTambahBelanja() {
    if (isianTotalHarga.text != "") {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Icon(
              Icons.shopping_bag_rounded,
              size: 125,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Total belanja:",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              rupiah(isianTotalHarga.text),
              style: TextStyle(fontSize: 55, color: Colors.blue),
            ),
            SizedBox(
              height: 7,
            ),
            InkWell(
                onTap: () {
                  alertTotalHarga();
                  setState(() {});
                },
                child: SizedBox(
                  width: 155,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.red[800],
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "ubah angka",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.red[800],
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 245,
            ),
            Container(
              width: 301,
              height: 51,
              color: Colors.blue,
              child: ElevatedButton(
                  // minWidth: 301,
                  // height: 51,
                  // color: Colors.blue,
                  onPressed: () async {
                    await initScan();

                    if (infoUser.length > 1 &&
                        int.parse(isianTotalHarga.text) > 4999) {
                      int totalBelanja = int.parse(isianTotalHarga.text);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MerchantConfirmationPage(
                                  widget.model,
                                  totalBelanja,
                                  idUser,
                                  infoUser['name'],
                                  infoUser['saldo'],
                                  infoUser['nohape'])));
                    } else {
                      alertUserTidakDitemukan();
                    }
                  },
                  child: SizedBox(
                    width: 255,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text("Scan Kartu",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  )),
            ),
            SizedBox(
              height: 13,
            ),
            //
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(11),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.21,
            ),
            // Text(
            //   "Tidak ada data belanja",
            //   style: TextStyle(color: Colors.red[800]),
            // ),
            // SizedBox(
            //   height: 7,
            // ),
            // Text(
            //   "Silahkan scan kembali QR-Code dengan posisi yang benar",
            //   textAlign: TextAlign.center,
            // ),
            SizedBox(
              height: 55,
            ),
            MaterialButton(
              color: Colors.blue,
              height: 165,
              minWidth: 165,
              shape: CircleBorder(
                  side: BorderSide(
                      width: 2, color: Colors.red, style: BorderStyle.none)),
              child: Icon(
                Icons.add_shopping_cart_rounded,
                color: Colors.white,
                size: 55,
              ),
              onPressed: () {
                alertTotalHarga();
                if (isianTotalHarga.text != "") {
                  setState(() {});
                }
              },
            ),
            SizedBox(
              height: 29,
            ),
            Container(
              width: 201,
              child: Text(
                'masukkan total belanja',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 31),
              ),
            )
          ],
        ),
      );
    }
  }

  alertTotalHarga() {
    Alert(
        closeFunction: () {},
        context: context,
        title: "Masukkan total belanja",
        content: Column(
          children: [
            TextField(
              autofocus: true,
              controller: isianTotalHarga,
              // obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Total harga",
                labelStyle: TextStyle(fontSize: 25),
                icon: Icon(Icons.assignment),
              ),
            ),
            SizedBox(
              height: 21,
            ),
            widgetIsianCatatan()
          ],
        ),
        buttons: [
          // DialogButton(
          //     color: Colors.red[800],
          //     child: Text(
          //       "batalkan",
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     onPressed: () {}),
          DialogButton(
              width: 201,
              color: Warna.primary,
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                int totalBelanja;

                if (isianTotalHarga.text.isNotEmpty) {
                  if (int.parse(isianTotalHarga.text) > 4999) {
                    totalBelanja = int.parse(isianTotalHarga.text);
                    Navigator.pop(context);

                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MerchantConfirmationPage(
                    //             widget.model,
                    //             totalBelanja,
                    //             idUser,
                    //             infoUser['name'],
                    //             infoUser['saldo'],
                    //             infoUser['nohape'])));
                  } else {
                    Alert(
                        context: context,
                        title: "Error",
                        type: AlertType.error,
                        desc: "Minimal belanja adalah Rp. 5000.",
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
                } else {
                  Alert(
                      context: context,
                      title: "Error",
                      type: AlertType.error,
                      desc: "Nominal belanja tidak boleh kosong",
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
              })
        ]).show();
  }

  Widget widgetIsianCatatan() {
    var penampungWidgetCatatan;

    if (isianCatatan.text == "") {
      return Row(
        children: [
          // Icon(
          //   Icons.add,
          //   color: Colors.blue[800],
          // ),
          // // SizedBox(width: 7),
          // // Text(
          // //   'Tambahkan Catatan',
          // //   style: TextStyle(
          // //       color: Colors.blue[800], decoration: TextDecoration.underline),
          // // )
        ],
      );
    } else {
      return Container();
    }
  }

  alertUserTidakDitemukan() {
    Alert(
        context: context,
        title: "Kartu tidak dapat di-identifikasi",
        type: AlertType.error,
        desc: "Silahkan scan kembali dengan posisi yang benar.",
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
}
