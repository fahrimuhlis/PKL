import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Edimu/konfigurasi/KonfigurasiAplikasi.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:getwidget/getwidget.dart';
import 'package:indonesia/indonesia.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class RiwayatMarketplace extends StatefulWidget {
  MainModel model;
  RiwayatMarketplace(this.model);

  @override
  _RiwayatMarketplaceState createState() => _RiwayatMarketplaceState();
}

class _RiwayatMarketplaceState extends State<RiwayatMarketplace> {
  int paginateBeli = 1;
  int paginateJual = 1;

  @override
  void initState() {
    initializeDateFormatting();

    paginateBeli = 1;
    paginateJual = 1;

    widget.model.listRiwayatPembelian = [];
    widget.model.listRiwayatPenjualan = [];

    widget.model.getRiwayatPembelian(paginateBeli);
    widget.model.getRiwayatPenjualan(paginateJual);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Riwayat'),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicator: BoxDecoration(
                  color: Warna.accent,
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.white,
                          width: 3,
                          style: BorderStyle.solid))),
              tabs: [
                Tab(
                  text: 'Pembelian',
                ),
                Tab(text: 'Penjualan')
              ],
            ),
          ),
          body: TabBarView(
            children: [pembelianPage(), penjualanPage()],
          )),
    );
  }

  Widget pembelianPage() {
    return Container(
      margin: EdgeInsets.all(15),
      child: listPembelian(context),
    );
  }

  Widget listPembelian(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      if (model.listRiwayatPembelian.length < 1) {
        return Center(
          child: Text(
            "Anda belum pernah melakukan pembelian produk",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[800], fontSize: 25),
          ),
        );
      } else {
        return ListView.builder(
            // physics: ,
            shrinkWrap: true,
            itemCount: model.listRiwayatPembelian.length,
            itemBuilder: (context, index) {
              return cardPembelian(model, index);
            });
      }
    });
  }

  Widget cardPembelian(MainModel model, int index) {
    String noWA;

    if (widget.model.listRiwayatPembelian[index]['nohape_penjual'] != null) {
      noWA = widget.model.listRiwayatPembelian[index]['nohape_penjual']
          .substring(1);
    } else {
      noWA = widget.model.listRiwayatPembelian[index]['user_id'].substring(1);
    }

    var infoPengiriman =
        widget.model.listRiwayatPembelian[index]['id_metode_pengiriman'] == 2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pesanan dikirim ke :",
                            style: TextStyle(color: Colors.grey[600]))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.model.listRiwayatPembelian[index]
                                    ['nama_penerima'] ??
                                widget.model.nama,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700)),
                        SizedBox(height: 7),
                        Text(
                            widget.model.listRiwayatPembelian[index]
                                    ['alamat_pembeli'] ??
                                widget.model.nama,
                            style: TextStyle()),
                      ],
                    ),
                  )
                ],
              )
            : ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("metode pengiriman :",
                        style: TextStyle(color: Colors.grey[600]))
                  ],
                ),
                trailing: Text('ambil sendiri'),
              );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 7,
      child: Container(
        // margin: EdgeInsets.all(9),
        child: ExpansionTile(
          leading: Image.network(
            TemplateAplikasi.publicDomain +
                'data_file/' +
                model.listRiwayatPembelian[index]['file'],
            // scale: 0.25,
            width: 75,
            height: 151,
            cacheWidth: 75,
            cacheHeight: 151,
            fit: BoxFit.cover,
          ),
          // initiallyExpanded: true,
          title: Container(
            padding: EdgeInsets.all(11),
            height: 101,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    model.listRiwayatPembelian[index]['deskripsi'].length <= 49
                        ? model.listRiwayatPembelian[index]['deskripsi']
                        : model.listRiwayatPembelian[index]['deskripsi']
                                .substring(0, 48) +
                            '...',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 7),
                Text(model.listRiwayatPembelian[index]['kwitansi'],
                    style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
          children: [
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tanggal :", style: TextStyle(color: Colors.grey[600]))
                ],
              ),
              trailing: Text(model.listRiwayatPembelian[index]['waktu']),
            ),
            infoPengiriman,
            Container(
              width: 251,
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 2.1,
              color: Warna.primary,
            ),
            Container(
              margin: EdgeInsets.all(9),
              padding: EdgeInsets.all(5),
              width: 251,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Total :"),
                  SizedBox(
                    width: 9,
                  ),
                  Text(rupiah(model.listRiwayatPembelian[index]['total_harga']),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19))
                ],
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 57,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  // color: Colors.green[700],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/whatsapp.png",
                        width: 35,
                        height: 35,
                      ),
                      SizedBox(width: 7),
                      Text(
                        "Hubungi Penjual",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(9),
                  //         bottomLeft: Radius.circular(9))),
                  onPressed: () async {
                    launchWhatsApp(
                      noWA,
                      model.listRiwayatPembelian[index]['deskripsi'],
                      model.listRiwayatPembelian[index]['total_harga'],
                      model.listRiwayatPembelian[index]['alamat_pembeli'],
                      model.listRiwayatPembelian[index]['id_metode_pengiriman'],
                      model.listRiwayatPembelian[index]['alamat_pengambilan'],
                      model.listRiwayatPembelian[index]['jumlah_barang'],
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  launchWhatsApp(
      String nohapePenjual,
      String namaBarang,
      String totalHarga,
      String alamatPenerima,
      int metodePengiriman,
      String alamatPenjual,
      int jumlahBarang) async {
    var alamatPembeli = alamatPenerima == null || alamatPenerima == ""
        ? "_(pembeli tidak menyertakan alamat)_"
        : alamatPenerima;

    var alamatUntukWa = metodePengiriman == 2
        ? "Barang mohon dikirimkan ke *${alamatPenerima.toUpperCase()}*"
        : "Barang akan kami ambil langsung di *${alamatPenjual ?? '(alamat penjual belum tertera)'}*";

    var templateWA = """
      Assalamualaikum wr wb. 
        
        saya *${widget.model.nama.toUpperCase()}* dari *${alamatPembeli}* telah membeli barang yang bapak/ibu jual di ${widget.model.namaKomunitas}, yaitu : 
        
        *${namaBarang.toUpperCase()}* sebanyak ${jumlahBarang} pcs.  
        
        *dana sebesar ${rupiah(totalHarga.toString())} telah saya transfer ke rekening Edimu bapak/ibu.* 
        
        ${alamatUntukWa} 

        Terimakasih
      """;

    final link =
        WhatsAppUnilink(phoneNumber: '+62' + nohapePenjual, text: templateWA);

    //debugPrint(templateWA);

    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".

    await launch('$link');
  }

  launchWhatsAppPenjualan(
      String nohapePenjual, String deskripsi, String totalHarga) async {
    final link = WhatsAppUnilink(
      phoneNumber: '+62' + nohapePenjual,
      text:
          "Assalamualaikum, saya *${widget.model.nama}* dari *${widget.model.namaKomunitas}* telah menjual barang yang bapak/ibu beli di aplikasi Edimu, yaitu : *${deskripsi}* sebanyak *${totalHarga} pcs*,  Terimakasih",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  Widget penjualanPage() {
    return Container(
      margin: EdgeInsets.all(15),
      child: listPenjualan(context),
    );
  }

  Widget loadingAsync(context) {
    var yangTampil = Container(
        height: MediaQuery.of(context).size.height - 185,
        alignment: Alignment.center,
        child: Center(child: CircularProgressIndicator()));

    Future.delayed(Duration(seconds: 7), () {
      yangTampil = Container(
          height: MediaQuery.of(context).size.height - 185,
          alignment: Alignment.center,
          child: Text('Belum ada transaksi',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 31)));
      setState(() {});
    });
    return yangTampil;
  }

  Widget listPenjualan(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      if (model.listRiwayatPenjualan.length < 1) {
        return Center(
          child: Text(
            "Anda belum pernah melakukan penjualan produk",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[800], fontSize: 25),
          ),
        );
      } else {
        return ListView.builder(
            // physics: ,
            shrinkWrap: true,
            itemCount: model.listRiwayatPenjualan.length,
            itemBuilder: (context, index) {
              return cardPenjualan(model, index);
            });
      }
    });
  }

  Widget cardPenjualan(MainModel model, int index) {
    String noWA;

    if (model.listRiwayatPenjualan[index]['nohape_penerima'] != null) {
      noWA = model.listRiwayatPenjualan[index]['nohape_penerima'].substring(1);
    } else {
      noWA = model.listRiwayatPenjualan[index]['id_buyer'].substring(1);
    }

    var infoPengiriman =
        model.listRiwayatPenjualan[index]['id_metode_pengiriman'] == 2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pesanan dikirim ke :",
                            style: TextStyle(color: Colors.grey[600]))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            model.listRiwayatPenjualan[index]
                                    ['nama_penerima'] ??
                                'nama_penerima',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700)),
                        SizedBox(height: 7),
                        Text(
                            model.listRiwayatPenjualan[index]
                                    ['alamat_pembeli'] ??
                                widget.model.nama,
                            style: TextStyle()),
                      ],
                    ),
                  )
                ],
              )
            : ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("metode pengiriman :",
                        style: TextStyle(color: Colors.grey[600]))
                  ],
                ),
                trailing: Text('ambil sendiri'),
              );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 7,
      child: Container(
        // margin: EdgeInsets.all(9),
        child: ExpansionTile(
          leading: Image.network(
            TemplateAplikasi.publicDomain +
                'data_file/' +
                model.listRiwayatPenjualan[index]['file'],
            // scale: 0.25,
            width: 75,
            height: 151,
            cacheWidth: 75,
            cacheHeight: 151,
            fit: BoxFit.cover,
          ),
          // initiallyExpanded: true,
          title: Container(
            padding: EdgeInsets.all(11),
            height: 101,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    model.listRiwayatPenjualan[index]['deskripsi'].length <= 49
                        ? model.listRiwayatPenjualan[index]['deskripsi']
                        : model.listRiwayatPenjualan[index]['deskripsi']
                                .substring(0, 48) +
                            '...',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 7),
                Text(model.listRiwayatPenjualan[index]['kwitansi'],
                    style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
          children: [
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tanggal :", style: TextStyle(color: Colors.grey[600]))
                ],
              ),
              trailing: Text(model.listRiwayatPenjualan[index]['waktu']),
            ),
            infoPengiriman,
            Container(
              width: 251,
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 2.1,
              color: Warna.primary,
            ),
            Container(
              margin: EdgeInsets.all(9),
              padding: EdgeInsets.all(5),
              width: 251,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Total :"),
                  SizedBox(
                    width: 9,
                  ),
                  Text(rupiah(model.listRiwayatPenjualan[index]['total_harga']),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19))
                ],
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 57,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  // color: Colors.green[700],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/whatsapp.png",
                        width: 35,
                        height: 35,
                      ),
                      SizedBox(width: 7),
                      Text(
                        "Hubungi Pembeli",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(9),
                  //         bottomLeft: Radius.circular(9))),
                  onPressed: () async {
                    launchWhatsAppPenjualan(
                        noWA,
                        model.listRiwayatPenjualan[index]['deskripsi'],
                        model.listRiwayatPenjualan[index]['total_harga']);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
