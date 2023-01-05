import 'package:Edimu/Widgets/EasyLoadingWidgget.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:indonesia/indonesia.dart';
import 'package:scoped_model/scoped_model.dart';

class RiwayatPembayaranSekolahFebruari2022 extends StatefulWidget {
  MainModel model;
  String idSiswa;
  String namaSiswa;
  String kelasSiswa;
  //
  RiwayatPembayaranSekolahFebruari2022(
      this.model, this.idSiswa, this.namaSiswa, this.kelasSiswa);
  @override
  _RiwayatPembayaranSekolahFebruari2022State createState() =>
      _RiwayatPembayaranSekolahFebruari2022State();
}

class _RiwayatPembayaranSekolahFebruari2022State
    extends State<RiwayatPembayaranSekolahFebruari2022> {
  List listRiwayatPembayaranSekolah = [];
  String namaSiswa = "";
  String kelas = "";
  @override
  void initState() {
    getRiwayatSekolah();
    super.initState();
  }

  void getRiwayatSekolah() async {
    EasyLoading.show(
      status: 'sedang diproses',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
    await widget.model.getRiwayatPembayaranSekolahFebruari2022();
    //
    listRiwayatPembayaranSekolah = widget.model.listRiwayatPembayaranSekolah
        .where((element) => element["id_siswa"] == widget.idSiswa)
        .toList();
    //
    namaSiswa = widget.namaSiswa;
    kelas = widget.kelasSiswa;
    //
    //debugPrint("isi listRiwayatPebayaranSekolah :");
    //debugPrint(listRiwayatPembayaranSekolah.toString());
    //
    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Riwayat Pembayaran"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) =>
              SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  viewDataSiswa(),
                  SizedBox(
                    height: 35,
                  ),
                  viewListRiwayat(model)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget viewDataSiswa() {
    //
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Warna.accent, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Icon(
                Icons.person,
                color: Warna.accent,
                size: 55,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  child: Text(
                    namaSiswa,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "kelas " + kelas,
                    style: TextStyle(color: Warna.accent),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget viewListRiwayat(MainModel model) {
    if (listRiwayatPembayaranSekolah.length > 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: listRiwayatPembayaranSekolah.length,
            itemBuilder: (BuildContext context, int index) {
              List _listDetailPerbulan =
                  listRiwayatPembayaranSekolah[index]["detailtagihan"];
              //
              String _bulan =
                  listRiwayatPembayaranSekolah[index]["bulan_bayar"];
              String _tahun =
                  listRiwayatPembayaranSekolah[index]["tahun_bayar"];

              //
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Card(
                  elevation: 15,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 21,
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Warna.primary,
                        ),
                        SizedBox(
                          width: 21,
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
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: _listDetailPerbulan.length,
                          itemBuilder: (BuildContext context2, int index2) {
                            return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 21),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(_listDetailPerbulan[index2]
                                          ["nama_kategori"]),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            rupiah(_listDetailPerbulan[index2]
                                                ["jumlah"]),
                                            style: TextStyle(
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            width: 11,
                                          ),
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green[700],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ));
                          })
                    ],
                  ),
                ),
              );
            }),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Belum ada riwayat pembayaran")],
        ),
      );
    }
  }

  Widget viewRiwayatKosong() {
    return Container(
      child: Center(
        child: Text("Riwayat Kosong"),
      ),
    );
  }
}

getNamaBulan(angkaBulan) {
  if (angkaBulan == 1 || angkaBulan == 01 || angkaBulan == 'JAN') {
    return "Januari";
  } else if (angkaBulan == 2 || angkaBulan == 02 || angkaBulan == 'FEB') {
    return "Februari";
  } else if (angkaBulan == 3 || angkaBulan == 03 || angkaBulan == 'MAR') {
    return "Maret";
  } else if (angkaBulan == 4 || angkaBulan == 04 || angkaBulan == 'APR') {
    return "April";
  } else if (angkaBulan == 5 || angkaBulan == 05 || angkaBulan == 'MAY' || angkaBulan == 'MEI') {
    return "Mei";
  } else if (angkaBulan == 6 || angkaBulan == 06 || angkaBulan == 'JUN') {
    return "Juni";
  } else if (angkaBulan == 7 || angkaBulan == 07 || angkaBulan == 'JUL') {
    return "Juli";
  } else if (angkaBulan == 8 || angkaBulan == 08 || angkaBulan == 'AUG' || angkaBulan == 'AGU') {
    return "Agustus";
  } else if (angkaBulan == 9 || angkaBulan == 09 || angkaBulan == 'SEP') {
    return "September";
  } else if (angkaBulan == 10 || angkaBulan == 'OCT' || angkaBulan == 'OKT') {
    return "Oktober";
  } else if (angkaBulan == 11 || angkaBulan == 'NOV') {
    return "November";
  } else if (angkaBulan == 12 || angkaBulan == 'DEC' || angkaBulan == 'DES') {
    return "Desember";
  }
}
