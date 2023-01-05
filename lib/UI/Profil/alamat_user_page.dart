import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/UI/Profil/tambah_alamat.dart';
import 'package:Edimu/UI/Profil/edit_alamat.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DaftarAlamatUserPage extends StatefulWidget {
  final MainModel model;
  //
  DaftarAlamatUserPage(this.model);

  @override
  State<DaftarAlamatUserPage> createState() => _DaftarAlamatUserPageState();
}

class _DaftarAlamatUserPageState extends State<DaftarAlamatUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Alamat'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          detailAlamat()
        ],
      ),
    );
  }

  Widget tombolTambalAlamat() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: TextButton(
          child: Text(
            'Tambah Alamat',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
                decoration: TextDecoration.underline),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailAlamatPage(widget.model)));
          },
        ),
      ),
    );
  }

  Widget detailAlamat() {
    return widget.model.alamatUser == ""
        ? Container()
        : Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(
                    color: Colors.lightGreen,
                    width: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(7)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.model.nama),
                SizedBox(height: 5),
                Text(widget.model.nohapeAktif,
                    style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                        fontSize: 14)),
                SizedBox(height: 5),
                Text(
                  widget.model.alamatUser,
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditAlamatPage(widget.model)));
                      // Alert(
                      //     context: context,
                      //     type: AlertType.warning,
                      //     title:
                      //         "Apakah Anda yakin ingin mengubah alamat tujuan pengiriman ini?",
                      //     buttons: [
                      //       DialogButton(
                      //         color: Colors.red,
                      //         child: Text(
                      //           "Tidak",
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //         },
                      //       ),
                      //       DialogButton(
                      //         color: Colors.blue[700],
                      //         child: Text(
                      //           "YA",
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       EditAlamatPage(widget.model)));
                      //         },
                      //       )
                      //     ]).show();
                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: Center(
                        child: Text(
                          'Ubah Alamat',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ),
                    )),
              ],
            ));
  }
}
