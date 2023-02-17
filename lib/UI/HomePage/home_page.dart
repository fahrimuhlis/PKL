import 'package:Edimu/UI/PembayaranSekolah/BayarSPP_Page_Feb2022.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:Edimu/UI/BottomNavBar/BARU_BottomNavBar.dart';
import 'package:Edimu/UI/BottomNavBar/bottomNavBar.dart';
import 'package:Edimu/UI/Marketplace/Lapakku.dart';
import 'package:Edimu/UI/PPOB/Tagihan.dart';
import 'package:Edimu/UI/PPOB/pulsa%20&%20topup.dart';
import 'package:Edimu/UI/HomePage/Profile_ABImart.dart';
import 'package:Edimu/UI/PembayaranSekolah/bayarspp_page.dart';
import 'package:Edimu/UI/Marketplace/bukatoko_page.dart';
import 'package:Edimu/UI/Marketplace/marketplace_komunitas.dart';
import 'package:Edimu/UI/Marketplace/marketplace_bikinlapak_page.dart';
import 'package:Edimu/UI/Marketplace/paylater_page.dart';
import 'package:Edimu/UI/Merchant/merchant_page.dart';
import 'package:Edimu/UI/TarikTunai/tarik_tunai.dart';
import 'package:Edimu/UI/Topup/topUp_page.dart';
import 'package:Edimu/UI/Marketplace/marketplace_komoditas_page.dart';
import 'package:Edimu/UI/Marketplace/marketplace_lokal_page.dart';
import 'package:Edimu/UI/Transfer/transfer_page.dart';
import 'package:Edimu/konfigurasi/KonfigurasiAplikasi.dart';
import 'package:Edimu/models/ads_model.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../Marketplace/detailItem_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class homePage extends StatefulWidget {
  final MainModel model;

  homePage(this.model);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  // widget.model.getSaldo;
  List listBarang_Pangan;
  List listLapak;
  //
  double tinggiTombolIcon = 99;
  double lebarTombolIcon = 99;

  int _current = 0;
  final CarouselController _controller = CarouselController();

  List penampungImageSlider = [
    {
      'judul': 'Minyak Goreng Bersubsidi',
      'image': 'lib/assets/minyakgoreng.PNG',
    },
    {
      'judul': 'Sembako Murah',
      'image': 'lib/assets/sembako.png',
    }
  ];
  List<Widget> listImageSlider = [];

  Widget boxperSlide;

  @override
  void initState() {
    listLapak = widget.model.listLapak;
    //   widget.model.getContacts();
    //   widget.model.getHistoryTransaction();
    //   widget.model.getAds();
    // widget.model.shalat();
    //   //widget.model.getListHistory();
    //   //widget.model.getHistoryTransaction();
    //   widget.model.getBalanceRp();
    //   widget.model.getBalanceEmas();
    //   widget.model.getBalanceSpp();
    widget.model.getTagihanSekolah();

    super.initState();
  }

  Future _refresh() async {
    await widget.model.refreshApi();
    await widget.model.getTagihanSekolah();
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1001));
    // setState(() {
    //   // listLapak = widget.model.listLapak;
    // });
  }

  Widget iconContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: <Widget>[
          Container(
            // margin: EdgeInsets.only(left: 13, right: 13),
            margin: EdgeInsets.symmetric(horizontal: 5),
            // Deretan Icon baris ke-1
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  iconTarikTunai(),
                  iconTopup(),
                  iconTransfer(),
                ]
//
                ),
          ),
          //
          SizedBox(
            height: 5,
          ),
          //
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    child: Container(
                      height: tinggiTombolIcon,
                      width: lebarTombolIcon,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            //Image.asset('assets/transfer.png'),
                            Image.asset(
                              AsetLokal.icon_fitur4,
                              width: 50,
                              height: 50,
                            ),
                            // Icon(Icons.send),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              Teks.fitur4,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PulsaDanPLN(widget.model)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    child: Container(
                        height: tinggiTombolIcon,
                        width: lebarTombolIcon,
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            //Image.asset('assets/transfer.png'),
                            Image.asset(
                              AsetLokal.icon_fitur5,
                              width: 50,
                              height: 50,
                            ),
                            // Icon(Icons.send),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              Teks.fitur5,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ))),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PulsaDanPLN(widget.model)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    child: Container(
                        height: tinggiTombolIcon,
                        width: lebarTombolIcon,
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            //Image.asset('assets/transfer.png'),
                            Image.asset(
                              AsetLokal.icon_fitur6,
                              width: 50,
                              height: 50,
                            ),
                            // Icon(Icons.send),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              Teks.fitur6,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ))),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuTagihan(widget.model)));
                    },
                  ),
                ),
              ],
            ),
          ),
          // jarak antara saf icon 2 & 3
          SizedBox(
            height: 5,
          ),
          //
          // icon saf ke-3
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    child: Container(
                        // color: Colors.green,
                        height: tinggiTombolIcon,
                        width: lebarTombolIcon,
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            //Image.asset('assets/transfer.png'),
                            Image.asset(
                              AsetLokal.icon_fitur7,
                              width: 50,
                              height: 50,
                            ),
                            // Icon(Icons.send),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              Teks.fitur7,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ))),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MarketPlace_Lokal_Page(widget.model)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    child: Container(
                        height: tinggiTombolIcon,
                        width: lebarTombolIcon,
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            //Image.asset('assets/transfer.png'),
                            Image.asset(
                              AsetLokal.icon_fitur8,
                              width: 50,
                              height: 50,
                            ),
                            // Icon(Icons.send),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              Teks.fitur8,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ))),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                marketPlacePage(widget.model)),
                      );
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(0),
                //   child: GestureDetector(
                //     child: Container(
                //       // color: Colors.amber,
                //         height: tinggiTombolIcon,
                //         width: lebarTombolIcon,
                //         child: Center(
                //             child: Column(
                //           children: <Widget>[
                //             //Image.asset('assets/transfer.png'),
                //             Image.asset(
                //               "lib/assets/zakat/zis.png",
                //               width: 50,
                //               height: 50,
                //             ),
                //             // Icon(Icons.send),
                //             SizedBox(
                //               height: 4,
                //             ),
                //             Text(
                //               'Lazismu & Iuran',
                //               style: TextStyle(fontSize: 14),
                //             ),
                //             Text(
                //               'Muhammadiyah',
                //               style: TextStyle(fontSize: 14),
                //             ),
                //           ],
                //         ))),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => MenuZakatPage(widget.model)),
                //       );
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    child: Container(
                        height: tinggiTombolIcon,
                        width: lebarTombolIcon,
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            //Image.asset('assets/transfer.png'),
                            Image.asset(
                              AsetLokal.icon_fitur9,
                              width: 50,
                              height: 50,
                            ),
                            // Icon(Icons.send),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              Teks.fitur9,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ))),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  marketPlacePage(widget.model)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget iconTransfer() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
        child: Container(
            width: lebarTombolIcon,
            height: tinggiTombolIcon,
            child: Center(
                child: Column(
              children: <Widget>[
                //Image.asset('assets/transfer.png'),
                Image.asset(
                  AsetLokal.icon_fitur3,
                  width: 50,
                  height: 50,
                ),
                // Icon(Icons.send),
                SizedBox(
                  height: 4,
                ),
                Text(
                  Teks.fitur3,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ))),
        onTap: () {
          if (widget.model.sudahVerifikasi) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => transferPage(widget.model)),
            );
          } else {
            popupSilahkanVerif();
          }
        },
      ),
    );
  }

  Widget iconTopup() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
        child: Container(
            width: lebarTombolIcon,
            height: tinggiTombolIcon,
            child: Center(
                child: Column(
              children: <Widget>[
                //Image.asset('assets/send.png'),
                //Icon(Icons.attach_money),
                Image.asset(
                  AsetLokal.icon_fitur2,
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  Teks.fitur2,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ))),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => topUpPage(widget.model)),
          );
        },
      ),
    );
  }

  Widget iconScanner() {
    //engga kepake
    if (widget.model.idAktor == 4) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: GestureDetector(
          child: Column(
            children: <Widget>[
              //Image.asset('assets/send.png'),
              //Icon(Icons.attach_money),
              Icon(
                Icons.qr_code_scanner_sharp,
                size: 35,
                color: Colors.red,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Scan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                'QR Code',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MerchantPage(widget.model)),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget iconFitur(
      String namaFile, String namaFiturBaris1, String namaFiturBaris2) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
        child: Container(
            width: lebarTombolIcon,
            height: tinggiTombolIcon,
            child: Center(
                child: Column(
              children: <Widget>[
                //Image.asset('assets/transfer.png'),
                Image.asset(
                  namaFile,
                  width: 50,
                  height: 50,
                ),
                // Icon(Icons.send),
                SizedBox(
                  height: 4,
                ),
                Text(
                  namaFiturBaris1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  namaFiturBaris2,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            ))),
        onTap: () {
          if (widget.model.sudahVerifikasi) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TarikTunai(widget.model)),
            );
          } else {
            popupSilahkanVerif();
          }
        },
      ),
    );
  }

  Widget iconTarikTunai() {
    // debugPrint("isi idKomunitas adalah :");
    // debugPrint(widget.model.idKomunitas.toString());
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
        child: Container(
          width: lebarTombolIcon,
          height: tinggiTombolIcon,
          child: Center(
            child: Column(
              children: <Widget>[
                //Image.asset('assets/transfer.png'),
                Image.asset(
                  AsetLokal.icon_fitur1,
                  width: 50,
                  height: 50,
                ),
                // Icon(Icons.send),
                SizedBox(
                  height: 4,
                ),
                Text(
                  Teks.fitur1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (widget.model.sudahVerifikasi) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TarikTunai(widget.model)),
            );
          } else {
            popupSilahkanVerif();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => Scaffold(
        bottomNavigationBar: bottomNavBar(0, model),
        appBar: AppBar(
          backgroundColor: Warna.primary,
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.only(top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  maxRadius: 45,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'lib/assets/logo_tanpa_label.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                // SizedBox(
                //   width: 7,
                // ),
                // Text(TemplateAplikasi.namaApp,
                //     style: TextStyle(color: Colors.white))
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: Warna.bgGradient(Warna.warnaHome),
              child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  // physics: BouncingScrollPhysics(),
//          mainAxisAlignment: MainAxisAlignment.start,
//          crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    peringatanVerifikasi(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Selamat Datang ",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            widget.model.nama,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                // color: WarnaPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Warna.primary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                      widget.model.namaKomunitas,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // color: WarnaPrimary,

                          fontWeight: FontWeight.w800,
                          color: Colors.grey[600]),
                    )),

                    boxSaldo(model),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                        child: widget.model.statusPayLater == 0
                            ? Container(
                                height: 6,
                              )
                            : widget.model.statusPayLaterUser == 0
                                ? Container(
                                    height: 6,
                                  )
                                : boxPayLater(context)),
                    widget.model.isMinyak == "true"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 10,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey[100]),
                              boxPromoIklan(context),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  height: 10,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey[100]),
                            ],
                          )
                        : Container(),

                    SizedBox(
                      height: 20,
                    ),
                    iconContainer(),
                    SizedBox(
                      height: 19,
                    ),
                    boxTagihanSekolah(model),
                    SizedBox(
                      height: 35,
                    ),
                    showcase(),
                    SizedBox(
                      height: 35,
                    ),
                    tombolJualBarang(),
                    SizedBox(
                      height: 19,
                    ),
                    tombolQRScanner(),
                    SizedBox(
                      height: 19,
                    ),
                    //Text("barang terbaru"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tombolJualBarang() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Container(
            height: 51,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                backgroundColor: Colors.blueGrey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart_sharp,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Lihat Barang Jualan Saya",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                if (widget.model.sudahVerifikasi) {
                  if (widget.model.apakahPunyaToko) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Lapakku(widget.model)));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BukaTokoPage(widget.model)));
                  }
                } else {
                  popupSilahkanVerif();
                }
              },
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            height: 51,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                backgroundColor: Colors.blue[800],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_business,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Jual Barang",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                if (widget.model.sudahVerifikasi) {
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
                } else {
                  popupSilahkanVerif();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget boxSaldo(model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 19, 15, 0),
      child: Container(
        width: 301,
        height: 57,
        decoration: BoxDecoration(
            //  color: WarnaPrimary,
            color: Warna.primary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(11))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image.asset('assets/pembayaran.png'),

            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    'Saldo',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      rupiah(model.formatedBalance),
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget boxPayLater(context) {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 11),
        padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
        width: 300,
        decoration: BoxDecoration(
            color: Colors.orange[800],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payment,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Pay Later :  ",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    rupiah(widget.model.saldoPayLaterSekarang),
                    style: TextStyle(fontSize: 19, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: PayLater(widget.model),
                    duration: Duration(milliseconds: 400),
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => PayLater(widget.model)),
                // );
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 3, 5, 3),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          bottomLeft: Radius.circular(7))),
                  child: Row(
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      )
                    ],
                  )),
            )
          ],
        ));
  }

  Widget tombolQRScanner() {
    if (widget.model.idAktor == 4) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          height: 51,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              backgroundColor: Colors.blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_scanner_outlined,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  "Scan QR-Code",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           MarketPlace_Lokal_Page(widget.model)),
              // );

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MerchantPage(widget.model)));
            },
          ),
        ),
      );
    } else {
      return Container(
        height: 15,
      );
    }
  }

  Widget peringatanVerifikasi() {
    if (!widget.model.sudahVerifikasi) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 11, vertical: 3),
          height: 71,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 151,
                child: Text('Silahkan VERIFIKASI akun anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              ),
              Container(
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                  ),
                  child: Row(
                    children: [
                      Image.asset('lib/assets/whatsapp.png', width: 25),
                      SizedBox(width: 5),
                      Text('Verifikasi', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  onPressed: () async {
                    showRequestVerifikasi();
                  },
                ),
              )
            ],
          ));
    } else {
      return Container();
    }
  }

  Widget showcase() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      if (widget.model.listLapak.length <= 0) {
        return Center(
          child: Container(
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width - 85,
              height: 125,
              child: Center(
                  child: Text(
                "komunitas ini belum memiliki lapak.",
                textAlign: TextAlign.center,
              ))),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(' Barang Terbaru',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 7),
              Container(
                height: 271,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.model.listLapak.length < 5
                        ? widget.model.listLapak.length
                        : 5,
                    //itemCount: widget.model.listAdss.adsLists.length
                    itemBuilder: (context, index) {
                      // DateTime waktuMentah = DateTime.parse(
                      //     widget.model.listLapak[index]["created_at"]);
                      // String waktu = Waktu(waktuMentah).format('EEEE, d MMMM y' +
                      //     ' ' +
                      //     DateFormat('Hm').format(waktuMentah));

                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailItemPage(
                                        widget.model,
                                        widget.model.listLapak[index]
                                            ["nama_barang"],
                                        widget.model
                                            .listLapak[index]["harga_barang"]
                                            .substring(
                                                0,
                                                widget
                                                        .model
                                                        .listLapak[index]
                                                            ["harga_barang"]
                                                        .length -
                                                    3),
                                        widget.model.listLapak[index]
                                            ['id_penjual'],
                                        widget.model.listLapak[index]
                                            ['nama_penjual'],
                                        widget.model.listLapak[index]
                                                ["deskripsi_barang"] ??
                                            "belum ada deskripsi barang",
                                        "Umum",
                                        TemplateAplikasi.publicDomain +
                                            'data_file/' +
                                            widget.model.listLapak[index]
                                                ["foto_barang"],
                                        widget.model.namaKomunitas,
                                        widget.model.listLapak[index]
                                            ["id_barang"],
                                        widget.model.listLapak[index]
                                            ["rekening_penjual"],
                                        widget.model.listLapak[index]
                                            ['nohape_penjual'],
                                        widget.model.listLapak[index]
                                            ['stok_barang'],
                                        "000",
                                        widget.model.listLapak[index]
                                            ['alamat_toko'],
                                        widget.model.listLapak[index]
                                            ['nama_toko'],
                                        widget.model.listLapak[index]
                                            ['id_toko'],
                                      )),
                            );
                          },
                          child: Card(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11)),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: 161,
                                    child: Image.network(
                                      TemplateAplikasi.publicDomain +
                                          'data_file/' +
                                          widget.model.listLapak[index]
                                              ["foto_barang"],
                                      fit: BoxFit.fill,
                                      height: 160,
                                      width: 120,
                                      cacheHeight: 240,
                                      cacheWidth: 240,
                                      alignment: Alignment.center,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          height: 160,
                                          width: 120,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 160.0,
                                    height: 101.0,
                                    padding: EdgeInsets.fromLTRB(7, 3, 7, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      // mainAxisAlignment: MainAxisAlignment.,
                                      children: <Widget>[
                                        // Container(height: 10,),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 5,
                                          ),
                                          child: Text(
                                            widget
                                                        .model
                                                        .listLapak[index]
                                                            ["nama_barang"]
                                                        .length <=
                                                    41
                                                ? widget.model.listLapak[index]
                                                    ["nama_barang"]
                                                : widget
                                                        .model
                                                        .listLapak[index]
                                                            ["nama_barang"]
                                                        .substring(0, 33) +
                                                    '...',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                              top: 3,
                                            ),
                                            child: Text(
                                              rupiah(widget
                                                  .model
                                                  .listLapak[index]
                                                      ["harga_barang"]
                                                  .substring(
                                                      0,
                                                      widget
                                                              .model
                                                              .listLapak[index][
                                                                  "harga_barang"]
                                                              .length -
                                                          3)),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.orange[900]),
                                            )),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 19,
                                              ),
                                              Flexible(
                                                child: Text(
                                                    widget.model.namaKomunitas,
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
//                    Card(
//                      child: Column(
//                        children: <Widget>[
//                          Image.network(widget.model.listAdss.adsLists[index].images,
//                           fit: BoxFit.fitWidth,height:120),
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Text(widget.model.listAdss.adsLists[index].title),
//                          )
//                        ],
//                      ),
//
//                    ),
                          );
                    }),
              )
            ],
          ),
        );
      }
    });
  }

  Widget ContentListTeller() {
    Widget listTile(int index) {
      return ListTile(
        onTap: () {
          launchWhatsApp(widget.model.listTeller[index]['nohape']);
        },
        title: Text(widget.model.listTeller[index]['name']),
        // subtitle: Text(widget.model.listTeller[index]['nohape']),
        trailing: Container(
          height: 45,
          width: 115,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
            ),
            child: Row(
              children: [
                Image.asset('lib/assets/whatsapp.png', width: 25),
                SizedBox(width: 5),
                Text('Hubungi', style: TextStyle(color: Colors.white))
              ],
            ),
            onPressed: () async {
              launchWhatsApp(widget.model.listTeller[index]['nohape']);
            },
          ),
        ),
      );
    }

    return Container(
        child: widget.model.listTeller.length == 1
            ? Column(children: [SizedBox(height: 25), listTile(0)])
            : widget.model.listTeller.length == 2
                ? Column(
                    children: [SizedBox(height: 25), listTile(0), listTile(1)])
                : widget.model.listTeller.length == 3
                    ? Column(children: [
                        SizedBox(height: 25),
                        listTile(0),
                        listTile(1),
                        listTile(2)
                      ])
                    : widget.model.listTeller.length == 4
                        ? Column(children: [
                            SizedBox(height: 25),
                            listTile(0),
                            listTile(1),
                            listTile(2),
                            listTile(3)
                          ])
                        : widget.model.listTeller.length > 4
                            ? Column(children: [
                                SizedBox(height: 25),
                                listTile(0),
                                listTile(1),
                                listTile(2),
                                listTile(3),
                                listTile(4)
                              ])
                            : Container());
  }

  popupSilahkanVerif() {
    Alert(
        type: AlertType.info,
        context: context,
        closeFunction: () {
          Navigator.pop(context);
        },
        title: "Silahkan VERIFIKASI akun anda",
        desc: "Akun anda belum terverifikasi",
        content: Container(
            padding: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                InkWell(
                  child: Text('Lain kali',
                      style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )),
        buttons: [
          DialogButton(
            child: Text('Verifikasi sekarang',
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              showRequestVerifikasi();
            },
          )
        ]).show();
  }

  Widget boxTagihanSekolah(MainModel model) {
    if (widget.model.dataSiswa.length > 0) {
      return SizedBox(
        width: 211,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: 51,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                backgroundColor: Colors.blueAccent,
              ),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/sekolah_biru.png',
                      width: 41,
                    ),
                    SizedBox(
                      width: 17,
                    ),
                    Text(
                      "pembayaran sekolah",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BayarSPPPageFebruari2022(model)));
              },
            ),
          ),
        ),
      );
    } else {
      return Container();
    }

    // kode lama
    // if (model.idGrup == 2) {
    //   return Container(
    //     width: 301,
    //     padding: EdgeInsets.all(7),
    //     decoration: BoxDecoration(
    //         //  color: WarnaPrimary,
    //         color: Colors.red[100],
    //         shape: BoxShape.rectangle,
    //         borderRadius: BorderRadius.all(Radius.circular(13))),
    //     child: model.dataSiswa.length > 0
    //         ? Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               //Image.asset('assets/pembayaran.png'),
    //               // Icon(Icons.warning_outlined, size: 25, color: Colors.red),
    //               SizedBox(
    //                 width: 7,
    //               ),
    //               Container(
    //                 child: Text(
    //                   "pembayaran sekolah",
    //                   style: TextStyle(fontWeight: FontWeight.w600),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: 27,
    //               ),

    //               FlatButton(
    //                   color: Warna.accent,
    //                   shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.all(Radius.circular(11))),
    //                   onPressed: () {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) =>
    //                                 BayarSPPPageFebruari2022(model)));
    //                   },
    //                   child: Text(
    //                     "lihat",
    //                     style: TextStyle(color: Colors.white),
    //                   ))
    //             ],
    //           )
    //         : Center(
    //             child: Container(
    //                 padding: EdgeInsets.all(9),
    //                 child: Text(
    //                   "Putra/putri anda belum terdaftar di sistem",
    //                   textAlign: TextAlign.center,
    //                 ))),
    //   );
    // } else {
    //   return Container();
    // }
  }

  Widget subsidiMinyakGoreng(context, String judul, String image) {
    double deviceWidth = 600;
    double deviceHeight = 125;
    return InkWell(
      onTap: () async {
        // await widget.model.getDataMinyak();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MarketPlace_Lokal_Page(
                    widget.model,
                    kategoriINIMART: 1,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        height: deviceHeight,
        width: deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                width: deviceWidth,
                height: deviceHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,

                        blurRadius: 5.0,
                        // spreadRadius: 2.0,
                      ),
                    ]),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.asset(
                  image,
                  fit: BoxFit.fitHeight,
                  // color: Colors.grey.withOpacity(0.25),
                ),
              ),
            ),
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent
                          ]),
                      borderRadius: BorderRadius.circular(5)),
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 200,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  judul,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget boxPromoIklan(context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      // height: 200,
      width: MediaQuery.of(context).size.width,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            child: CarouselSlider(
              items: listImageSlider,
              carouselController: _controller,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  // viewportFraction: 0.93
                  aspectRatio: 2.4,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          // SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: listImageSlider.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: _current == entry.key ? 15 : 8,
                  height: 6,
                  margin: EdgeInsets.fromLTRB(3, 0, 3, 4),
                  decoration: BoxDecoration(
                      shape: _current == entry.key
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: _current == entry.key
                          ? BorderRadius.circular(5)
                          : null,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.green)
                          .withOpacity(_current == entry.key ? 1 : 0.4)),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  showRequestVerifikasi() async {
    EasyLoading.show(
      dismissOnTap: true,
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
    );

    String response = await widget.model.getTeller();

    if (response == 'sukses') {
      EasyLoading.dismiss();

      Alert(
          type: AlertType.none,
          context: context,
          title: "Konfirmasi ke Teller",
          desc: "Silahkan hubungi salah satu Teller berikut:",
          content: ContentListTeller(),
          buttons: []).show();
    }
  }

  launchWhatsApp(nomerWA) async {
    nomerWA = nomerWA.substring(1);

    final link = WhatsAppUnilink(
      phoneNumber: '+62' + nomerWA,
      text:
          "Assalamualaikum, saya *${widget.model.nama}* dari komunitas *${widget.model.namaKomunitas}* ingin melakukan verifikasi akun Edimu.",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }
}

//================= source listAds asli ========================
//==============================================================
//   Widget showcase() {
//     return Container(
//       height: 200,
//       child: ListView.builder(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: 3
//           //itemCount: widget.model.listAdss.adsLists.length
//           ,
//           itemBuilder: (context, index) {
//             return Container(
//               width: 160.0,
//               height: 180.0,
//               child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => detailItemPage(
//                               widget.model.listAdss.adsLists[index].title,
//                               widget.model.listAdss.adsLists[index].price,
//                               widget
//                                   .model.listAdss.adsLists[index].usernameOwner,
//                               widget.model.listAdss.adsLists[index].owner,
//                               widget.model.listAdss.adsLists[index].description,
//                               widget.model.listAdss.adsLists[index].title,
//                               widget
//                                   .model.listAdss.adsLists[index].catagoryName,
//                               widget.model.listAdss.adsLists[index].images,
//                               widget.model)),
//                     );
//                   },
//                   child: Card(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       // mainAxisAlignment: MainAxisAlignment.,
//                       children: <Widget>[
//                         Image.network(
//                           widget.model.listAdss.adsLists[index].images,
//                           fit: BoxFit.fitWidth,
//                           height: 120,
//                           alignment: Alignment.center,
//                         ),
//                         // Container(height: 10,),
//                         Container(
//                           margin: EdgeInsets.only(top: 5, left: 5),
//                           child: Text(
//                             widget.model.listAdss.adsLists[index].title,
//                             style: TextStyle(fontSize: 12),
//                           ),
//                         ),
//                         Container(
//                             margin: EdgeInsets.only(top: 3, left: 5),
//                             child: Text(
//                               "Harga " +
//                                   widget.model.listAdss.adsLists[index].price
//                                       .toString(),
//                               style: TextStyle(
//                                   fontSize: 12, color: Colors.pinkAccent),
//                             ))
// //                            Padding(
// //                              padding: const EdgeInsets.all(8.0),
// //                              child: Text(model.listAdss.adsLists[index].title),
// //                            ),
// //                            Padding(
// //                              padding: const EdgeInsets.all(8.0),
// //                              child: Text(model.listAdss.adsLists[index].price.toString()),
// //                            )
//                       ],
//                     ),
//                   )
// //                    Card(
// //                      child: Column(
// //                        children: <Widget>[
// //                          Image.network(widget.model.listAdss.adsLists[index].images,
// //                           fit: BoxFit.fitWidth,height:120),
// //                          Padding(
// //                            padding: const EdgeInsets.all(8.0),
// //                            child: Text(widget.model.listAdss.adsLists[index].title),
// //                          )
// //                        ],
// //                      ),
// //
// //                    ),
//                   ),
//             );
//           }),
//     );
//   }
