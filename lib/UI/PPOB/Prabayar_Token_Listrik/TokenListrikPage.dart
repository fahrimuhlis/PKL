import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Token_Listrik/Konfirmasi_Token.dart';
import 'package:Edimu/UI/Topup/topUp_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TokenListrikPage extends StatefulWidget {
  MainModel model;
  int tabIndex;
  // TokenListrikPage(this.model);

  TokenListrikPage(this.model, this.tabIndex);

  @override
  _TokenListrikPageState createState() => _TokenListrikPageState();
}

class _TokenListrikPageState extends State<TokenListrikPage>
    with SingleTickerProviderStateMixin {
  var nomorPelangganController = TextEditingController();
  //
  Map masterPricelist = {
    "data_pelanggan": {"status": 0}
  };
  List displayedPricelist = [];
  //
  String kodeItemYangDipilih = "0";
  Map itemYangDipilih;
  //
  var scrollController = ScrollController();
  TabController tabController;
  //
  //  state untuk riwaayat
  List listRiwayatPembelian = [];

  @override
  void initState() {
    //
    tabController = TabController(length: 2, vsync: this);
    getRiwayatPembelianToken();
    super.initState();
    //
    tabController.addListener(() {
      if (tabController.index != 0) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  Future getRiwayatPembelianToken() async {
    EasyLoading.show(
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
    //
    listRiwayatPembelian = await widget.model.getRiwayatTokenListrik();
    setState(() {});
    //
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.tabIndex,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Token listrik PLN"),
            centerTitle: true,
            bottom: TabBar(
              controller: tabController,
              onTap: (value) {},
              indicatorColor: Colors.white,
              tabs: [Tab(text: 'Beli'), Tab(text: 'Riwayat')],
            )),
        body: TabBarView(
            controller: tabController,
            children: [beliTokenListrik(), riwayatBeliTokenListrik()]),
      ),
    );
  }

  Widget riwayatBeliTokenListrik() {
    return RefreshIndicator(
      onRefresh: refreshRiwayat,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(9),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text("Riwayat Pembelian Token Listrik"),
              SizedBox(
                height: 15,
              ),
              ListView.builder(
                  reverse: true,
                  itemCount: listRiwayatPembelian.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String _token = listRiwayatPembelian[index]['message'] ==
                            'SUCCESS'
                        ? listRiwayatPembelian[index]['serial_number']
                        : listRiwayatPembelian[index]['message'] == 'PROCESS'
                            ? 'harap menunggu, token anda sedang diproses...'
                            : listRiwayatPembelian[index]['message'] == 'FAILED'
                                ? 'Pembelian gagal, saldo telah anda telah dikembalikan'
                                : 'system error';

                    Color _warnaStatusTransaksi = listRiwayatPembelian[index]
                                ['message'] ==
                            'SUCCESS'
                        ? Colors.green[800]
                        : listRiwayatPembelian[index]['message'] == 'PROCESS'
                            ? Colors.blue[800]
                            : listRiwayatPembelian[index]['message'] == 'FAILED'
                                ? Colors.red[700]
                                : Colors.grey;

                    return Card(
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(9, 9, 9, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat("EEEE, d MMM yyyy", "id_ID")
                                          .format(DateTime.parse(
                                              listRiwayatPembelian[index]
                                                  ['Timestamp'])),
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text("no meteran : " +
                                        listRiwayatPembelian[index]['noHp'])
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      listRiwayatPembelian[index]['message'],
                                      style: TextStyle(
                                          color: _warnaStatusTransaksi),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      rupiah(
                                          listRiwayatPembelian[index]['price']),
                                      style:
                                          TextStyle(color: Colors.orange[900]),
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                                child: Text(
                              "Token : $_token",
                              style: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            )),
                            SizedBox(
                              height: 15,
                            ),
                            tombolBeliLagi(index)
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future refreshRiwayat() async {
    listRiwayatPembelian = await widget.model.getRiwayatTokenListrik();
    //debugPrint("PPPPPPPPPPPPPP");
    setState(() {});
  }

  Widget beliTokenListrik() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   padding: EdgeInsets.symmetric(),
                //   child: TextField(
                //     style: TextStyle(fontSize: 19),
                //     decoration: InputDecoration(
                //         labelText: "Nomor Meter/ID Pelanggan",
                //         hintText: "masukkan nomor meter/ID pelanggan",
                //         labelStyle: TextStyle(fontWeight: FontWeight.bold),
                //         suffix: nomorPelangganController.text.length > 5
                //             ? Icon(
                //                 Icons.check_circle,
                //                 color: Warna.hijauMain,
                //               )
                //             : Icon(
                //                 Icons.cancel,
                //                 color: Colors.red,
                //               )),
                //     controller: nomorPelangganController,
                //     onChanged: (text) {},
                //     keyboardType: TextInputType.number,
                //   ),
                // ),
                SizedBox(
                  height: 55,
                ),
                Text(
                  "Masukkan nomor meteran/pelanggan :",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 19,
                ),
                TextField(
                  controller: nomorPelangganController,
                  autofocus: true,
                  // onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      // suffixIcon:
                      //     masterPricelist["data_pelanggan"]["status"] == "1"
                      //         ? Icon(
                      //             Icons.check_circle,
                      //             color: Colors.green[600],
                      //           )
                      //         : Container(),
                      //
                      // hintText: "Contoh : 0813xxxxxxx",
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'Nomor meteran',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blue, width: 2.0))),
                ),
                SizedBox(
                  height: 0,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    
                    child: ElevatedButton(
                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800],),
                        onPressed: () async {
                          cekPelanggan();
                        },
                        child: Text(
                          "Cek Pelanggan",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                infoPelanggan(),
                SizedBox(
                  height: 25,
                ),
                gridItem()
              ],
            ),
          ),
        ),
        tombolBeliFixed()
      ],
    );
  }

  cekPelanggan() async {
    EasyLoading.show(
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );

    masterPricelist = await widget.model
        .getPricelistTokenPLNPrepaid(nomorPelangganController.text);

    setState(() {});

    if (masterPricelist["data_pelanggan"]["status"] == "1") {
      FocusScope.of(context).unfocus();
      displayedPricelist = masterPricelist["result"];

      scrollController.animateTo(scrollController.position.pixels + 350,
          duration: Duration(milliseconds: 1701),
          curve: Curves.linearToEaseOut);
    } else {
      Alert(
          context: context,
          type: AlertType.info,
          title: "Maaf",
          desc: "Maaf, no meteran tidak ditemukan, silahkan periksa kembali",
          buttons: [
            DialogButton(
                child: Text("OK",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]).show();
    }

    EasyLoading.dismiss();
  }

  Widget gridItem() {
    if (displayedPricelist.length > 0 &&
        masterPricelist["data_pelanggan"]["status"] == "1") {
      return Column(
        children: [
          SizedBox(
            height: 17,
          ),
          Text(
            "Silahkan pilih nominal",
            style: TextStyle(fontSize: 19),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 155),
            child: GridView.builder(
                itemCount: displayedPricelist.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    //crossAxis = horizontal
                    crossAxisSpacing: 15,
                    // mainAxis = vertical
                    mainAxisSpacing: 15,
                    childAspectRatio: 2),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      //
                      kodeItemYangDipilih =
                          displayedPricelist[index]["pulsa_code"];
                      itemYangDipilih = displayedPricelist[index];
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.blue[800]),
                          borderRadius: BorderRadius.circular(7),
                          color: displayedPricelist[index]["pulsa_code"] ==
                                  kodeItemYangDipilih
                              ? Colors.blue[800]
                              : Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            rupiah(displayedPricelist[index]["pulsa_nominal"])
                                .replaceAll("Rp ", ""),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: displayedPricelist[index]
                                            ["pulsa_code"] ==
                                        kodeItemYangDipilih
                                    ? Colors.white
                                    : Colors.blue[800]),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                              rupiah(
                                  displayedPricelist[index]["harga_enduser"]),
                              style: TextStyle(
                                color: displayedPricelist[index]
                                            ["pulsa_code"] ==
                                        kodeItemYangDipilih
                                    ? Colors.white
                                    : Colors.blue[800],
                              ))
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Text(""),
        ),
      );
    }
  }

  Widget infoPelanggan() {
    String infoTegangan;
    int trimmedInfoTegangan;

    if (masterPricelist["data_pelanggan"]["status"] == "1") {
      infoTegangan = masterPricelist["data_pelanggan"]["segment_power"]
          .replaceAll("R1  /", "");
      trimmedInfoTegangan = int.parse(infoTegangan);
    }

    return Container(
      decoration: BoxDecoration(
          // border: Border.all(width: 2, color: Colors.blue[800]),
          borderRadius: BorderRadius.circular(7),
          color: Colors.amber[300]),
      child: masterPricelist["data_pelanggan"]["status"] == "1"
          ? Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(9),
              child: Column(
                children: [
                  ListTile(
                    title: Text("Nomor meteran"),
                    trailing:
                        Text(masterPricelist["data_pelanggan"]["meter_no"]),
                  ),
                  ListTile(
                    title: Text("Nama"),
                    trailing: Text(masterPricelist["data_pelanggan"]["name"]),
                  ),
                  ListTile(
                    title: Text("Tegangan"),
                    trailing: Text(trimmedInfoTegangan.toString() + " VA"),
                  )
                ],
              ),
            )
          : Container(),
    );
  }

  Widget tombolBeliFixed() {
    if (displayedPricelist.length > 0 &&
        masterPricelist["data_pelanggan"]["status"] == "1" &&
        kodeItemYangDipilih != "0") {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 61,
          child: ElevatedButton(
            // color: Colors.blue[800],
            // shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(19),
            //     topRight: Radius.circular(19))),
            onPressed: () {
              //
              if ((int.parse(widget.model.formatedBalance) <
                      itemYangDipilih["harga_enduser"]) &&
                  ((widget.model.saldoPayLaterSekarang <
                          itemYangDipilih["harga_enduser"]) ||
                      widget.model.statusPayLater == 0 ||
                      widget.model.statusPayLaterUser == 0)) {
                alertPulsaTidakCukup();
              } else {
                if (nomorPelangganController.text.length > 5 &&
                    masterPricelist["data_pelanggan"]["status"] == "1") {
                  // if (widget.model.statusPayLater == 0 ||
                  //     widget.model.statusPayLaterUser == 0) {
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) {
                  //     return KonfirmasiTokenPLNPage(
                  //         widget.model,
                  //         itemYangDipilih,
                  //         masterPricelist["data_pelanggan"],
                  //         masterPricelist['id_biaya_layanan'],
                  //         1);
                  //   }));
                  // }

                  showMetodePembayaran();
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_shopping_cart_sharp,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  "Beli",
                  style: TextStyle(fontSize: 21, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  showMetodePembayaran() {
    showModalBottomSheet(
        elevation: 5,
        enableDrag: true,
        isDismissible: true,
        // bounce: true,
        isScrollControlled: true,
        // duration: Duration(milliseconds: 350),
        context: context,
        builder: (context) => MetodePembayaran(
            widget.model,
            itemYangDipilih,
            masterPricelist["data_pelanggan"],
            masterPricelist['id_biaya_layanan']));
  }

  alertPulsaTidakCukup() {
    Alert(
        context: context,
        title: "maaf",
        type: AlertType.info,
        desc: "maaf saldo anda tidak cukup untuk melakukan pembelian",
        buttons: [
          DialogButton(
              child: Text(
                "Isi Saldo",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => topUpPage(
                            widget.model,
                          )),
                );
              })
        ]).show();
  }

  Widget tombolBeliLagi(int index) {
    return ElevatedButton(
        // height: 51,
        // minWidth: double.infinity,
        // color: Colors.blue[800],
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        onPressed: () {
          tabController.animateTo(0);
          //
          setState(() {
            nomorPelangganController.text = listRiwayatPembelian[index]['noHp'];
          });

          cekPelanggan();
        },
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Beli Lagi",
              style: TextStyle(color: Colors.white),
            )
          ],
        )));
  }
}

