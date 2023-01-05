import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/PPOB/Pascabayar_Listrik/TagihanListrik_Page.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Token_Listrik/TokenListrikPage.dart';
import 'package:Edimu/Widgets/WhatsappBox.dart';
import 'package:Edimu/scoped_model/StatusTransaksiPPOB.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class KonfirmasiBPJSPage extends StatefulWidget {
  MainModel model;
  Map infoTagihan;

  KonfirmasiBPJSPage(this.model, this.infoTagihan);

  @override
  _KonfirmasiBPJSPageState createState() => _KonfirmasiBPJSPageState();
}

class _KonfirmasiBPJSPageState extends State<KonfirmasiBPJSPage> {
  var isianPin = TextEditingController();
  List listDetailTagihan = [];
  String namaPemilikNomor;
  int metodePembayaran = 0;

  @override
  void initState() {
    listDetailTagihan =
        widget.infoTagihan["message"]["desc"]["tagihan"]["detail"];
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Konfirmasi Pembelian"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text("Jenis Pembayaran"),
                      trailing: Text("Tagihan PLN"),
                    ),
                    ListTile(
                      title: Text("ID Pelanggan"),
                      trailing: Text(widget.infoTagihan["message"]["hp"]),
                    ),
                    ListTile(
                      title: Text("Nama Pelanggan"),
                      trailing: Text(widget.infoTagihan["message"]["tr_name"]),
                    ),
                    ListTile(
                      title: Text("Jumlah bulan"),
                      trailing:
                          Text(listDetailTagihan.length.toString() + " bulan"),
                    ),
                    ListTile(
                      title: Text("Total"),
                      trailing: Text(
                        rupiah(widget.infoTagihan["hargaEndUser"]),
                        style: TextStyle(
                            color: Colors.orange[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    daftarDetailTagihan()
                  ],
                ),
              ),
            ),
            tombolBayarFixed()
          ],
        ));
  }

  Widget daftarDetailTagihan() {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            // border: Border.all(width: 2, color: Colors.blue[800]),
            // borderRadius: BorderRadius.circular(7),
            // color: Colors.blue[800]
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   "Daftar Tagihan:",
            //   style: TextStyle(color: Colors.black),
            // ),
            // SizedBox(height: 17),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listDetailTagihan.length,
                itemBuilder: (context, index) {
                  String nilaiTagihan =
                      listDetailTagihan[index]["nilai_tagihan"];

                  String biayaAdmin = listDetailTagihan[index]["admin"];

                  String biayaDenda = listDetailTagihan[index]["denda"];

                  int totalPerBulan = int.parse(nilaiTagihan) +
                      int.parse(biayaAdmin) +
                      int.parse(biayaDenda);
                  //

                  return Column(
                    children: [
                      Card(
                        elevation: 7,
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 11),
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                        "Tagihan ${hitungBulanListrikPPOB(listDetailTagihan[index]['periode'])}",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))),
                              ),
                              ListTile(
                                title: Text("nilai tagihan"),
                                trailing: Text(rupiah(nilaiTagihan)),
                              ),
                              ListTile(
                                title: Text("admin"),
                                trailing: Text(rupiah(biayaAdmin)),
                              ),
                              ListTile(
                                title: Text("denda"),
                                trailing: Text(rupiah(biayaDenda)),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 15),
                                width: double.infinity,
                                height: 45,
                                color: Colors.amber[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(""),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      rupiah(totalPerBulan),
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  );
                }),
            SizedBox(
              height: 95,
            )
          ],
        ));
  }

  Widget tombolBayarFixed() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.all(5),
                  // width: MediaQuery.of(context).size.width * 0.41,
                  height: 61,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text("total"),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        rupiah(widget.infoTagihan["hargaEndUser"]),
                        style:
                            TextStyle(color: Colors.orange[900], fontSize: 19),
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                height: 61,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800],),
                    // color: Colors.blue[800],
                    onPressed: () async {
                      popupPin();
                    },
                    child: Center(
                      child: Text(
                        "Bayar",
                        style: TextStyle(fontSize: 21, color: Colors.white),
                      ),
                    )),
              ),
            )
          ],
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
        content: TextField(
          autofocus: true,
          controller: isianPin,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "PIN Transaksi",
            labelStyle: TextStyle(fontSize: 25),
            icon: Icon(Icons.assignment),
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

              StatusPPOB res = await widget.model.bayarTagihanPascaBayar(
                  widget.infoTagihan["message"]["tr_id"],
                  widget.infoTagihan['hargaEndUser'],
                  "PLNPOSTPAID",
                  widget.infoTagihan['apakahDev'],
                  isianPin.text,
                  metodePembayaran);

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
                        "Saldo/pulsa komunitas ${widget.model.namaKomunitas} tidak cukup untuk melakukan transaksi ini",
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
