import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:intl/intl.dart';
import 'package:Edimu/konfigurasi/api.dart';
import 'package:Edimu/UI/PembayaranSekolah/RiwayatSpp_Page.dart';
import 'package:http/http.dart' as http;

class PayLater extends StatefulWidget {
  final MainModel model;

  PayLater(this.model);

  @override
  _PayLaterState createState() => _PayLaterState();
}

class _PayLaterState extends State<PayLater> {
  TabController tabController;
  bool isSelectAllRiwayat = false;
  List paylaterRiwayat = [];
  List listPaylaterBulanIni = [];
  dynamic listHistorys;

  List listRiwayat;
  // List bulanPaylaterRiwayat = [
  //   {
  //     'bulan': 'Januari',
  //     'kode': '01',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'Februari',
  //     'kode': '02',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'Maret',
  //     'kode': '03',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'April',
  //     'kode': '04',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'Mei',
  //     'kode': '05',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'Juni',
  //     'kode': '06',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'Juli',
  //     'kode': '07',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'Agustus',
  //     'kode': '08',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'September',
  //     'kode': '09',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'Oktober',
  //     'kode': '10',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'November',
  //     'kode': '11',
  //     'data pembelian': [],
  //   },
  //   {
  //     'bulan': 'Desembmer',
  //     'kode': '12',
  //     'data pembelian': [],
  //   }
  // ];

  Future riwayatPenggunaanPaylater() async {
    final bodyJSON = jsonEncode({
      'id': widget.model.usernameUser,
      'password': widget.model.passwordUser,
    });

    EasyLoading.show(
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );

    final response = await http.post(UrlAPI.getHistoryPaylater,
        body: bodyJSON, headers: widget.model.headerJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        paylaterRiwayat = data['list riwayat'];
      });

      DateTime now = DateTime.now();
      String formattedDate = DateFormat.M().format(now);

      if (formattedDate.length == 1) {
        formattedDate = "0" + formattedDate;
      }
      paylaterRiwayat.forEach((item) {
        if (item['tanggal_pembelian'].substring(5, 7) == formattedDate) {
          listPaylaterBulanIni.add(item);
        }
      });

      EasyLoading.dismiss();

      debugPrint(
          'Ini adalah isi data paylaterRiwayat ===============================================================');
      debugPrint(paylaterRiwayat.toString());

