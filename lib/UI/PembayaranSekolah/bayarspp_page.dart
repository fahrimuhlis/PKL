// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:Edimu/UI/PembayaranSekolah/RiwayatSpp_Page.dart';
// import 'package:Edimu/UI/PembayaranSekolah/bayarspp_confirm_page.dart';
// import 'package:Edimu/UI/Topup/topUp_page.dart';
// import 'package:Edimu/scoped_model/main.dart';
// import 'package:Edimu/konfigurasi/style.dart';
// import 'package:indonesia/indonesia.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:expandable/expandable.dart';
// import 'package:scoped_model/scoped_model.dart';

// // sekali bayar:
// // - AJP
// // - Matrikulasi
// // - Perlengkapan

// // Tahunan:
// // - kegiatan
// // - heregistrasi
// // - infaq_ortuasuh
// // - infaq_pembangunan
// // - ajp_asrama

// // Bulanan :
// // - IPP
// // - BP3
// // - Makan
// // - Snack
// // - Antar Jemput
// // - Infaq

// class BayarSpp_Page extends StatefulWidget {
//   final MainModel model;
//   BayarSpp_Page(this.model);

//   @override
//   _BayarSpp_PageState createState() => _BayarSpp_PageState();
// }

// class _BayarSpp_PageState extends State<BayarSpp_Page> {
//   // List listTagihan = [];
//   List listTagihanBaru = [];

//   int grandTotal = 0;

//   var dataSiswa;

//   @override
//   void initState() {
//     listTagihanBaru = [];
//     dataSiswa = widget.model.dataSiswa;
//     // listTagihanBaru = widget.model.listTagihanBaru;

//     widget.model.listTagihanBaru.forEach((v) => listTagihanBaru.add(v));

//     // if(listTagihanBaru.length > 0){
//     //   hitungTotalTagihan();
//     // }

//     // widget.model.tagihan.forEach((k, v) => listTagihan.add(v));

//     // if (listTagihanBaru.length > 0) {
//     //   listTagihanBaru.forEach((index) {
//     //     for (var item in index) {
//     //       if (item["status_pembayaran"] == "belum lunas") {
//     //         grandTotal += int.parse(item["nominal"].replaceAll(".00", ""));
//     //       }
//     //     }
//     //   });
//     // }

//     // //debugPrint('isi var listTagihan :');
//     // //debugPrint(listTagihan.toString());
//     // //debugPrint("isi var grandTotal = ${grandTotal.toString()}");
//     // super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//           backgroundColor: Warna.hijauBG2,
//           appBar: AppBar(
//             actions: [
//               IconButton(
//                   icon: Icon(
//                     Icons.receipt,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 RiwayatSPP_Page(widget.model)));
//                   })
//             ],
//             title: Text("Tagihan Sekolah"),
//             centerTitle: true,
//             bottom: TabBar(
//               indicatorColor: Colors.white,
//               indicator: BoxDecoration(
//                   color: Colors.green,
//                   border: Border(
//                       bottom: BorderSide(
//                           color: Colors.white,
//                           width: 3,
//                           style: BorderStyle.solid))),
//               tabs: [
//                 Tab(text: 'Bulanan'),
//                 Tab(text: 'Tahunan'),
//                 Tab(text: 'Sekali Bayar')
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [pageBulanan(), pageTahunan(), pageSekaliBayar()],
//           )),
//     );
//   }

//   namaBulan(angkaBulan) {
//     if (angkaBulan == 1) {
//       return "Januari";
//     } else if (angkaBulan == 2) {
//       return "Februari";
//     } else if (angkaBulan == 3) {
//       return "Maret";
//     } else if (angkaBulan == 4) {
//       return "April";
//     } else if (angkaBulan == 5) {
//       return "Mei";
//     } else if (angkaBulan == 6) {
//       return "Juni";
//     } else if (angkaBulan == 7) {
//       return "Juli";
//     } else if (angkaBulan == 8) {
//       return "Agustus";
//     } else if (angkaBulan == 9) {
//       return "September";
//     } else if (angkaBulan == 10) {
//       return "Oktober";
//     } else if (angkaBulan == 11) {
//       return "November";
//     } else if (angkaBulan == 12) {
//       return "Desember";
//     }
//   }

