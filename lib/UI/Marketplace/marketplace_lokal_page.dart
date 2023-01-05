import 'dart:convert';

import 'package:Edimu/UI/SubsidiMinyakGoreng/detailMinyakGoreng.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:Edimu/UI/Marketplace/bukatoko_page.dart';
import 'package:Edimu/UI/Marketplace/cart_display.dart';
import 'package:Edimu/UI/Marketplace/detailItem_page.dart';
import 'package:Edimu/UI/Marketplace/marketplace_bikinlapak_page.dart';
import 'package:Edimu/UI/Marketplace/marketplace_lapaksaya.dart';
import 'package:Edimu/UI/Marketplace/marketplace_riwayat.dart';
import 'package:Edimu/konfigurasi/KonfigurasiAplikasi.dart';
import 'package:Edimu/models/ads_model.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:Edimu/konfigurasi/api.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MarketPlace_Lokal_Page extends StatefulWidget {
  MainModel model;
  final int kategoriINIMART;
  MarketPlace_Lokal_Page(this.model, {this.kategoriINIMART = null});

  @override
  _MarketPlace_Lokal_PageState createState() => _MarketPlace_Lokal_PageState();
}

class _MarketPlace_Lokal_PageState extends State<MarketPlace_Lokal_Page> {
  List listLapak;

  // untuk getLapakLokal()
  int pageLapak = 1;
  int lastPage = 1;
  bool isGetLapakLokalOpened = true;

  int searchPageIndex = 0;
  int searchLastPage = 1;

  double jarakStackXElevatedButton = 55.0;

  TextEditingController searchText = TextEditingController();

  var bouncingController = BouncingScrollPhysics();

  ScrollController _scrollController = new ScrollController();

  var textAppBar = Text('Pasar Lokal', style: TextStyle(color: Colors.white));
  var wadahAppBar;

  bool apakahSearch = false;
  bool apakahLoading = false;
  var wadahGridview;

  bool apakahKategori = false;
  int idKategori = 0;
  String selectedNamaKategori;

  //ColorFilter untuk membedakan mana stok barang HABIS & TIDAK
  var barangAda =
      ColorFilter.mode(Color.fromRGBO(255, 255, 255, 1), BlendMode.dstIn);

  var barangKosong =
      ColorFilter.mode(Color.fromRGBO(255, 255, 255, 0.4), BlendMode.dstIn);

  var gambarBarangKosong =
      ColorFilter.mode(Color.fromRGBO(255, 255, 255, 0.4), BlendMode.dstIn);

  List dataMinyak = [];

