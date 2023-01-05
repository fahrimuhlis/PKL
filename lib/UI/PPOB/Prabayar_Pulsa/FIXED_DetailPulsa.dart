import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/Topup/topUp_page.dart';
import 'package:Edimu/Widgets/WhatsappBox.dart';
import 'package:Edimu/scoped_model/StatusTransaksiPPOB.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:indonesia/indonesia.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DetailPulsaPage extends StatefulWidget {
   MainModel model;
  Map pulsaYangDibeli;
  String nomorPengisian;
  int metodePembayaran;

  DetailPulsaPage(this.model, this.pulsaYangDibeli, this.nomorPengisian,
      this.metodePembayaran);

  @override
  _DetailPulsaPageState createState() => _DetailPulsaPageState();
}

class _DetailPulsaPageState extends State<DetailPulsaPage> {
  var isianPin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pulsa " + widget.pulsaYangDibeli['pulsa_op']),
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
                    trailing: Text("Pulsa"),
                  ),
                  ListTile(
                    title: Text("Operator"),
                    trailing: Text(widget.pulsaYangDibeli["pulsa_op"]),
                  ),
                  ListTile(
                    title: Text("Nominal"),
                    trailing: Text(widget.pulsaYangDibeli["pulsa_nominal"]),
                  ),
                  ListTile(
                    title: Text("Harga"),
                    trailing:
                        Text(rupiah(widget.pulsaYangDibeli["harga_enduser"])),
                  ),
                   ListTile(
                    title: Text("Metode pembayaran"),
                    trailing: Text(widget.metodePembayaran == 1
                        ? 'Saldo ediMU'
                        : 'Pay Later'),
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
                        children: [
                          Text(
                            "Nomor Tujuan:",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(widget.nomorPengisian,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
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
            if (int.parse(widget.model.formatedBalance) >=
                widget.pulsaYangDibeli["harga_enduser"]) {
              popupPin();
            } else {
              alertPulsaTidakCukup();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.attach_money,
              //   color: Colors.white,
              // ),
              // SizedBox(
              //   width: 0,
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

              if (int.parse(widget.model.formatedBalance) >=
                  widget.pulsaYangDibeli["harga_enduser"]) {
                //
              

                  StatusPPOB respond = await widget.model.beliPulsaPrepaid(
                  widget.pulsaYangDibeli,
                  widget.nomorPengisian,
                  isianPin.text,
                  widget.metodePembayaran,
                );

                if (respond == StatusPPOB.sukses) {
                  Alert(
                      context: context,
                      title: "Berhasil",
                      type: AlertType.success,
                      desc:
                          "Pengisian pulsa anda berhasil, silahkan tunggu sebentar.",
                      buttons: [
                        DialogButton(
                          color: Colors.blue[800],
                          child:
                              Text("OK", style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ]).show();
                } else if (respond == StatusPPOB.salahPin) {
                  Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "PIN SALAH",
                      desc: "Maaf, PIN yang anda masukkan salah",
                      buttons: [
                        DialogButton(
                            color: Colors.blue[800],
                            child: Text(
                              "coba lagi",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ]).show();
                } else if (respond == StatusPPOB.saldoKomunitasTidakCukup) {
                  String _pesanWA =
                      "Saya *${widget.model.nama}* dari *${widget.model.namaKomunitas}* ingin melakukan pembelian *Pulsa/Paket Data* akan tetapi saldo PPOB komunitas ${widget.model.namaKomunitas} telah habis, mohon untuk segera isi saldo PPOB agar saya bisa segera membeli produk tersebut, Terima kasih. 🙏";

                  Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Maaf",
                      desc:
                          "Maaf, Komunitas ${widget.model.namaKomunitas} tidak memiliki saldo/pulsa PPOB yang cukup, silahkan ingatkan teller untuk melakukan pengisian saldo PPOB.",
                      content:
                          Container(child: WhatsappBox(widget.model, _pesanWA)),
                      buttons: [
                        DialogButton(
                            color: Colors.blue[800],
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
              } else {
                Alert(
                    type: AlertType.error,
                    context: context,
                    title: "Beli pulsa",
                    desc:
                        "Maaf, pembelian beli pulsa gagal, pastikan jaringan sinyal & saldo anda cukup.",
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

              EasyLoading.dismiss();
            },
          ),
        ]).show();
  }

  alertPulsaTidakCukup() {
    Alert(
        context: context,
        title: "maaf",
        type: AlertType.info,
        desc: "maaf saldo anda tidak cukup untuk melakukan pembelian",
        buttons: [
          DialogButton(
              child: Text(
                "Isi Saldo",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => topUpPage(
                            widget.model,
                          )),
                );
              })
        ]).show();
  }
}