//   Widget pageBulanan() {
//     return ScopedModelDescendant(
//       builder: (BuildContext context, Widget child, MainModel model) =>
//           RefreshIndicator(
//         onRefresh: _refresh,
//         child: Container(
//           margin: EdgeInsets.all(5),
//           padding: EdgeInsets.all(11),
//           child: ListView(
//             children: [
//               SizedBox(
//                 height: 1,
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Saldo : ${rupiah(model.formatedBalance)}"),
//               ),
//               SizedBox(
//                 height: 29,
//               ),
//               infoSiswaDanTagihan(model),
//               SizedBox(
//                 height: 19,
//               ),
//               cardBulanan()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget pageSekaliBayar() {
//     return RefreshIndicator(
//       onRefresh: _refresh,
//       child: Container(
//         margin: EdgeInsets.all(5),
//         padding: EdgeInsets.all(11),
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 1,
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text("Saldo : ${rupiah(widget.model.formatedBalance)}"),
//             ),
//             SizedBox(
//               height: 29,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.amber[200],
//                   borderRadius: BorderRadius.circular(9)),
//               padding: EdgeInsets.all(15),
//               width: 291,
//               child: Column(
//                 children: [
//                   Text(
//                     dataSiswa['nama'] ?? "......",
//                     style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 0,
//                   ),
//                   Text(dataSiswa['alamat'] ?? "......",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey[600])),
//                   SizedBox(
//                     height: 21,
//                   ),
//                   Text("Total Tagihan Sekolah :"),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     // listTagihan[0][0]["nominal"].isEmpty
//                     listTagihanBaru.length <= 0
//                         ? "Rp ....."
//                         : rupiah(widget.model.grandTotal.toString()),
//                     style: TextStyle(fontSize: 29),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 19,
//             ),
//             cardSekaliBayar()
//           ],
//         ),
//       ),
//     );
//   }

//   Widget pageTahunan() {
//     return RefreshIndicator(
//       onRefresh: _refresh,
//       child: Container(
//         margin: EdgeInsets.all(5),
//         padding: EdgeInsets.all(11),
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 1,
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text("Saldo : ${rupiah(widget.model.formatedBalance)}"),
//             ),
//             SizedBox(
//               height: 29,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.amber[200],
//                   borderRadius: BorderRadius.circular(9)),
//               padding: EdgeInsets.all(15),
//               width: 291,
//               child: Column(
//                 children: [
//                   Text(
//                     dataSiswa['nama'] ?? "......",
//                     style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 0,
//                   ),
//                   Text(dataSiswa['alamat'] ?? "......",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey[600])),
//                   SizedBox(
//                     height: 21,
//                   ),
//                   Text("Total Tagihan Sekolah :"),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     // listTagihan[0][0]["nominal"].isEmpty
//                     listTagihanBaru.length <= 0
//                         ? "Rp ....."
//                         : rupiah(widget.model.grandTotal.toString()),
//                     style: TextStyle(fontSize: 29),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 19,
//             ),
//             cardTahunan()
//           ],
//         ),
//       ),
//     );
//   }

//   Future _refresh() async {
//     // ========================
//     // ===== REFRESH VERSI BARU 14 oktober 2021
//     // ========================
//     EasyLoading.show(
//       status: 'sedang diproses',
//       maskType: EasyLoadingMaskType.black,
//       dismissOnTap: true,
//     );

//     listTagihanBaru = [];
//     widget.model.listTagihanBaru = [];
//     widget.model.listTagihanBulanan = {};
//     widget.model.cobaListBulanan = [];
//     widget.model.listTagihanTahunan = [];
//     widget.model.listTagihanSekaliBayar = [];
//     //ngosongin total
//     widget.model.totalBulanan = 0;
//     widget.model.totalTahunan = 0;
//     widget.model.totalSekaliBayar = 0;
//     widget.model.grandTotal = 0;

//     await widget.model.getTagihanBaru();
//     widget.model.listTagihanBaru.forEach((v) => listTagihanBaru.add(v));
//     setState(() {});

