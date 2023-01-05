import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/Marketplace/cart_display.dart';
import 'package:Edimu/UI/Marketplace/OLD_checkout_page.dart';
import 'package:Edimu/UI/Marketplace/marketplace_lokal_page.dart';
import 'package:Edimu/UI/Marketplace/shipping_cart_page.dart';
import 'package:Edimu/UI/Topup/topUp_page.dart';
import 'package:Edimu/UI/Transfer/transfer_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:vibration/vibration.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

enum AniProps { width, height, color }

class detailItemPage extends StatefulWidget {
  MainModel model;
  int idLapak;
  String rekSeller;
  String title;
  String price;
  String usernamePenjual;
  String namaPenjual;
  String description;
  String kategori;
  String images;
  String komunitasPenjual;
  String nohapePenjual;
  int stok;
  String waktu;
  String alamatPengambilan;
  String namaToko;
  int idToko;

  detailItemPage(
      this.model,
      this.title,
      this.price,
      this.usernamePenjual,
      this.namaPenjual,
      this.description,
      this.kategori,
      this.images,
      this.komunitasPenjual,
      this.idLapak,
      this.rekSeller,
      this.nohapePenjual,
      this.stok,
      this.waktu,
      this.alamatPengambilan,
      this.namaToko,
      this.idToko);

  @override
  _detailItemPageState createState() => _detailItemPageState();
}

class _detailItemPageState extends State<detailItemPage> {
  String nomerUntukWa;
  int orderUnit = 1;

  //tambahan setelah ada cart
  bool _canVibrate = false;
  var isianJumlahBarang = TextEditingController();
  var focusNode = FocusNode();
  bool autoFocusIsianJumlah = false;
  ScrollController _scrollController;
  bool apakahSudahBelanja = false;

  //punya-nya penghitungBarang
  int jumlahBarang = 1;
  int totalHarga = 0;
  int hargaSatuan;

  //untuk snackbar
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  void add() {
    setState(() {
      ++orderUnit;
    });
  }

  void remove() {
    setState(() {
      if (orderUnit > 1) {
        orderUnit--;
      }
    });
  }

