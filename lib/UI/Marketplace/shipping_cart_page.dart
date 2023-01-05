import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/HomePage/home_page.dart';
import 'package:Edimu/UI/Marketplace/marketplace_lokal_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class CheckoutCartPage extends StatefulWidget {
  MainModel model;
  List isiKeranjang;
  int totalBelanja;
  int caraPembayaran;
  String jenisCaraPembayaran;
  String namaPenerima;
  String nohapePenerima;

  CheckoutCartPage(this.model, this.isiKeranjang, this.totalBelanja,
      {this.caraPembayaran = 0,
      this.jenisCaraPembayaran = "",
      this.namaPenerima = null,
      this.nohapePenerima = null});

  @override
  _CheckoutCartPageState createState() => _CheckoutCartPageState();
}

class _CheckoutCartPageState extends State<CheckoutCartPage> {
  var isianNamaPenerima = TextEditingController();
  var isianNohapePenerima = TextEditingController();
  var isianAlamatPenerima = TextEditingController();
  var isianCatatan = TextEditingController();
  var isianPin = TextEditingController();

  bool mauLanjut = false;

  int metodePengiriman = 0;
  int metodePembayaran = 0;

  String namaToko;
  String alamatToko;
  int totalBelanja = 0;

  String textDaftarBarang = '';

  int biayaLayanan = 0;

  var scrollController = ScrollController();

  final validator = GlobalKey<FormState>();

  @override
  void initState() {
    //debugPrint("isi widget.isiKeranjang :");
    //debugPrint(widget.isiKeranjang.toString());

    // TODO: implement initState
    isianNamaPenerima.text = widget.namaPenerima ?? widget.model.nama;
    isianNohapePenerima.text =
        widget.nohapePenerima ?? widget.model.nohapeAktif;
    isianAlamatPenerima.text = widget.model.alamatUser;

    namaToko = widget.isiKeranjang[0]["namaToko"];
    alamatToko = widget.isiKeranjang[0]["alamatToko"];
    metodePembayaran = widget.caraPembayaran;

    //hitung totalBelanja
    widget.isiKeranjang.forEach((item) {
      totalBelanja += item["total"];
    });

    totalBelanja += widget.model.biayaLayananAplikasi;

    //generate text untuk list barang
    widget.isiKeranjang.forEach((item) {
      String _textPenampung;
      _textPenampung =
          '- ${item["namaBarang"]} : ${item["jumlahBarang"]} x ${rupiah(item["hargaSatuan"])}\n';
      textDaftarBarang = textDaftarBarang + _textPenampung;
    });

    //debugPrint("isi textDaftarBarang:");
    //debugPrint(rapiin(textDaftarBarang));

    if ((int.parse(widget.model.formatedBalance) >= totalBelanja) &&
        (widget.caraPembayaran == 0)) {
      setState(() {
        metodePembayaran = 1;
      });
    }

    hitungBiayaLayanan();
    super.initState();
  }