//     EasyLoading.dismiss();
//     // // ========================
//     // // ===== REFRESH VERSI LAMA
//     // // ========================
//     // await widget.model.refresh_getTagihan();
//     // // await Future.delayed(Duration(milliseconds: 1001));
//     // setState(() {
//     //   dataSiswa = widget.model.dataSiswa;
//     //   listTagihanBaru = [];
//     //   widget.model.tagihan.forEach((k, v) => listTagihanBaru.add(v));
//     //   grandTotal = 0;
//     //   listTagihanBaru.forEach((index) {
//     //     for (var item in index) {
//     //       if (item["status_pembayaran"] == "belum lunas") {
//     //         grandTotal += int.parse(item["nominal"].replaceAll(".00", ""));
//     //       }
//     //     }
//     //   });
//     // });
//   }

//   // hitungTotalTagihan() {
//   //   listTagihanBaru.forEach((item) {
//   //     if (item['nominal'] == 'belum lunas') {
//   //       String nominal;
//   //       //debugPrint('isi item-nya forEach:');
//   //       //debugPrint(item.toString());
//   //       nominal = item['nominal'].replaceAll(".00", "");
//   //       grandTotal += int.parse(nominal);
//   //     }
//   //   });
//   //   //debugPrint('total grandTotal tagihan adalah sebesar : ${grandTotal.toString()}');
//   //   // for(int i=0; i < listTagihanBaru.length; i++){
//   //   //   // //debugPrint('isi item-nya forEach:');
//   //   //   // //debugPrint(i.toString());
//   //   //   // String nominal = listTagihanBaru[i]['nominal'];
//   //   //   // grandTotal += int.parse(nominal);
//   //   //   //debugPrint(i.toString());
//   //   // }
//   // }

