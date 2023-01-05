import 'package:flutter/material.dart';
import 'package:Edimu/UI/Marketplace/confirm_checkout.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';

class Checkout_Page extends StatefulWidget {
  MainModel model;
  String title;
  String price;
  String usernamePenjual;
  String namaPenjual;
  String description;
  String kategori;
  String images;
  String komunitasPenjual;
  String gambar;
  int idLapak;
  String rekPenjual;
  String nohapePenjual;
  String deskripsi;
  int stok;
  String alamatPengambilan;

  Checkout_Page(
      this.model,
      this.title,
      this.price,
      this.usernamePenjual,
      this.namaPenjual,
      this.description,
      this.kategori,
      this.images,
      this.komunitasPenjual,
      this.gambar,
      this.idLapak,
      this.rekPenjual,
      this.nohapePenjual,
      this.deskripsi,
      this.stok,
      this.alamatPengambilan);

  @override
  _Checkout_PageState createState() => _Checkout_PageState();
}

class _Checkout_PageState extends State<Checkout_Page> {
  TextEditingController isianCatatan = TextEditingController();
  TextEditingController isianAlamat = TextEditingController();
  TextEditingController isianNamaPenerima = TextEditingController();
  TextEditingController isianNohape = TextEditingController();
  TextEditingController isianJumlahBarang = TextEditingController();

  bool autoFocusIsianJumlah = false;

  ScrollController _scrollController;

  String namaPenerima = '.....';
  String noHapePenerima = '.....';
  String alamatPenerima = '.....';
  String catatanPembeli = 'tidak ada catatan';
  int idMetodePengiriman = 1;
  int jumlah = 1;
  int hargaSatuan;
  int totalHarga = 0;
  var focusNode = FocusNode();

  List<bool> _selections = List.generate(3, (_) => false);

  bool _canVibrate = true;

  bisaGetar() async {
    _canVibrate = await Vibration.hasVibrator();
    bisaGetar();
  }

