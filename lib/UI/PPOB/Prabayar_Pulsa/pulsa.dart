// import 'dart:js';

import 'package:Edimu/UI/Topup/topUp_page.dart';
import 'package:Edimu/Widgets/PopupSaldoTidakCukup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Pulsa/FIXED_DetailPulsa.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Pulsa/detail_pembayaranpulsa.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:intl/intl.dart';
import 'package:Edimu/UI/PPOB/pulsa%20&%20topup.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Pulsa extends StatefulWidget {
  MainModel model;
  Pulsa(this.model);

  @override
  _PulsaState createState() => _PulsaState();
}

class _PulsaState extends State<Pulsa> {
  var nomorController = TextEditingController();
  bool pilihPulsa = true;
  bool pilihPaketData = false;
  bool saldoCukup = false;
  String klik = "";
  String no_tlpn = "";
  String operator = "Telkomsel";
  String nominalPulsa = "";
  int hargaPulsa = 0;
  String hargaPulsaString = "";
  String dataPaket = "";
  int hargaPaketData = 0;
  String hargaPaketDataString = "";
  String deskripsiPaket = "";
  int sisaSaldo = 200000;
  int amount = 0;

  //tambahan alkaff
  List masterPricelist = [];
  List displayedPricelist = [];
  List displayedPaketData = [];
  //
  String detectedOperator;
  Map itemYangDipilih = {};
  String kodeItemYangDipilih = "";
  String gambarOperator;
  //
  bool isSelectPulsa = true;

  List nilaiPulsa = [
    {"isSelected": false, "nominal": "15.000", "harga": 17000},
    {"isSelected": false, "nominal": "25.000", "harga": 27000},
    {"isSelected": false, "nominal": "30.000", "harga": 32000},
    {"isSelected": false, "nominal": "40.000", "harga": 42000},
    {"isSelected": false, "nominal": "50.000", "harga": 52000},
    {"isSelected": false, "nominal": "75.000", "harga": 77000},
    {"isSelected": false, "nominal": "100.000", "harga": 102000},
    {"isSelected": false, "nominal": "150.000", "harga": 152000},
    {"isSelected": false, "nominal": "200.000", "harga": 202000},
    {"isSelected": false, "nominal": "300.000", "harga": 302000},
    {"isSelected": false, "nominal": "500.000", "harga": 502000},
    {"isSelected": false, "nominal": "100.0000", "harga": 1002000},
    {"isSelected": false, "nominal": "150.0000", "harga": 1502000},
    {"isSelected": false, "nominal": "200.0000", "harga": 2002000},
  ];

  List nilaiPaketData = [
    {
      "isSelected": false,
      "paket": "Internet Combo 10GB",
      "deskripsi":
          "10GB Kuota Utama + 100 SMS + 100 Menit Nelpon (On Net) + 2GB VideoMax. Masa aktif 30 hari",
      "harga": 100000
    },
    {
      "isSelected": false,
      "paket": "Data 50GB",
      "deskripsi": "50GB Kuota Utama + 2GB OMG! Masa aktif 30 hari",
      "harga": 200000
    },
    {
      "isSelected": false,
      "paket": "Data 100GB",
      "deskripsi": "100GB Kuota Utama + 2GB OMG! Masa aktif 30 hari",
      "harga": 400000
    },
    {
      "isSelected": false,
      "paket": "Data 25.000",
      "deskripsi": "Data 300MB - 750MB + 1GB OMG!",
      "harga": 25000
    },
  ];

  List transaksi = [
    {"no_tlpn": "085100000001", "operator": "lib/assets/PPOB/as.png"},
    {"no_tlpn": "087800000002", "operator": "lib/assets/PPOB/xl.png"}
  ];

  // tambahan variabel
  Map<String, List> listOperator = {
    "Telkomsel": [
      "0852",
      "0853",
      "0811",
      "0812",
      "0813",
      "0821",
      "0822",
      '0851',
      "0823"
    ],
    "Indosat": ["0855", '0856', '0857', '0858', '0814', '0815', '0816'],
    "XL": ['0817', '0818', '0819', '0859', '0877', '0878'],
    'Three': ['0895', '0896', '0897', '0898', '0899'],
    'AXIS': ['0831', '0832', '0833', '0838'],
    'Smart': [
      '0881',
      '0882',
      '0883',
      '0884',
      '0885',
      '0886',
      '0887',
      '0888',
      '0889'
    ]
  };

  @override
  void initState() {
    //

    super.initState();
    getPricelist();
  }