//   Widget infoSiswaDanTagihan(MainModel model) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.amber[200], borderRadius: BorderRadius.circular(9)),
//       padding: EdgeInsets.all(15),
//       width: 291,
//       child: Column(
//         children: [
//           Text(
//             dataSiswa['nama'] ?? "......",
//             style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(
//             height: 0,
//           ),
//           Text(dataSiswa['alamat'] ?? "......",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey[600])),
//           SizedBox(
//             height: 21,
//           ),
//           Text("Total Tagihan Sekolah :"),
//           SizedBox(
//             height: 5,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 // listTagihan[0][0]["nominal"].isEmpty
//                 listTagihanBaru.length <= 0
//                     ? "Rp ....."
//                     : rupiah(model.grandTotal.toString()),
//                 style: TextStyle(fontSize: 29),
//               ),
//               const SizedBox(
//                 width: 1,
//               ),
//               ElevatedButton.icon(
//                   // color: Colors.green,
//                   minWidth: 0,
//                   height: 50,
//                   onPressed: () {
//                     _refresh();
//                   },
//                   icon: Icon(
//                     Icons.refresh,
//                     color: Colors.blue[800],
//                     size: 29,
//                   ),
//                   label: Container())
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget allTagihan() {
//     return ScopedModelDescendant(
//         builder: (BuildContext context, Widget child, MainModel model) {
//       if (listTagihanBaru.length <= 0) {
//         return Center(
//           child: tagihanKosong("semua tagihan"),
//         );
//       } else {
//         return Container(
//           width: 350,
//           child: ListView.builder(
//             physics: ScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: listTagihanBaru.length,
//             itemBuilder: (context, index) {
//               String angkaSPP;
//               String angkaBP3;
//               String angkaMakan;
//               String angkaSnack;

//               List pembayaranUntuk = []; //untuk menampung id jenis tagihan

//               // listTagihan[index].forEach((item) {
//               //   if (item["nama"] == "IPP") {
//               //     angkaSPP = item['nominal'].replaceAll(".00", "");
//               //   } else if() {}
//               // });

//               // listTagihan[index].forEach((item) {
//               //   if (item["nama"] == "BP3") {
//               //     angkaBP3 = item['nominal'].replaceAll(".00", "");
//               //   }
//               // });

//               // listTagihan[index].forEach((item) {
//               //   if (item["nama"] == "makan") {
//               //     angkaMakan = item['nominal'].replaceAll(".00", "");
//               //   }
//               // });

//               // listTagihan[index].forEach((item) {
//               //   if (item["nama"] == "snack") {
//               //     angkaSnack = item['nominal'].replaceAll(".00", "");
//               //   }
//               // });

//               var statusPembayaran =
//                   listTagihanBaru[index]["status_pembayaran"] == "lunas"
//                       ? Icon(
//                           Icons.check_circle,
//                           color: Colors.green,
//                           size: 29,
//                         )
//                       : Icon(
//                           Icons.cancel,
//                           color: Colors.red,
//                           size: 29,
//                         );

//               var sudahLunas =
//                   listTagihanBaru[index]["status_pembayaran"] == "lunas"
//                       ? Container(
//                           decoration: BoxDecoration(
//                               color: Colors.green,
//                               borderRadius: BorderRadius.circular(5)),
//                           width: 121,
//                           margin: EdgeInsets.only(top: 15),
//                           padding: EdgeInsets.all(9),
//                           child: Text(
//                             "Lunas",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         )
//                       : Container(
//                           width: 121,
//                           decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(5)),
//                           margin: EdgeInsets.only(top: 15),
//                           padding: EdgeInsets.all(9),
//                           child: Text(
//                             "belum lunas",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         );

//               var styleAngka =
//                   listTagihanBaru[index]["status_pembayaran"] == "lunas"
//                       ? TextStyle(color: Colors.green[700])
//                       : TextStyle(color: Colors.red[900]);

//               var tombolBayar =
//                   listTagihanBaru[index]["status_pembayaran"] == "lunas"
//                       ? Container(
//                           height: 0.5,
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.only(
//                               bottom: 11, right: 11, left: 11),
//                           child: SizedBox(
//                               width: MediaQuery.of(context).size.width,
//                               height: 47,
//                               child: ElevatedButton(
//                                 color: Colors.blue[800],
//                                 child: Text(
//                                   "Bayar",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(9.0)),
//                                 onPressed: () {
//                                   // masih belum tau untuk apa
//                                   pembayaranUntuk
//                                       .add(listTagihanBaru[index]['jenis_id']);

//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Confirm_BayarSpp(
//                                             widget.model,
//                                             pembayaranUntuk,
//                                             listTagihanBaru[index]
//                                                 ["bulan_pembayaran"],
//                                             int.parse(listTagihanBaru[index]
//                                                     ['nominal']
//                                                 .replaceAll(".00", "")),
//                                             dataSiswa)),
//                                   );
//                                 },
//                               )),
//                         );

//               return Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//                 semanticContainer: true,
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 elevation: 7,
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 15),
//                   // margin: EdgeInsets.all(9),
//                   child: ExpansionTile(
//                     // initiallyExpanded: true,

//                     title: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(listTagihanBaru[index]['nama'],
//                             style: TextStyle(fontWeight: FontWeight.w700)),
//                         // SizedBox(
//                         //   width: 25,
//                         // ),
//                         sudahLunas
//                       ],
//                     ),
//                     subtitle: Text(
//                         "${namaBulan(listTagihanBaru[index]["bulan_pembayaran"])} ${listTagihanBaru[index]['tahun']}"),
//                     children: [
//                       ListTile(
//                         title: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Biaya :"),
//                             SizedBox(
//                               width: 95,
//                             ),
//                             statusPembayaran
//                           ],
//                         ),
//                         trailing: Text(
//                           rupiah(listTagihanBaru[index]['nominal']
//                               .replaceAll(".00", "")),
//                           style: styleAngka,
//                         ),
//                       ),
//                       Container(
//                         width: 251,
//                         margin: EdgeInsets.symmetric(horizontal: 15),
//                         height: 2.1,
//                         color: Warna.primary,
//                       ),
//                       Container(
//                         margin: EdgeInsets.all(9),
//                         padding: EdgeInsets.all(5),
//                         width: 251,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text("Total :"),
//                             SizedBox(
//                               width: 9,
//                             ),
//                             Text(
//                                 rupiah(listTagihanBaru[index]['nominal']
//                                     .replaceAll(".00", "")),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 19))
//                           ],
//                         ),
//                       ),
//                       tombolBayar
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }
//     });
//   }

