import 'package:flutter/material.dart';
import 'package:Edimu/UI/Marketplace/receiptMarketplace_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:format_indonesia/format_indonesia.dart';

class ConfirmCheckout_Page extends StatefulWidget {
  MainModel model;
  String title;
  String namaPenerima;
  String nohapePenerima;
  String alamatPenerima;
  int metodePengiriman;
  int idLapak;
  int totalHarga;
  String catatanPembeli;
  String rekPenjual;
  String gambar;
  int jumlah;
  String usernamePenjual;
  String nohapePenjual;
  String deskripsi;
  String alamatPengambilan;

  ConfirmCheckout_Page(
      this.model,
      this.title,
      this.namaPenerima,
      this.nohapePenerima,
      this.alamatPenerima,
      this.metodePengiriman,
      this.idLapak,
      this.totalHarga,
      this.catatanPembeli,
      this.rekPenjual,
      this.gambar,
      this.jumlah,
      this.usernamePenjual,
      this.nohapePenjual,
      this.deskripsi,
      this.alamatPengambilan);

  @override
  _ConfirmCheckout_PageState createState() => _ConfirmCheckout_PageState();
}

class _ConfirmCheckout_PageState extends State<ConfirmCheckout_Page> {
  String pin;

  List<bool> _selections = List.generate(3, (_) => false);

  bool _canVibrate;