      // formulaPembagianMarketPlace = data["data konstanta"];

    } else {
      debugPrint("fungsi GET Riwayat Pay Later belum berhasil");
      return null;
    }
  }

  @override
  void initState() {
    riwayatPenggunaanPaylater();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          title: Text("Pay Later"),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: ListView(children: [
        Container(
            height: 145,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Warna.primary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: sisaPayLater(context),
                ),
                tabJenisItemFixed(),
              ],
            )),
        SizedBox(height: 15),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: isSelectAllRiwayat == false
                    ? Border.all(width: 1, color: Colors.orange)
                    : null,
                color: Colors.white),
            child: isSelectAllRiwayat == false
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pembelian bulan ini'),
                          Text(
                            rupiah(widget.model.penggunaanPayLater),
                            style: TextStyle(
                                fontSize: 18, color: Colors.orange[800]),
                          ),
                        ]),
                  )
                : Container()),
        // SizedBox(height: 15),
        SizedBox(height: isSelectAllRiwayat == false ? 5 : 0),
        Container(
            height: MediaQuery.of(context).size.height -
                (isSelectAllRiwayat == false ? 185 : 140),
            child: isSelectAllRiwayat == false
                ? tampilkanRiwayatPaylaterBulanIni()
                : tampilkanSemuaRiwayatPayLater()),
      ]),
    );
  }

  Widget tabJenisItemFixed() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelectAllRiwayat = false;
                    });
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.43,
                    decoration: BoxDecoration(
                        color:
                            !isSelectAllRiwayat ? Warna.primary : Colors.white,
                        // border: Border.all(width: 1, color: Warna.primary),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Bulan ini",
                        style: TextStyle(
                            color: !isSelectAllRiwayat
                                ? Colors.white
                                : Warna.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelectAllRiwayat = true;
                    });
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.43,
                    decoration: BoxDecoration(
                        color:
                            isSelectAllRiwayat ? Warna.primary : Colors.white,
                        // border: Border.all(width: 1, color: Warna.primary),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Riwayat",
                        style: TextStyle(
                            color: isSelectAllRiwayat
                                ? Colors.white
                                : Warna.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tampilkanRiwayatPaylaterBulanIni() {
    return listRiwayatPembelianPaylater(listPaylaterBulanIni);
  }

  Widget tampilkanSemuaRiwayatPayLater() {
    return listRiwayatPembelianPaylater(paylaterRiwayat);
  }

  Widget infoPelanggan(context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // SizedBox(
          //   height: 30,
          // ),
          // Text(
          //   "Info Pay Later",
          //   style: TextStyle(fontSize: 21),
          // ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              // border: Border.all(width: 2, color: Colors.blue[800]),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber[200], width: 3),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.amber[200],
                        width: constraints.maxWidth,
                        child: Column(
                          children: [
                            Text(
                              'Sisa Pay Later',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 5),
                            Text(
                              rupiah(widget.model.saldoPayLaterSekarang),
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Jumlah yang dikeluarkan bulan ini',
                      style: TextStyle(fontSize: 14, color: Colors.orange[900]),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      rupiah(widget.model.penggunaanPayLater),
                      style: TextStyle(fontSize: 22, color: Colors.orange[900]),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget sisaPayLater(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              height: 45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          Text(
                            'Sisa Pay Later',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(height: 3),
                          Text(
                            rupiah(widget.model.saldoPayLaterSekarang),
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paylaterYgDipakai(context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              // border: Border.all(width: 2, color: Colors.blue[800]),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber[200], width: 3),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.amber[200],
                        width: constraints.maxWidth,
                        child: Column(
                          children: [
                            Text(
                              'Jumlah yang dikeluarkan bulan ini',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 5),
                            Text(
                              rupiah(widget.model.penggunaanPayLater),
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget listPembelian(context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.M().format(now);
    DateTime datetime;
    List listPaylaterBulanIni = [];
    if (formattedDate.length == 1) {
      formattedDate = "0" + formattedDate;
    }
    paylaterRiwayat.forEach((item) {
      if (item['tanggal_pembelian'].substring(5, 7) == formattedDate) {
        listPaylaterBulanIni.add(item);
      }
    });
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: listPaylaterBulanIni.length,
          itemBuilder: (context, index) {
            datetime = DateTime.parse(
                listPaylaterBulanIni[index]['tanggal_pembelian']);
            return Column(children: [
              Container(
                color: Colors.green,
                padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: Row(children: [
                  Text(
                    Waktu(datetime).yMMMMd(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            ]);
          }),
    );
  }

  // Widget listPembelian(context) {
  //   DateTime now = DateTime.now();
  //   String formattedDate = DateFormat.M().format(now);
  //   DateTime datetime;
  //   List listPaylaterBulanIni = [];
  //   if (formattedDate.length == 1) {
  //     formattedDate = "0" + formattedDate;
  //   } else {
  //     formattedDate = formattedDate;
  //   }
  //   paylaterRiwayat.forEach((item) {
  //     if (item['tanggal_pembelian'].substring(5, 7) == formattedDate) {
  //       listPaylaterBulanIni.add(item);
  //     }
  //   });

  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  //     semanticContainer: true,
  //     clipBehavior: Clip.antiAliasWithSaveLayer,
  //     child: Container(
  //       // padding: EdgeInsets.only(bottom: 15),
  //       child: ExpansionTile(
  //         initiallyExpanded: false,
  //         title: Row(
  //           children: [
  //             Icon(
  //               Icons.fact_check,
  //               size: 30,
  //               color: Warna.primary,
  //             ),
  //             SizedBox(
  //               width: 11,
  //             ),
  //             Text(
  //               'Pembelian bulan ini',
  //               style:
  //                   TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
  //             ),
  //           ],
  //         ),
  //         children: [
  //           LayoutBuilder(
  //             builder: (BuildContext context, BoxConstraints constraints) {
  //               return Container(
  //                 height: listPaylaterBulanIni.length * 75.0,
  //                 // padding: EdgeInsets.symmetric(horizontal: 3),
  //                 width: constraints.maxWidth,
  //                 child: ListView.builder(
  //                     physics: NeverScrollableScrollPhysics(),
  //                     itemCount: listPaylaterBulanIni.length,
  //                     itemBuilder: (context, index) {
  //                       datetime = DateTime.parse(
  //                           listPaylaterBulanIni[index]['tanggal_pembelian']);

  //                       return Container(
  //                         margin: EdgeInsets.symmetric(
  //                             vertical: index % 2 == 0 ? 0 : 5),
  //                         padding: EdgeInsets.symmetric(
  //                             vertical: index % 2 == 0 ? 5 : 0),
  //                         color:
  //                             index % 2 == 0 ? Colors.grey[100] : Colors.white,
  //                         child: ListTile(
  //                             title: Text(
  //                                 listPaylaterBulanIni[index]['list_pembelian']
  //                                     ['nama_barang'],
  //                                 style: TextStyle(
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold)),
  //                             subtitle: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                     listPaylaterBulanIni[index]
  //                                         ['list_pembelian']['nama_toko'],
  //                                     style: TextStyle(
  //                                         fontWeight: FontWeight.w400),
  //                                     maxLines: 1,
  //                                     overflow: TextOverflow.ellipsis),
  //                                 Text(Waktu(datetime).yMMMMd(),
  //                                     style: TextStyle(
  //                                         fontWeight: FontWeight.w400),
  //                                     maxLines: 1,
  //                                     overflow: TextOverflow.ellipsis),
  //                               ],
  //                             ),
  //                             trailing: Text(
  //                               rupiah(listPaylaterBulanIni[index]
  //                                   ['list_pembelian']['harga_barang']),
  //                               style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.bold),
  //                             )),
  //                       );
  //                     }),
  //               );
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget listRiwayatPembelianPaylater(context) {
  //   DateTime datetime;
  //   for (var i = 0; i < 12; i++) {
  //     paylaterRiwayat.forEach((item) {
  //       if (item['tanggal_pembelian'].substring(5, 7) ==
  //           bulanPaylaterRiwayat[i]['kode']) {
  //         bulanPaylaterRiwayat[i]['data pembelian'].add(item);
  //       }
  //     });
  //   }

  //   // debugPrint(
  //   //     '================================================================ bulanPaylaterRiwayat');
  //   // debugPrint(bulanPaylaterRiwayat.toString());

  //   return ListView.builder(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       padding: EdgeInsets.only(bottom: 15),
  //       itemCount: 12,
  //       itemBuilder: (context, index1) {
  //         return bulanPaylaterRiwayat[index1]['data pembelian'].length == 0
  //             ? Container()
  //             : Padding(
  //                 padding: const EdgeInsets.only(bottom: 15),
  //                 child: Card(
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(5)),
  //                   semanticContainer: true,
  //                   clipBehavior: Clip.antiAliasWithSaveLayer,
  //                   child: Container(
  //                     // padding: EdgeInsets.only(bottom: 15),

  //                     child: ExpansionTile(
  //                       initiallyExpanded: false,
  //                       title: Row(
  //                         children: [
  //                           Icon(
  //                             Icons.fact_check,
  //                             size: 30,
  //                             color: Warna.primary,
  //                           ),
  //                           SizedBox(
  //                             width: 11,
  //                           ),
  //                           Text(
  //                             bulanPaylaterRiwayat[index1]['bulan'],
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w500),
  //                           ),
  //                         ],
  //                       ),
  //                       children: [
  //                         LayoutBuilder(
  //                           builder: (BuildContext context,
  //                               BoxConstraints constraints) {
  //                             return Container(
  //                               height: bulanPaylaterRiwayat[index1]
  //                                           ['data pembelian']
  //                                       .length *
  //                                   75.0,
  //                               // padding: EdgeInsets.symmetric(horizontal: 3),
  //                               width: constraints.maxWidth,
  //                               child: ListView.builder(
  //                                   physics: NeverScrollableScrollPhysics(),
  //                                   itemCount: bulanPaylaterRiwayat[index1]
  //                                           ['data pembelian']
  //                                       .length,
  //                                   itemBuilder: (context, index2) {
  //                                     datetime = DateTime.parse(
  //                                         bulanPaylaterRiwayat[index1]
  //                                                 ['data pembelian'][index2]
  //                                             ['tanggal_pembelian']);
  //                                     return Container(
  //                                       margin: EdgeInsets.symmetric(
  //                                           vertical: index2 % 2 == 0 ? 0 : 5),
  //                                       padding: EdgeInsets.symmetric(
  //                                           vertical: index2 % 2 == 0 ? 5 : 0),
  //                                       color: index2 % 2 == 0
  //                                           ? Colors.grey[100]
  //                                           : Colors.white,
  //                                       child: ListTile(
  //                                           title: Text(
  //                                               bulanPaylaterRiwayat[index1]
  //                                                           ['data pembelian'][
  //                                                       index2]['list_pembelian']
  //                                                   ['nama_barang'],
  //                                               style: TextStyle(
  //                                                   color: Colors.black,
  //                                                   fontWeight:
  //                                                       FontWeight.bold)),
  //                                           subtitle: Column(
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                   bulanPaylaterRiwayat[index1]
  //                                                                   [
  //                                                                   'data pembelian']
  //                                                               [index2]
  //                                                           ['list_pembelian']
  //                                                       ['nama_toko'],
  //                                                   style: TextStyle(
  //                                                       fontWeight:
  //                                                           FontWeight.w400),
  //                                                   maxLines: 1,
  //                                                   overflow:
  //                                                       TextOverflow.ellipsis),
  //                                               Text(Waktu(datetime).yMMMMd(),
  //                                                   style: TextStyle(
  //                                                       fontWeight:
  //                                                           FontWeight.w400),
  //                                                   maxLines: 1,
  //                                                   overflow:
  //                                                       TextOverflow.ellipsis),
  //                                             ],
  //                                           ),
  //                                           trailing: Text(
  //                                             rupiah(bulanPaylaterRiwayat[
  //                                                             index1]
  //                                                         ['data pembelian']
  //                                                     [index2]['list_pembelian']
  //                                                 ['harga_barang']),
  //                                             style: TextStyle(
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.bold),
  //                                           )),
  //                                     );
  //                                   }),
  //                             );
  //                           },
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //       });
  // }

  Widget listRiwayatPembelianPaylater(List riwayatSemuaPaylater) {
    DateTime datetime;
    String _tanggal;
    String _bulan;
    String _sisaWaktu;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
          itemCount: riwayatSemuaPaylater.length,
          itemBuilder: (context, index) {
            datetime = DateTime.parse(
                riwayatSemuaPaylater[index]['tanggal_pembelian']);
            _tanggal = DateFormat("d", "id_ID").format(datetime);
            _bulan =
                DateFormat("MMMM", "id_ID").format(datetime).substring(0, 3);
            _sisaWaktu = DateFormat("yyyy, HH:mm", "id_ID").format(datetime);
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("$_tanggal $_bulan $_sisaWaktu",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(
                              riwayatSemuaPaylater[index]['list_pembelian']
                                          ['nama_barang'] !=
                                      null
                                  ? 'marketplace'
                                  : riwayatSemuaPaylater[index]
                                                  ['list_pembelian']
                                              ['harga_pulsa'] !=
                                          null
                                      ? 'pulsa/pln'
                                      : riwayatSemuaPaylater[index]
                                                  ['list_pembelian']['code'] !=
                                              null
                                          ? riwayatSemuaPaylater[index]
                                              ['list_pembelian']['code']
                                          : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              // maxLines: 1,
                              // overflow: TextOverflow.ellipsis
                            )
                          ])),
                  Container(
                      child: riwayatSemuaPaylater[index]['list_pembelian']
                                  ['nama_barang'] !=
                              null
                          ? marketplace(context, index, riwayatSemuaPaylater)
                          : riwayatSemuaPaylater[index]['list_pembelian']
                                      ['harga_pulsa'] !=
                                  null
                              ? pripaid(context, index, riwayatSemuaPaylater)
                              : riwayatSemuaPaylater[index]['list_pembelian']
                                          ['code'] !=
                                      null
                                  ? postpaid(
                                      context, index, riwayatSemuaPaylater)
                                  : Container()),
                ],
              ),
            );
          }),
    );
  }

  Widget marketplace(
      context, int index, List riwayatPaylaterPerJenisTransaksi) {
    return Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
          title: Text(
              riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']
                  ['nama_barang'],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']['jumlah_barang']} x ${rupiah(riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']['harga_barang'].replaceAll('.00', ''))}')
            ],
          ),
          trailing: Text(
            rupiah((riwayatPaylaterPerJenisTransaksi[index]
                    ['nominal_transaksi'])
                .replaceAll('.000000', '')),
            style: TextStyle(
                color: Colors.orange[800], fontWeight: FontWeight.bold),
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
            'Toko : ${riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']['nama_toko']}',
            style: TextStyle(fontWeight: FontWeight.w400),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      SizedBox(height: 15)
    ]));
  }

  Widget pripaid(context, int index, List riwayatPaylaterPerJenisTransaksi) {
    return Container(
        child: Column(children: [
      ListTile(
          title: Text(
              riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']
                  ['no_hp'],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']
                      ['operator'],
                  style: TextStyle(fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          trailing: Text(
            rupiah((riwayatPaylaterPerJenisTransaksi[index]
                    ['nominal_transaksi'])
                .replaceAll('.000000', '')),
            style: TextStyle(
                color: Colors.orange[800], fontWeight: FontWeight.bold),
          )),
    ]));
  }

  Widget postpaid(context, int index, List riwayatPaylaterPerJenisTransaksi) {
    return Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
          title: Text(
              riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']
                  ['nama_pelanggan'],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'no meteran : ${riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']['no_pelanggan']}',
                  style: TextStyle(fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          trailing: Text(
            rupiah((riwayatPaylaterPerJenisTransaksi[index]
                    ['nominal_transaksi'])
                .replaceAll('.000000', '')),
            style: TextStyle(
                color: Colors.orange[800], fontWeight: FontWeight.bold),
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
            riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']['code'] ==
                    'BPJS'
                ? 'Jumlah bulan : ${int.parse(riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']['periode_bulan'])}'
                : 'Tagihan ${hitungTagihanBulan(riwayatPaylaterPerJenisTransaksi[index]['list_pembelian']['periode_bulan'])}',
            style: TextStyle(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      SizedBox(height: 15)
    ]));
  }
}

hitungTagihanBulan(String angka) {
  String angkaBulan = angka.substring(4, 6);
  String angkaTahun = angka.substring(0, 4);

  String angkaBulanKe2;
  String angkaTahunKe2;

  // angkaBulan.replaceAll("0", "");

  //debugPrint("angkaBulan = $angkaBulan --- angkaTahun = $angkaTahun");

  String finalString;

  if (angka.length > 11) {
    angkaBulanKe2 = angka.substring(11);
    angkaTahunKe2 = angka.substring(7, 11);

    finalString =
        "${getNamaBulan(int.parse(angkaBulan)).substring(0, 3)} $angkaTahun ~ ${getNamaBulan(int.parse(angkaBulanKe2)).substring(0, 3)} $angkaTahunKe2";

    //debugPrint("isi finalString:");
    //debugPrint(finalString);

    return finalString;
  } else {
    return "${getNamaBulan(int.parse(angkaBulan))} $angkaTahun";
  }
}