//   Widget cardSekaliBayar() {
//     return ScopedModelDescendant(
//         builder: (BuildContext context, Widget child, MainModel model) {
//       if (model.listTagihanSekaliBayar.length <= 0) {
//         return tagihanKosong("sekali bayar");
//       } else {
//         return Container(
//           width: 350,
//           child: ListView.builder(
//             physics: ScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: model.listTagihanSekaliBayar.length,
//             itemBuilder: (context, index) {
//               List pembayaranUntuk = []; //untuk menampung id jenis tagihan

//               // listTagihan[index].forEach((item) {
//               //   if (item["nama"] == "IPP") {
//               //     angkaSPP = item['nominal'].replaceAll(".00", "");
//               //   } else if() {}
//               // });

//               // listTagihan[index].forEach((item) {
//               //   if (item["nama"] == "BP3") {
//               //     angkaBP3 = item['nominal'].replaceAll(".00", "");
//               //   }
//               // });

//               // listTagihan[index].forEach((item) {
//               //   if (item["nama"] == "makan") {
//               //     angkaMakan = item['nominal'].replaceAll(".00", "");
//               //   }
//               // });

//               // listTagihan[index].forEach((item) {
//               //   if (item["nama"] == "snack") {
//               //     angkaSnack = item['nominal'].replaceAll(".00", "");
//               //   }
//               // });

//               var statusPembayaran = model.listTagihanSekaliBayar[index]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 29,
//                     )
//                   : Icon(
//                       Icons.cancel,
//                       color: Colors.red,
//                       size: 29,
//                     );

//               var sudahLunas = model.listTagihanSekaliBayar[index]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Container(
//                       decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(5)),
//                       width: 121,
//                       margin: EdgeInsets.only(top: 15),
//                       padding: EdgeInsets.all(9),
//                       child: Text(
//                         "Lunas",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   : Container(
//                       width: 121,
//                       decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(5)),
//                       margin: EdgeInsets.only(top: 15),
//                       padding: EdgeInsets.all(9),
//                       child: Text(
//                         "belum lunas",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     );

//               var styleAngka = model.listTagihanSekaliBayar[index]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? TextStyle(color: Colors.green[700])
//                   : TextStyle(color: Colors.red[900]);

//               var tombolBayar = model.listTagihanSekaliBayar[index]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Container(
//                       height: 0.5,
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 11, right: 11, left: 11),
//                       child: SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           height: 47,
//                           child: ElevatedButton(
//                             color: Colors.blue[800],
//                             child: Text(
//                               "Bayar",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(9.0)),
//                             onPressed: () {
//                               // masih belum tau untuk apa
//                               pembayaranUntuk.add(model
//                                   .listTagihanSekaliBayar[index]['jenis_id']);

//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Confirm_BayarSpp(
//                                         widget.model,
//                                         pembayaranUntuk,
//                                         model.listTagihanSekaliBayar[index]
//                                             ["bulan_pembayaran"],
//                                         int.parse(model
//                                             .listTagihanSekaliBayar[index]
//                                                 ['nominal']
//                                             .replaceAll(".00", "")),
//                                         dataSiswa)),
//                               );
//                             },
//                           )),
//                     );

//               return Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//                 semanticContainer: true,
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 elevation: 7,
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 15),
//                   // margin: EdgeInsets.all(9),
//                   child: ExpansionTile(
//                     // initiallyExpanded: true,

//                     title: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(model.listTagihanSekaliBayar[index]['nama'],
//                             style: TextStyle(fontWeight: FontWeight.w700)),
//                         // SizedBox(
//                         //   width: 25,
//                         // ),
//                         sudahLunas
//                       ],
//                     ),
//                     subtitle: Text(
//                         "${namaBulan(model.listTagihanSekaliBayar[index]["bulan_pembayaran"])} ${model.listTagihanSekaliBayar[index]['tahun']}"),
//                     children: [
//                       ListTile(
//                         title: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Biaya :"),
//                             SizedBox(
//                               width: 95,
//                             ),
//                             statusPembayaran
//                           ],
//                         ),
//                         trailing: Text(
//                           rupiah(model.listTagihanSekaliBayar[index]['nominal']
//                               .replaceAll(".00", "")),
//                           style: styleAngka,
//                         ),
//                       ),
//                       Container(
//                         width: 251,
//                         margin: EdgeInsets.symmetric(horizontal: 15),
//                         height: 2.1,
//                         color: Warna.primary,
//                       ),
//                       Container(
//                         margin: EdgeInsets.all(9),
//                         padding: EdgeInsets.all(5),
//                         width: 251,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text("Total :"),
//                             SizedBox(
//                               width: 9,
//                             ),
//                             Text(
//                                 rupiah(model.listTagihanSekaliBayar[index]
//                                         ['nominal']
//                                     .replaceAll(".00", "")),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 19))
//                           ],
//                         ),
//                       ),
//                       tombolBayar
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }
//     });
//   }