  getPricelist() async {
    EasyLoading.show(
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );

    masterPricelist = await widget.model.getPricelistPulsaPrepaid();

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pulsa"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: ListView(children: <Widget>[
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      //color: Colors.red,
                      child: TextField(
                        style: TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                            labelText: "Nomor HP",
                            suffix: nomorController.text.length > 9
                                ? Icon(
                                    Icons.check_circle,
                                    color: Warna.primary,
                                  )
                                : Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  )),
                        controller: nomorController,
                        onChanged: (text) async {
                          // Digunakan untuk memantau text form
                          // no_tlpn = "$text";
                          await deteksiOperator();
                          setState(() {});
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      )),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () async {
                      // final PhoneContact contact =
                      //     await FlutterContactPicker.pickPhoneContact();
                      // nomorController.text = contact.phoneNumber.number;
                      deteksiOperator();
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.contacts_rounded,
                            size: 35,
                            color: Warna.primary,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "kontak",
                            style: TextStyle(color: Warna.primary),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: nomorController.text.length > 3
                      ? beli(context)
                      : transaksiTerbaru2(context)),
            ]),
          ),
          tombolBeliFixed()
          // widget Abdi
          // Container(
          //     child: saldoCukup == false || nomorController.text.length == 0
          //         ? Container()
          //         : tombolLanjut(context)),
        ]),
      ),
    );
  }

  Widget beli(context) {
    var widthGambar = MediaQuery.of(context).size.width * 0.35;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 9,
        ),
        // Container(
        //   child: Image.network(
        //     gambarOperator,
        //     cacheWidth: widthGambar.round(),
        //   ),
        // ),
        // tabMenuPaketAtauPulsa(context),
        SizedBox(
          height: 25,
        ),
        TabJenisItemFixed(),
        SizedBox(
          height: 25,
        ),
        Container(
            child:
                isSelectPulsa ? menuPulsaFixed() : menuPaketDataFixedAlkaff())
      ],
    );
  }

  Widget tombolBeliFixed() {
    if (itemYangDipilih.length > 0) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19),
                      topRight: Radius.circular(19))),
            ),
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(19),
            //         topRight: Radius.circular(19))),
            // color: Colors.blue[800],
            onPressed: () {
              // if (widget.model.statusPayLater == 0 ||
              //     widget.model.statusPayLaterUser == 0) {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     return DetailPulsaPage(
              //         widget.model, itemYangDipilih, nomorController.text, 1);
              //   }));
              // }

              if ((int.parse(widget.model.formatedBalance) <
                      itemYangDipilih["harga_enduser"]) &&
                  ((widget.model.saldoPayLaterSekarang <
                          itemYangDipilih["harga_enduser"]) ||
                      widget.model.statusPayLater == 0 ||
                      widget.model.statusPayLaterUser == 0)) {
                alertPulsaTidakCukup();
              } else {
                showMetodePembayaran();
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

  alertPulsaTidakCukup() {
    Alert(
        context: context,
        title: "Maaf",
        type: AlertType.info,
        desc: "Saldo anda tidak cukup untuk melakukan pembelian",
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
            widget.model, itemYangDipilih, nomorController.text));
  }

  Widget TabJenisItemFixed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isSelectPulsa = true;
            });
          },
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.39,
            decoration: BoxDecoration(
                color: isSelectPulsa ? Warna.primary : Colors.white,
                border: Border.all(width: 1, color: Warna.primary),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Pulsa",
                style: TextStyle(
                    color: isSelectPulsa ? Colors.white : Warna.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        InkWell(
          onTap: () {
            setState(() {
              isSelectPulsa = false;
            });
          },
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.39,
            decoration: BoxDecoration(
                color: !isSelectPulsa ? Warna.primary : Colors.white,
                border: Border.all(width: 1, color: Warna.primary),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Paket Data",
                style: TextStyle(
                    color: !isSelectPulsa ? Colors.white : Warna.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget transaksiTerbaru(context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
          width: MediaQuery.of(context).size.width * 0.85,
          child: Text("Transaksi Terbaru"),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2, color: Colors.grey),
              borderRadius: BorderRadius.circular(7)),
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          width: MediaQuery.of(context).size.width * 0.95,
          height: 70,
          child: Row(
            children: [
              Container(
                  //color: Colors.lightGreenAccent,
                  margin: EdgeInsets.fromLTRB(15, 5, 0, 5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    "085100000001",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  )),
              Container(
                //color: Colors.lightBlue,
                height: 35,
                width: MediaQuery.of(context).size.width * 0.21,
                child: Image(
                  image: AssetImage("lib/assets/PPOB/as.png"),
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2, color: Colors.grey),
              borderRadius: BorderRadius.circular(7)),
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          width: MediaQuery.of(context).size.width * 0.95,
          height: 70,
          child: Row(
            children: [
              Container(
                  //color: Colors.lightGreenAccent,
                  margin: EdgeInsets.fromLTRB(15, 5, 0, 5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    "087800000002",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  )),
              Container(
                //color: Colors.lightBlue,
                // width: MediaQuery.of(context).size.width * 0.21,
                // height: 30,
                child: Image(
                  image: AssetImage("lib/assets/PPOB/xl.png"),
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget transaksiTerbaru2(context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Text("Transaksi Terbaru"),
      ),
      // ListView.builder(
      //     shrinkWrap: true,
      //     itemCount: transaksi.length,
      //     itemBuilder: (context, index) {
      //       return Container(
      //         margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      //         width: MediaQuery.of(context).size.width,
      //         height: 70,
      //         decoration: BoxDecoration(
      //             border: Border.all(width: 2, color: Colors.grey),
      //             borderRadius: BorderRadius.circular(7),
      //             color: Colors.white),
      //         child: Material(
      //           borderRadius: BorderRadius.circular(7),
      //           color: Colors.transparent,
      //           child: InkWell(
      //             borderRadius: BorderRadius.circular(7),
      //             onTap: () {},
      //             child: Row(
      //               children: [
      //                 Container(
      //                   width: MediaQuery.of(context).size.width * 0.65,
      //                   height: 35,
      //                   //color: Colors.amber,
      //                   padding: EdgeInsets.fromLTRB(20, 7, 0, 0),
      //                   child: Text(
      //                     transaksi[index]["no_tlpn"],
      //                     textAlign: TextAlign.left,
      //                     style: TextStyle(
      //                         fontSize: 20,
      //                         color: Colors.black,
      //                         fontWeight: FontWeight.w700),
      //                   ),
      //                 ),
      //                 Container(
      //                     //color: Colors.lightBlue,
      //                     height: 35,
      //                     width: MediaQuery.of(context).size.width * 0.19,
      //                     child: Image(
      //                       image: AssetImage(transaksi[index]["operator"]),
      //                       fit: BoxFit.contain,
      //                     ))
      //               ],
      //             ),
      //           ),
      //         ),
      //       );
      //     })
    ]);
  }

  Widget tabMenuPaketAtauPulsa(context) {
    //=============================== Button =============================
    return Container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 7, 0, 10),
              width: MediaQuery.of(context).size.width * 0.4,
              height: 35,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: pilihPulsa == true ? Colors.green : Colors.grey),
                  borderRadius: BorderRadius.circular(7),
                  color: pilihPulsa == true ? Colors.green : Colors.white),
              child: Material(
                borderRadius: BorderRadius.circular(7),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(7),
                  onTap: () {
                    pilihPulsa = true;
                    pilihPaketData = false;

                    setState(() {});
                  },
                  child: Center(
                      child: Text("Pulsa",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: pilihPulsa == true
                                  ? Colors.white
                                  : Colors.black))),
                ),
              ),
            ),
            // Container(width: 15),
            // Container(
            //   margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
            //   width: MediaQuery.of(context).size.width * 0.4,
            //   height: 35,
            //   decoration: BoxDecoration(
            //       border: Border.all(
            //           width: 2,
            //           color:
            //               pilihPaketData == true ? Colors.green : Colors.grey),
            //       borderRadius: BorderRadius.circular(7),
            //       color: pilihPaketData == true ? Colors.green : Colors.white),
            //   child: Material(
            //     borderRadius: BorderRadius.circular(7),
            //     color: Colors.transparent,
            //     child: InkWell(
            //       highlightColor: Colors.lightGreen,
            //       borderRadius: BorderRadius.circular(7),
            //       onTap: () {
            //         pilihPulsa = false;
            //         pilihPaketData = true;

            //         setState(() {});
            //       },
            //       child: Center(
            //           child: Text("Paket Data",
            //               style: TextStyle(
            //                   fontWeight: FontWeight.w700,
            //                   color: pilihPaketData == true
            //                       ? Colors.white
            //                       : Colors.black))),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    ));

//=============================== Menu Pulsa ============================
  }

  Widget paketData(context) {
    return Container(
        //color: Colors.amber,
        child: Column(children: [
      Container(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 140,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 40,
                    //color: Colors.amber,
                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Text(
                      "Internet Combo 10GB",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    //color: Colors.red,
                    padding: EdgeInsets.fromLTRB(15, 20, 0, 10),
                    child: Text(
                      "10GB Kuota Utama + 100 SMS + 100 Menit Nelpon (On Net) + 2GB VideoMax. Masa aktif 30 hari",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 35,
                          //color: Colors.amber,
                          padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Text(
                            "Rp. 100.000",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.39,
                          height: 35,
                          //color: Colors.red,
                          padding: EdgeInsets.fromLTRB(0, 10, 15, 0),
                          child: Text(
                            "Lihat Detail",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
        ),
      ),
    ]));
  }

  Widget paketDataFixed(context) {
    return Column(
      children: [
        Container(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: nilaiPaketData.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.075,
                      10,
                      MediaQuery.of(context).size.width * 0.075,
                      10),
                  width: MediaQuery.of(context).size.width,
                  height: 135,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: nilaiPaketData[index]["isSelected"] == true
                              ? Colors.green
                              : Colors.grey),
                      borderRadius: BorderRadius.circular(7),
                      color: nilaiPaketData[index]["isSelected"] == true
                          ? Colors.lightGreenAccent[100]
                          : Colors.white),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        // Caranya Mas Al-Kaff
                        nilaiPaketData.forEach((item) {
                          item["isSelected"] = false;
                        });
                        klik = nilaiPaketData[index]["paket"];
                        nilaiPaketData[index]["isSelected"] = true;
                        dataPaket = nilaiPaketData[index]["paket"];
                        deskripsiPaket = nilaiPaketData[index]["deskripsi"];
                        hargaPaketData = nilaiPaketData[index]["harga"];
                        hargaPaketDataString = NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(hargaPaketData);
                        // Menonaktifkan Pulsa
                        nominalPulsa = "";
                        hargaPulsa = 0;
                        if (sisaSaldo >= hargaPaketData) {
                          saldoCukup = true;
                        } else {
                          Alert(
                                  context: context,
                                  title: "",
                                  content: Column(children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Saldo tidak Mencukupi",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Silahkan isi saldo anda terlebih dahulu",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    )
                                  ]),
                                  // title: "Saldo tidak Mencukupi",
                                  // desc:
                                  //     "Silahkan isi saldo anda terlebih dahulu",
                                  type: AlertType.error)
                              .show();
                          saldoCukup = false;
                        }
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 40,
                              //color: Colors.amber,
                              padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                              child: Text(nilaiPaketData[index]["paket"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ))),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            //color: Colors.red,
                            padding: EdgeInsets.fromLTRB(10, 17, 15, 5),
                            child: Text(
                              nilaiPaketData[index]["deskripsi"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.62,
                                  height: 35,
                                  //color: Colors.amber,
                                  padding: EdgeInsets.fromLTRB(22, 5, 0, 0),
                                  child: Text(
                                    NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 0)
                                        .format(nilaiPaketData[index]["harga"]),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: 35,
                                    //color: Colors.red,
                                    margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                                    child: ElevatedButton(
                                        child: Text("Lihat Detail",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.blue[900],
                                                fontWeight: FontWeight.w700)),
                                        onPressed: () {
                                          Alert(
                                            context: context,
                                            title: "",
                                            // title:
                                            //     nilaiPaketData[index]["paket"],
                                            // desc:
                                            //     nilaiPaketData[index]["deskripsi"],
                                            content: Column(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      nilaiPaketData[index]
                                                          ["paket"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    nilaiPaketData[index]
                                                        ["deskripsi"],
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    NumberFormat.currency(
                                                            locale: 'id',
                                                            symbol: 'Rp ',
                                                            decimalDigits: 0)
                                                        .format(nilaiPaketData[
                                                            index]["harga"]),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.lightGreen,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ).show();
                                        })
                                    // Text(
                                    //   "Lihat Detail",
                                    //   textAlign: TextAlign.right,
                                    //   style: TextStyle(
                                    //       fontSize: 15,
                                    //       color: Colors.blue[900],
                                    //       fontWeight: FontWeight.w700),
                                    // ),
                                    )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Container(height: 80)
      ],
    );
  }

  Widget Pulsa(context) {
    return Container(
      //color: Colors.amber,
      child: Column(children: [
        Container(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "15.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "25.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "30.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "40.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width * 0.1,
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "50.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "75.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width * 0.1,
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "100.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "150.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "200.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "300.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "500.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width * 0.375,
                height: 60,
                child: Center(
                  child: Text(
                    "1000.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
              )
            ],
          ),
        )
      ]),
    );
  }

  Widget Pulsa2(context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: nilaiPulsa.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
                10, MediaQuery.of(context).size.width * 0.1, 10),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: klik == nilaiPulsa[index]["nominal"]
                        ? Colors.green
                        : Colors.grey),
                borderRadius: BorderRadius.circular(5),
                color: klik == nilaiPulsa[index]["nominal"]
                    ? Colors.lightGreenAccent[100]
                    : Colors.white),
            child: Material(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.lightGreen,
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  setState(() {
                    // Caranya Fauzan
                    klik = nilaiPulsa[index]["nominal"];
                  });
                },
                child: Center(
                    child: Text(nilaiPulsa[index]["nominal"],
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black))),
              ),
            ),
          );
        });
  }

  Widget menuPulsaFixed() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 55),
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
            String nominalPulsa = displayedPricelist[index]['pulsa_nominal'];

            String convertedNominalPulsa = nominalPulsa.length < 7
                ? nominalPulsa.substring(0, nominalPulsa.length - 3) + " ribu"
                : nominalPulsa.length < 8
                    ? nominalPulsa.replaceAll("000000", " juta")
                    : "";

            if (displayedPricelist[index]["pulsa_op"] == detectedOperator) {
              return InkWell(
                onTap: () {
                  kodeItemYangDipilih = displayedPricelist[index]['pulsa_code'];
                  itemYangDipilih = displayedPricelist[index];
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blue[800]),
                      borderRadius: BorderRadius.circular(7),
                      color: displayedPricelist[index]['pulsa_code'] ==
                              kodeItemYangDipilih
                          ? Colors.blue[800]
                          : Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        convertedNominalPulsa,
                        style: TextStyle(
                            color: displayedPricelist[index]['pulsa_code'] !=
                                    kodeItemYangDipilih
                                ? Colors.blue[800]
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: displayedPricelist[index]
                                            ['pulsa_code'] !=
                                        kodeItemYangDipilih
                                    ? Colors.blue[800]
                                    : Colors.white,
                              ),
                              children: [
                            TextSpan(
                              text: "harga : ",
                            ),
                            TextSpan(
                                text: rupiah(
                                    displayedPricelist[index]["harga_enduser"]),
                                style: TextStyle(
                                    color: displayedPricelist[index]
                                                ['pulsa_code'] !=
                                            kodeItemYangDipilih
                                        ? Colors.orange[900]
                                        : Colors.white,
                                    fontWeight: FontWeight.w800))
                          ])),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget menuPaketDataFixedAlkaff() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 55),
      child: ListView.builder(
          itemCount: displayedPaketData.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            String nominalPulsa = displayedPaketData[index]['pulsa_nominal'];

            if (displayedPaketData[index]["pulsa_op"] == detectedOperator) {
              return InkWell(
                onTap: () {
                  kodeItemYangDipilih = displayedPaketData[index]['pulsa_code'];
                  itemYangDipilih = displayedPaketData[index];
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blue[800]),
                      borderRadius: BorderRadius.circular(7),
                      color: displayedPaketData[index]['pulsa_code'] ==
                              kodeItemYangDipilih
                          ? Colors.blue[800]
                          : Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nominalPulsa,
                        style: TextStyle(
                            color: displayedPaketData[index]['pulsa_code'] !=
                                    kodeItemYangDipilih
                                ? Colors.blue[800]
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(rupiah(displayedPaketData[index]["harga_enduser"]),
                          style: TextStyle(
                              color: displayedPaketData[index]['pulsa_code'] !=
                                      kodeItemYangDipilih
                                  ? Colors.orange[900]
                                  : Colors.white,
                              fontWeight: FontWeight.w800))
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget menuPulsaAbdi(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          //margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: MediaQuery.of(context).size.width * 0.85,
          child: GridView.builder(
              itemCount: nilaiPulsa.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  //SliverGridDelegateWithMaxCrossAxisExtent
                  maxCrossAxisExtent: 300,
                  //SliverGridDelegateWithFixedCrossAxisCount
                  //crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 3.3),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: klik == nilaiPulsa[index]["nominal"]
                              ? Colors.green
                              : Colors.grey),
                      borderRadius: BorderRadius.circular(7),
                      color: klik == nilaiPulsa[index]["nominal"]
                          ? Colors.lightGreenAccent[100]
                          : Colors.white),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        setState(() {
                          // Caranya Fauzan
                          klik = nilaiPulsa[index]["nominal"];
                          nilaiPulsa[index]["isSelected"] = true;
                          // Mengambil nilai Variabel nominalPulsa dan hargaPulsa
                          nominalPulsa = nilaiPulsa[index]["nominal"];
                          hargaPulsa = nilaiPulsa[index]["harga"];
                          hargaPulsaString = NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                              .format(hargaPulsa);
                          // Menonaktifkan Paket Data
                          dataPaket = "";
                          hargaPaketData = 0;
                          deskripsiPaket = "";
                          if (sisaSaldo >= hargaPulsa) {
                            saldoCukup = true;
                          } else {
                            Alert(
                                    context: context,
                                    title: "Saldo tidak Mencukupi",
                                    desc:
                                        "Silahkan isi saldo anda terlebih dahulu",
                                    type: AlertType.error)
                                .show();
                            saldoCukup = false;
                          }
                        });
                      },
                      child: Center(
                          child: Text(nilaiPulsa[index]["nominal"].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.black))),
                    ),
                  ),
                );
              }),
        ),
        Container(height: 80),
      ],
    );
  }

  Widget tombolLanjut(context) {
    if (itemYangDipilih.length > 0) {
      return Align(
          alignment: Alignment(0, 1),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
                color: Colors.white),
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 55,
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DetailPembayaran(
                            no_tlpn,
                            operator,
                            nominalPulsa,
                            hargaPulsaString,
                            dataPaket,
                            deskripsiPaket,
                            hargaPaketDataString,
                          );
                        }));
                      },
                      child: Center(
                          child: Text("Lanjut",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          ));
    } else {
      return Container();
    }
  }

  deteksiOperator() {
    setState(() {
      displayedPricelist = [];
    });

    if (nomorController.text.length > 3) {
      listOperator.forEach((key, value) {
        value.forEach((angkaPrefix) {
          if (nomorController.text.substring(0, 4) == angkaPrefix) {
            //debugPrint("ini adalah nomor = {$key}");
            detectedOperator = key;
          }
        });
      });
    }
    //
    //
    //

    setState(() {
      displayedPricelist = masterPricelist
          .where((item) =>
              item["pulsa_op"] == detectedOperator &&
              item['pulsa_nominal'].length < 9 &&
              isNumeric(item["pulsa_nominal"]))
          .toList();

      displayedPaketData = masterPricelist
          .where((item) =>
              item["pulsa_op"] == detectedOperator &&
              !isNumeric(item["pulsa_nominal"]))
          .toList();
    });

    // ================ DEBUG AREA ============================
    // List debugMasterPricelist = masterPricelist
    //     .where((item) => item["pulsa_op"] == detectedOperator)
    //     .toList();
    // //debugPrint("isi masterpricelist :");
    // //debugPrint(debugMasterPricelist.toString());
    // ========================================================

    displayedPricelist.forEach((item2) {
      if (item2['pulsa_op'] == "Telkomsel") {
        gambarOperator =
            "https://cdn-2.tstatic.net/tribunnews/foto/bank/images/internet-telkomsel-mati.jpg";
      } else {
        gambarOperator = displayedPricelist[0]['icon_url'];
      }
    });

    displayedPricelist
        .sort((a, b) => (a["pulsa_price"].compareTo(b["pulsa_price"])));

    displayedPaketData
        .sort((a, b) => (a["pulsa_price"].compareTo(b["pulsa_price"])));
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

class MetodePembayaran extends StatefulWidget {
  MainModel model;
  Map itemYangDipilih;
  String nomorPengisian;

  MetodePembayaran(
    this.model,
    this.itemYangDipilih,
    this.nomorPengisian,
  );

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
        widget.itemYangDipilih['harga_enduser']) {
      jenisPembayaran[0]['status'] = false;
    }
    if (widget.model.statusPayLater == 0 ||
        widget.model.statusPayLaterUser == 0 ||
        (widget.model.saldoPayLaterSekarang <
            widget.itemYangDipilih['harga_enduser'])) {
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
                    //                 widget.itemYangDipilih['harga_enduser']) {
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
                              debugPrint(
                                  "isi metodePembayaran = $metodePembayaran");
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailPulsaPage(
                                    widget.model,
                                    widget.itemYangDipilih,
                                    widget.nomorPengisian,
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
