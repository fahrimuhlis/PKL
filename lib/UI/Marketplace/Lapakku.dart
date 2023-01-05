import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/Marketplace/EditLapak_Page.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:indonesia/indonesia.dart';

class Lapakku extends StatefulWidget {
  MainModel model;

  Lapakku(this.model);

  @override
  _LapakkuState createState() => _LapakkuState();
}

class _LapakkuState extends State<Lapakku> {
  List masterListLapak = [];
  List listLapakku = [];
  List listBarangKosong = [];
  var searchController = TextEditingController();

  @override
  void initState() {
    getLapakku();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Lapak Saya"),
              centerTitle: true,
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicator: BoxDecoration(
                      color: Warna.accent,
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.white,
                              width: 3,
                              style: BorderStyle.solid))),
                  tabs: [
                    Tab(
                      text: "Semua",
                    ),
                    Tab(
                      text: "Habis(${listBarangKosong.length})",
                    )
                  ]),
            ),
            body: TabBarView(
              children: [tabSemuaLapak(), tabStokHabis()],
            )));
  }

  Widget tabSemuaLapak() {
    return RefreshIndicator(
      onRefresh: () async {
        getLapakku();
      },
      child: Container(
        padding: EdgeInsets.all(11),
        child: masterListLapak.length < 1
            ? Center(
                child: Text("Kamu belum punya lapak"),
              )
            : Container(
                child: ListView(
                // shrinkWrap: true,
                children: [
                  searchBar(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listLapakku.length,
                    itemBuilder: (context, index) {
                      //debugPrint("index ALL-LAPAK ke-${index}");
                      return Card(
                        child: ListTile(
                            title: Text(listLapakku[index]["nama_barang"]),
                            subtitle: Text(
                                rupiah(listLapakku[index]['harga_barang'])),
                            trailing: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor:Warna.accent, ),
                                // color: Warna.accent,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditLapak_Page(
                                              widget.model,
                                              listLapakku[index]['id_barang'],
                                              listLapakku[index]['nama_barang'],
                                              listLapakku[index]
                                                  ['deskripsi_barang'],
                                              listLapakku[index]
                                                  ['harga_barang'],
                                              listLapakku[index]['stok_barang']
                                                  .toString(),
                                              listLapakku[index]['id_kategori'],
                                              listLapakku[index]
                                                  ['foto_barang'])));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "ubah",
                                  style: TextStyle(color: Colors.white),
                                ))),
                      );
                    },
                  ),
                ],
              )),
      ),
    );
  }

  Widget tabStokHabis() {
    return Container(
      padding: EdgeInsets.all(11),
      child: listBarangKosong.length < 1
          ? Center(
              child: Text("Tidak ada barang yang Habis/Kosong"),
            )
          : Container(
              child: ListView(
              // shrinkWrap: true,
              children: [
                // searchBar(),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text(
                    "Barang yang habis",
                    style: TextStyle(color: Colors.red[800], fontSize: 27),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listBarangKosong.length,
                    itemBuilder: (context, index) {
                      // //debugPrint("isi ['stok_barang'] :");
                      // //debugPrint(
                      //     masterListLapak[index]["stok_barang"].toString());
                      //debugPrint("index ke-${index}");
                      //debugPrint(
                          // "isi masterlistlapak (${listBarangKosong.length} baris): ");
                      //debugPrint(listBarangKosong.toString());

                      return cardBarangHabis(index);
                    }),
              ],
            )),
    );
  }

  Widget cardBarangHabis(index) {
    if (listBarangKosong[index]["stok_barang"] == 0) {
      return Card(
        child: ListTile(
            title: Text(listBarangKosong[index]["nama_barang"]),
            subtitle: Text(rupiah(listBarangKosong[index]['harga_barang'])),
            trailing: ElevatedButton.icon(
               style: ElevatedButton.styleFrom(backgroundColor:Colors.red[800], ),
                // color: Colors.red[800],
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditLapak_Page(
                              widget.model,
                              listBarangKosong[index]['id_barang'],
                              listBarangKosong[index]['nama_barang'],
                              listBarangKosong[index]['deskripsi_barang'],
                              listBarangKosong[index]['harga_barang'],
                              listBarangKosong[index]['stok_barang'].toString(),
                              listBarangKosong[index]['id_kategori'],
                              listBarangKosong[index]['foto_barang'])));
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                label: Text(
                  "ubah",
                  style: TextStyle(color: Colors.white),
                ))),
      );
    } else {
      return Container();
    }
  }

  Widget searchBar() {
    return TextField(
      onChanged: (text) {
        if (text.length > 0) {
          text = text.toLowerCase();

          setState(() {
            listLapakku = masterListLapak.where((item) {
              var namaBarang = item["nama_barang"].toLowerCase();
              return namaBarang.contains(text);
            }).toList();
          });
        } else {
          setState(() {
            listLapakku = masterListLapak;
          });
        }
      },
      controller: searchController,
      decoration: InputDecoration(
          labelText: "Search",
          hintText: "Cari Barang",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
    );
  }

  void getLapakku() async {
    masterListLapak = [];
    listLapakku = [];
    listBarangKosong = [];
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    listLapakku = await widget.model.getLapakku();
    masterListLapak = listLapakku;

    masterListLapak.forEach((item) {
      if (item["stok_barang"] < 1) {
        listBarangKosong.add(item);
      }
    });

    if (listLapakku.length > 0) {
      setState(() {});
    }

    EasyLoading.dismiss();
  }
}