  launchWhatsApp(namaBarang) async {
    final link = WhatsAppUnilink(
      phoneNumber: '+62' + nomerUntukWa,
      text:
          "Assalamualaikum, saya tertarik dengan *${widget.description}* yang bapak/ibu *${widget.namaPenjual}* jual di aplikasi Edimu",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  @override
  void initState() {
    nomerUntukWa = widget.nohapePenjual.substring(1);
    //debugPrint('isi var nomerUntukWa');
    //debugPrint(nomerUntukWa);

    //tambahan setelah fitur cart
    isianJumlahBarang.text = "1";
    hargaSatuan = int.parse(widget.price);
    EasyLoading.instance
      ..radius = 10
      ..indicatorSize = 45
      ..maskColor = Colors.green[100].withOpacity(0.5);

    widget.description == null
        ? widget.description = "tidak ada deskripsi barang"
        : null;

    // ==============>
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var keteranganStok = widget.stok > 0
        ? Text(' - stok : ${widget.stok.toString()} pcs',
            style: TextStyle(fontSize: 18))
        : Text(' - Stok barang telah habis',
            style: TextStyle(fontSize: 18, color: Colors.red));

    var alamatPengambilan = widget.alamatPengambilan != null
        ? Container(
            width: MediaQuery.of(context).size.width * 0.75,
            // margin: EdgeInsets.only(right: 51),
            child: Text(widget.alamatPengambilan,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w400)))
        : Container();

    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          floatingActionButton: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 45, left: 25),
              child: FloatingActionButton(
                child: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          backgroundColor: Warna.hijauBG2,
          // extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   title: Text("Detail item"),
          //   backgroundColor: Colors.transparent,
          // ),
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  children: <Widget>[
                    Container(
                      child: widget.stok < 1
                          ? Stack(
                              children: [
                                Center(
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        Color.fromRGBO(255, 255, 255, 0.4),
                                        BlendMode.dstIn),
                                    child: Image.network(
                                      widget.images,
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width,
                                      height: 461,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 231),
                                    child: Text(
                                      'Barang Habis',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 45),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Image.network(
                              widget.images,
                              fit: BoxFit.contain,
                              height: 461,
                              alignment: Alignment.center,
                            ),
                    ),
                    SizedBox(height: 25),
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          widget.title,
                          style: TextStyle(fontSize: 18),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 10, bottom: 0),
                        child: Row(children: [
                          Text(
                            rupiah(widget.price),
                            style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 1),
                          keteranganStok
                          // Text(
                          //   " - stok : ${widget.stok.toString()} item",
                          //   style: TextStyle(fontSize: 18),
                          // )
                        ])),
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 6, bottom: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(Icons.store),
                            SizedBox(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.89,
                                  child: Text(
                                    widget.namaPenjual,
                                    softWrap: true,
                                    style: TextStyle(
                                        // color: Colors.red[800],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(height: 5),
                                alamatPengambilan
                              ],
                            )
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 1, left: 6, bottom: 1),
                        child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 5),
                            Text(
                              widget.namaPenjual,
                              style: TextStyle(
                                  // color: Colors.red[800],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 0, left: 35, bottom: 0),
                        child: Text(
                          "${widget.komunitasPenjual}",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        )),
                    // Container(
                    //     margin: EdgeInsets.only(top: 10, left: 6, bottom: 9),
                    //     child: Row(
                    //       // mainAxisSize: MainAxisSize.max,
                    //       children: [
                    //         Icon(Icons.date_range),
                    //         SizedBox(width: 5),
                    //         Text(
                    //           widget.waktu,
                    //           style: TextStyle(
                    //               // color: Colors.red[800],
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.w400),
                    //         ),
                    //       ],
                    //     )),
                    Card(
                      child: ListTile(
                        // title: Text("Deskripsi"),
                        title: Html(
                          data: widget.description,
                        ),
                        //subtitle: Html(widget.description),
                      ),
                    ),
                    Card(
                        child: Column(
                      children: <Widget>[
                        ListTile(
                          // title: Text("Tanya penjual"),
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Warna.primary,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text('kirim pesan ke penjual bila diperlukan',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey))
                            ],
                          ),
                        ),
                        SizedBox(height: 9),
                      ],
                    )),
                    SizedBox(height: 79),
                    // Card(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Container(
                    //         margin: EdgeInsets.only(top: 10),
                    //         child: Text(
                    //           "Jumlah barang yang ingin dibeli",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(fontSize: 14),
                    //         ),
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           IconButton(
                    //             padding: EdgeInsets.all(1),
                    //             color: Colors.blue[800],
                    //             icon: Icon(Icons.remove),
                    //             iconSize: 35,
                    //             // button -
                    //             onPressed: remove,
                    //           ),
                    //           Text(
                    //             '$orderUnit',
                    //             style: TextStyle(fontSize: 20),
                    //           ),
                    //           IconButton(
                    //             padding: EdgeInsets.all(1),
                    //             iconSize: 35,
                    //             color: Colors.blue[800],
                    //             icon: Icon(Icons.add),
                    //             // button +
                    //             onPressed: add,
                    //           )
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                // Align(
                //     alignment: Alignment.topLeft,
                //     child: Padding(
                //       padding: EdgeInsets.only(top: 15, left: 1),
                //       child: IconButton(
                //         icon: Icon(Icons.keyboard_backspace_outlined),
                //         iconSize: 45,
                //         color: Colors.white,
                //         onPressed: () {
                //           Navigator.pop(context);
                //         },
                //       ),
                //     )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: double.infinity,
                      height: 61,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                launchWhatsApp(widget.title);
                              },
                              child: Container(
                                color: Colors.green[700],
                                height: 61,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          icon: Image.asset(
                                            "lib/assets/whatsapp.png",
                                            width: 67,
                                            height: 67,
                                          ),
                                          onPressed: () {
                                            launchWhatsApp(widget.title);
                                          }),
                                      SizedBox(width: 7),
                                      Text('Chat',
                                          style: TextStyle(color: Colors.white))
                                    ]),
                              ),
                            ),
                          ),
                          Container(
                            child:
                                widget.stok < 1 ? tombolHabis() : tombolBeli(),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ));
    });
  }

  // aja sihFAB tombol CART kanan barang
  // kalo perlu
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
                "15",
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
          onPressed: () {
            //masukin interaksi disini
            showAddToCart();
          }),
    );
  }

  showAddToCart() {
    showModalBottomSheet(
        elevation: 5,
        enableDrag: true,
        isDismissible: true,
        // bounce: true,
        isScrollControlled: true,
        // duration: Duration(milliseconds: 350),
        context: context,
        builder: (context) => BottomModalAddToCart(
            widget.model,
            widget.stok,
            widget.price,
            widget.idLapak,
            widget.rekSeller,
            widget.images,
            widget.title,
            widget.namaToko,
            widget.alamatPengambilan,
            widget.idToko.toString(),
            widget.nohapePenjual,
            widget.namaPenjual));
  }

  Widget tombolBeli() {
    return Expanded(
      flex: 4,
      child: Container(
        height: 61,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.only(
            //         topRight: Radius.circular(9), topLeft: Radius.circular(9))),
          ),
          icon: Icon(Icons.add_shopping_cart, color: Colors.white),
          label: Text(
            "Beli",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            //debugPrint("isi widget.nohapePenjual :");
            //debugPrint(widget.nohapePenjual.toString());
            showAddToCart();
          },
        ),
      ),
    );
  }

  Widget tombolHabis() {
    return Expanded(
      flex: 4,
      child: Container(
        height: 61,
        color: Colors.red[800],
        child: ElevatedButton.icon(
          // height: 61,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         topRight: Radius.circular(9),
          //         topLeft: Radius.circular(9))),
          // color: Colors.red[800],
          icon: Icon(Icons.warning, color: Colors.white),
          label: Text(
            "Barang habis",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (!widget.model.sudahVerifikasi) {
              Alert(
                  type: AlertType.info,
                  context: context,
                  closeFunction: () {},
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
                      onPressed: () {},
                    )
                  ]).show();
            } else {
              Alert(
                  type: AlertType.info,
                  context: context,
                  closeFunction: () {},
                  title: "Maaf barang sudah habis",
                  desc: "Silahkan hubungi penjual untuk info lebih lanjut",
                  buttons: [
                    DialogButton(
                      child: Text('OK', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ]).show();
            }
          },
        ),
      ),
    );
  }

  //punya Class Utama
  popUpMelebihiStok() {
    Alert(
            type: AlertType.error,
            title: "Stok Tidak Cukup",
            closeFunction: () {},
            context: context,
            desc: "Stok yang tersedia = ${widget.stok} pcs"
            // buttons: [
            //   DialogButton(
            //     color: Colors.blue[800],
            //     child: Text("Tambahkan", style: TextStyle(color: Colors.white)),
            //     onPressed: () async {
            //       setState(() {
            //         catatanPembeli = isianCatatan.text;
            //       });
            //       Navigator.pop(context);
            //     },
            //   )
            // ]
            )
        .show();
  }
}

