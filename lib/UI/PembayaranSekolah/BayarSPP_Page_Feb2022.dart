import 'package:Edimu/UI/PembayaranSekolah/RiwayatSpp_Page.dart';
import 'package:Edimu/Widgets/EasyLoadingWidgget.dart';
import 'package:Edimu/Widgets/PopupSaldoTidakCukup.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BayarSPPPageFebruari2022 extends StatefulWidget {
  MainModel model;
  BayarSPPPageFebruari2022(this.model);
  //
  @override
  _BayarSPPPageFebruari2022State createState() =>
      _BayarSPPPageFebruari2022State();
}

class _BayarSPPPageFebruari2022State extends State<BayarSPPPageFebruari2022> {
  Map dataSiswa = {};
  List listTagihanTerpilih = [];
  int totalTagihanTerpilih = 0;
  //
  var isianPin = TextEditingController();
  //
  double lebarTombol = 0;

  @override
  void initState() {
    if (widget.model.dataSiswa.length == 1) {
      dataSiswa = widget.model.dataSiswa[0];
      widget.model.listTagihanSekolah.forEach((item) {
        item["detailtagihan"].forEach((item2) {
          if (item2["apakahDipilih"]) {
            listTagihanTerpilih.add(item2);
          }
        });
      });
    }

    //debugPrint("isi widget.model.listTagihan");
    //debugPrint(widget.model.listTagihanSekolah.toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lebarTombol = MediaQuery.of(context).size.width - 65;
    if (dataSiswa.length == 0) {
      Future.delayed(Duration.zero, () => showPilihAnak());
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Bayar SPP"),
          centerTitle: true,
          actions: widget.model.dataSiswa.length > 1
              ? [
                  InkWell(
                    onTap: () {
                      showPilihAnak();
                    },
                    child: Container(
                      width: 65,
                      padding: EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 31,
                          )
                        ],
                      ),
                    ),
                  )
                ]
              : [],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    viewDataSiswa(widget.model),
                    SizedBox(
                      height: 25,
                    ),
                    lihatRiwayat(),
                    SizedBox(
                      height: 5,
                    ),
                    viewListTagihan(widget.model),
                    SizedBox(
                      height:
                          widget.model.listTagihanSekolah.length > 0 ? 155 : 0,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: tombolBayar(),
              ),
            )
          ],
        ));
  }

  Widget lihatRiwayat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RiwayatPembayaranSekolahFebruari2022(widget.model,
                  dataSiswa["id_siswa"], dataSiswa["nama"], dataSiswa["kelas"]);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            child: Text(
              "lihat riwayat",
              style: TextStyle(
                  color: Warna.accent,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget tombolBayar() {
    totalTagihanTerpilih = 0;
    listTagihanTerpilih.forEach((item) {
      totalTagihanTerpilih += item["jumlah"];
    });
    //
    return InkWell(
      onTap: () {
        int _totalBayar = 0;
        //
        listTagihanTerpilih.forEach((item) {
          _totalBayar += item["jumlah"];
        });
        //
        if (int.parse(widget.model.formatedBalance) >= _totalBayar) {
          showPopupPin();
        } else {
          alertSaldoTidakCukup(context);
        }
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 411),
          height: 65,
          width: listTagihanTerpilih.length > 0 ? lebarTombol : 0,
          decoration: BoxDecoration(
              color: Warna.accent, borderRadius: BorderRadius.circular(9)),
          child: Container(
            width: lebarTombol,
            padding: EdgeInsets.symmetric(horizontal: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Bayar",
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
                Spacer(
                  flex: 1,
                ),
                Text(
                  "${rupiah(totalTagihanTerpilih)}",
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
                Icon(
                  Icons.navigate_next_rounded,
                  color: Colors.white,
                  size: 35,
                )
              ],
            ),
          )),
    );
  }

  Widget viewListTagihan(MainModel model) {
    List _filteredListTagihan = model.listTagihanSekolah
        .where((item) => item["id_siswa"] == dataSiswa["id_siswa"])
        .toList();

    if (_filteredListTagihan.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 15),
          itemCount: _filteredListTagihan.length,
          itemBuilder: (context, index) {
            List _listDetailPerbulan =
                _filteredListTagihan[index]["detailtagihan"];
            //
            String _bulan = _filteredListTagihan[index]["bulan"];
            String _tahun = _filteredListTagihan[index]["tahun"];
            String _tagihanPerbulan = _filteredListTagihan[index]
                    ["totaltagihan"]
                .replaceAll(".00", "");

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  // padding: EdgeInsets.only(bottom: 15),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Warna.primary,
                            ),
                            SizedBox(
                              width: 11,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [Text("$_bulan"), Text("$_tahun")],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          rupiah(_tagihanPerbulan),
                          style: TextStyle(
                              color: Colors.orange[900],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Container(
                        height: _listDetailPerbulan.length * 55.0,
                        child: Center(
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _listDetailPerbulan.length,
                              itemBuilder: (context, index2) {
                                //
                                return InkWell(
                                  onTap: () {
                                    if (!_listDetailPerbulan[index2]
                                        ["apakahDipilih"]) {
                                      listTagihanTerpilih
                                          .add(_listDetailPerbulan[index2]);
                                    } else {
                                      listTagihanTerpilih.removeWhere((item) =>
                                          item["id_tagihan"] ==
                                          _listDetailPerbulan[index2]
                                              ["id_tagihan"]);
                                    }

                                    _listDetailPerbulan[index2]
                                            ["apakahDipilih"] =
                                        !_listDetailPerbulan[index2]
                                            ["apakahDipilih"];
                                    setState(() {});

                                    //debugPrint("isi listTagihanTerpilih :");
                                    //debugPrint(listTagihanTerpilih.toString());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 11),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Text(
                                                _listDetailPerbulan[index2]
                                                    ["nama_kategori"]),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(rupiah(
                                                  _listDetailPerbulan[index2]
                                                      ["jumlah"])),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                _listDetailPerbulan[index2]
                                                        ["apakahDipilih"]
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank_outlined,
                                                color: Warna.accent,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } else if (dataSiswa.length > 0 && _filteredListTagihan.length == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 155),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_sharp,
                size: 97,
                color: Colors.green[600],
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                child: Text(
                  "Tagihan telah lunas",
                  style: TextStyle(fontSize: 19),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget viewDataSiswa(MainModel model) {
    if (dataSiswa.length > 0) {
      int _totalTagihanPerSiswa = 0;
      String _kelas = dataSiswa['kelas'] ?? '....';
      //
      model.listTagihanSekolah.forEach((item) {
        if (item["id_siswa"] == dataSiswa["id_siswa"]) {
          _totalTagihanPerSiswa +=
              int.parse(item["totaltagihan"].replaceAll(".00", ""));
        }
      });
      //
      return Container(
        decoration: BoxDecoration(
            color: Colors.amber[200], borderRadius: BorderRadius.circular(9)),
        padding: EdgeInsets.all(15),
        width: 291,
        child: Column(
          children: [
            Text(
              dataSiswa['nama'] ?? "......",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 0,
            ),
            Text("kelas " + _kelas,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600])),
            SizedBox(
              height: 11,
            ),
            Text("total tagihan sekolah :"),
            SizedBox(
              height: 5,
            ),
            Container(
              child: _totalTagihanPerSiswa == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Lunas",
                            style: TextStyle(
                                fontSize: 29,
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.check_circle_sharp,
                          size: 27,
                          color: Colors.green[600],
                        )
                      ],
                    )
                  : Text(
                      rupiah(_totalTagihanPerSiswa),
                      style: TextStyle(
                          fontSize: 29,
                          color: Colors.orange[900],
                          fontWeight: FontWeight.bold),
                    ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  showPopupPin() {
    Alert(
        context: context,
        title: "silahkan masukkan pin:",
        closeFunction: () {},
        content: Container(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Icon(
                  Icons.lock,
                  size: 71,
                  color: Warna.primary,
                ),
                TextField(
                  autofocus: true,
                  controller: isianPin,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                )
              ],
            ),
          ),
        ),
        buttons: [
          DialogButton(
              color: Colors.red[800],
              child: Text(
                "batal",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          DialogButton(
              color: Warna.accent,
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                EasyLoading.show(
                  status: 'sedang diproses',
                  maskType: EasyLoadingMaskType.black,
                  dismissOnTap: true,
                );
                //
                String respon = await widget.model
                    .bayarTagihanSekolah(isianPin.text, listTagihanTerpilih);
                //
                if (respon == "sukses") {
                  Alert(
                      context: context,
                      title: "Berhasil",
                      type: AlertType.success,
                      desc: "pembayaran sekolah berhasil",
                      closeFunction: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      buttons: [
                        DialogButton(
                            color: Warna.accent,
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              //
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RiwayatPembayaranSekolahFebruari2022(
                                    widget.model,
                                    dataSiswa["id_siswa"],
                                    dataSiswa["nama"],
                                    dataSiswa["kelas"]);
                              }));
                            })
                      ]).show();
                } else if (respon == "pin salah") {
                  Alert(
                      context: context,
                      type: AlertType.error,
                      title: "pin salah",
                      desc: "silahkan masukkan PIN yang benar",
                      buttons: [
                        DialogButton(
                            child: Text(
                              "coba lagi",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ]).show();
                } else {
                  Alert(
                      context: context,
                      title: "Gagal",
                      type: AlertType.error,
                      desc: "pembayaran sekolah belum berhasil",
                      closeFunction: () {
                        Navigator.pop(context);
                      },
                      buttons: [
                        DialogButton(
                            color: Colors.red[800],
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
              })
        ]).show();
  }

  showPilihAnak() async {
    Future.delayed(Duration(milliseconds: 251));
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text("Silahkan pilih siswa:"),
                  SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 65),
                    child: Divider(
                      color: Warna.primary,
                      thickness: 2.5,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: widget.model.dataSiswa.length < 5
                          ? (85 * widget.model.dataSiswa.length.toDouble())
                          : (85 * 4.0),
                      child: ListView.builder(
                          itemCount: widget.model.dataSiswa.length,
                          itemBuilder: (context, index) {
                            int totalTagihanPerAnak = 0;
                            widget.model.listTagihanSekolah.forEach((item) {
                              if (item["id_siswa"] ==
                                  widget.model.dataSiswa[index]["id_siswa"]) {
                                totalTagihanPerAnak += int.parse(
                                    item["totaltagihan"].replaceAll(".00", ""));
                              }
                            });
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                elevation: 7,
                                child: ListTile(
                                  onTap: () {
                                    listTagihanTerpilih = [];
                                    dataSiswa = widget.model.dataSiswa[index];
                                    //
                                    widget.model.listTagihanSekolah
                                        .forEach((item) {
                                      if (item["id_siswa"] ==
                                          dataSiswa["id_siswa"]) {
                                        item["detailtagihan"].forEach((item2) {
                                          if (item2["apakahDipilih"]) {
                                            listTagihanTerpilih.add(item2);
                                          }
                                        });
                                      }
                                    });
                                    //
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  // leading: Icon(Icons.person),
                                  title: Text(
                                    widget.model.dataSiswa[index]["nama"],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  trailing: totalTagihanPerAnak == 0
                                      ? Container(
                                          width: 75,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "lunas",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            ],
                                          ),
                                        )
                                      : Text(
                                          rupiah(totalTagihanPerAnak),
                                          style: TextStyle(
                                              color: Colors.orange[900],
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => homePage(widget.model)),
                      // );
                    },
                    child: Text('Kembali', style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