//   Widget cardTahunan() {
//     return ScopedModelDescendant(
//         builder: (BuildContext context, Widget child, MainModel model) {
//       if (listTagihanBaru.length <= 0) {
//         return Center(
//           child: tagihanKosong("Tagihan Tahunan"),
//         );
//       } else {
//         return Container(
//           width: 350,
//           child: ListView.builder(
//             physics: ScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: model.listTagihanTahunan.length,
//             itemBuilder: (context, index) {
//               List pembayaranUntuk = []; //untuk menampung id jenis tagihan

//               var statusPembayaran = model.listTagihanTahunan[index]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 29,
//                     )
//                   : Icon(
//                       Icons.cancel,
//                       color: Colors.red,
//                       size: 29,
//                     );

//               var sudahLunas = model.listTagihanTahunan[index]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Container(
//                       decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(5)),
//                       width: 121,
//                       margin: EdgeInsets.only(top: 15),
//                       padding: EdgeInsets.all(9),
//                       child: Text(
//                         "Lunas",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   : Container(
//                       width: 121,
//                       decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(5)),
//                       margin: EdgeInsets.only(top: 15),
//                       padding: EdgeInsets.all(9),
//                       child: Text(
//                         "belum lunas",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     );

//               var styleAngka = model.listTagihanTahunan[index]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? TextStyle(color: Colors.green[700])
//                   : TextStyle(color: Colors.red[900]);

//               var tombolBayar = model.listTagihanTahunan[index]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Container(
//                       height: 0.5,
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 11, right: 11, left: 11),
//                       child: SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           height: 47,
//                           child: ElevatedButton(
//                             color: Colors.blue[800],
//                             child: Text(
//                               "Bayar",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(9.0)),
//                             onPressed: () {
//                               // masih belum tau untuk apa
//                               pembayaranUntuk.add(
//                                   model.listTagihanTahunan[index]['jenis_id']);

//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Confirm_BayarSpp(
//                                         widget.model,
//                                         pembayaranUntuk,
//                                         model.listTagihanTahunan[index]
//                                             ["bulan_pembayaran"],
//                                         int.parse(model
//                                             .listTagihanTahunan[index]
//                                                 ['nominal']
//                                             .replaceAll(".00", "")),
//                                         dataSiswa)),
//                               );
//                             },
//                           )),
//                     );

//               return Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//                 semanticContainer: true,
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 elevation: 7,
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 15),
//                   // margin: EdgeInsets.all(9),
//                   child: ExpansionTile(
//                     // initiallyExpanded: true,

//                     title: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(model.listTagihanTahunan[index]['nama'],
//                             style: TextStyle(fontWeight: FontWeight.w700)),
//                         // SizedBox(
//                         //   width: 25,
//                         // ),
//                         sudahLunas
//                       ],
//                     ),
//                     subtitle: Text(
//                         "${namaBulan(model.listTagihanTahunan[index]["bulan_pembayaran"])} ${model.listTagihanTahunan[index]['tahun']}"),
//                     children: [
//                       ListTile(
//                         title: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Biaya :"),
//                             SizedBox(
//                               width: 95,
//                             ),
//                             statusPembayaran
//                           ],
//                         ),
//                         trailing: Text(
//                           rupiah(model.listTagihanTahunan[index]['nominal']
//                               .replaceAll(".00", "")),
//                           style: styleAngka,
//                         ),
//                       ),
//                       Container(
//                         width: 251,
//                         margin: EdgeInsets.symmetric(horizontal: 15),
//                         height: 2.1,
//                         color: Warna.primary,
//                       ),
//                       Container(
//                         margin: EdgeInsets.all(9),
//                         padding: EdgeInsets.all(5),
//                         width: 251,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text("Total :"),
//                             SizedBox(
//                               width: 9,
//                             ),
//                             Text(
//                                 rupiah(model.listTagihanTahunan[index]
//                                         ['nominal']
//                                     .replaceAll(".00", "")),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 19))
//                           ],
//                         ),
//                       ),
//                       tombolBayar
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }
//     });
//   }