class BottomModalAddToCart extends StatefulWidget {
  MainModel model;
  int stok;
  String price;
  String rekPenjual;
  int idLapak;
  String urlGambar;
  String namaGambar;
  String namaToko;
  String alamatToko;
  String idToko;
  String nohapePenjual;
  String namaPenjual;

  BottomModalAddToCart(
      this.model,
      this.stok,
      this.price,
      this.idLapak,
      this.rekPenjual,
      this.urlGambar,
      this.namaGambar,
      this.namaToko,
      this.alamatToko,
      this.idToko,
      this.nohapePenjual,
      this.namaPenjual);

  @override
  _BottomModalAddToCartState createState() => _BottomModalAddToCartState();
}

class _BottomModalAddToCartState extends State<BottomModalAddToCart> {
  //tambahan setelah ada cart
  bool _canVibrate = false;
  var isianJumlahBarang = TextEditingController();
  var focusNode = FocusNode();
  bool autoFocusIsianJumlah = false;
  ScrollController _scrollController;
  String catatan = "";
  bool apakahSudahBelanja = false;

  //punya-nya penghitungBarang
  int jumlahBarang = 1;
  int totalHarga;
  int hargaSatuan;

  // animasi icon
  // AnimationController animationController;

  initState() {
    //tambahan setelah fitur cart
    totalHarga = int.parse(widget.price);
    isianJumlahBarang.text = "1";
    hargaSatuan = int.parse(widget.price);

    super.initState();
    //
  }

