import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/PPOB/PDAM/pdam_page.dart';
import 'package:Edimu/UI/PPOB/Pascabayar_Listrik/KonfirmasiPascaListrik_Page.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Token_Listrik/Konfirmasi_Token.dart';
import 'package:Edimu/UI/PembayaranSekolah/RiwayatSpp_Page.dart';
import 'package:Edimu/UI/Topup/topUp_page.dart';
import 'package:Edimu/Widgets/EasyLoadingWidgget.dart';
import 'package:Edimu/Widgets/WhatsappBox.dart';
import 'package:Edimu/scoped_model/StatusTransaksiPPOB.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SamsatPage extends StatefulWidget {
  MainModel model;
  int tabIndex;
  // SamsatPage(this.model);

  SamsatPage(this.model, this.tabIndex);

  @override
  _SamsatPageState createState() => _SamsatPageState();
}

class _SamsatPageState extends State<SamsatPage>
    with SingleTickerProviderStateMixin {
  var nomorPelangganController = TextEditingController();
  var nomorKTPController = TextEditingController();
  var isianPin = TextEditingController();
  //
  Map infoTagihan = {};
  List listDetailTagihan = [];
  List displayedPricelist = [];
  Map infoKendaraan = {};
  //
  //
  var scrollController = ScrollController();
  TabController tabController;
  var focus;
  //
  //  state untuk riwaayat
  List listRiwayatPembelian = [];
  //
  String kodePasca = "";
  String kodeWilayah = "";
  List listStringKodeWilayah = ["sedang diproses"];
  int metodePembayaran = 0;
  bool isMetodePembayaranActive = false;

  @override
  void initState() {
    //
    tabController = TabController(length: 2, vsync: this);
    //
    getWilayahPDAM();
    //
    super.initState();
    debugPrint("initialIndex adalah = ${widget.tabIndex}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  getWilayahPDAM() async {
    await widget.model.getWilayahSamsat();

    listStringKodeWilayah =
        widget.model.listWilayahPDAM.map((e) => e["name"]).toList();
    //
    List _filteredList = listStringKodeWilayah
        .where((item) =>
            item.toLowerCase().contains(widget.model.asalKota.toLowerCase()))
        .toList();

    //

    kodeWilayah = _filteredList.length > 0 ? _filteredList.first : "";

    if (kodeWilayah.length > 2) {
      String _kodePasca = widget.model.listWilayahPDAM
          .firstWhere((element) => element["name"] == kodeWilayah)["code"];

      kodePasca = _kodePasca;
    }

    setState(() {});

    debugPrint(
        "kode wilayah setelah difilter sesuai data nasabah = ${kodeWilayah}");
  }

  Future getRiwayatPembayaranPLNPasca() async {
    // if (widget.model.listRiwayatPLNPascabayar.length == 0) {

    // }
    EdimuLoading.munculkan();
    //
    await widget.model.getRiwayatListrikPascaBayar('ESAMSAT');
    //
    EdimuLoading.tutup();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.tabIndex,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Tagihan Samsat"),
            centerTitle: true,
            bottom: TabBar(
              controller: tabController,
              onTap: (value) {
                if (value != 0) {
                  FocusScope.of(context).unfocus();
                  getRiwayatPembayaranPLNPasca();
                }
              },
              indicatorColor: Colors.white,
              // indicator: BoxDecoration(
              //     color: Colors.green,
              //     border: Border(
              //         bottom: BorderSide(
              //             color: Colors.white,
              //             width: 3,
              //             style: BorderStyle.solid))),
              tabs: [Tab(text: 'Beli'), Tab(text: 'Riwayat')],
            )),
        body: TabBarView(
            controller: tabController,
            children: [beliTokenListrik(), riwayatBeliTokenListrik()]),
      ),
    );
  }

  Widget riwayatBeliTokenListrik() {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => RefreshIndicator(
        onRefresh: refreshRiwayat,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(9),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text("Riwayat Tagihan Samsat"),
                SizedBox(
                  height: 15,
                ),
                ListView.builder(
                    reverse: true,
                    itemCount: model.listRiwayatPLNPascabayar.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Color _warnaStatusTransaksi = Colors.green[800];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat("EEEE, d MMM yyyy", "id_ID")
                                            .format(model
                                                .listRiwayatPLNPascabayar[index]
                                                .timestamp),
                                        style: TextStyle(
                                            color: Colors.blue[800],
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Sukses",
                                        style: TextStyle(
                                            color: _warnaStatusTransaksi),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  height: 3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.81,
                                  color: Colors.grey[100],
                                ),
                                ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(model
                                            .listRiwayatPLNPascabayar[index]
                                            .namaPelanggan),
                                        Text(
                                          "nopol kendaraan : " +
                                              model
                                                  .listRiwayatPLNPascabayar[
                                                      index]
                                                  .noPelanggan,
                                          style:
                                              TextStyle(color: Colors.black45),
                                        )
                                      ],
                                    ),
                                    subtitle: Text("Tagihan " +
                                        hitungBulanSamsat(model
                                            .listRiwayatPLNPascabayar[index]
                                            .periodeBulan)),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          rupiah(model
                                              .listRiwayatPLNPascabayar[index]
                                              .totalNominal),
                                          style: TextStyle(
                                              color: Colors.orange[900]),
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                // FlatButton(
                                //     height: 51,
                                //     minWidth: double.infinity,
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.only(
                                //             topLeft: Radius.circular(7),
                                //             topRight: Radius.circular(7))),
                                //     color: Colors.blue[800],
                                //     onPressed: () async {
                                //       //
                                //       setState(() {
                                //         nomorPelangganController.text = model
                                //             .listRiwayatPLNPascabayar[index]
                                //             .noPelanggan;

                                //         kodeWilayah = model
                                //             .listRiwayatPLNPascabayar[index]
                                //             .code;
                                //       });

                                //       tabController.animateTo(0);

                                //       cekTagihan();
                                //     },
                                //     child: Container(
                                //         child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       children: [
                                //         Icon(
                                //           Icons.refresh,
                                //           color: Colors.white,
                                //         ),
                                //         SizedBox(
                                //           width: 5,
                                //         ),
                                //         Text(
                                //           "Bayar Lagi",
                                //           style: TextStyle(color: Colors.white),
                                //         )
                                //       ],
                                //     )))
                              ],
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future refreshRiwayat() async {
    EdimuLoading.munculkan();
    await widget.model.getRiwayatListrikPascaBayar('ESAMSAT');
    EdimuLoading.tutup();
  }

  Widget beliTokenListrik() {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   height: 100,
                  //   child: Image.asset(
                  //     "lib/assets/PPOB/logo_PLN.png",
                  //     width: 100,
                  //   ),
                  // ),
                  boxPilihWilayah(),
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "masukkkan nopol Kendaraan & no. KTP :",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  TextField(
                    controller: nomorPelangganController,
                    // autofocus: true,

                    // onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    textInputAction: TextInputAction.next,
                    // keyboardType: TextInputType.number,
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
                        labelText: 'Nopol kendaraan',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0))),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: nomorKTPController,
                    // autofocus: true,

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
                        labelText: 'Nomor KTP',
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
                  tombolPeriksa(),
                  SizedBox(
                    height: 35,
                  ),
                  infoPelanggan(),
                  SizedBox(
                    height: 25,
                  ),
                  daftarDetailTagihan(),
                  SizedBox(
                    height: 75,
                  ),
                ],
              ),
            ),
          ),
          tombolBeliFixed()
        ],
      ),
    );
  }

  Widget boxPilihWilayah() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) =>
          Container(
        child: DropdownSearch(
          // mode: Mode.DIALOG,
          enabled: true,
          // label: "pilih wilayah",
          // hint: "ini adalah hint",
          items: listStringKodeWilayah,
          // showSearchBox: true,
          selectedItem:
              kodeWilayah.length > 3 ? kodeWilayah : "silahkan pilih wilayah",
          onChanged: (value) {
            kodeWilayah = value;
            //
            String _kodePasca = widget.model.listWilayahPDAM.firstWhere(
                (element) => element["name"] == kodeWilayah)["code"];

            kodePasca = _kodePasca;
            //
            debugPrint("isi kode wilayah = ${kodeWilayah}");
          },
        ),
      ),
    );
  }

  Widget tombolPeriksa() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
     
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800],),
            onPressed: () async {
              cekTagihan();
            },
            child: Text(
              "Cek Tagihan",
              style: TextStyle(color: Colors.white, fontSize: 17),
            )),
      ),
    );
  }

  cekTagihan() async {
    EasyLoading.show(
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );

    infoTagihan = await widget.model.getTagihanListrikPascaBayar(
        nomorPelangganController.text, kodePasca,
        noKTP: nomorKTPController.text);

    setState(() {});

    if (infoTagihan["status"] == StatusPPOB.pelangganDitemukan) {
      FocusScope.of(context).unfocus();

      setState(() {
        if (widget.model.saldoPayLaterSekarang < infoTagihan['hargaEndUser']) {
          metodePembayaran = 1;
        }
      });

      setState(() {
        infoKendaraan = infoTagihan['message']["desc"];
      });

      scrollController.animateTo(scrollController.position.pixels + 307,
          duration: Duration(milliseconds: 1701),
          curve: Curves.linearToEaseOut);
      //
    } else if (infoTagihan['status'] == StatusPPOB.tagihanSudahLunas) {
      FocusScope.of(context).unfocus();
      Alert(
          context: context,
          type: AlertType.success,
          title: "Tagihan Lunas",
          desc: "Selamat, Tagihan pajak di nopol tersebut sudah lunas.",
          buttons: [
            DialogButton(
                child: Text("OK",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () async {
                  Navigator.pop(context);
                  tabController.animateTo(1);
                })
          ]).show();
    } else {
      setState(() {
        listDetailTagihan = [];
      });
      Alert(
          context: context,
          type: AlertType.info,
          title: "Maaf",
          desc:
              "No pajak/pelanggan tidak ditemukan, silahkan periksa kembali data-data diatas.",
          buttons: [
            DialogButton(
                child: Text("coba lagi",
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

  Widget infoPelanggan() {
    String infoTegangan;

    if (infoTagihan["status"] == StatusPPOB.pelangganDitemukan) {
      //
      return Column(
        children: [
          SizedBox(
            height: 35,
          ),
          Text(
            "Info tagihan",
            style: TextStyle(fontSize: 21),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              // border: Border.all(width: 2, color: Colors.blue[800]),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Warna.primary, width: 3),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    tileColor: Warna.primary,
                    title: Text(
                      "Nomor rangka",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(infoKendaraan["nomor_rangka"],
                        style: TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    tileColor: Warna.primary,
                    title: Text("Nomor mesin",
                        style: TextStyle(color: Colors.white)),
                    trailing: Text(infoKendaraan["nomor_mesin"],
                        style: TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    title: Text("Type"),
                    trailing: Text(infoKendaraan["tipe_kb"]),
                  ),
                  ListTile(
                    title: Text("Tahun buatan"),
                    trailing: Text(infoKendaraan["tahun_buatan"]),
                  ),
                  ListTile(
                    title: Text("Merek"),
                    trailing: Text(infoKendaraan["merek_kb"]),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Model",
                            style: TextStyle(fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 11,
                        ),
                        Center(child: Text(infoKendaraan["model_kb"]))
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text("Akhir pajak baru"),
                    trailing: Text(hitungBulanSamsat(
                        infoKendaraan["tgl_akhir_pajak_baru"])),
                  ),
                  biayaPokokTile(),
                  biayaDendaTile(),
                  biayaAdminTile(),
                  ListTile(
                    title: Text("Biaya Parkir"),
                    trailing: Text(
                      rupiah(infoKendaraan['biaya_parkir_pokok']),
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: Text("Pajak Progresif"),
                    trailing: Text(
                      rupiah(infoKendaraan['biaya_pajak_progresif']),
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: Text("Total pajak"),
                    trailing: Text(
                      rupiah(infoTagihan['hargaEndUser']),
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget biayaPokokTile() {
    int biayaBBN = int.parse(infoKendaraan["biaya_pokok"]["BBN"]) ?? 0;
    int biayaPKB = int.parse(infoKendaraan["biaya_pokok"]["PKB"]) ?? 0;
    int biayaSWD = int.parse(infoKendaraan["biaya_pokok"]["SWD"]) ?? 0;
    //
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Biaya pokok"),
          Text(rupiah(biayaBBN + biayaPKB + biayaSWD),
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold))
        ],
      ),
      children: [
        ListTile(
          title: Text("BBN"),
          trailing: Text(
            rupiah(biayaBBN),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("PKB"),
          trailing: Text(
            rupiah(biayaPKB),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("SWD"),
          trailing: Text(
            rupiah(biayaSWD),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget biayaDendaTile() {
    int dendaBBN = int.parse(infoKendaraan["biaya_denda"]["BBN"]) ?? 0;
    int dendaPKB = int.parse(infoKendaraan["biaya_denda"]["PKB"]) ?? 0;
    int dendaSWD = int.parse(infoKendaraan["biaya_denda"]["SWD"]) ?? 0;
    //
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Biaya Denda"),
          Text(rupiah(dendaBBN + dendaPKB + dendaSWD),
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold))
        ],
      ),
      children: [
        ListTile(
          title: Text("BBN"),
          trailing: Text(
            rupiah(dendaBBN),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("PKB"),
          trailing: Text(
            rupiah(dendaPKB),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("SWD"),
          trailing: Text(
            rupiah(dendaSWD),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget biayaAdminTile() {
    int biayaAdmin = infoTagihan["message"]["admin"];
    int biayaSTNK = int.parse(infoKendaraan["biaya_denda"]["BBN"]) ?? 0;
    int biayaTNKB = int.parse(infoKendaraan["biaya_denda"]["PKB"]) ?? 0;
    //
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Biaya Admin"),
          Text(rupiah(biayaSTNK + biayaTNKB + biayaAdmin),
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold))
        ],
      ),
      children: [
        ListTile(
          title: Text("Admin"),
          trailing: Text(
            rupiah(biayaAdmin),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("BBN"),
          trailing: Text(
            rupiah(biayaSTNK),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("PKB"),
          trailing: Text(
            rupiah(biayaTNKB),
            style: TextStyle(
                fontSize: 19,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget daftarDetailTagihan() {
    if (infoTagihan["status"] == StatusPPOB.pelangganDitemukan) {
      return Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              // border: Border.all(width: 2, color: Colors.blue[800]),
              // borderRadius: BorderRadius.circular(7),
              // color: Colors.blue[800]
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   "Daftar Tagihan:",
              //   style: TextStyle(color: Colors.black),
              // ),
              // SizedBox(height: 17),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listDetailTagihan.length,
                  itemBuilder: (context, index) {
                    int nilaiTagihan = listDetailTagihan[index]["bill_amount"];

                    int biayaAdmin = listDetailTagihan[index]["misc_amount"];

                    int biayaDenda = listDetailTagihan[index]["penalty"];

                    int totalPerBulan =
                        nilaiTagihan + biayaAdmin + biayaDenda + 2000;
                    //

                    return Column(
                      children: [
                        Card(
                          elevation: 7,
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 11),
                                  width: double.infinity,
                                  child: Center(
                                      child: Text("Tagihan",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold))),
                                ),
                                ListTile(
                                  title: Text("nilai tagihan"),
                                  trailing: Text(rupiah(nilaiTagihan)),
                                ),
                                ListTile(
                                  title: Text("biaya admin"),
                                  trailing: Text(rupiah(2000)),
                                ),
                                ListTile(
                                  title: Text("biaya lain-lain"),
                                  trailing: Text(rupiah(biayaAdmin)),
                                ),
                                ListTile(
                                  title: Text("denda"),
                                  trailing: Text(rupiah(biayaDenda)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 15),
                                  width: double.infinity,
                                  height: 45,
                                  color: Colors.amber[300],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(""),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        rupiah(totalPerBulan),
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  }),
              SizedBox(
                height: 0,
              )
            ],
          ));
    } else {
      return Container();
    }
  }

  Widget tombolBeliFixed() {
    if (infoTagihan["status"] == StatusPPOB.pelangganDitemukan) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 61,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      // width: MediaQuery.of(context).size.width * 0.41,
                      height: 61,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text("total"),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            rupiah(infoTagihan["hargaEndUser"]),
                            style: TextStyle(
                                color: Colors.orange[900], fontSize: 19),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 61,
                    color: Colors.blue[800],
                    child: ElevatedButton(
                      onPressed: () {
                        //
                        if ((int.parse(widget.model.formatedBalance) <
                                infoTagihan["hargaEndUser"]) &&
                            (widget.model.saldoPayLaterSekarang <
                                infoTagihan["hargaEndUser"])) {
                          alertPulsaTidakCukup();
                        } else {
                          showMetodePembayaran();
                        }
                        // if (int.parse(widget.model.formatedBalance) <
                        //     infoTagihan["hargaEndUser"]) {
                        //   alertPulsaTidakCukup();
                        // } else {
                        //   if (infoTagihan["status"] ==
                        //       StatusPPOB.pelangganDitemukan) {
                        //      if (widget.model.statusPayLater == 0 || widget.model.statusPayLaterUser == 0) {
                        //       metodePembayaran = 1;
                        //       popupPin();
                        //     } else {
                        //       setState(() {
                        //         isMetodePembayaranActive = true;
                        //       });
                        //     }
                        //   }
                        // }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.add_shopping_cart_sharp,
                          //   color: Colors.white,
                          // ),
                          // SizedBox(
                          //   width: 7,
                          // ),
                          Text(
                            "Bayar",
                            style: TextStyle(fontSize: 21, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
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
              infoTagihan["message"]["tr_id"],
              infoTagihan['hargaEndUser'],
              kodePasca,
              infoTagihan['apakahDev'],
            ));
  }

  // showMetodePembayaran() {
  //   if (infoTagihan["status"] == StatusPPOB.pelangganDitemukan) {
  //     return Align(
  //       alignment: Alignment.bottomCenter,
  //       child: Container(
  //         height: MediaQuery.of(context).size.height * 0.5,
  //         child: Stack(children: [
  //           Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.white,

  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black45,
  //                     spreadRadius: 3,
  //                     blurRadius: 5,
  //                     offset: Offset(0, 3), // changes position of shadow
  //                   )
  //                 ],
  //               ),
  //               height: MediaQuery.of(context).size.height * 0.5,
  //               child: Column(
  //                   // crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: [
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         color: Colors.blue[800],

  //                       ),
  //                       padding: EdgeInsets.symmetric(vertical: 15),
  //                       width: MediaQuery.of(context).size.width,
  //                       child: Text(
  //                         "Pilih Metode Pembayaran",
  //                         style: TextStyle(
  //                           fontSize: 17,
  //                           color: Colors.white,
  //                         ),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     LayoutBuilder(
  //                       builder:
  //                           (BuildContext context, BoxConstraints constraints) {
  //                         return ToggleSwitch(
  //                           cornerRadius: 5,
  //                           minWidth: constraints.maxWidth * 0.498,
  //                           minHeight: 49,
  //                           fontSize: 15,
  //                           initialLabelIndex: metodePembayaran - 1,
  //                           activeBgColor: Colors.green,
  //                           activeFgColor: Colors.white,
  //                           inactiveBgColor: Colors.grey[200],
  //                           inactiveFgColor: Colors.grey[400],
  //                           labels: ["Saldo GENI", "Pay Later"],
  //                           // changeOnTap: true,
  //                           onToggle: (index) {
  //                             if (index == 1 &&

  //                                         widget.model.saldoPayLaterSekarang <
  //                                     infoTagihan['hargaEndUser']) {
  //                               Alert(
  //                                       type: AlertType.error,
  //                                       context: context,
  //                                       title: "Perhatian",
  //                                       desc:
  //                                           'Mohon maaf, saat ini Anda tidak dapat melakukan transaksi Pay Later, silahkan melakukan transaksi dengan metode pembayaran lainnya')
  //                                   .show();
  //                               setState(() {
  //                                 index = 0;
  //                                 metodePembayaran = 1;
  //                               });
  //                             } else {
  //                               setState(() {
  //                                 index = index;
  //                                 metodePembayaran = index + 1;
  //                               });
  //                             }
  //                             debugPrint(
  //                                 "isi metodePembayaran = $metodePembayaran");
  //                           },
  //                         );
  //                       },
  //                     ),
  //                     // SizedBox(height: 20),
  //                     metodePembayaran == 0
  //                         ? Container()
  //                         : Padding(
  //                             padding:
  //                                 const EdgeInsets.symmetric(horizontal: 15),
  //                             child: Container(
  //                               margin: EdgeInsets.only(top: 2),
  //                               padding: EdgeInsets.all(15),
  //                               width: MediaQuery.of(context).size.width,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 color: Colors.green[100],
  //                               ),
  //                               child: metodePembayaran == 1
  //                                   ? Text(
  //                                       "Sisa saldo Anda ${rupiah(widget.model.formatedBalance)}.",
  //                                       textAlign: TextAlign.center)
  //                                   : Text(
  //                                       "Sisa pay later Anda ${rupiah(widget.model.saldoPayLaterSekarang)}.\nBeli sekarang Bayar pada tanggal 28 akhir bulan",
  //                                       textAlign: TextAlign.center),
  //                             ),
  //                           ),
  //                     SizedBox(height: 30),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 15),
  //                       child: Row(
  //                         children: [
  //                           Expanded(
  //                             flex: 2,
  //                             child: FlatButton(
  //                                 height: 50,
  //                                 shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(5)),
  //                                 color: Colors.red,
  //                                 onPressed: () {
  //                                   setState(() {
  //                                     isMetodePembayaranActive = false;
  //                                   });
  //                                 },
  //                                 child: Text(
  //                                   "Kembali",
  //                                   style: TextStyle(
  //                                       fontSize: 17, color: Colors.white),
  //                                 )),
  //                           ),
  //                           SizedBox(width: 5),
  //                           Expanded(
  //                             flex: 3,
  //                             child: FlatButton(
  //                                 height: 50,
  //                                 shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(5)),
  //                                 color: Colors.blue[800],
  //                                 onPressed: () {
  //                                   if (metodePembayaran == 0) {
  //                                     Alert(
  //                                             type: AlertType.error,
  //                                             context: context,
  //                                             title: "Perhatian",
  //                                             desc:
  //                                                 'Silahkan pilih metode pembayaran terlebih dahulu')
  //                                         .show();
  //                                   } else {
  //                                     popupPin();
  //                                   }
  //                                 },
  //                                 child: Text(
  //                                   "Lanjut Pembayaran",
  //                                   style: TextStyle(
  //                                       fontSize: 17, color: Colors.white),
  //                                 )),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ])),
  //         ]),
  //       ),
  //     );
  //   } else {
  //     Container();
  //   }
  // }

  Widget alertPulsaTidakCukup() {
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
}

hitungBulanSamsat(String angka) {
  String angkaTanggal = angka.substring(6, 8);
  String angkaBulan = angka.substring(4, 6);
  String angkaTahun = angka.substring(0, 4);

  String angkaBulanKe2;
  String angkaTahunKe2;

  // angkaBulan.replaceAll("0", "");

  debugPrint(
      "angkaTanggal = $angkaTanggal - angkaBulan = $angkaBulan - angkaTahun = $angkaTahun");
  //
  //

  return "$angkaTanggal ${getNamaBulan(int.parse(angkaBulan))} $angkaTahun";
}

class MetodePembayaran extends StatefulWidget {
  MainModel model;
  int trID;
  int totalBayar;
  String kodePasca;
  bool apakahDev;

  MetodePembayaran(
    this.model,
    this.trID,
    this.totalBayar,
    this.kodePasca,
    this.apakahDev,
  );

  @override
  State<MetodePembayaran> createState() => _MetodePembayaranState();
}

class _MetodePembayaranState extends State<MetodePembayaran> {
  var isianPin = TextEditingController();
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
    if (int.parse(widget.model.formatedBalance) < widget.totalBayar) {
      jenisPembayaran[0]['status'] = false;
    }
    if (widget.model.statusPayLater == 0 ||
        widget.model.statusPayLaterUser == 0 ||
        (widget.model.saldoPayLaterSekarang < widget.totalBayar)) {
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
                              popupPin();
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

  Future refreshRiwayat() async {
    EdimuLoading.munculkan();
    await widget.model.getRiwayatListrikPascaBayar('ESAMSAT');
    EdimuLoading.tutup();
  }

  popupPin() {
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
            child: Text("OK", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              EasyLoading.show(
                status: 'sedang diproses',
                maskType: EasyLoadingMaskType.black,
                dismissOnTap: true,
              );

              List res = await widget.model.bayarTagihanPascaBayar(
                  widget.trID,
                  widget.totalBayar,
                  widget.kodePasca,
                  widget.apakahDev,
                  isianPin.text,
                  metodePembayaran);

              if (res[0] == StatusPPOB.sukses) {
                refreshRiwayat();
                //
                Alert(
                    context: context,
                    title: "Sukses",
                    type: AlertType.success,
                    desc: "pembayaran tagihan Samsat anda berhasil!",
                    buttons: [
                      DialogButton(
                          color: Colors.blue[800],
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SamsatPage(widget.model, 0);
                            }));
                            // tabController.animateTo(1);
                          })
                    ]).show();
              } else if (res[0] == StatusPPOB.salahPin) {
                Alert(
                    context: context,
                    title: "PIN SALAH",
                    type: AlertType.error,
                    desc: "Maaf, PIN anda salah, silahkan coba kembali",
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
              } else if (res[0] == StatusPPOB.saldoKomunitasTidakCukup) {
                if (res[1] == "Saldo PPOB di komunitas anda tidak cukup") {
                  String _pesanWA =
                      "Saya *${widget.model.nama}* dari *${widget.model.namaKomunitas}* ingin melakukan pembayaran *Tagihan BPJS* tetapi saldo PPOB komunitas ${widget.model.namaKomunitas} telah habis, mohon untuk segera isi saldo PPOB agar saya bisa segera membeli produk tersebut, Terima kasih 🙏 .";

                  Alert(
                      context: context,
                      title: "MAAF",
                      type: AlertType.info,
                      desc:
                          "Saldo komunitas ${widget.model.namaKomunitas} tidak cukup untuk melakukan transaksi ini",
                      content: Container(
                        child: WhatsappBox(widget.model, _pesanWA),
                      ),
                      buttons: [
                        DialogButton(
                            color: Colors.blue[800],
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            })
                      ]).show();
                } else {
                  Alert(
                      context: context,
                      title: res[1],
                      type: AlertType.info,
                      buttons: [
                        DialogButton(
                            color: Colors.blue[800],
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            })
                      ]).show();
                }
              } else {
                Alert(
                    context: context,
                    title: "Error",
                    type: AlertType.error,
                    desc: "Transaksi gagal.",
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

              EasyLoading.dismiss();
            },
          ),
        ]).show();
  }
}
