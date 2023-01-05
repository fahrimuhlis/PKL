import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:scoped_model/scoped_model.dart';

class lapakSayaPage extends StatefulWidget {
  @override
  _lapakSayaPageState createState() => _lapakSayaPageState();
}

class _lapakSayaPageState extends State<lapakSayaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toko Saya'),
        centerTitle: true,
      ),
      body: Container(
          child: SingleChildScrollView(
              child: Column(
        children: [listLapakSaya(context)],
      ))),
    );
  }

  Widget listLapakSaya(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      if (model.listRiwayatPembelian.length < 1) {
        return Container(
            height: MediaQuery.of(context).size.height - 185,
            alignment: Alignment.center,
            child: Text('Belum ada transaksi pembelian',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 31)));
      } else {
        return ListView.builder(
            // physics: ,
            shrinkWrap: true,
            itemCount: model.listRiwayatPembelian.length,
            itemBuilder: (context, index) {
              return ListTile(
                isThreeLine: true,
                title: Text(model.listRiwayatPembelian[index]['deskripsi']),
                trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                    ),
                    // color: Colors.green[800],
                    child:
                        Text('Hubungi', style: TextStyle(color: Colors.white)),
                    onPressed: () {}),
                subtitle: Text(model.listRiwayatPembelian[index]['waktu']),
              );
            });
      }
    });
  }
}
