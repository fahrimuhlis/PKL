import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:rflutter_alert/rflutter_alert.dart';

class MerchantConfirmationPage extends StatefulWidget {
  MainModel model;
  int totalBelanja = 0;
  String idBuyer;
  String namaBuyer;
  String saldoBuyer;
  String nohapeWali;

  MerchantConfirmationPage(this.model, this.totalBelanja, this.idBuyer,
      this.namaBuyer, this.saldoBuyer, this.nohapeWali);

  @override
  _MerchantConfirmationPageState createState() =>
      _MerchantConfirmationPageState();
}

class _MerchantConfirmationPageState extends State<MerchantConfirmationPage> {
  var textOnQR = "";
  var infoUser = {};
  var isianPIN = TextEditingController();
  var isianDeskripsi = TextEditingController();

  void initState() {
    isianDeskripsi.text = "tidak ada catatan";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Merchant Edimu"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(child: informasiUserContainer()),
            Positioned(bottom: 0, child: tombolBayar())
          ],
        ),
      ),
    );
  }

  Widget informasiUserContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
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
            trailing: Text(widget.namaBuyer),
          ),
          ListTile(
            title: Text("ID Login :"),
            trailing: Text(widget.idBuyer),
          ),
          ListTile(
            title: Text("Saldo :"),
            trailing: Text(rupiah(widget.saldoBuyer)),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(9)),
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 11),
              // width: 291,
              // height: 75,
              child: Column(
                children: [
                  Text("Total belanja :"),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    rupiah(widget.totalBelanja),
                    style: TextStyle(fontSize: 45),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              "batalkan",
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.red[800],
                  decoration: TextDecoration.underline),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  alertTotalHarga() {
    Alert(
        closeFunction: () {
          Navigator.pop(context);
        },
        context: context,
        title: "Masukkan PIN Transaksi",
        content: Column(
          children: [
            TextField(
              autofocus: true,
              controller: isianPIN,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "PIN Transaksi",
                labelStyle: TextStyle(fontSize: 25),
                icon: Icon(Icons.assignment),
              ),
            )
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
              onPressed: () async {
                EasyLoading.show(
                    status: 'sedang diproses',
                    maskType: EasyLoadingMaskType.black,
                    dismissOnTap: true);

                bool response = await widget.model.confirmBelanjaMerchant(
                    isianPIN.text,
                    widget.idBuyer,
                    widget.totalBelanja,
                    isianDeskripsi.text);

                EasyLoading.dismiss();

                if (int.parse(widget.saldoBuyer) > widget.totalBelanja &&
                    response) {
                  Alert(
                      context: context,
                      title: "Berhasil",
                      desc: "Transaksi Berhasil",
                      type: AlertType.success,
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ]).show();
                } else {
                  Alert(
                      context: context,
                      title: "Transaksi Gagal",
                      desc: "PIN Transaksi salah",
                      type: AlertType.error,
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ]).show();
                }
              })
        ]).show();
  }

  Widget tombolBayar() {
    return MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 71,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(9), topLeft: Radius.circular(15))),
        color: Colors.blue,
        onPressed: () async {
          alertTotalHarga();
        },
        child: Text("Lanjutkan", style: TextStyle(color: Colors.white)));
  }
}
