import 'package:flutter/material.dart';
import 'package:Edimu/UI/Marketplace/detailItem_page.dart';
import 'package:Edimu/models/ads_model.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:scoped_model/scoped_model.dart';

class Komoditas_page extends StatefulWidget {
  MainModel model;
  Komoditas_page(this.model);

  @override
  _Komoditas_pageState createState() => _Komoditas_pageState();
}

class _Komoditas_pageState extends State<Komoditas_page> {
  List listKomunitas = ListBarang.listBarang_pangan;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          backgroundColor: Warna.hijauBG2,
          appBar: AppBar(
            title: Text("Pasar Komoditas"),
            backgroundColor: hijauMain,
            centerTitle: true,
          ),
          body: comingSoon());
    });
  }

  Widget comingSoon() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Segera',
          style: TextStyle(
              fontSize: 53,
              color: Colors.grey[800],
              fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 7),
        Text(
          'Hadir',
          style: TextStyle(
              fontSize: 53,
              color: Colors.grey[800],
              fontWeight: FontWeight.w900),
        ),
      ],
    ));
  }

  Widget barangKomoditasDummy() {
    return Padding(
      padding: const EdgeInsets.only(top: 11),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1),
          padding: EdgeInsets.only(left: 5, right: 5),
          itemCount: listKomunitas.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => detailItemPage(
                            widget.model,
                            listKomunitas[index]["nama_barang"],
                            listKomunitas[index]["harga_barang"],
                            listKomunitas[index]["id_penjual"],
                            listKomunitas[index]["nama_penjual"],
                            listKomunitas[index]["deskripsi_barang"],
                            "Umum",
                            listKomunitas[index]["foto_barang"],
                            widget.model.namaKomunitas,
                            15,
                            '30501070008',
                            '087859770756',
                            75,
                            'ini waktu',
                            'ini tempat pengambilan',
                            'ini nama toko',
                            999)),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 7,
                  child: Container(
                    height: 11250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 161,
                          child: Image.network(
                            listKomunitas[index]["fotoBarang"],
                            fit: BoxFit.cover,
                            height: 101,
                            alignment: Alignment.center,
                          ),
                        ),
                        Container(
                          width: 160.0,
                          height: 61.0,
                          padding: EdgeInsets.all(7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            // mainAxisAlignment: MainAxisAlignment.,
                            children: <Widget>[
                              // Container(height: 10,),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 0,
                                ),
                                child: Text(
                                  listKomunitas[index]["namaBarang"],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: 3,
                                  ),
                                  child: Text(
                                    "Harga : " +
                                        rupiah(listKomunitas[index]
                                            ["hargaBarang"]),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.pinkAccent),
                                  )),
                              // Expanded(
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.start,
                              //     mainAxisSize: MainAxisSize.max,
                              //     children: [
                              //       Icon(
                              //         Icons.location_on,
                              //         size: 19,
                              //       ),
                              //       Text(
                              //           listKomunitas[index]
                              //               ["lokasiBarang"],
                              //           style: TextStyle(fontSize: 12))
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