  @override
  dispose() {
    super.dispose();
    // animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 25, 11, 11),
                child: ListView(
                  children: [
                    Text(
                      "Masukkan ke keranjang",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 15),
                    //   child: Container(
                    //     color: Warna.hijauMain,
                    //     height: 5,
                    //     width: double.infinity,
                    //   ),
                    // ),
                    Divider(
                      color: Warna.primary,
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Saldo : " + rupiah(widget.model.formatedBalance),
                          style: TextStyle(fontSize: 18, color: Warna.primary),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text("harga satuan :"),
                        SizedBox(
                          width: 9,
                        ),
                        Text(
                          rupiah(widget.price.toString()),
                          style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'jumlah :',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        tombolHitungJumlahBarang()
                      ],
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Card(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //Total belanja
                              ListTile(
                                leading: Text("total :"),
                                title: Text(
                                  rupiah(totalHarga.toString()),
                                  style: TextStyle(
                                      color: Colors.green[800],
                                      fontSize: rupiah(totalHarga.toString())
                                                  .length <=
                                              10
                                          ? 31
                                          : 23,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 21,
                    ),

                    //tombol konfirmasi keranjang belanja

                    Container(
                      child: apakahSudahBelanja
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CartDisplayPage(widget.model)),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_rounded,
                                    color: Colors.blue[800],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "lihat keranjang belanja",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue[800],
                                        fontSize: 19),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ),

                    SizedBox(
                      height: 9,
                    ),

                    Container(
                      height: apakahSudahBelanja ? 41 : 51,
                      width: double.infinity,
                      // color: Colors.blue[800],
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: apakahSudahBelanja
                              ? Colors.grey
                              : Colors.blue[800],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17))),
                        ),
                        // color:
                        //     apakahSudahBelanja ? Colors.grey : Colors.blue[800],
                        // minWidth: double.infinity,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(17))),
                        // height: apakahSudahBelanja ? 41 : 51,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(apakahSudahBelanja ? "Tambah" : "OK, Beli",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            SizedBox(
                              width: 0,
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onPressed: () {
                          //debugPrint("isi widget.nohapePenjual :");
                          //debugPrint(widget.nohapePenjual.toString());

                          String idLapak = widget.idLapak.toString();

                          widget.model.addToCart(
                              widget.idLapak,
                              widget.rekPenjual,
                              jumlahBarang,
                              int.parse(widget.price),
                              "widget.catatan",
                              widget.urlGambar,
                              widget.namaGambar,
                              widget.namaToko,
                              widget.alamatToko,
                              widget.idToko,
                              widget.nohapePenjual,
                              widget.namaPenjual);

                          setState(() {
                            apakahSudahBelanja = true;
                          });

                          EasyLoading.showSuccess("BERHASIL",
                              dismissOnTap: true,
                              duration: Duration(milliseconds: 901),
                              maskType: EasyLoadingMaskType.black);
                        },
                      ),
                    ),

                    SizedBox(
                      height: 9,
                    ),

