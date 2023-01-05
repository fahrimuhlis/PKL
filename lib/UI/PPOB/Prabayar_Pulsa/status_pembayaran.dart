import 'package:flutter/material.dart';
import 'package:Edimu/UI/PPOB/pulsa%20&%20topup.dart';
import 'package:intl/intl.dart';
// import 'package:tanggal_indonesia/tanggal_indonesia.dart';

class StatusPembayaran extends StatelessWidget {
  String no_hp;
  String operator;
  String nominalPulsa;
  String hargaPulsa;
  String paketData;
  String deskripsiPaket;
  String hargaPaketData;
  DateTime date = DateTime.now();

  StatusPembayaran(
    this.no_hp,
    this.operator,
    this.nominalPulsa,
    this.hargaPulsa,
    this.paketData,
    this.deskripsiPaket,
    this.hargaPaketData,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) {
            //   return Pulsa();
            // }));
          },
        ),
        title: Text("Status Pembayaran"),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.home),
        //     onPressed: () {
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (context) {
        //         return Pembayaran();
        //       }));
        //     },
        //   ),
        // ],
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Center(
                    child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text(
                    "Transaksi Berhasil",
                    style: TextStyle(fontSize: 15, color: Colors.lightGreen),
                  ),
                )),
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(date.toString()),
                  ),
                ),
                Center(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: nominalPulsa == ""
                            ? Text(
                                "Paket Data",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              )
                            : Text(
                                "Pulsa",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              )))
              ],
            ),
          ),
          Container(
              child: nominalPulsa == ""
                  ? tampilanHargaPaketData(context)
                  : tampilanHargaPulsa(context))
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
            no_hp,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Operator", style: TextStyle(fontSize: 15)),
          trailing: Text(operator, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Nominal Pulsa", style: TextStyle(fontSize: 15)),
          trailing: Text("Rp " + nominalPulsa, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Harga", style: TextStyle(fontSize: 15)),
          trailing: Text(hargaPulsa, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Biaya Admin", style: TextStyle(fontSize: 15)),
          trailing: Text("Rp 0", style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Total", style: TextStyle(fontSize: 15)),
          trailing: Text(hargaPulsa,
              style: TextStyle(fontSize: 15, color: Colors.lightGreen)),
        ),
      ),
    ]);
  }

  Widget tampilanHargaPaketData(context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: ListTile(
          title: Text("Nomor Handphone", style: TextStyle(fontSize: 15)),
          trailing: Text(
            no_hp,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Jenis Paket Data", style: TextStyle(fontSize: 15)),
          trailing: Text(paketData, style: TextStyle(fontSize: 15)),
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
                deskripsiPaket,
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
          trailing: Text(hargaPaketData, style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Biaya Admin", style: TextStyle(fontSize: 15)),
          trailing: Text("Rp 0", style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListTile(
          title: Text("Total", style: TextStyle(fontSize: 15)),
          trailing: Text(hargaPaketData,
              style: TextStyle(fontSize: 15, color: Colors.lightGreen)),
        ),
      ),
    ]);
  }
}