class MetodePembayaran extends StatefulWidget {
  MainModel model;
  Map tokenYangDipilih;
  Map dataPelanggan;
  String idBiayaLayanan;

  MetodePembayaran(this.model, this.tokenYangDipilih, this.dataPelanggan,
      this.idBiayaLayanan);

  @override
  State<MetodePembayaran> createState() => _MetodePembayaranState();
}

class _MetodePembayaranState extends State<MetodePembayaran> {
  int metodePembayaran = 0;

  List jenisPembayaran = [
    {
      'isSelected': false,
      'status': true,
      'label': 'Saldo ediMU',
      'kode': 1,
    },
    {
      'isSelected': false,
      'status': true,
      'label': 'Pay Later',
      'kode': 2,
    }
  ];

  @override
  Widget build(BuildContext context) {
    if (int.parse(widget.model.formatedBalance) <
        widget.tokenYangDipilih['harga_enduser']) {
      jenisPembayaran[0]['status'] = false;
    }
    if (widget.model.statusPayLater == 0 ||
        widget.model.statusPayLaterUser == 0 ||
        (widget.model.saldoPayLaterSekarang <
            widget.tokenYangDipilih['harga_enduser'])) {
      jenisPembayaran[1]['status'] = false;
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Pilih Metode Pembayaran",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 2,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // LayoutBuilder(
                    //   builder:
                    //       (BuildContext context, BoxConstraints constraints) {
                    //     return ToggleSwitch(
                    //       cornerRadius: 5,
                    //       minWidth: constraints.maxWidth * 0.498,
                    //       minHeight: 49,
                    //       fontSize: 15,
                    //       initialLabelIndex: metodePembayaran - 1,
                    //       activeBgColor: Colors.green,
                    //       activeFgColor: Colors.white,
                    //       inactiveBgColor: Colors.grey[200],
                    //       inactiveFgColor: Colors.grey[400],
                    //       labels: ["Saldo GENI", "Pay Later"],
                    //       // changeOnTap: true,
                    //       onToggle: (index) {
                    //         if (index == 1 &&
                    //             int.parse(widget.model.saldoPayLaterSekarang) <
                    //                 widget.tokenYangDipilih['harga_enduser']) {
                    //           Alert(
                    //                   type: AlertType.error,
                    //                   context: context,
                    //                   title: "Perhatian",
                    //                   desc:
                    //                       'Mohon maaf, saat ini Anda tidak dapat melakukan transaksi Pay Later, silahkan melakukan transaksi dengan metode pembayaran lainnya')
                    //               .show();
                    //           setState(() {
                    //             index = 0;
                    //             metodePembayaran = 1;
                    //           });
                    //         } else {
                    //           setState(() {
                    //             index = index;
                    //             metodePembayaran = index + 1;
                    //           });
                    //         }
                    //         debugPrint(
                    //             "isi metodePembayaran = $metodePembayaran");
                    //       },
                    //     );
                    //   },
                    // ),
                    // SizedBox(height: 20),
                    Container(
                      height: 205,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: jenisPembayaran.length,
                          itemBuilder: (context, index) {
                            return jenisPembayaran[index]['status'] == false
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 6, 5, 1),
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                metodePembayaran =
                                                    jenisPembayaran[index]
                                                        ['kode'];

                                                jenisPembayaran.forEach((item) {
                                                  item['isSelected'] = false;
                                                });
                                                jenisPembayaran[index]
                                                    ['isSelected'] = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: jenisPembayaran[index]
                                                            ['isSelected'] ==
                                                        true
                                                    ? Colors.blue
                                                    : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  jenisPembayaran[index]
                                                      ['label'],
                                                  style: TextStyle(
                                                      color: jenisPembayaran[
                                                                      index][
                                                                  'isSelected'] ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black54),
                                                ),
                                              ),
                                            )),
                                      ),
                                      Container(
                                        child: jenisPembayaran[index]
                                                    ['isSelected'] !=
                                                true
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 5, 10),
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.blue[100],
                                                  ),
                                                  child: metodePembayaran == 1
                                                      ? Text(
                                                          "Sisa saldo Anda ${rupiah(widget.model.formatedBalance)}",
                                                        )
                                                      : Text(
                                                          "Sisa pay later Anda ${rupiah(widget.model.saldoPayLaterSekarang)}\nBeli sekarang Bayar pada tanggal 28 akhir bulan",
                                                        ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  );
                          }),
                    ),
                    // metodePembayaran == 0
                    //     ? Container()
                    //     : Container(
                    //         margin: EdgeInsets.only(top: 2),
                    //         padding: EdgeInsets.all(15),
                    //         width: MediaQuery.of(context).size.width,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           color: Colors.green[100],
                    //         ),
                    //         child: metodePembayaran == 1
                    //             ? Text(
                    //                 "Sisa saldo Anda ${rupiah(widget.model.formatedBalance)}.",
                    //                 textAlign: TextAlign.center)
                    //             : Text(
                    //                 "Sisa pay later Anda ${rupiah(widget.model.saldoPayLaterSekarang)}.\nBeli sekarang Bayar pada tanggal 28 akhir bulan",
                    //                 textAlign: TextAlign.center),
                    //       ),
                    SizedBox(height: 30),
                    Container(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.blue[800],
                          ),
                          onPressed: () {
                            if (metodePembayaran == 0) {
                              Alert(
                                      type: AlertType.error,
                                      context: context,
                                      title: "Perhatian",
                                      desc:
                                          'Silahkan pilih metode pembayaran terlebih dahulu')
                                  .show();
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return KonfirmasiTokenPLNPage(
                                    widget.model,
                                    widget.tokenYangDipilih,
                                    widget.dataPelanggan,
                                    widget.idBiayaLayanan,
                                    metodePembayaran);
                              }));
                            }
                          },
                          child: Text(
                            "Lanjut Pembelian",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          )),
                    ),
                  ]),
            )),
      ]),
    );
  }
}