                    Container(
                      height: 41,
                      width: double.infinity,
                      child: apakahSudahBelanja
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(17))),
                              ),
                              // color: Colors.grey,
                              // minWidth: double.infinity,
                              // height: 41,
                              // shape: RoundedRectangleBorder(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(17))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 0,
                                  ),
                                  Text("Belanja lainnya",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17)),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MarketPlace_Lokal_Page(widget.model)),
                                );
                              },
                            )
                          : Container(),
                    ),

                    SizedBox(
                      height: 9,
                    ),

                    Container(
                      width: double.infinity,
                      height: 51,
                      child: apakahSudahBelanja
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(17))),
                              ),
                              // color: Colors.blue[800],
                              // minWidth: double.infinity,
                              // height: 51,
                              // shape: RoundedRectangleBorder(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(17))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Bayar",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 19)),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              onPressed: () {
                                //debugPrint(
                                // "isiKeranjang saat ini : ${widget.model.isiKeranjang}");
                                int _jumlahItemKeranjang = 0;
                                widget.model.isiKeranjang.forEach((key, value) {
                                  value.forEach((key2, value2) {
                                    _jumlahItemKeranjang++;
                                  });
                                });
                                //debugPrint(
                                // "isi keranjang saat ini = ${_jumlahItemKeranjang}");
                                if (int.parse(widget.model.formatedBalance) >=
                                        (jumlahBarang * hargaSatuan +
                                            widget
                                                .model.biayaLayananAplikasi) &&
                                    _jumlahItemKeranjang == 1) {
                                  List listPenampung = [];
                                  Map objekBarang = {
                                    "idLapak": widget.idLapak,
                                    "namaBarang": widget.namaGambar,
                                    "norekPenjual": widget.rekPenjual,
                                    "jumlahBarang": jumlahBarang,
                                    "catatan": catatan,
                                    "hargaSatuan": hargaSatuan,
                                    "total": jumlahBarang * hargaSatuan,
                                    "urlGambar": widget.urlGambar,
                                    "namaToko": widget.namaToko,
                                    "alamatToko": widget.alamatToko,
                                    "idToko": widget.idToko,
                                    "nohapePenjual": widget.nohapePenjual
                                  };

                                  listPenampung.add(objekBarang);

                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckoutCartPage(
                                            widget.model,
                                            listPenampung,
                                            jumlahBarang * hargaSatuan)),
                                  );
                                } else if (_jumlahItemKeranjang > 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CartDisplayPage(widget.model)),
                                  );
                                } else {
                                  Alert(
                                      context: context,
                                      title: "Saldo tidak cukup",
                                      type: AlertType.info,
                                      closeFunction: () {
                                        Navigator.pop(context);
                                      },
                                      desc:
                                          "Maaf saldo anda tidak cukup untuk melakukan pembayaran",
                                      content: Column(
                                        children: [
                                          SizedBox(
                                            height: 27,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                color: Colors.amber[300]),
                                            padding: EdgeInsets.all(11),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "saldo anda :",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[850]),
                                                    ),
                                                    Text(rupiah(widget
                                                        .model.formatedBalance))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("total belanja :",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[850])),
                                                    Text(rupiah(jumlahBarang *
                                                        hargaSatuan))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("biaya layanan :",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[850])),
                                                    Text(rupiah(widget.model
                                                        .biayaLayananAplikasi))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      buttons: [
                                        DialogButton(
                                            child: Text(
                                              "Isi Saldo",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        topUpPage(
                                                          widget.model,
                                                        )),
                                              );
                                            })
                                      ]).show();
                                }
                              },
                            )
                          : Container(),
                    ),
                    Container(
                      height: 135,
                    )
                  ],
                ),
              ),
            ),
          ),

          //tombolKonfirmasi keranjang
          // Positioned(
          //   bottom: 0,
          //   child:
          // )
        ],
      ),
    );
  }

  Widget tombolHitungJumlahBarang() {
    double lebarSayapTombol = MediaQuery.of(context).size.width * 0.61;
    double tinggiSayapTombol = 51;

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: tinggiSayapTombol,
          width: lebarSayapTombol,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9), color: Colors.blue[800]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    _canVibrate
                        ? Vibration.vibrate(
                            pattern: [0, 75],
                          )
                        : null;
                    if (jumlahBarang > 1) {
                      setState(() {
                        jumlahBarang = int.parse(isianJumlahBarang.text) - 1;

                        isianJumlahBarang.text = jumlahBarang.toString();

                        totalHarga = hargaSatuan * jumlahBarang;
                      });
                    }
                  },
                  child: Container(
                    height: 41,
                    width: double.infinity,
                    child: Center(
                      child: Text('-',
                          style: TextStyle(color: Colors.white, fontSize: 21)),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  height: 35,
                  width: 55,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: isianJumlahBarang,
                        autofocus: autoFocusIsianJumlah,
                        focusNode: focusNode,
                        // keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue[800]),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),

                        onChanged: (isian) {
                          if (int.parse(isian) > widget.stok) {
                            setState(() {
                              jumlahBarang = 1;
                              isianJumlahBarang.text = "1";
                              totalHarga =
                                  int.parse(widget.price) * jumlahBarang;
                            });
                            popUpMelebihiStok();
                          } else if (isian == "" || isian == "0") {
                            setState(() {
                              jumlahBarang = 1;
                              isianJumlahBarang.text = "1";
                              totalHarga =
                                  int.parse(widget.price) * jumlahBarang;
                            });
                          } else if (int.parse(isian) <= widget.stok) {
                            //debugPrint("amaaannnnn");
                            setState(() {
                              jumlahBarang = int.parse(isian);
                              totalHarga =
                                  int.parse(widget.price) * jumlahBarang;
                            });
                          } else {
                            setState(() {
                              isianJumlahBarang.text = "0";
                            });
                          }
                        },

                        onTap: () {
                          focusNode.requestFocus();
                          // _scrollController.animateTo(
                          //     _scrollController.position.pixels + 455,
                          //     duration: Duration(milliseconds: 2701),
                          //     curve: Curves.linearToEaseOut);

                          setState(() {
                            autoFocusIsianJumlah = true;
                          });

                          if (isianJumlahBarang.text == "0") {
                            isianJumlahBarang.text = "";
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    _canVibrate
                        ? Vibration.vibrate(
                            pattern: [0, 75],
                          )
                        : null;
                    if (int.parse(isianJumlahBarang.text) < widget.stok) {
                      setState(() {
                        jumlahBarang = int.parse(isianJumlahBarang.text) + 1;

                        isianJumlahBarang.text = jumlahBarang.toString();

                        totalHarga = hargaSatuan * jumlahBarang;

                        //debugPrint("isi total harga : ${rupiah(totalHarga)}");
                      });
                    } else if (int.parse(isianJumlahBarang.text) ==
                        widget.stok) {
                      popUpMelebihiStok();
                    }
                  },
                  child: Container(
                    height: tinggiSayapTombol,
                    width: lebarSayapTombol,
                    child: Center(
                      child: Text('+',
                          style: TextStyle(color: Colors.white, fontSize: 21)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: Text('sisa : ' + widget.stok.toString() + ' pcs',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
        )
      ],
    );
  }

  //punya class bottom sheet
  popUpMelebihiStok() {
    Alert(
        type: AlertType.error,
        title: "Stok Tidak Cukup",
        closeFunction: () {},
        context: context,
        desc: "Stok yang tersedia = ${widget.stok} pcs",
        buttons: [
          DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ]
        // buttons: [
        //   DialogButton(
        //     color: Colors.blue[800],
        //     child: Text("Tambahkan", style: TextStyle(color: Colors.white)),
        //     onPressed: () async {
        //       setState(() {
        //         catatanPembeli = isianCatatan.text;
        //       });
        //       Navigator.pop(context);
        //     },
        //   )
        // ]
        ).show();
  }
}