  @override
  void initState() {
    //debugPrint(
    // "isi var apakahPunyaToko : " + widget.model.apakahPunyaToko.toString());
    listLapak = [];
    listLapak = widget.model.listLapak;
    lastPage = widget.model.lastPageMarketplace;

    setState(() {
      idKategori = widget.kategoriINIMART ?? 0;
    });

    if (idKategori == 1) {
      getDataMinyak();
    }


    super.initState();

    wadahAppBar = textAppBar;

    // =============================================
    // =============================================
    // ======= Listener paginasiManual =============
    // =============================================
    // =============================================

    _scrollController.addListener(() {
      //debugPrint('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
      if (apakahSearch) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (searchPageIndex < searchLastPage) {
            setState(() {
              wadahLoading = loadingMore;
            });
            _scrollController.animateTo(_scrollController.position.pixels + 55,
                duration: Duration(milliseconds: 2701),
                curve: Curves.linearToEaseOut);

            getSearchResult(searchPageIndex + 1, searchText.text);
          } else if (searchPageIndex == searchLastPage) {
            EasyLoading.showToast('semua barang sudah ditampilkan',
                toastPosition: EasyLoadingToastPosition.bottom,
                dismissOnTap: true);

            //debugPrint('lapak dah abis om....');
            // _scrollController.animateTo(_scrollController.position.pixels + 155,
            //     duration: Duration(milliseconds: 2701),
            //     curve: Curves.linearToEaseOut);
          }
        } else {
          // //debugPrint('ini search....');
          // //debugPrint('searchIndexPage = ${searchPageIndex.toString()}');
          // //debugPrint('searchLastPage = ${searchLastPage.toString()}');
        }
      } else if (apakahKategori) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          //debugPrint(
          // "mentok di : ${_scrollController.position.pixels.toString()}");
          //debugPrint('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
          //debugPrint('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');

          if (pageLapak < lastPage) {
            setState(() {
              wadahLoading = loadingMore;
            });
            // _scrollController.animateTo(_scrollController.position.pixels + 55,
            //     duration: Duration(milliseconds: 2701),
            //     curve: Curves.linearToEaseOut);

            getLapakPerKategori(pageLapak, idKategori);
          } else if (pageLapak == lastPage) {
            EasyLoading.showToast('semua barang sudah ditampilkan',
                toastPosition: EasyLoadingToastPosition.bottom,
                dismissOnTap: true);

            //debugPrint('lapak dah abis om....');

            // _scrollController.animateTo(_scrollController.position.pixels + 155,
            //     duration: Duration(milliseconds: 2701),
            //     curve: Curves.linearToEaseOut);
          }
        } else {
          // //debugPrint('ini KATEGORI....');
          // //debugPrint('kategoriIndexPage = ${pageLapak.toString()}');
          // //debugPrint('kategoriLastPage = ${lastPage.toString()}');
        }
      } else {
        // untuk scroll biasa (All)
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          //debugPrint(
          // "mentok di : ${_scrollController.position.pixels.toString()}");
          //debugPrint('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
          //debugPrint('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');

          if (pageLapak < lastPage && isGetLapakLokalOpened) {
            setState(() {
              wadahLoading = loadingMore;
            });

            // _scrollController.animateTo(_scrollController.position.pixels + 155,
            //     duration: Duration(milliseconds: 2701),
            //     curve: Curves.linearToEaseOut);

            getLapakLokal(pageLapak + 1);
          } else if (pageLapak == lastPage) {
            EasyLoading.showToast('semua barang sudah ditampilkan',
                toastPosition: EasyLoadingToastPosition.bottom,
                dismissOnTap: true);
            //debugPrint('lapak dah abis om....');

            // _scrollController.animateTo(_scrollController.position.pixels + 155,
            //     duration: Duration(milliseconds: 2701),
            //     curve: Curves.linearToEaseOut);
          }
        } else {
          // //debugPrint('bukan search....');
          // //debugPrint('pageLapak = ${pageLapak.toString()}');
          // //debugPrint('lastPage = ${lastPage.toString()}');
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        backgroundColor: Warna.hijauBG2,
        appBar: AppBar(
          title: Container(
            height: 39,
            padding: EdgeInsets.only(left: 15),
            color: Colors.white,
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                if (searchText.text.length > 0) {
                  setState(() {
                    listLapak = [];
                    apakahKategori = false;
                    apakahSearch = true;
                    searchPageIndex = 0;
                  });

                  getSearchResult(1, searchText.text);
                }
              },
              controller: searchText,
              // autofocus: true,
              decoration: InputDecoration(
                // suffix: Container(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Icon(Icons.clear, color: Colors.red,),
                //     SizedBox(width: 5),
                //     Text('hapus')
                //   ],
                // )),
                fillColor: Colors.white,
                hintText: "Cari barang/toko/penjual",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              onChanged: (keyword) async {
                // Future.delayed(Duration(milliseconds: 1000), () {
                //   setState(() {
                //     apakahSearch = true;
                //   });
                // });
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  if (searchText.text.length > 0) {
                    setState(() {
                      listLapak = [];
                      apakahKategori = false;
                      apakahSearch = true;
                      searchPageIndex = 0;
                    });

                    getSearchResult(1, searchText.text);
                  }
                },
              ),
            )
          ],
          backgroundColor: hijauMain,
          // centerTitle: true,
        ),
        body: bodyStack(),
        floatingActionButton: tombolCartFAB(),
      );
    });
  }

  Widget modalBottomSheet() {}

  Widget bodySliver() {
    return CustomScrollView(
      slivers: [pakeSliver()],
    );
  }

  Widget bodyHasilPencarian() {
    if (apakahLoading) {
      return Center(child: Center(child: CircularProgressIndicator()));
    } else {
      return Container(
        // height: MediaQuery.of(context).size.height - 115,
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      listLapak = widget.model.listLapak;
                      apakahSearch = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 11, top: 11),
                    child: Container(
                        child: Row(
                      children: [
                        Icon(Icons.keyboard_backspace, color: Colors.blue[800]),
                        SizedBox(width: 3),
                        Text("kembali",
                            style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                      ],
                    )),
                  ),
                )
              ],
            ),
            Container(
                child: apakahSearch ? gridviewSearchResult() : gridviewBiasa()),
            SizedBox(height: 0),
            wadahLoading
          ],
        ),
      );
    }
  }

  Widget bodyStack() {
    return Stack(
      children: [
        Container(
            child: apakahSearch ? bodyHasilPencarian() : paginasiManual()),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                // color: Colors.white,
                margin: EdgeInsets.only(bottom: 25),
                // padding: EdgeInsets.all(13),
                child: wadahLoading))
      ],
    );
  }

  Widget paginasiManual() {
    return Container(
      // height: MediaQuery.of(context).size.height - 115,
      child: ListView(
        shrinkWrap: true,
        // physics: BouncingScrollPhysics(),
        controller: _scrollController,
        children: [
          SizedBox(
            height: 11,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width - 29,
              height: 65,
              child: sliderKategori()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (widget.model.apakahPunyaToko) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BikinLapak_Page(widget.model)));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BukaTokoPage(widget.model)));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 11, left: 10),
                  child: Container(
                      child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.blue[800]),
                      SizedBox(width: 1),
                      Text("Buat Lapak",
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                    ],
                  )),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RiwayatMarketplace(widget.model)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, top: 11),
                  child: Container(
                      child: Row(
                    children: [
                      Icon(Icons.receipt, color: Colors.blue[800]),
                      SizedBox(width: 3),
                      Text("Riwayat Belanja",
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                    ],
                  )),
                ),
              )
            ],
          ),
          Container(child: gridviewBiasa()),
          SizedBox(height: 0),
          wadahLoading
        ],
      ),
    );
  }

  Widget subsidiMinyakGorengDisable(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 175, 30, 0),
      child: Text(
        "Maaf, komunitas Anda tidak menyediakan barang di kategori INI MART",
        style: TextStyle(
          color: Colors.black45,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget subsidiMinyakGoreng(context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = 125;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
          itemCount: dataMinyak.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(9, 5, 9, 5),
              child: InkWell(
                onTap: () async {
                  await Future.delayed(Duration(milliseconds: 201));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailMinyakGoreng(
                              widget.model,
                              dataMinyak[index]["Nama_Sembako"],
                              dataMinyak[index]["harga_barang"].substring(0,
                                  dataMinyak[index]["harga_barang"].length - 3),
                              dataMinyak[index]['Deskripsi_Produk'],
                              dataMinyak[index]['Satuan'],
                              TemplateAplikasi.publicDomain +
                                  dataMinyak[index]['Foto_Produk'],
                              dataMinyak[index]['id_komunitas'],
                              dataMinyak[index]['stok_barang'],
                              dataMinyak[index]['id_minyak'],
                              dataMinyak[index]['id_sembako'],
                            )),
                  );
                  // if (widget.model.nikUser != "kosong" &&
                  //     widget.model.nikUser != "" &&
                  //     widget.model.nikUser != null) {
                  //   await Future.delayed(Duration(milliseconds: 201));
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DetailMinyakGoreng(
                  //               widget.model,
                  //               dataMinyak[index]["Nama_Sembako"],
                  //               dataMinyak[index]["harga_barang"].substring(
                  //                   0,
                  //                   dataMinyak[index]["harga_barang"].length -
                  //                       3),
                  //               dataMinyak[index]['Deskripsi_Produk'],
                  //               dataMinyak[index]['Satuan'],
                  //               dataMinyak[index]['Foto_Produk'],
                  //               dataMinyak[index]['id_komunitas'],
                  //               dataMinyak[index]['stok_barang'],
                  //               dataMinyak[index]['id_minyak'],
                  //               dataMinyak[index]['id_sembako'],
                  //             )),
                  //   );
                  // } else {
                  //   Alert(
                  //       context: context,
                  //       title: "Maaf",
                  //       type: AlertType.error,
                  //       desc:
                  //           "Agar dapat melakukan pembelian sembako, Anda harus menambahkan NIK terlebih dahulu",
                  //       buttons: [
                  //         DialogButton(
                  //             child: Text(
                  //               "Tambahkan NIK",
                  //               style: TextStyle(color: Colors.white),
                  //             ),
                  //             onPressed: () {
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => TambahNIK(
                  //                             widget.model,
                  //                             pageSebelumnya:
                  //                                 "marketplace_local",
                  //                           )));
                  //             })
                  //       ]).show();
                  // }
                },
                child: Card(
                  elevation: 5,
                  semanticContainer: true,
                  color: Colors.white,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: deviceHeight,
                    width: deviceWidth,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 5,
                          //   left: 0,
                          right: 5,
                          child: Image.network(
                            TemplateAplikasi.publicDomain +
                                dataMinyak[index]['Foto_Produk'],
                            fit: BoxFit.contain,
                            // color: Colors.grey.withOpacity(0.25),
                            // width: 160,
                            height: deviceHeight - 10,
                            width: deviceWidth * 0.4,
                            alignment: Alignment.center,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: deviceHeight - 10,
                                width: deviceWidth * 0.4,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: deviceHeight,
                          width: deviceWidth * 0.5,
                          decoration: BoxDecoration(
                              // color: Colors.transparent
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                Warna.primary,
                                Colors.lightGreen.withOpacity(0.6)
                              ])),
                        ),
                        Container(
                          color: Colors.transparent,

                          height: deviceHeight,
                          width: deviceWidth * 0.5,
                          // padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dataMinyak[index]['Nama_Sembako'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      "${rupiah(dataMinyak[index]["harga_barang"].substring(0, dataMinyak[index]["harga_barang"].length - 3))}/${dataMinyak[index]["Satuan"]}",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Warna.primary,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget gridviewSearchResult() {
    return Padding(
      padding: const EdgeInsets.only(top: 11),
      child: listLapak.length == 0
          ? Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 175),
                Text('barang tidak ditemukan'),
                SizedBox(height: 7),
                InkWell(
                  onTap: () {
                    setState(() {
                      listLapak = widget.model.listLapak;
                      apakahSearch = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 11, top: 11),
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.keyboard_backspace, color: Colors.blue[800]),
                        SizedBox(width: 3),
                        Text("kembali",
                            style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                      ],
                    )),
                  ),
                ),
              ],
            ))
          : GridView.builder(
              reverse: false,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width / 520),
              padding: EdgeInsets.only(left: 5, right: 5),
              itemCount: listLapak.length,
              // controller: _scrollController,
              itemBuilder: (context, index) {
                // DateTime waktuMentah =
                //     DateTime.parse(listLapak[index]["waktu"]);
                // String waktu =
                //     Waktu(waktuMentah).format('EEEE, d MMMM y, HH:mm');

                // //debugPrint('isi var waktu adalah : $waktu');
                return cardBarang(index);
              }),
    );
  }

  Widget gridviewBiasa() {
    if (listLapak.length == 0) {
      if (apakahKategori) {
        return Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 175),
            Text('tidak ada barang di kategori $selectedNamaKategori'),
            SizedBox(height: 7),
            InkWell(
              onTap: () {
                setState(() {
                  listLapak = widget.model.listLapak;
                  apakahSearch = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 11, top: 11),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_backspace, color: Colors.blue[800]),
                    SizedBox(width: 3),
                    Text("kembali",
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)),
                  ],
                )),
              ),
            ),
          ],
        ));
      } else {
        return Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 175),
            Text('tidak ada barang di marketplace'),
            SizedBox(height: 7),
            InkWell(
              onTap: () {
                setState(() {
                  listLapak = widget.model.listLapak;
                  apakahSearch = false;
                });
              },
              child: Text("Kembali"),
            ),
          ],
        ));
      }
    } else if (listLapak.length > 0) {
      return Container(
        // height: MediaQuery.of(context).size.height - 35,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 11, 3, 5),
          child: GridView.builder(
              reverse: false,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // addAutomaticKeepAlives: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width / 520),
              padding: EdgeInsets.only(left: 5, right: 5),
              itemCount: listLapak.length,
              // controller: _scrollController,
              itemBuilder: (context, index) {
                // DateTime waktuMentah =
                //     DateTime.parse(widget.model.listLapak[index]["waktu"]);
                // String waktu = Waktu(waktuMentah).format('EEEE, d MMMM y, HH:mm');

                // //debugPrint('isi var waktu adalah : $waktu');
                return cardBarang(index);
              }),
        ),
      );
    }
  }

  Widget sliderKategori() {
    List listKategori;

    if (widget.model.idKomunitas == 15) {
      listKategori = [
        {'id': '0', 'namaKategori': 'Semua'},
        {'id': '1', 'namaKategori': 'INI MART'},
        {
          'id': '341',
          'namaKategori': 'UMKM',
        },
        {
          'id': '342',
          'namaKategori': 'Open PO',
        },
        {
          'id': '331',
          'namaKategori': 'Bahan Pokok',
        },
        {
          'id': '334',
          'namaKategori': 'Alat Sekolah',
        },
        {
          'id': '335',
          'namaKategori': 'Alat Rumah Tangga',
        },
        {
          'id': '336',
          'namaKategori': 'Makanan & Minuman',
        },
        {
          'id': '337',
          'namaKategori': 'Teknologi Informasi',
        },
        {
          'id': '340',
          'namaKategori': 'Preloved (bekas)',
        },
        {
          'id': '339',
          'namaKategori': 'Fashion',
        },
        {
          'id': '338',
          'namaKategori': 'Lainnya',
        },
      ];
    } else {
      //selain 212Mart
      listKategori = [
        {'id': '0', 'namaKategori': 'Semua'},
        {'id': '1', 'namaKategori': 'INI MART'},
        {
          'id': '341',
          'namaKategori': 'UMKM',
        },
        {
          'id': '342',
          'namaKategori': 'Open PO',
        },
        {
          'id': '331',
          'namaKategori': 'Bahan Pokok',
        },
        {
          'id': '334',
          'namaKategori': 'Alat Sekolah',
        },
        {
          'id': '335',
          'namaKategori': 'Alat Rumah Tangga',
        },
        {
          'id': '336',
          'namaKategori': 'Makanan & Minuman',
        },
        {
          'id': '337',
          'namaKategori': 'Teknologi Informasi',
        },
        {
          'id': '340',
          'namaKategori': 'Preloved (bekas)',
        },
        {
          'id': '339',
          'namaKategori': 'Fashion',
        },
        {
          'id': '338',
          'namaKategori': 'Lainnya',
        },
      ];
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: listKategori.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: index == 0
              ? EdgeInsets.only(left: 9.0)
              : index == (listKategori.length - 1)
                  ? EdgeInsets.only(right: 9.0)
                  : EdgeInsets.all(0),
          child: Card(
            color: idKategori == int.parse(listKategori[index]['id'])
                ? Colors.blue[800]
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue[800],
                  ),
                  borderRadius: BorderRadius.circular(12.0)),
              width: 121,
              child: InkWell(
                onTap: () async {
                  listLapak = [];
                  setState(() {
                    idKategori = int.parse(listKategori[index]['id']);
                  });
                  if (idKategori != 1) {
                    EasyLoading.show(
                        status: 'sedang diproses...',
                        maskType: EasyLoadingMaskType.black,
                        dismissOnTap: true);
                  }
                  idKategori == 0
                      ? apakahKategori = false
                      : apakahKategori = true;

                  if (idKategori == 0) {
                    pageLapak = 1;
                    selectedNamaKategori = null;
                    await getLapakLokal(1);
                  } else {
                    selectedNamaKategori = listKategori[index]['namaKategori'];
                    pageLapak = 1;
                    await getLapakPerKategori(1, idKategori);
                  }
                  EasyLoading.dismiss();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                  child: Center(
                      child: listKategori[index]["namaKategori"] == "UMKM"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  listKategori[index]['namaKategori'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: idKategori ==
                                            int.parse(listKategori[index]['id'])
                                        ? Colors.white
                                        : Colors.blue[800],
                                  ),
                                )
                              ],
                            )
                          : Text(
                              listKategori[index]['namaKategori'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: idKategori ==
                                        int.parse(listKategori[index]['id'])
                                    ? Colors.white
                                    : Colors.blue[800],
                              ),
                            )),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future getLapakPerKategori(int page, int idKategori) async {
    // _scrollController.animateTo(_scrollController.position.pixels + 1,
    //     duration: Duration(milliseconds: 2701), curve: Curves.linearToEaseOut);

    //debugPrint("==============================");
    //debugPrint("saatnya getLapakKategori");
    //debugPrint("==============================");

    final bodyJSON = jsonEncode({
      'nohape': widget.model.usernameUser,
      // 'password': widget.model.passwordUser,
      'idKategori': idKategori
    });

    final response = await http.post(
        UrlAPI.getLapakKategori + '?page=' + page.toString(),
        body: bodyJSON,
        headers: widget.model.headerJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      // //debugPrint('isi listLapak perkategori :');
      // //debugPrint(data.toString());

      setState(() {
        listLapak.addAll(data['data store']['data']);
        //debugPrint('listLapak.addAll sukses');
        lastPage = data['data store']['last_page'];

        wadahLoading = Container();
      });

      //debugPrint(
      // "current_page saat ini: ${data['data store']['current_page']}");
      //debugPrint("last_page saat ini: ${data['data store']['last_page']}");

      // EasyLoading.dismiss();
      if (pageLapak > 1) {
        _scrollController.animateTo(_scrollController.position.pixels + 255,
            duration: Duration(milliseconds: 2701),
            curve: Curves.linearToEaseOut);
      }

      pageLapak++;

      if (listLapak.length > 2) {
        // //debugPrint("isi kategori index ke ${listLapak.length - 2} adalah :");
        // //debugPrint(listLapak[listLapak.length - 2].toString());
      } else if (listLapak.length > 0) {
        // //debugPrint("isi kategori index ke-0 adalah :");
        // //debugPrint(listLapak[0].toString());
      }
      setState(() {});
    } else {
      //debugPrint("fungsi get  paginasi lapak belum berhasil");
    }

    // //debugPrint("listLapak terbaru ada ${listLapak.length.toString()} lapak");
  }

  Future getSearchResult(int index, String keyword) async {
    //debugPrint("saatya request searchPageIndex ke-${index.toString()}");
    if (index == 1) {
      EasyLoading.show(
          status: 'sedang diproses...',
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: true);
    }

    final bodyJSON = jsonEncode({
      'nohape': widget.model.usernameUser,
      // 'password': widget.model.passwordUser,
      'text': keyword
    });

    final response = await http.post(
        UrlAPI.cariLapak + '?page=' + index.toString(),
        body: bodyJSON,
        headers: widget.model.headerJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      // //debugPrint('isi listLapak setelah paginasi :');
      // //debugPrint(data.toString());

      setState(() {
        searchLastPage = data['data']['last_page'];
        listLapak.addAll(data['data']['data']);

        wadahLoading = Container();

        apakahLoading = false;

        searchPageIndex = searchPageIndex + 1;
      });

      EasyLoading.dismiss();

      if (index > 1) {
        _scrollController.animateTo(_scrollController.position.pixels + 455,
            duration: Duration(milliseconds: 2701),
            curve: Curves.linearToEaseOut);
      }
    } else {
      //debugPrint("fungsi get  paginasi lapak belum berhasil");
      apakahLoading = false;
    }

    // //debugPrint(
    //     "SEARCH :::current_page saat ini: ${data['data']['current_page']}");
    // //debugPrint("SEARCH :::last_page saat ini: ${searchLastPage}");
  }

  Future getLapakLokal(int page) async {
    // _scrollController.animateTo(_scrollController.position.pixels + 355,
    //     duration: Duration(milliseconds: 2701), curve: Curves.linearToEaseOut);

    //buka tutup trigger scroll agar tidak getlapak dobel2
    isGetLapakLokalOpened = false;

    final bodyJSON = jsonEncode({
      'nohape': widget.model.usernameUser,
      // 'password': widget.model.passwordUser,
    });

    final response = await http.post(
        UrlAPI.getMarketplace14juli2021 + '?page=' + page.toString(),
        body: bodyJSON,
        headers: widget.model.headerJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      // //debugPrint('isi listLapak setelah paginasi :');
      // //debugPrint(data.toString());

      // //debugPrint(
      //     "getLapakLoal :::current_page saat ini: ${data['data']['current_page']}");
      // //debugPrint(
      //     "getLapakLokal :::last_page saat ini: ${data['data']['last_page']}");

      setState(() {
        lastPage = data['data store']['last_page'];

        listLapak.addAll(data['data store']['data']);

        wadahLoading = Container();

        pageLapak++;
      });

      // //debugPrint("isi kategori index ke ${listLapak.length - 2} adalah :");
      // //debugPrint(listLapak[listLapak.length - 2].toString());

      // EasyLoading.dismiss();
      _scrollController.animateTo(_scrollController.position.pixels + 255,
          duration: Duration(milliseconds: 2701),
          curve: Curves.linearToEaseOut);

      setState(() {
        isGetLapakLokalOpened = true;
      });
    } else {
      //debugPrint("fungsi get  paginasi lapak belum berhasil");
      // pageLapak--;
    }

    //debugPrint(
    // "current lapakLokal saat ini : ${data["data store"]["current_page"]}");
  }

  Future getDataMinyak() async {
    final bodyJSON = jsonEncode({
      'id': widget.model.usernameUser,
      // 'password': widget.model.passwordUser,
    });

    EasyLoading.show(
        status: 'sedang diproses...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);

    final response = await http.post(UrlAPI.subsidiMinyak,
        body: bodyJSON, headers: widget.model.headerJSON);

    var data = json.decode(response.body);
    debugPrint(
        "====================================================== Data Minyak");
    debugPrint(data.toString());

    if (response.statusCode == 200) {
      // debugPrint('isi listLapak setelah paginasi :');
      // debugPrint(data.toString());
      setState(() {
        dataMinyak = data['data'];
      });
      debugPrint(
          "====================================================== Data Minyak lokal");
      debugPrint(data.toString());
    } else {
      debugPrint("fungsi GET data minyak subsidi belum berhasil");
      return null;
    }

    EasyLoading.dismiss();
  }

  var wadahLoading = Container();

  var loadingMore = Container(
      width: 255,
      color: Colors.grey[200],
      padding: EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 7,
          ),
          Text('Data sedang dimuat',
              style: TextStyle(fontWeight: FontWeight.w400)),
        ],
      ));

  Widget pakeSliver() {
    return SliverGrid(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return FutureBuilder(
              // future: getLapakLokalUntukSliver(1),
              builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? Image.network(
                        TemplateAplikasi.publicDomain +
                            'data_file/' +
                            snapshot.data[index]["foto_barang"],
                        fit: BoxFit.cover,
                        height: 101,
                        alignment: Alignment.center,
                        // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                        //   return Center(child: CircularProgressIndicator(),);
                        // },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      )
                    : Text('Pasar lokal kosong')
                : Center(child: Text('.....'));
          });
        }));
  }

  // tombol lihat isi CART kanan barang
  Widget tombolCartFAB() {
    return Container(
      padding: EdgeInsets.all(9),
      height: 100,
      width: 100,
      child: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.model.isiKeranjang.length.toString(),
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CartDisplayPage(widget.model)),
            );

            // kalo pake modalBottomSheet
            // showBarModalBottomSheet(
            //   elevation: 5,
            //   enableDrag: true,
            //   isDismissible: true,
            //   bounce: true,
            //   duration: Duration(milliseconds: 350),
            //   context: context,
            //   builder: (context) => CartDisplayBottomSheet(widget.model),
            // );
          }),
    );
  }

  // kok ga muncul ya?
  Widget tombolJualBarang() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: jarakStackXElevatedButton,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11)),
            ),
            // color: Colors.blue[800],
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(11))),
            onPressed: () {
              if (widget.model.apakahPunyaToko) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BikinLapak_Page(widget.model)));
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BukaTokoPage(widget.model)));
              }
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.add_business, color: Colors.white),
              SizedBox(
                width: 7,
              ),
              Text('Jual barang', style: TextStyle(color: Colors.white)),
            ])),
      ),
    );
  }

  Widget gambarBerdasarkanStok(int stok, String gambar) {
    return Container(
        child: stok < 1
            ? Container(
                height: 160,
                width: 195,
                child: Stack(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Color.fromRGBO(255, 255, 255, 0.3), BlendMode.dstIn),
                      child: Image.network(
                        TemplateAplikasi.publicDomain + 'data_file/' + gambar,
                        fit: BoxFit.fill,
                        height: 160,
                        width: 195,
                        cacheHeight: 242,
                        cacheWidth: 242,
                        alignment: Alignment.center,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                        child: Text("Habis",
                            style: TextStyle(fontSize: 35, color: Colors.red)))
                  ],
                ),
              )
            : Image.network(
                TemplateAplikasi.publicDomain + 'data_file/' + gambar,
                fit: BoxFit.fill,
                height: 160,
                width: 121,
                cacheHeight: 242,
                cacheWidth: 242,
                alignment: Alignment.center,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ));
  }

  Widget cardBarang(index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => detailItemPage(
                  widget.model,
                  listLapak[index]["nama_barang"],
                  listLapak[index]["harga_barang"].substring(
                      0, listLapak[index]["harga_barang"].length - 3),
                  listLapak[index]['id_penjual'],
                  listLapak[index]['nama_penjual'],
                  listLapak[index]["deskripsi_barang"],
                  "Umum",
                  TemplateAplikasi.publicDomain +
                      'data_file/' +
                      listLapak[index]["foto_barang"],
                  widget.model.namaKomunitas,
                  listLapak[index]["id_barang"],
                  listLapak[index]["rekening_penjual"],
                  listLapak[index]['nohape_penjual'],
                  listLapak[index]['stok_barang'],
                  '1969-07-20 20:18:04',
                  listLapak[index]['alamat_toko'],
                  listLapak[index]['nama_toko'],
                  listLapak[index]['id_toko'])),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 7,
        child: ColorFiltered(
          colorFilter:
              // listLapak[index]['stok'] < 1 ? barangKosong : barangAda,
              barangAda,
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            // height: 711,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.,
              children: <Widget>[
                gambarBerdasarkanStok(listLapak[index]['stok_barang'],
                    listLapak[index]['foto_barang']),
                // Container(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 5),
                        child: Text(
                          listLapak[index]["nama_barang"].length <= 32
                              ? listLapak[index]["nama_barang"]
                              : listLapak[index]["nama_barang"]
                                      .substring(0, 32) +
                                  '',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 3, left: 5),
                          child: Text(
                            rupiah(listLapak[index]["harga_barang"].substring(0,
                                listLapak[index]["harga_barang"].length - 3)),
                            style:
                                TextStyle(fontSize: 14, color: Colors.red[800]),
                          )),
                      // Container(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     mainAxisSize: MainAxisSize.max,
                      //     children: [
                      //       Icon(
                      //         Icons.location_on,
                      //         size: 19,
                      //       ),
                      //       Text(listLapak[index]["lokasiBarang"],
                      //           style: TextStyle(fontSize: 12))
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //jaga2 kalo error
  Widget cardBarangPunyaSearch(index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => detailItemPage(
                    widget.model,
                    listLapak[index]["nama_barang"],
                    listLapak[index]["harga_barang"].substring(
                        0, listLapak[index]["harga_barang"].length - 3),
                    listLapak[index]['id_penjual'],
                    listLapak[index]['nama_penjual'],
                    listLapak[index]["deskripsi_barang"] ??
                        "tidak ada deskripsi barang",
                    "Umum",
                    TemplateAplikasi.publicDomain +
                        'data_file/' +
                        listLapak[index]["foto_barang"],
                    widget.model.namaKomunitas,
                    listLapak[index]["id_barang"],
                    listLapak[index]["rekening_penjual"],
                    listLapak[index]['nohape_penjual'],
                    listLapak[index]['stok_barang'],
                    '1969-07-20 20:18:04',
                    listLapak[index]['alamat_toko'],
                    listLapak[index]['nama_toko'],
                    listLapak[index]['id_toko'],
                  )),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 7,
        child: ColorFiltered(
          // colorFilter: listLapak[index]['stok'] < 1
          //     ? barangKosong
          //     : barangAda,
          colorFilter: barangAda,
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            // height: 711,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.,
              children: <Widget>[
                Image.network(
                  TemplateAplikasi.publicDomain +
                      'data_file/' +
                      listLapak[index]["foto_barang"],
                  fit: BoxFit.cover,
                  height: 121,
                  width: 121,

                  cacheHeight: 242,
                  cacheWidth: 242,

                  // cacheHeight: 101,
                  // cacheWidth:
                  //     (MediaQuery.of(context).size.width * 0.45)
                  //         .round(),

                  alignment: Alignment.center,
                  // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                  //   return Center(child: CircularProgressIndicator(),);
                  // },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
                // Container(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 5),
                        child: Text(
                          listLapak[index]["nama_barang"].length <= 39
                              ? listLapak[index]["nama_barang"]
                              : listLapak[index]["nama_barang"]
                                      .substring(0, 39) +
                                  '',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 3, left: 5),
                          child: Text(
                            rupiah(listLapak[index]["harga_barang"].substring(0,
                                listLapak[index]["harga_barang"].length - 3)),
                            style:
                                TextStyle(fontSize: 12, color: Colors.red[800]),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