  void hitungBiayaLayanan() {
    Map formula =
        widget.model.formulaPembagianMarketPlace[totalBelanja >= 50000 ? 1 : 0];

    int hargaMin = int.parse(formula["harga_min"].replaceAll(".00", ""));
    int hargaMax = int.parse(formula["harga_max"].replaceAll(".00", ""));
    int marginMin = int.parse(formula["margin_min"].replaceAll(".00", ""));
    int marginMax = int.parse(formula["margin_max"].replaceAll(".00", ""));

    double margin = ((marginMax - marginMin) / (hargaMax - hargaMin));

    biayaLayanan =
        (((totalBelanja - hargaMin) * margin) + marginMin).ceil().toInt();

    debugPrint("totalBelanja = ${rupiah(totalBelanja)}");
    debugPrint("isi int margin = ${margin}");
    debugPrint("isi int biayaLayanan = ${biayaLayanan}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atur Pengiriman"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: validator,
            child: ListView(
              controller: scrollController,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text("  Identitas Penerima"),
                SizedBox(
                  height: 0,
                ),
                Container(
                  padding: EdgeInsets.all(11),
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: !mauLanjut,
                        controller: isianNamaPenerima,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            labelText: "nama penerima",
                            icon: Icon(Icons.person)),
                        validator: (value) {
                          if (value.length < 1) {
                            return "harap isi nama pembeli";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  padding: EdgeInsets.all(11),
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: !mauLanjut,
                        controller: isianNohapePenerima,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            labelText: "No.HP penerima",
                            icon: Icon(Icons.phone)),
                        validator: (value) {
                          if (value.length < 9) {
                            return "harap isi nomor handphone dengan lengkap";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("  Pengiriman"),
                Card(
                  child: Container(
                      padding: EdgeInsets.all(9),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: metodePengiriman == 0
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(71, 7, 7, 13),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "pilih salah satu",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(height: 10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 15),
                              Icon(Icons.local_shipping, color: Colors.grey),
                              SizedBox(width: 25),
                              Expanded(
                                // flex: 4,
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return ToggleSwitch(
                                      cornerRadius: 3,
                                      minWidth: constraints.maxWidth * 0.498,
                                      minHeight: 49,
                                      fontSize: 15,
                                      initialLabelIndex: metodePengiriman - 1,
                                      activeBgColor: Colors.blue[800],
                                      activeFgColor: Colors.white,
                                      inactiveBgColor: Colors.grey[200],
                                      inactiveFgColor: Colors.grey[400],
                                      labels: ["Ambil Sendiri", "Dikirim"],
                                      // changeOnTap: true,
                                      onToggle: (index) {
                                        setState(() {
                                          index = index;
                                          metodePengiriman = index + 1;
                                        });
                                        debugPrint(
                                            "isi metodePengiriman = $metodePengiriman");
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: metodePengiriman == 1
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(71, 17, 7, 7),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "alamat pengambilan:",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(namaToko),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(alamatToko ??
                                            "Penjual tidak mencantumkan alamat toko")
                                      ],
                                    ),
                                  )
                                : metodePengiriman == 2
                                    ? Container(
                                        padding:
                                            EdgeInsets.fromLTRB(65, 17, 7, 7),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("barang akan dikirim ke:"),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            TextFormField(
                                              controller: isianAlamatPenerima,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "*masukkan alamat yang lengkap",
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey[600])),
                                              validator: (value) {
                                                if (value.length < 5 &&
                                                    metodePengiriman == 2) {
                                                  return "harap lengkapi alamat anda";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                          ),
                          SizedBox(height: 11)
                        ],
                      )),
                ),
                SizedBox(
                  height: 11,
                ),
                Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "  Metode Pembayaran",
                          textAlign: TextAlign.left,
                        )),
                    Card(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(9, 17, 9, 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 15),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 9.0),
                                    child:
                                        Icon(Icons.payment, color: Colors.grey),
                                  ),
                                  SizedBox(width: 25),
                                  Expanded(
                                      // flex: 4,
                                      child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5)),
                                      border: Border.all(
                                        color: Colors.blue[700],
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(metodePembayaran == 1
                                        ? "Saldo ediMU"
                                        : metodePembayaran == 0
                                            ? "pilih metode bayar"
                                            : widget.jenisCaraPembayaran),
                                  )),
                                  InkWell(
                                      onTap: () {
                                        showMetodePembayaran();
                                      },
                                      child: Container(
                                        width: 75,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 9, horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[700],
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                          border: Border.all(
                                            color: Colors.blue[700],
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          "Ganti",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                                ],
                              ),
                              // SizedBox(height: 5),
                              Container(
                                child: metodePembayaran == 1
                                    ? Container(
                                        padding:
                                            EdgeInsets.fromLTRB(80, 17, 7, 7),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Sisa saldo ediMU Anda " +
                                                rupiah(widget
                                                    .model.formatedBalance)),
                                          ],
                                        ),
                                      )
                                    : metodePembayaran == 2
                                        ? Container(
                                            padding: EdgeInsets.fromLTRB(
                                                71, 17, 7, 7),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sisa Pay Later Anda " +
                                                      rupiah(widget.model
                                                          .saldoPayLaterSekarang),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                    'Beli sekarang Bayar pada tanggal akhir bulan',
                                                    style: TextStyle(
                                                        color: Colors.black54)),
                                              ],
                                            ),
                                          )
                                        : Container(),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),

                SizedBox(
                  height: 11,
                ),

                Text("  Catatan"),
                Container(
                  padding: EdgeInsets.all(11),
                  child: Column(
                    children: [
                      TextField(
                        enabled: !mauLanjut,
                        controller: isianCatatan,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            labelText: "catatan untuk penjual",
                            icon: Icon(Icons.description)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                daftarBelanjaan(),

                //if mauLanjut == true
                Container(
                  child: mauLanjut
                      ? Container(
                          padding: EdgeInsets.all(15),
                          color: Colors.orangeAccent[100],
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info,
                                size: 39,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Pastikan data yang anda masukkan TELAH BENAR.",
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Apakah anda sudah yakin?")
                            ],
                          )),
                        )
                      : Container(),
                ),
                //pembatas bawah
                SizedBox(
                  height: 85,
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 65,
                child: mauLanjut
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[800],
                                  ),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Periksa lagi",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      mauLanjut = false;
                                    });

                                    scrollController.animateTo(0,
                                        duration: Duration(milliseconds: 501),
                                        curve: Curves.easeIn);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                  ),
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Konfirmasi",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19),
                                  ),
                                  onPressed: () {
                                    popupPIN(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800]),
                        // color: Colors.blue[800],
                        onPressed: () async {
                          validator.currentState.validate();

                          if (validator.currentState.validate() &&
                              metodePengiriman != 0) {
                            setState(() {
                              mauLanjut = !mauLanjut;
                            });

                            Future.delayed(Duration(milliseconds: 750));

                            scrollController.animateTo(
                                //,
                                scrollController.position.pixels + 200,
                                duration: Duration(milliseconds: 1701),
                                curve: Curves.linearToEaseOut);
                          } else {
                            scrollController.animateTo(0,
                                duration: Duration(milliseconds: 501),
                                curve: Curves.easeIn);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Konfirmasi",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                            )
                          ],
                        ),
                      ),
              ))
        ],
      ),
    );
  }

  Widget daftarBelanjaan() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Card(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 11),
            child: Column(
              children: [
                Text("Daftar Belanjaan"),
                SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.isiKeranjang.length,
                  itemBuilder: (context, index) {
                    int _totalBayarPerbarang = 0;
                    _totalBayarPerbarang = widget.isiKeranjang[index]
                            ["jumlahBarang"] *
                        widget.isiKeranjang[index]["hargaSatuan"];
                    //
                    return Container(
                      child: ListTile(
                        title: Text(
                          widget.isiKeranjang[index]["namaBarang"],
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                        subtitle: Text(
                          "${widget.isiKeranjang[index]["jumlahBarang"]} ${widget.isiKeranjang[0]['idToko'] == "" ? " ${widget.isiKeranjang[index]["satuan"]}" : " Pcs"}",
                          style: TextStyle(color: Colors.red[700]),
                        ),
                        trailing: Text(
                          rupiah(_totalBayarPerbarang),
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    );
                  },
                ),

                // biaya layanan aplikasi
                Container(
                    child: ListTile(
                        title: Text(
                          "Biaya layanan aplikasi",
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                        ),
                        trailing: Text(
                          rupiah(biayaLayanan),
                          style: TextStyle(color: Colors.blue[800]),
                        ))),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                      padding: EdgeInsets.all(11),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.amber[200],
                      height: 65,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "total",
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            rupiah(totalBelanja + biayaLayanan),
                            style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 29,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      )),
                )
              ],
            )),
      ),
    );
  }

  popupPIN(context) {
    Alert(
        context: context,
        title: "Masukkan PIN Anda",
        closeIcon: Icon(Icons.close),
        // closeFunction: () {},
        content: Container(
          margin: EdgeInsets.only(top: 25),
          width: 205,
          child: PinCodeTextField(
            backgroundColor: Colors.transparent,
            appContext: context,
            controller: isianPin,
            autoDisposeControllers: false,
            length: 6,
            showCursor: false,
            enableActiveFill: true,
            obscureText: true,
            autoFocus: true,
            obscuringWidget: Container(
                width: 14,
                height: 14,
                decoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
            // obscuringCharacter: 'G',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {},
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 32,
              fieldWidth: 32,
              borderWidth: 2.5,
              activeColor: Colors.grey[400],
              inactiveColor: Colors.grey[300],
              selectedColor: Colors.green[400],
              activeFillColor: Colors.grey[400],
              inactiveFillColor: Colors.grey[300],
              selectedFillColor: Colors.grey[300],
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Colors.red[800],
            child: Text("Batal", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          DialogButton(
            color: Colors.blue[800],
            child: Text("Konfirm", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              var catatanPembeli;
              if (isianCatatan.text == null || isianCatatan.text == "") {
                catatanPembeli = "tidak ada catatan";
              } else {
                catatanPembeli = isianCatatan.text;
              }

              // untuk nampilin daftar belanjaan :
              List daftarbarang = [];

              widget.isiKeranjang.forEach((element) {
                daftarbarang.add(element["namaBarang"]);
              });

              if (widget.model.statusPayLater == 0 ||
                  widget.model.statusPayLaterUser == 0) {
                metodePembayaran = 1;
              }

              //plus catatan pembeli
              String textCatatanTransaksi = '''
              Barang yang dibeli :\n
              ${textDaftarBarang}

              Catatan pembeli: 
              ${catatanPembeli}\n
              ''';
              // =================================

              EasyLoading.show(
                dismissOnTap: true,
                status: 'sedang diproses',
                maskType: EasyLoadingMaskType.black,
              );

              String response = await widget.model.confirmBayarCart(
                  int.parse(widget.isiKeranjang[0]['idToko']),
                  int.parse(widget.isiKeranjang[0]['norekPenjual']),
                  totalBelanja - widget.model.biayaLayananAplikasi,
                  rapiin(textCatatanTransaksi),
                  isianPin.text,
                  isianNamaPenerima.text,
                  isianNohapePenerima.text,
                  isianAlamatPenerima.text,
                  widget.isiKeranjang,
                  metodePengiriman,
                  metodePembayaran,
                  biayaLayanan);

              if (response == "sukses") {
                EasyLoading.dismiss();
                Alert(
                    context: context,
                    title: "Berhasil",
                    type: AlertType.success,
                    desc: "Pembelian berhasil",
                    closeFunction: () {
                      // Navigator.pop(context);
                      widget.model.isiKeranjang
                          .remove(widget.isiKeranjang[0]["norekPenjual"]);

                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => homePage(widget.model)),
                      // );

                      hubungiWA();
                    },
                    content: Container(
                      padding: EdgeInsets.all(11),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.pop(context);
                              widget.model.isiKeranjang.remove(
                                  widget.isiKeranjang[0]["norekPenjual"]);

                              // Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           MarketPlace_Lokal_Page(widget.model)),
                              // );
                            },
                            child: Container(
                              child: Text(
                                "Belanja lagi",
                                style: TextStyle(
                                    color: Colors.blue[800],
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          // ElevatedButton(
                          //     color: Colors.green[700],
                          //     onPressed: () {
                          //       hubungiWA();
                          //     },
                          //     child: Center(
                          //         child: Container(
                          //       padding: EdgeInsets.symmetric(vertical: 11),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             "lib/assets/whatsapp.png",
                          //             width: 35,
                          //             height: 35,
                          //           ),
                          //           SizedBox(
                          //             width: 7,
                          //           ),
                          //           Text(
                          //             "Hubungi Penjual",
                          //             style: TextStyle(color: Colors.white),
                          //           )
                          //         ],
                          //       ),
                          //     )))
                        ],
                      ),
                    ),
                    buttons: [
                      DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            finishTransaksi();
                          })
                    ]).show();
              } else if (response == "pinSalah") {
                EasyLoading.dismiss();

                //debugPrint("hasil response dari konfirmBelanja adalah :");
                //debugPrint(response);

                Alert(
                    context: context,
                    title: "Pin salah",
                    type: AlertType.error,
                    desc: "Masukkan PIN yang benar",
                    buttons: [
                      DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ]).show();
              } else {
                EasyLoading.dismiss();

                //debugPrint("hasil response dari konfirmBelanja adalah :");
                //debugPrint(response);

                Alert(
                    context: context,
                    title: "Error",
                    type: AlertType.error,
                    desc: "Transaksi gagal",
                    buttons: [
                      DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ]).show();
              }
            },
          )
        ]).show();
  }

  finishTransaksi() {
    // Navigator.pop(context);
    widget.model.isiKeranjang.remove(widget.isiKeranjang[0]["norekPenjual"]);

    // Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => homePage(widget.model)),
    // );

    hubungiWA();
  }

  hubungiWA() async {
    String _daftarBarangUntukWA = '';

    widget.isiKeranjang.forEach((item) {
      String _textPenampung;
      _textPenampung =
          '*- ${item["namaBarang"]} : ${item["jumlahBarang"]} x @ ${rupiah(item["hargaSatuan"])}*\n';
      _daftarBarangUntukWA = _daftarBarangUntukWA + _textPenampung;
    });

    String alamatWAPenjual = widget.isiKeranjang[0]["nohapePenjual"];
    alamatWAPenjual.substring(1);

    String textInfoPengiriman = metodePengiriman == 1
        ? "Metode Pengiriman : *Pembeli akan mengambil barang langsung*"
        : "Metode Pengiriman : Barang akan dikirim ke *${isianAlamatPenerima.text}*";

    List daftarbarang = [];
    widget.isiKeranjang.forEach((element) {
      daftarbarang.add(element["namaBarang"]);
    });

    String textPesanWa = """
      Assalamualaikum wr wb.\n 
        
      saya *${widget.model.nama.toUpperCase()}* dari *${widget.model.namaKomunitas}* telah melakukan pembelian barang yang bapak/ibu jual di ${widget.model.namaKomunitas}.\n
        
      berikut adalah nama barang yang dibeli :
      ${_daftarBarangUntukWA}

      $textInfoPengiriman\n

      *Dana sebesar ${rupiah(widget.totalBelanja)} telah saya transfer ke rekening Edimu bapak/ibu.*\n

      Terimakasih
      """;

    final link = WhatsAppUnilink(
      phoneNumber: '+62' + '$alamatWAPenjual',
      text: rapiin(textPesanWa),
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
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
            widget.isiKeranjang,
            widget.totalBelanja,
            metodePembayaran,
            isianNamaPenerima.text,
            isianNohapePenerima.text));
  }
}