  @override
  void initState() {
    namaPenerima = widget.model.nama;
    noHapePenerima = widget.model.idUser;
    alamatPenerima = widget.model.alamatUser;
    hargaSatuan = int.parse(widget.price);
    totalHarga = hargaSatuan;

    isianNohape.text = noHapePenerima;
    isianJumlahBarang.text = "0";

    //debugPrint('isi var totalHarga = ${totalHarga.toString()}');
    bisaGetar();
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Checkout',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    detailPenerima(),
                    SizedBox(height: 1),
                    metodePengiriman(),
                    SizedBox(height: 1),
                    detailPesanan(),
                    SizedBox(height: 155),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 15, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('Total : '),
                        Text(rupiah(totalHarga),
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.red[800],
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(width: 19),
                    SizedBox(
                        width: 169,
                        height: 57,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0)),
                          ),
                          // color: Colors.blue[800],
                          child: Text(
                            "Buat Pesanan",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(9.0)),
                          onPressed: () async {
                            if (int.parse(widget.model.formatedBalance) >=
                                totalHarga) {
                              //debugPrint(
                              // 'usernamePenjual = ${widget.usernamePenjual}');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConfirmCheckout_Page(
                                          widget.model,
                                          widget.title,
                                          namaPenerima,
                                          noHapePenerima,
                                          isianAlamat.text,
                                          idMetodePengiriman,
                                          widget.idLapak,
                                          totalHarga,
                                          catatanPembeli,
                                          widget.rekPenjual,
                                          widget.gambar,
                                          jumlah,
                                          widget.usernamePenjual,
                                          widget.nohapePenjual,
                                          widget.deskripsi,
                                          widget.alamatPengambilan ??
                                              "(alamat penjual belum tertera)")));
                            } else {}
                          },
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget detailPenerima() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Penerima',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            ListTile(
                dense: true,
                leading: Icon(Icons.person),
                title: Text(namaPenerima,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: InkWell(
                  onTap: () {
                    popupNamaPenerima();
                  },
                  child: Text(
                    'Ubah',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ),
                isThreeLine: true,
                subtitle: Text(alamatPenerima)),
            ListTile(
              dense: true,
              leading: Icon(Icons.phone),
              title: Text(noHapePenerima,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: InkWell(
                onTap: () {
                  popupNohape();
                },
                child: Text(
                  'Ubah',
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget metodePengiriman() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text('Metode Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 19),
                Icon(Icons.local_shipping, color: Colors.grey),
                SizedBox(width: 27),
                ToggleSwitch(
                  minWidth: 111,
                  minHeight: 49,
                  fontSize: 15,
                  initialLabelIndex: idMetodePengiriman - 1,
                  activeBgColor: Colors.blue[800],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey[200],
                  inactiveFgColor: Colors.grey[400],
                  labels: ["Ambil Sendiri", "Dikirim"],
                  changeOnTap: true,
                  onToggle: (index) {
                    if (index == 1) {
                      setState(() {
                        idMetodePengiriman = index + 1;
                      });
                      popupAlamatPenerima();
                      // _scrollController.animateTo(
                      //     _scrollController.position.pixels + 355,
                      //     duration: Duration(milliseconds: 701),
                      //     curve: Curves.linearToEaseOut);
                    } else {
                      setState(() {
                        idMetodePengiriman = index + 1;
                        //debugPrint(
                        // 'isi idMetodePengiriman saat ini adalah = ${idMetodePengiriman.toString()}');
                        //debugPrint("isi index adalah = ${index.toString()}");
                      });
                    }
                  },
                )
              ],
            ),
            SizedBox(height: 9),
            Container(
                padding: EdgeInsets.only(left: 7, right: 7),
                child: idMetodePengiriman == 1
                    ? widget.alamatPengambilan != null
                        ? Container(
                            child: ListTile(
                            leading: Icon(Icons.location_on),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tempat Pengambilan :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.red[800])),
                                SizedBox(height: 5),
                                Text(widget.alamatPengambilan,
                                    style: TextStyle(
                                        letterSpacing: 0.75,
                                        fontSize: 16,
                                        color: Colors.black)),
                              ],
                            ),
                          ))
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.amber[200],
                            ),
                            padding: EdgeInsets.only(
                                left: 7, right: 7, top: 7, bottom: 7),
                            child: Column(
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 65),
                                Text(
                                    'Penjual tidak mencantumkan alamat pengambilan barang.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red[800])),
                                SizedBox(height: 13),
                                Text('Silahkan hubungi penjual',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red[800])),
                                SizedBox(height: 3),
                                SizedBox(
                                    width: 275,
                                    height: 57,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(9),
                                                topLeft: Radius.circular(9),
                                                bottomLeft: Radius.circular(9),
                                                bottomRight:
                                                    Radius.circular(9))),
                                      ),
                                      // color: Colors.green[700],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "lib/assets/whatsapp.png",
                                            width: 35,
                                            height: 35,
                                          ),
                                          SizedBox(width: 7),
                                          Text(
                                            "Tanyakan Alamat",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.only(
                                      //         topRight: Radius.circular(9),
                                      //         topLeft: Radius.circular(9),
                                      //         bottomLeft: Radius.circular(9),
                                      //         bottomRight: Radius.circular(9))),
                                      onPressed: () async {},
                                    )),
                              ],
                            ))
                    : Container(
                        child: ListTile(
                            leading: Icon(Icons.home),
                            title: TextField(
                              // autofocus: true,
                              controller: isianAlamat,
                              // keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Alamat Pengiriman :",
                                labelStyle: TextStyle(
                                    fontSize: 17, color: Colors.red[800]),
                              ),
                            ))))
          ],
        ),
      ),
    );
  }

  Widget detailPesanan() {
    return Card(
      elevation: 7,
      child: Container(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Pesanan',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            ListTile(
              dense: true,
              leading: Image.network(widget.gambar,
                  fit: BoxFit.cover, width: 50, height: 50),
              title: Text(widget.description,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              subtitle: Text(rupiah(widget.price),
                  style: TextStyle(color: Colors.red)),
            ),
            // SizedBox(height: 7),
            ListTile(
                leading: Text(
                  'jumlah',
                  style: TextStyle(color: Colors.red),
                ),
                title: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 41,
                      width: 159,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.blue[800]),
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
                                if (jumlah > 0) {
                                  setState(() {
                                    jumlah =
                                        int.parse(isianJumlahBarang.text) - 1;

                                    isianJumlahBarang.text = jumlah.toString();

                                    totalHarga = hargaSatuan * jumlah;
                                  });
                                }
                              },
                              child: Container(
                                height: 41,
                                width: double.infinity,
                                child: Center(
                                  child: Text('-',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 21)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            // onTap: () {
                            //   popupJumlahBarang();
                            // },

                            //Stok indikator biasa (sebelum tanggal 8 may 2021)
                            // child: Container(
                            //     height: 25,
                            //     width: 37,
                            //     decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.circular(9)),
                            //     child: Center(child: Text(jumlah.toString()))),

                            child: Container(
                              color: Colors.white,
                              height: 25,
                              width: 37,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: isianJumlahBarang,
                                autofocus: autoFocusIsianJumlah,
                                focusNode: focusNode,
                                // keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blue[800]),
                                // decoration: InputDecoration(),

                                onChanged: (isian) {
                                  if (int.parse(isian) > widget.stok) {
                                    popUpMelebihiStok();
                                  } else if (isian == "") {
                                    setState(() {
                                      isianJumlahBarang.text = "0";
                                    });
                                  } else if (int.parse(isian) <= widget.stok) {
                                    //debugPrint("amaaannnnn");
                                    setState(() {
                                      jumlah = int.parse(isian);
                                      totalHarga =
                                          int.parse(widget.price) * jumlah;
                                    });
                                  } else {
                                    setState(() {
                                      isianJumlahBarang.text = "0";
                                    });
                                  }
                                },

                                onTap: () {
                                  focusNode.requestFocus();
                                  _scrollController.animateTo(
                                      _scrollController.position.pixels + 455,
                                      duration: Duration(milliseconds: 2701),
                                      curve: Curves.linearToEaseOut);

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
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                _canVibrate
                                    ? Vibration.vibrate(
                                        pattern: [0, 75],
                                      )
                                    : null;
                                if (int.parse(isianJumlahBarang.text) <
                                    widget.stok) {
                                  setState(() {
                                    jumlah =
                                        int.parse(isianJumlahBarang.text) + 1;

                                    isianJumlahBarang.text = jumlah.toString();

                                    totalHarga = hargaSatuan * jumlah;
                                  });
                                } else if (int.parse(isianJumlahBarang.text) ==
                                    widget.stok) {
                                  popUpMelebihiStok();
                                }
                              },
                              child: Container(
                                height: 41,
                                width: double.infinity,
                                child: Center(
                                  child: Text('+',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 21)),
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
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w500)),
                    )
                  ],
                )),
            ListTile(
                leading: Text(
                  'catatan',
                  style: TextStyle(color: Colors.red),
                ),
                title: catatanPembeli == 'tidak ada catatan'
                    ? Center(
                        child: InkWell(
                          child: Text(
                            'Tambahkan catatan',
                            style: TextStyle(
                                color: Colors.blue[800],
                                decoration: TextDecoration.underline),
                          ),
                          onTap: () {
                            popupCatatan();
                          },
                        ),
                      )
                    : Text(catatanPembeli),
                trailing: catatanPembeli != 'tidak ada catatan'
                    ? InkWell(
                        onTap: () {
                          popupCatatan();
                        },
                        child: Text(
                          'Ubah',
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      )
                    : SizedBox())
          ],
        ),
      ),
    );
  }

  popupAlamatPenerima() {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      animationDuration: Duration(milliseconds: 413),
      // isCloseButton: true,
      isOverlayTapDismiss: true,
    );

    Alert(
        title: "Masukkan Alamat Pengiriman",
        style: alertStyle,
        closeFunction: () {},
        context: context,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: isianAlamat,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Alamat pengiriman",
                labelStyle: TextStyle(fontSize: 17),
                icon: Icon(Icons.home),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.blue[800],
            child: Text("Konfirmasi", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              setState(() {
                isianAlamat.text = isianAlamat.text;
                // alamatPenerima = isianAlamat.text;
              });
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  popupJumlahBarang() {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      animationDuration: Duration(milliseconds: 413),
      // isCloseButton: true,
      isOverlayTapDismiss: true,
    );

    Alert(
        title: "Masukkan Jumlah Barang",
        style: alertStyle,
        closeFunction: () {},
        context: context,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              autofocus: true,
              controller: isianJumlahBarang,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "jumlah barang:",
                labelStyle: TextStyle(fontSize: 17),
                icon: Icon(Icons.home),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.blue[800],
            child: Text("Konfirmasi", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              if (int.parse(isianJumlahBarang.text) > widget.stok) {
                // Alert(
                //         type: AlertType.error,
                //         title:
                //             "Maaf angka yang dimasukkan melebihi stok yang tersedia",
                //         context: context,
                //         closeFunction: () {},
                //         content: Text(
                //             "jumlah stok yang tersedia : ${widget.stok.toString()}"))
                //     .show();

                Alert(
                    type: AlertType.error,
                    context: context,
                    title: "Transaksi gagal",
                    desc:
                        "Pembelian barang gagal, silahkan cek kembali PIN anda",
                    buttons: [
                      DialogButton(
                        color: Colors.blue[800],
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      )
                    ]).show();
              } else {
                setState(() {
                  jumlah = int.parse(isianJumlahBarang.text);
                  totalHarga = hargaSatuan * jumlah;
                  // alamatPenerima = isianAlamat.text;
                });
              }
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  popupNamaPenerima() {
    // if(catatanPembeli != ' '){
    //   isianCatatan.text = catatanPembeli;
    // }

    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      animationDuration: Duration(milliseconds: 413),
      // isCloseButton: true,
      isOverlayTapDismiss: true,
    );

    Alert(
        title: "Masukkan Informasi Penerima",
        style: alertStyle,
        closeFunction: () {},
        context: context,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: isianCatatan,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nama",
                labelStyle: TextStyle(fontSize: 17),
                icon: Icon(Icons.person),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.blue[800],
            child: Text("Ubah", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              setState(() {
                namaPenerima = isianCatatan.text;
                // alamatPenerima = isianAlamat.text;
              });
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  popupNohape() {
    TextEditingController isianCatatan = TextEditingController();

    if (catatanPembeli != ' ') {
      isianCatatan.text = catatanPembeli;
    }

    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      animationDuration: Duration(milliseconds: 413),
      // isCloseButton: true,
      isOverlayTapDismiss: true,
    );

    Alert(
        title: "Masukkan No.HP Penerima",
        style: alertStyle,
        closeFunction: () {},
        context: context,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: isianNohape,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "No. HP",
                labelStyle: TextStyle(fontSize: 25),
                icon: Icon(Icons.assignment),
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.blue[800],
            child: Text("Ubah", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              setState(() {
                noHapePenerima = isianNohape.text;
              });
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  popupCatatan() {
    TextEditingController isianCatatan = TextEditingController();

    if (catatanPembeli != 'tidak ada catatan') {
      isianCatatan.text = catatanPembeli;
    }

    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      animationDuration: Duration(milliseconds: 413),
      // isCloseButton: true,
      isOverlayTapDismiss: true,
    );

    Alert(
        title: "Catatan untuk penjual",
        style: alertStyle,
        closeFunction: () {},
        context: context,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: isianCatatan,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Catatan",
                labelStyle: TextStyle(fontSize: 25),
                icon: Icon(Icons.assignment),
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.blue[800],
            child: Text("Tambahkan", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              setState(() {
                catatanPembeli = isianCatatan.text;
              });
              Navigator.pop(context);
            },
          )
        ]).show();
  }

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
