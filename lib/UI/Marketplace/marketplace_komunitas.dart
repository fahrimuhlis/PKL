import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Edimu/UI/Marketplace/detailItem_page.dart';
import 'package:Edimu/models/ads_model.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:scoped_model/scoped_model.dart';

class marketPlacePage extends StatefulWidget {
  MainModel model;
  marketPlacePage(this.model);

  @override
  _marketPlacePageState createState() => _marketPlacePageState();
}

class _marketPlacePageState extends State<marketPlacePage> {
  List listKomunitas = ListBarang.listBarang_komunitas;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          backgroundColor: Warna.hijauBG2,
          appBar: AppBar(
            title: Text("Pasar Komunitas"),
            backgroundColor: hijauMain,
            centerTitle: true,
          ),
          body: listBarang212mart());
    });
  }

  Widget listBarang212mart() {
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

  // Widget kumpulanBarangDummy() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: 11),
  //     child: GridView.builder(
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //         ),
  //         padding: EdgeInsets.only(left: 5, right: 5),
  //         itemCount: listKomunitas.length,
  //         itemBuilder: (context, index) {
  //           return Container(
  //             height: 1150,
  //             width: 235,
  //             child: InkWell(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => detailItemPage(
  //                           widget.model,
  //                           listKomunitas[index]["nama_barang"],
  //                           listKomunitas[index]["harga_barang"],
  //                           listKomunitas[index]["id_penjual"],
  //                           listKomunitas[index]["nama_penjual"],
  //                           listKomunitas[index]["deskripsi_barang"],
  //                           "Umum",
  //                           listKomunitas[index]["foto_barang"],
  //                           widget.model.namaKomunitas,
  //                           15,
  //                           '30501070008',
  //                           '087859770756',
  //                           75, 'iniwaktu', 'ini alamat pengambilan')),
  //                 );
  //               },
  //               child: Card(
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(11)),
  //                 semanticContainer: true,
  //                 clipBehavior: Clip.antiAliasWithSaveLayer,
  //                 elevation: 5,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   // mainAxisAlignment: MainAxisAlignment.,
  //                   children: <Widget>[
  //                     Container(
  //                       height: 101,
  //                       width: double.infinity,
  //                       child: Image.network(
  //                         listKomunitas[index]["fotoBarang"],
  //                         fit: BoxFit.cover,
  //                         alignment: Alignment.center,
  //                       ),
  //                     ),
  //                     // Container(height: 10,),
  //                     Container(
  //                       margin: EdgeInsets.only(top: 5, left: 5),
  //                       child: Text(
  //                         listKomunitas[index]["namaBarang"],
  //                         style: TextStyle(fontSize: 14),
  //                       ),
  //                     ),
  //                     Container(
  //                         margin: EdgeInsets.only(top: 3, left: 5),
  //                         child: Text(
  //                           rupiah(listKomunitas[index]["hargaBarang"]),
  //                           style:
  //                               TextStyle(fontSize: 12, color: Colors.red[800]),
  //                         )),
  //                     // Container(
  //                     //   child: Row(
  //                     //     mainAxisAlignment: MainAxisAlignment.start,
  //                     //     mainAxisSize: MainAxisSize.max,
  //                     //     children: [
  //                     //       Icon(
  //                     //         Icons.location_on,
  //                     //         size: 19,
  //                     //       ),
  //                     //       Text(listKomunitas[index]["lokasiBarang"],
  //                     //           style: TextStyle(fontSize: 12))
  //                     //     ],
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }
}