//   Widget cardBulanan() {
//     return ScopedModelDescendant(
//         builder: (BuildContext context, Widget child, MainModel model) {
//       if (model.cobaListBulanan.length <= 0) {
//         return Center(
//           child: tagihanKosong("tagihan bulanan"),
//         );
//       } else {
//         return Container(
//           width: 350,
//           child: ListView.builder(
//             physics: ScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: model.cobaListBulanan.length,
//             itemBuilder: (context, index) {
//               List pembayaranUntuk = [];

//               model.cobaListBulanan[index].forEach((item) {
//                 //debugPrint('isi item cobaListBulanan :');
//                 //debugPrint(item.toString());
//                 pembayaranUntuk.add(item["jenis_id"]);
//               });

//               //debugPrint(
//                   'isi List pembayaranUntuk = ' + pembayaranUntuk.toString());

//               String angkaSPP = '0';
//               String angkaBP3 = '0';
//               String angkaMakan = '0';
//               String angkaSnack = '0';
//               String angkaInfaq = '0';

//               //debugPrint('isi cobaListBulanan :::indeks:::');
//               //debugPrint(model.cobaListBulanan[index].toString());

//               model.cobaListBulanan[index].forEach((value) {
//                 if (value["nama"] == "IPP") {
//                   angkaSPP = value['nominal'].replaceAll(".00", "");
//                 }
//               });

//               model.cobaListBulanan[index].forEach((value) {
//                 if (value["nama"] == "BP3") {
//                   angkaBP3 = value['nominal'].replaceAll(".00", "");
//                 }
//               });

//               model.cobaListBulanan[index].forEach((value) {
//                 if (value["nama"] == "makan") {
//                   angkaMakan = value['nominal'].replaceAll(".00", "");
//                 }
//               });

//               model.cobaListBulanan[index].forEach((value) {
//                 if (value["nama"] == "snack") {
//                   angkaSnack = value['nominal'].replaceAll(".00", "");
//                 }
//               });

//               model.cobaListBulanan[index].forEach((value) {
//                 if (value["nama"] == "infaq") {
//                   angkaInfaq = value['nominal'].replaceAll(".00", "");
//                 }
//               });

//               int totalBulanan = 0;

//               totalBulanan = int.parse(angkaSPP) +
//                   int.parse(angkaSnack) +
//                   int.parse(angkaMakan) +
//                   int.parse(angkaSnack) +
//                   int.parse(angkaBP3);

//               //debugPrint(
//                   'isi angka totalBulanan adalah = ${totalBulanan.toString()}');

//               var statusPembayaran = model.cobaListBulanan[index][0]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 29,
//                     )
//                   : Icon(
//                       Icons.cancel,
//                       color: Colors.red,
//                       size: 29,
//                     );

//               var sudahLunas = model.cobaListBulanan[index][0]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Container(
//                       decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(5)),
//                       width: 121,
//                       padding: EdgeInsets.all(9),
//                       child: Text(
//                         "Lunas",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   : Container(
//                       width: 121,
//                       decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(5)),
//                       padding: EdgeInsets.all(9),
//                       child: Text(
//                         "belum lunas",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     );

//               var styleAngka = model.cobaListBulanan[index][0]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? TextStyle(color: Colors.green[700])
//                   : TextStyle(color: Colors.red[900]);

