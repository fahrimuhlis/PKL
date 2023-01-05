import 'package:flutter/material.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Pulsa/status_pembayaran.dart';

class DetailPembayaran extends StatefulWidget {
  String no_hp;
  String operator;
  String nominalPulsa;
  String hargaPulsaString;
  String paketData;
  String hargaPaketDataString;
  String deskripsiPaket;

  DetailPembayaran(
    this.no_hp,
    this.operator,
    this.nominalPulsa,
    this.hargaPulsaString,
    this.paketData,
    this.deskripsiPaket,
    this.hargaPaketDataString,
  );

  @override
  _DetailPembayaranState createState() => _DetailPembayaranState();
}

class _DetailPembayaranState extends State<DetailPembayaran> {
  createAlertDialog(BuildContext context) {
    var customController = TextEditingController();
    String password = "";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Center(
                child: Text(
                  "Masukkan PIN Transaksi",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              content: TextField(
                  controller: customController,
                  onChanged: (text) {
                    // Digunakan untuk memantau text form
                    //debugPrint("isi text adalah = $text");
                    password = "$text";
                    setState(() {});
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.assignment,
                        color: Colors.lightGreen,
                      ),
                      labelText: "PIN Transaksi",
                      labelStyle: TextStyle(color: Colors.lightGreen))),
              actions: [
                Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 35,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 2, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.lightBlue[800]),
                        child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                child: Center(
                                    child: Text("Konfirmasi",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white))),
                                onTap: () {
                                  password == "abdillah"
                                      ? Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                          builder: (context) {
                                            return StatusPembayaran(
                                                widget.no_hp,
                                                widget.operator,
                                                widget.nominalPulsa,
                                                widget.hargaPulsaString,
                                                widget.paketData,
                                                widget.deskripsiPaket,
                                                widget.hargaPaketDataString);
                                          },
                                        ))
                                      : Container();
                                }))))
              ]);
        });
  }

  // String Saldo = "200.000";
  // int SaldoInt = 0;
  // int hargaPulsaInt = 0;
  // int hargaPaketDataInt = 0;
  // String SaldoNumberOnly = "";

  // @override
  // void initState() {
  //   super.initState();
  //   hargaPulsaInt = int.parse(widget.hargaPulsaNumberOnly);
  //   hargaPaketDataInt = int.parse(widget.hargaPaketDataNumberOnly);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pembayaran"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Container(
              child: widget.nominalPulsa == ""
                  ? tampilanHargaPaketData(context)
                  : tampilanHargaPulsa(context)),
          Bayar(context)
        ],
      ),
    );
  }

  Widget tampilanHargaPulsa(context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: ListTile(
          title: Text("Nomor Handphone", style: TextStyle(fontSize: 15)),
          //subtitle: Text("Ini Subtitle"),
          trailing: Text(
            widget.no_hp,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Operator", style: TextStyle(fontSize: 15)),
          trailing: Text(widget.operator, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Nominal Pulsa", style: TextStyle(fontSize: 15)),
          trailing:
              Text("Rp " + widget.nominalPulsa, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Harga", style: TextStyle(fontSize: 15)),
          trailing:
              Text(widget.hargaPulsaString, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Biaya Admin", style: TextStyle(fontSize: 15)),
          trailing: Text("Rp 0", style: TextStyle(fontSize: 15)),
        ),
      ),
      sisaSaldo(context)
    ]);
  }

  Widget tampilanHargaPaketData(context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: ListTile(
          title: Text("Nomor Handphone", style: TextStyle(fontSize: 15)),
          trailing: Text(
            widget.no_hp,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Jenis Paket Data", style: TextStyle(fontSize: 15)),
          trailing: Text(widget.paketData, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Row(children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Text("Deskripsi", style: TextStyle(fontSize: 15))),
          Container(
              margin: EdgeInsets.fromLTRB(75, 0, 0, 0),
              width: MediaQuery.of(context).size.width * 0.55,
              child: Text(
                widget.deskripsiPaket,
                style: TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              )),
        ]),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Harga", style: TextStyle(fontSize: 15)),
          trailing:
              Text(widget.hargaPaketDataString, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Biaya Admin", style: TextStyle(fontSize: 15)),
          trailing: Text("Rp 0", style: TextStyle(fontSize: 15)),
        ),
      ),
      sisaSaldo(context)
    ]);
  }

  Widget sisaSaldo(context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(width: 2, color: Colors.transparent),
          borderRadius: BorderRadius.circular(7)),
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      width: MediaQuery.of(context).size.width * 0.85,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              //color: Colors.lightGreenAccent,
              padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                "Saldo",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              )),
          Container(
              //color: Colors.lightGreen,
              padding: EdgeInsets.fromLTRB(0, 5, 11, 5),
              // width: 200,
              child: Text(
                "Rp" + "200.000",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
  }

  Widget Bayar(context) {
    return Align(
        alignment: Alignment(0, 1),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)]),
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Container(
                  child: Column(
                children: [
                  Container(
                      //color: Colors.amber,
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 20,
                      child: Text(
                        "Total Pembayaran",
                        style: TextStyle(fontSize: 15),
                      )),
                  Container(
                      //color: Colors.lightBlue,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 25,
                      child: widget.nominalPulsa == ""
                          ? Text(widget.hargaPaketDataString,
                              style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700))
                          : Text(
                              widget.hargaPulsaString,
                              style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ))
                ],
              )),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.lightBlue[800]),
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        createAlertDialog(context);
                        // SaldoNumberOnly = Saldo.replaceAll(".", "");
                        // SaldoInt = int.parse(SaldoNumberOnly);
                        // SaldoInt >= hargaPaketDataInt ||
                        //         SaldoInt >= hargaPulsaInt
                        //     ? createAlertDialog(context)
                        //     : null;
                      },
                      child: Center(
                          child: Text("Bayar",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white))),
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
              )
            ],
          ),
        ));
  }
}