  bisaGetar() async {
    _canVibrate = await Vibration.hasVibrator();
    bisaGetar();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Konfirmasi Pembayaran',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    boxPeringatan(),
                    SizedBox(height: 7),
                    detailPembeli(),
                    SizedBox(height: 1),
                    metodePengiriman(),
                    SizedBox(height: 1),
                    detailPesanan(),
                    SizedBox(height: 75)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 57,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(9),
                                topLeft: Radius.circular(9))),
                      ),
                      // color: Colors.blue[800],
                      child: Text(
                        "Bayar",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.only(
                      //         topRight: Radius.circular(9),
                      //         topLeft: Radius.circular(9))),
                      onPressed: () async {
                        if (int.parse(widget.model.formatedBalance) >=
                            widget.totalHarga) {
                          TextEditingController isianCatatan =
                              TextEditingController();

                          var alertStyle = AlertStyle(
                            animationType: AnimationType.fromTop,
                            animationDuration: Duration(milliseconds: 651),
                            // isCloseButton: true,
                            isOverlayTapDismiss: true,
                          );

                          Alert(
                              title: "Masukkan PIN Transaksi",
                              style: alertStyle,
                              closeFunction: () {},
                              context: context,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextField(
                                    autofocus: true,
                                    controller: isianCatatan,
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
                                DialogButton(
                                  color: Colors.blue[800],
                                  child: Text("Konfirmasi",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    EasyLoading.show(
                                      status: 'sedang diproses',
                                      maskType: EasyLoadingMaskType.black,
                                      dismissOnTap: true,
                                    );

                                    Map respon = await widget.model
                                        .konfirmasiBeli(
                                            widget.idLapak,
                                            widget.jumlah,
                                            widget.totalHarga,
                                            widget.catatanPembeli,
                                            isianCatatan.text,
                                            widget.usernamePenjual,
                                            widget.alamatPenerima,
                                            widget.rekPenjual,
                                            widget.metodePengiriman,
                                            widget.nohapePenerima,
                                            widget.nohapePenjual,
                                            widget.namaPenerima);
                                    // Navigator.pop(context);

                                    if (respon['status'] == 'sukses') {
                                      await EasyLoading.dismiss();
                                      Alert(
                                          type: AlertType.success,
                                          context: context,
                                          title: "SUKSES",
                                          desc: "Pembelian barang berhasil.",
                                          buttons: [
                                            DialogButton(
                                              color: Colors.blue[800],
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ReceiptMarketplace_Page(
                                                            widget.model,
                                                            widget.title,
                                                            widget.namaPenerima,
                                                            widget
                                                                .nohapePenerima,
                                                            widget
                                                                .alamatPenerima,
                                                            widget
                                                                .metodePengiriman,
                                                            widget.idLapak,
                                                            widget.totalHarga,
                                                            widget
                                                                .catatanPembeli,
                                                            widget.rekPenjual,
                                                            widget.gambar,
                                                            widget.jumlah,
                                                            widget
                                                                .usernamePenjual,
                                                            widget
                                                                .nohapePenjual,
                                                            respon,
                                                            widget.deskripsi,
                                                            widget
                                                                .alamatPengambilan)));
                                              },
                                            )
                                          ]).show();
                                    } else {
                                      await EasyLoading.dismiss();
                                      Alert(
                                          type: AlertType.error,
                                          context: context,
                                          title: "Transaksi gagal",
                                          desc:
                                              "Pembelian barang gagal, silahkan cek kembali PIN anda",
                                          buttons: [
                                            DialogButton(
                                              color: Colors.blue[800],
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                await EasyLoading.dismiss();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ]).show();
                                    }
                                  },
                                )
                              ]).show();
                        }
                      },
                    )),
              ),
            )
          ],
        ));
  }

  popupPin() {
    TextEditingController isianCatatan = TextEditingController();

    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      animationDuration: Duration(milliseconds: 651),
      // isCloseButton: true,
      isOverlayTapDismiss: true,
    );

    Alert(
        title: "Masukkan PIN Transaksi",
        style: alertStyle,
        closeFunction: () {},
        context: context,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: isianCatatan,
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
          DialogButton(
            color: Colors.blue[800],
            child: Text("Ubah", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              setState(() {
                pin = isianCatatan.text;
              });
              // Navigator.pop(context);
            },
          )
        ]).show();
  }

  Widget boxPeringatan() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber[200], borderRadius: BorderRadius.circular(9)),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Silahkan periksa kembali pesanan anda sebelum melakukan pembayaran.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Text("Total Belanja Anda:"),
            SizedBox(
              height: 5,
            ),
            Text(
              rupiah(widget.totalHarga.toString()),
              style: TextStyle(fontSize: 29),
            )
          ],
        ),
      ),
    );
  }

  Widget detailPembeli() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Penerima barang',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(widget.namaPenerima,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // trailing: InkWell(
              //   onTap: () {},
              //   child: Text(
              //     'Ubah',
              //     style: TextStyle(color: Colors.blue[800]),
              //   ),
              // ),
              // isThreeLine: true,
              // subtitle: Text(alamatPenerima)
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(widget.nohapePenerima,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // trailing: InkWell(
              //   onTap: () {},
              //   child: Text(
              //     'Ubah',
              //     style: TextStyle(color: Colors.blue[800]),
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }

  Widget metodePengiriman() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text('Metode Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 0),
            ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text(
                    widget.metodePengiriman == 1
                        ? "Ambil Sendiri"
                        : "Barang akan dikirim ke :",
                    style: TextStyle(color: Colors.red)),
                subtitle: widget.metodePengiriman == 1
                    ? Text(widget.alamatPengambilan)
                    : Text(widget.alamatPenerima))
          ],
        ),
      ),
    );
  }

  Widget detailPesanan() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Pesanan',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            ListTile(
              leading: Image.network(widget.gambar,
                  fit: BoxFit.cover, width: 50, height: 50),
              title: Text(widget.deskripsi,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              trailing: InkWell(
                onTap: () {},
                child: Text(
                  '${widget.jumlah.toString()} x',
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ),
            ),
            ListTile(
                dense: true,
                title: widget.catatanPembeli == ' '
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'catatan : ',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              child: Text(widget.catatanPembeli),
                            ),
                          )
                        ],
                      ))
            // trailing: catatanPembeli != ' '
            //     ? InkWell(
            //         onTap: () {},
            //         child: Text(
            //           'Ubah',
            //           style: TextStyle(color: Colors.blue[800]),
            //         ),
            //       )
            //     : Container()
          ],
        ),
      ),
    );
  }
}