//               var tombolBayar = model.cobaListBulanan[index][0]
//                           ["status_pembayaran"] ==
//                       "lunas"
//                   ? Container(
//                       height: 0.5,
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 11, right: 11, left: 11),
//                       child: SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           height: 47,
//                           child: ElevatedButton(
//                             color: Colors.blue[800],
//                             child: Text(
//                               "Bayar",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(9.0)),
//                             onPressed: () {
//                               if (int.parse(model.formatedBalance) >=
//                                   totalBulanan) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Confirm_BayarSpp(
//                                           model,
//                                           pembayaranUntuk,
//                                           model.cobaListBulanan[index][0]
//                                               ["bulan_pembayaran"],
//                                           totalBulanan,
//                                           dataSiswa)),
//                                 );
//                               } else {
//                                 Alert(
//                                     type: AlertType.info,
//                                     context: context,
//                                     closeFunction: () {},
//                                     title: "Saldo anda tidak cukup",
//                                     desc:
//                                         "silahkan lakukan topup SALDO Edimu untuk melakukan pembayaran barang",
//                                     content: Container(
//                                         padding: EdgeInsets.only(top: 25),
//                                         child: Column(
//                                           children: [
//                                             InkWell(
//                                               child: Text('Lain kali',
//                                                   style: TextStyle(
//                                                       color: Colors.grey[600],
//                                                       decoration: TextDecoration
//                                                           .underline)),
//                                               onTap: () {
//                                                 Navigator.pop(context);
//                                               },
//                                             )
//                                           ],
//                                         )),
//                                     buttons: [
//                                       DialogButton(
//                                         child: Text('Topup saldo sekarang',
//                                             style:
//                                                 TextStyle(color: Colors.white)),
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     topUpPage(model)),
//                                           );
//                                         },
//                                       )
//                                     ]).show();
//                               }
//                             },
//                           )),
//                     );

//               return Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//                 semanticContainer: true,
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 elevation: 7,
//                 child: Container(
//                   // margin: EdgeInsets.all(9),
//                   child: ExpansionTile(
//                     // initiallyExpanded: true,

//                     title: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                             namaBulan(widget.model.cobaListBulanan[index][0]
//                                     ["bulan_pembayaran"]) +
//                                 ' ' +
//                                 widget.model.cobaListBulanan[index][0]["tahun"]
//                                     .toString(),
//                             style: TextStyle(fontWeight: FontWeight.w700)),
//                         // SizedBox(
//                         //   width: 25,
//                         // ),
//                         sudahLunas
//                       ],
//                     ),
//                     children: [
//                       ListTile(
//                         title: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("IPP"),
//                             SizedBox(
//                               width: 95,
//                             ),
//                             statusPembayaran
//                           ],
//                         ),
//                         trailing: Text(
//                           rupiah(angkaSPP),
//                           style: styleAngka,
//                         ),
//                       ),
//                       ListTile(
//                         title: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("BP3"),
//                             SizedBox(
//                               width: 95,
//                             ),
//                             statusPembayaran
//                           ],
//                         ),
//                         trailing: Text(rupiah(angkaBP3), style: styleAngka),
//                       ),
//                       ListTile(
//                         title: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Uang Makan"),
//                             SizedBox(
//                               width: 35,
//                             ),
//                             statusPembayaran
//                           ],
//                         ),
//                         trailing: Text(rupiah(angkaMakan), style: styleAngka),
//                       ),
//                       ListTile(
//                         title: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Uang Snack"),
//                             SizedBox(
//                               width: 35,
//                             ),
//                             statusPembayaran
//                           ],
//                         ),
//                         trailing: Text(rupiah(angkaSnack), style: styleAngka),
//                       ),
//                       Container(
//                         width: 251,
//                         margin: EdgeInsets.symmetric(horizontal: 15),
//                         height: 2.1,
//                         color: Warna.primary,
//                       ),
//                       Container(
//                         margin: EdgeInsets.all(9),
//                         padding: EdgeInsets.all(5),
//                         width: 251,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text("Total :"),
//                             SizedBox(
//                               width: 9,
//                             ),
//                             Text(rupiah(totalBulanan.toString()),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 19))
//                           ],
//                         ),
//                       ),
//                       tombolBayar
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }
//     });
//   }

//   Widget tagihanKosong(String pesan) {
//     return Container(
//       padding: EdgeInsets.only(top: 75),
//       child: Center(
//           child: Column(
//         children: [
//           Text("Tidak ada tagihan"),
//           SizedBox(
//             height: 7,
//           ),
//           Text(pesan),
//         ],
//       )),
//     );
//   }
// }
