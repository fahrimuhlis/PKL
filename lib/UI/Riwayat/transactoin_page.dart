import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Edimu/UI/BottomNavBar/bottomNavBar.dart';
import 'package:Edimu/UI/Riwayat/DetailRiwayatTransaksi.dart';
import 'package:Edimu/models/transactionHistory_model.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:indonesia/indonesia.dart';

class transactionPage extends StatefulWidget {
  final MainModel model;

  transactionPage(this.model);

  @override
  _transactionPageState createState() => _transactionPageState();
}

class _transactionPageState extends State<transactionPage>
    with TickerProviderStateMixin {
  dynamic listHistorys;
  List listRiwayat;
  //
  TabController tabController;

  initState() {
    // widget.model.getContacts();

    //experiment unuk menggabungkan 2 tabel

    listHistorys = widget.model.getHistoryTransaction();
    tabController = TabController(length: 3, vsync: this);

    // listRiwayat.addAll(widget.model.listHistorys.historyLists);
    // listRiwayat.addAll(widget.model.listRiwayatBelanjaMerchant);

    // listRiwayat.sort((m1, m2) {
    //   var r = m1['waktu'].compareTo(m2['waktu']);
    //   if (r != 0) return r;
    //   return m1['waktu'].compareTo(m2['waktu']);
    // });

    // ======================================

    //getContact();
    super.initState();

    tabController.addListener(() {
      setState(() {});
    });
  }

  Future refresh() async {
    listHistorys = widget.model.getHistoryTransaction();
    await Future.delayed(Duration(milliseconds: 750));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Scaffold(
            appBar: AppBar(
              title: Text("Riwayat Transaksi"),
              centerTitle: true,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: bottomNavBar(2, widget.model));

        // if (!model.isLoad && listHistorys != "tidak ada data")
        if (model.listHistorys == null) {
          content = Scaffold(
              appBar: AppBar(
                title: Text("Riwayat Transaksi"),
                centerTitle: true,
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
              bottomNavigationBar: bottomNavBar(2, widget.model));
        } else if (model.listHistorys.historyLists != null) {
          content = DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  title: Text("Riwayat Transaksi"),
                  centerTitle: true,
                  bottom: TabBar(
                    controller: tabController,
                    onTap: (value) {
                      // if (value != 0) {
                      //   FocusScope.of(context).unfocus();
                      // }
                      // setState(() {});
                    },
                    indicatorColor: Warna.accent,
                    indicator: BoxDecoration(
                        color: Warna.accent,
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.white,
                                width: 3,
                                style: BorderStyle.solid))),
                    tabs: [
                      Tab(
                        // text: "semua",
                        child: Text(
                          "semua",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.swap_vert_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.arrow_upward_rounded,
                            color: Colors.white),
                        child: Text(
                          "keluar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.arrow_downward, color: Colors.white),
                        child: Text(
                          "masuk",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )),
              body: TabBarView(controller: tabController, children: [
                bodySemuaTransaksi(model),
                bodyTransaksiKeluar(model),
                bodyTransaksiMasuk(model)
              ]),
              bottomNavigationBar: bottomNavBar(2, widget.model),
            ),
          );
        } else if (listHistorys == null) {
          content = Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
              bottomNavigationBar: bottomNavBar(2, widget.model));
        } else {
          content = Scaffold(
              body: Center(
                child: Text("gagal mengambil transaksi"),
              ),
              bottomNavigationBar: bottomNavBar(2, widget.model));
        }
        return content;
      },
    );
  }

  Widget bodySemuaTransaksi(MainModel model) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Container(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: model.listHistorys.historyLists.length,
            itemBuilder: (context, index) {
              return CardTransaction(widget.model, index);
            }),
      ),
    );
  }

  Widget bodyTransaksiMasuk(MainModel model) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Container(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: model.listHistorys.historyLists.length,
            itemBuilder: (context, index) {
              if (model.listHistorys.historyLists[index].namaPenerima ==
                  model.nama) {
                return CardTransaction(model, index);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Widget bodyTransaksiKeluar(MainModel model) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Container(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: model.listHistorys.historyLists.length,
            itemBuilder: (context, index) {
              if (model.listHistorys.historyLists[index].namaPengirim ==
                  model.nama) {
                return CardTransaction(model, index);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Widget cardTransaction(index) {
    return InkWell(
      onTap: () {
        if (widget.model.listHistorys.historyLists[index].jenisTransaksi ==
            'belanja marketplace') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailRiwayat_Page(widget.model)));
        }
      },
      child: Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          child: ExpansionTile(
            title: Text(
              // "${listHistorys.historyLists[index].jenis}",
              DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(
                  widget.model.listHistorys.historyLists[index].waktu)),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Text(
                  widget.model.listHistorys.historyLists[index].deskripsi,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Text(
                  "Rek. Penerima : " +
                      widget
                          .model.listHistorys.historyLists[index].norekPenerima,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Text(
                  "#" +
                      widget.model.listHistorys.historyLists[index].idKwitansi,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  height: 3,
                  color: Color(0xff00D6AB),
                )
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(rupiah(widget.model.listHistorys.historyLists[index].jumlah
                    .replaceFirst(".00", ""))),
                SizedBox(height: 5),
                Text(widget
                    .model.listHistorys.historyLists[index].jenisTransaksi)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget transaksiLama(index) {
    return Column(
      children: [
        ListTile(
          // title: Text(historysList.historyLists[index].transferTypeName),
          title: Text(
            // "${listHistorys.historyLists[index].jenis}",
            DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(
                widget.model.listHistorys.historyLists[index].waktu)),
          ),
          onTap: () {},
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text(
                "Pengirim  : " +
                    widget.model.listHistorys.historyLists[index].namaPengirim,
              ),
              Text(
                "Penerima : " +
                    widget.model.listHistorys.historyLists[index].namaPenerima,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text(
                "#" + widget.model.listHistorys.historyLists[index].idKwitansi,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  widget.model.listHistorys.historyLists[index].deskripsi ??
                      "tidak ada catatan",
                  style: TextStyle(color: Colors.grey[800])),
            ],
          ),
          trailing: Container(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(rupiah(widget.model.listHistorys.historyLists[index].jumlah
                    .replaceFirst(".00", ""))),
                SizedBox(height: 5),
                Text(
                  widget.model.listHistorys.historyLists[index].jenisTransaksi,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.end,
                )
              ],
            ),
          ),
          isThreeLine: true,
        ),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 5),
          height: 3,
          color: Warna.primary,
        )
      ],
    );
  }
}

// class CardTransaction extends StatefulWidget {
//   MainModel model;
//   int index;

//   CardTransaction(this.model, this.index);

//   @override
//   _CardTransactionState createState() => _CardTransactionState();
// }

// class _CardTransactionState extends State<CardTransaction> {
//   int index;
//   bool isClicked = false;

//   @override
//   initState() {
//     index = widget.index;
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     Color warnaNominal =
//         widget.model.listHistorys.historyLists[index].namaPengirim ==
//                 widget.model.nama
//             ? Colors.orange[900]
//             : Colors.green[700];

//     String prefixSimbolNominal =
//         widget.model.listHistorys.historyLists[index].namaPengirim ==
//                 widget.model.nama
//             ? "-"
//             : "+";

//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
//           color: Warna.primary,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 DateFormat("d MMMM yyyy, HH:mm", "id_ID").format(DateTime.parse(
//                     widget.model.listHistorys.historyLists[index].waktu)),
//                 style: TextStyle(color: Colors.white),
//               ),
//               Text(
//                 widget.model.listHistorys.historyLists[index].jenisTransaksi
//                     .replaceAll(" Admin", "")
//                     .replaceAll("belanja ", ""),
//                 style: TextStyle(color: Colors.white),
//               )
//             ],
//           ),
//         ),
//         ListTile(
//           // title: Text(historysList.historyLists[index].transferTypeName),

//           onTap: () {
//             isClicked = !isClicked;
//           },
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(top: 5),
//               ),
//               // Padding(
//               //   padding: EdgeInsets.only(top: 5),
//               // ),
//               Text(
//                 "Pengirim  : " +
//                     widget.model.listHistorys.historyLists[index].namaPengirim,
//               ),
//               Text(
//                 "Penerima : " +
//                     widget.model.listHistorys.historyLists[index].namaPenerima,
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 5),
//               ),
//               Text(
//                 "#" + widget.model.listHistorys.historyLists[index].idKwitansi,
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Text(
//                   rapiin(widget
//                           .model.listHistorys.historyLists[index].deskripsi) ??
//                       rapiin("tidak ada catatan"),
//                   textAlign: TextAlign.left,
//                   style: TextStyle(color: Colors.grey[800])),
//               SizedBox(
//                 height: 17,
//               )
//             ],
//           ),
//           trailing: Container(
//             width: 125,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   prefixSimbolNominal +
//                       rupiah(widget
//                           .model.listHistorys.historyLists[index].jumlah
//                           .replaceFirst(".00", "")),
//                   style: TextStyle(
//                       color: warnaNominal, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           isThreeLine: true,
//         ),
//         Container(
//           child: isClicked
//               ? Container(
//                   padding: EdgeInsets.all(11),
//                   height: 55,
//                   child: Column(
//                     children: [Container()],
//                   ),
//                 )
//               : Container(),
//         ),
//       ],
//     );
//   }
// }

class CardTransaction extends StatefulWidget {
  MainModel model;
  int index;

  CardTransaction(this.model, this.index);

  @override
  _CardTransactionState createState() => _CardTransactionState();
}

class _CardTransactionState extends State<CardTransaction> {
  int index;
  bool isClicked = false;

  @override
  initState() {
    index = widget.index;
    super.initState();
  }

  Widget build(BuildContext context) {
    String jenisTransaksi = widget
        .model.listHistorys.historyLists[index].jenisTransaksi
        .replaceAll(" Admin", "")
        .replaceAll("belanja ", "")
        .toLowerCase();
    //
    int nominalTransaksi =
        widget.model.listHistorys.historyLists[index].jumlah != null
            ? int.parse(widget.model.listHistorys.historyLists[index].jumlah
                .replaceFirst(".00", ""))
            : 0;

    Color warnaNominal =
        widget.model.listHistorys.historyLists[index].namaPengirim ==
                widget.model.nama
            ? Colors.orange[900]
            : Colors.green[700];

    String prefixSimbolNominal =
        widget.model.listHistorys.historyLists[index].namaPengirim ==
                widget.model.nama
            ? "-"
            : "+";

    // format waktu

    DateTime waktuTransaksi =
        DateTime.parse(widget.model.listHistorys.historyLists[index].waktu);

    String _tanggal = DateFormat("d", "id_ID").format(waktuTransaksi);

    String _bulan =
        DateFormat("MMMM", "id_ID").format(waktuTransaksi).substring(0, 3);

    String _sisaWaktu =
        DateFormat("yyyy, HH:mm", "id_ID").format(waktuTransaksi);

    //
    //

    // waktu rilis regulasi pembagian yang baru 12 april 2022
    DateTime patokanWaktuProduction = DateTime.parse("2022-04-12 20:00:00");

    if (jenisTransaksi == "biaya layanan" &&
        (waktuTransaksi.isAfter(patokanWaktuProduction) ||
            nominalTransaksi != 2000)) {
      //
      nominalTransaksi = nominalTransaksi ~/ 2;
    }

    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.fromLTRB(10, 5, 10, 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            color: widget.model.listHistorys.historyLists[index]
                        .nomorPelanggan ==
                    null
                ? Warna.primary
                : widget.model.listHistorys.historyLists[index].message ==
                        "SUCCESS"
                    ? Warna.primary
                    : widget.model.listHistorys.historyLists[index].message ==
                            "PAYMENT SUCCESS"
                        ? Warna.primary
                        : Colors.orange[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$_tanggal $_bulan $_sisaWaktu",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  jenisTransaksi,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          ListTile(
            // title: Text(historysList.historyLists[index].transferTypeName),
    
            onTap: () {
              isClicked = !isClicked;
            },
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 5),
                // ),
                Text(
                  "Pengirim  : " +
                      widget.model.listHistorys.historyLists[index].namaPengirim,
                ),
                Text(
                  "Penerima : " +
                      widget.model.listHistorys.historyLists[index].namaPenerima,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Text(
                  "#" + widget.model.listHistorys.historyLists[index].idKwitansi,
                ),
                SizedBox(
                  height: 10,
                ),
                widget.model.listHistorys.historyLists[index].nomorPelanggan !=
                        null
                    ? Text(
                        "Nomor pelanggan : " +
                            widget.model.listHistorys.historyLists[index]
                                .nomorPelanggan,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500))
                    : Container(),
                Text(
                    widget.model.listHistorys.historyLists[index].deskripsi ==
                            null
                        ? "tidak ada catatan"
                        : rapiin(widget
                            .model.listHistorys.historyLists[index].deskripsi),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey[800])),
                SizedBox(
                  height: 10,
                ),
                widget.model.listHistorys.historyLists[index].nomorPelanggan ==
                        null
                    ? Text("")
                    : Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: widget.model.listHistorys.historyLists[index]
                                      .nomorPelanggan ==
                                  null
                              ? Warna.primary
                              : widget.model.listHistorys.historyLists[index]
                                          .message ==
                                      "SUCCESS"
                                  ? Warna.primary
                                  : widget.model.listHistorys
                                              .historyLists[index].message ==
                                          "PAYMENT SUCCESS"
                                      ? Warna.primary
                                      : Colors.orange[800],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "transaksi ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.model.listHistorys.historyLists[index]
                                              .message ==
                                          "SUCCESS"
                                      ? "SUKSES"
                                      : widget
                                                  .model
                                                  .listHistorys
                                                  .historyLists[index]
                                                  .message ==
                                              "PAYMENT SUCCESS"
                                          ? "SUKSES"
                                          : "GAGAL",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 7),
                                Icon(
                                    widget.model.listHistorys
                                                .historyLists[index].message ==
                                            "SUCCESS"
                                        ? Icons.check_box
                                        : widget
                                                    .model
                                                    .listHistorys
                                                    .historyLists[index]
                                                    .message ==
                                                "PAYMENT SUCCESS"
                                            ? Icons.check_box
                                            : Icons.cancel,
                                    color: Colors.white),
                              ],
                            )
                          ],
                        ),
                      ),
                SizedBox(
                  height: 17,
                )
              ],
            ),
            trailing: Container(
              width: 125,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    prefixSimbolNominal + rupiah(nominalTransaksi),
                    style: TextStyle(
                        color: warnaNominal, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            isThreeLine: true,
          ),
          Container(
            child: isClicked
                ? Container(
                    padding: EdgeInsets.all(11),
                    height: 55,
                    child: Column(
                      children: [Container()],
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
