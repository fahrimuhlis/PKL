import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';

class DetailRiwayat_Page extends StatefulWidget {
  MainModel model;
  //
  String idTransaksi;

  DetailRiwayat_Page(this.model);

  @override
  _DetailRiwayat_PageState createState() => _DetailRiwayat_PageState();
}

class _DetailRiwayat_PageState extends State<DetailRiwayat_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Transaksi"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}