class MetodePembayaran extends StatefulWidget {
  MainModel model;
  List isiKeranjang;
  int totalBelanja;
  int metodePembayaran;
  String namaPenerima;
  String nohapePenerima;

  MetodePembayaran(this.model, this.isiKeranjang, this.totalBelanja,
      this.metodePembayaran, this.namaPenerima, this.nohapePenerima);

  @override
  State<MetodePembayaran> createState() => _MetodePembayaranState();
}

class _MetodePembayaranState extends State<MetodePembayaran> {
  int metodePembayaran = 0;
  String jenisMetodePembayaran = '';
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
  void initState() {
    // TODO: implement initState
    metodePembayaran = widget.metodePembayaran;
    if (metodePembayaran == 1) {
      jenisMetodePembayaran = jenisPembayaran[0]['label'];
      jenisPembayaran[0]['isSelected'] = true;
    } else if (metodePembayaran == 2) {
      jenisMetodePembayaran = jenisPembayaran[1]['label'];
      jenisPembayaran[1]['isSelected'] = true;
    }

    debugPrint(
        '==================== Metode pembayaran awal = $metodePembayaran =====================');
    debugPrint(
        '==================== Jenis metode pembayaran awal = $jenisMetodePembayaran =====================');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (int.parse(widget.model.formatedBalance) < widget.totalBelanja) {
      jenisPembayaran[0]['status'] = false;
    }

    if (widget.model.statusPayLater == 0 ||
        widget.model.statusPayLaterUser == 0) {
      jenisPembayaran[1]['status'] = false;
    } else if (widget.model.saldoPayLaterSekarang < widget.totalBelanja) {
      jenisPembayaran[1]['status'] = false;
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 2,
                color: Colors.grey[300],
              ),
              SizedBox(height: 10),
              pilihanMetodePembayaran(),
              SizedBox(height: 50),
              tombolFixPilih()
            ]),
      ),
    );
  }

  Widget pilihanMetodePembayaran() {
    return Container(
      height: 205,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          // physics: NeverScrollableScrollPhysics(),
          itemCount: jenisPembayaran.length,
          itemBuilder: (context, index) {
            return jenisPembayaran[index]['status'] == false
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 6, 5, 1),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                metodePembayaran =
                                    jenisPembayaran[index]['kode'];
                                jenisMetodePembayaran =
                                    jenisPembayaran[index]['label'];

                                jenisPembayaran.forEach((item) {
                                  item['isSelected'] = false;
                                });
                                jenisPembayaran[index]['isSelected'] = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    jenisPembayaran[index]['isSelected'] == true
                                        ? Colors.blue
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  jenisPembayaran[index]['label'],
                                  style: TextStyle(
                                      color: jenisPembayaran[index]
                                                  ['isSelected'] ==
                                              true
                                          ? Colors.white
                                          : Colors.black54),
                                ),
                              ),
                            )),
                      ),
                      Container(
                        child: jenisPembayaran[index]['isSelected'] != true
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.blue[100],
                                  ),
                                  child: metodePembayaran == 1
                                      ? Text(
                                          "Sisa saldo Anda ${rupiah(widget.model.formatedBalance)}.",
                                        )
                                      : Text(
                                          "Sisa pay later Anda ${rupiah(widget.model.saldoPayLaterSekarang)}.\nBeli sekarang Bayar pada tanggal 28 akhir bulan",
                                        ),
                                ),
                              ),
                      ),
                    ],
                  );
          }),
    );
  }

  Widget tombolFixPilih() {
    return Container(
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
          ),
          onPressed: () {
            if (metodePembayaran == 0) {
              Alert(
                      type: AlertType.error,
                      context: context,
                      title: "Perhatian",
                      desc: 'Silahkan pilih metode pembayaran terlebih dahulu')
                  .show();
            } else {
              debugPrint("isi metodePembayaran = $metodePembayaran");
              Navigator.pop(context);
              // Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckoutCartPage(
                          widget.model,
                          widget.isiKeranjang,
                          widget.totalBelanja,
                          caraPembayaran: metodePembayaran,
                          jenisCaraPembayaran: jenisMetodePembayaran,
                          namaPenerima: widget.namaPenerima,
                          nohapePenerima: widget.nohapePenerima,
                        )),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text('Konfirmasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                )),
          )),
    );
  }
}
