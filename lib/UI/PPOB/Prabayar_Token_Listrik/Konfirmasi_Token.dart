import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Token_Listrik/TokenListrikPage.dart';
import 'package:Edimu/Widgets/WhatsappBox.dart';
import 'package:Edimu/scoped_model/StatusTransaksiPPOB.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:indonesia/indonesia.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class KonfirmasiTokenPLNPage extends StatefulWidget {
 MainModel model;
  Map tokenYangDibeli;
  Map dataPelanggan;
  String idBiayaLayanan;
  int metodePembayaran;

  KonfirmasiTokenPLNPage(this.model, this.tokenYangDibeli, this.dataPelanggan,
      this.idBiayaLayanan, this.metodePembayaran);

  @override
  _KonfirmasiTokenPLNPageState createState() => _KonfirmasiTokenPLNPageState();
}

class _KonfirmasiTokenPLNPageState extends State<KonfirmasiTokenPLNPage> {
  var isianPin = TextEditingController();
  String namaPemilikNomor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Konfirmasi Pembelian"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text("Jenis Pembelian"),
                    trailing: Text("Token Listrik"),
                  ),
                  ListTile(
                    title: Text("ID Pelanggan"),
                    trailing: Text(widget.dataPelanggan["meter_no"]),
                  ),
                  ListTile(
                    title: Text("Nama Pelanggan"),
                    trailing: Text(widget.dataPelanggan["name"]),
                  ),
                  ListTile(
                    title: Text("Harga"),
                    trailing:
                        Text(rupiah(widget.tokenYangDibeli["harga_enduser"])),
                  ),
                    ListTile(
                    title: Text("Metode pembayaran"),
                    trailing: Text(widget.metodePembayaran == 1
                        ? "Saldo ediMU"
                        : "Pay Later"),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.blue[800]),
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.blue[800]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Info Pelanggan:",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 17),
                          Text(widget.dataPelanggan["name"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 7),
                          Text(widget.dataPelanggan["meter_no"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold))
                        ],
                      ))
                ],
              ),
            ),
            tombolBayarFixed()
          ],
        ));
  }

  Widget tombolBayarFixed() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 61,
        child: ElevatedButton(
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(19), topRight: Radius.circular(19))),
          // color: Colors.blue[800],
          onPressed: () async {
            popupPin();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.attach_money,
              //   color: Colors.white,
              // ),
              // SizedBox(
              //   width: 1,
              // ),
              Text(
                "Bayar",
                style: TextStyle(fontSize: 21, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  popupPin() {
    Alert(
        context: context,
        title: "Masukkan PIN Anda",
        closeIcon: Icon(Icons.close),
        // closeFunction: () {},
        content: Container(
          margin: EdgeInsets.only(top: 25),
          width: 205,
          child: PinCodeTextField(
            backgroundColor: Colors.transparent,
            appContext: context,
            controller: isianPin,
            autoDisposeControllers: false,
            length: 6,
            showCursor: false,
            enableActiveFill: true,
            obscureText: true,
            autoFocus: true,
            obscuringWidget: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle)),
            // obscuringCharacter: 'G',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {},
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 32,
              fieldWidth: 32,
              borderWidth: 2.5,
              activeColor: Colors.grey[400],
              inactiveColor: Colors.grey[300],
              selectedColor: Colors.green[400],
              activeFillColor: Colors.grey[400],
              inactiveFillColor: Colors.grey[300],
              selectedFillColor: Colors.grey[300],
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Colors.red[800],
            child: Text("Batal", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          DialogButton(
            color: Colors.blue[800],
            child: Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              EasyLoading.show(
                status: 'sedang diproses',
                maskType: EasyLoadingMaskType.black,
                dismissOnTap: true,
              );
              
               StatusPPOB res = await widget.model.beliTokenListrikPrepaid(
                  widget.tokenYangDibeli,
                  widget.dataPelanggan["meter_no"],
                  widget.idBiayaLayanan,
                  isianPin.text,
                  widget.metodePembayaran);

              if (res == StatusPPOB.sukses) {
                Alert(
                    context: context,
                    title: "Sukses",
                    type: AlertType.success,
                    desc: "pembelian token PLN berhasil",
                    buttons: [
                      DialogButton(
                          color: Colors.blue[800],
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);

                            TokenListrikPage(
                              widget.model,
                              1,
                            );
                          })
                    ]).show();
              } else if (res == StatusPPOB.salahPin) {
                Alert(
                    context: context,
                    title: "PIN SALAH",
                    type: AlertType.error,
                    desc: "Maaf, PIN anda salah, silahkan coba kembali",
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
              } else if (res == StatusPPOB.saldoKomunitasTidakCukup) {
                String _pesanWA =
                    "Saya *${widget.model.nama}* dari *${widget.model.namaKomunitas}* ingin melakukan pembelian *Token Listrik Prabayar* tetapi saldo PPOB komunitas ${widget.model.namaKomunitas} telah habis, mohon untuk segera isi saldo PPOB agar saya bisa segera membeli produk tersebut, Terima kasih 🙏 .";

                Alert(
                    context: context,
                    title: "MAAF",
                    type: AlertType.info,
                    desc:
                        "Saldo komunitas ${widget.model.namaKomunitas} tidak cukup untuk melakukan transaksi ini",
                    content: Container(
                      child: WhatsappBox(widget.model, _pesanWA),
                    ),
                    buttons: [
                      DialogButton(
                          color: Colors.blue[800],
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          })
                    ]).show();
              } else {
                Alert(
                    context: context,
                    title: "Error",
                    type: AlertType.error,
                    desc: "Transaksi gagal.",
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

              EasyLoading.dismiss();
            },
          ),
        ]).show();
  }
}
