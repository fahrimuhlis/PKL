import 'package:Edimu/Widgets/IconMenu.dart';
import 'package:flutter/material.dart';
import 'package:Edimu/UI/PPOB/BPJS/BPJS_Page.dart';
import 'package:Edimu/UI/PPOB/Pascabayar_Listrik/TagihanListrik_Page.dart';
import 'package:Edimu/UI/PPOB/Samsat/samsat.dart';
import 'package:Edimu/UI/PPOB/indihome/Indihome_Page.dart';
import 'package:Edimu/UI/PPOB/PDAM/pdam_page.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Pulsa/pulsa.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Token_Listrik/TokenListrikPage.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';

class MenuTagihan extends StatelessWidget {
  MainModel model;

  MenuTagihan(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tagihan & Pembayaran"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: ListView(
        children: <Widget>[
          // judul baris tagihan
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 7,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blue[800],
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                    child: Text(
                      "Tagihan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Listrik Pasca Bayar
                      IconMenu("lib/assets/PPOB/pembayaran listrik-1.png",
                          "Tagihan Listrik", ListrikPascaBayarPage(model, 0)),
                      // BPJS
                      IconMenu("lib/assets/PPOB/pembayaran bpjs.png",
                          "BPJS Kesehatan", BPJSPage(model, 0)),

                      IconMenu("lib/assets/PPOB/pembayaran pdam.png", "PDAM",
                          PDAMPage(model, 0)),
                      IconMenu("lib/assets/PPOB/indihome.png",
                          "Telkom Indihome", IndihomePage(model, 0)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 11,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 11, 5, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconMenu("lib/assets/PPOB/pembayaran multifinance.png",
                          "Tagihan Samsat ", SamsatPage(model, 0)),
                      IconMenu("lib/assets/PPOB/pembayaran gas.png", "Gas PGN"),
                      IconMenu(
                        "lib/assets/PPOB/pembayaran tv kabel.png",
                        "TV Kabel dan Internet",
                      ),
                      IconMenu("lib/assets/PPOB/pembayaran multifinance.png",
                          "Angsuran Kredit"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            )),
          ),
          // Tagihan baris ke-2

          SizedBox(
            height: 31,
          ),
          Card(
            elevation: 7,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blue[800],
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                    child: Text(
                      "Travel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconMenu("lib/assets/PPOB/pembayaran kereta.png",
                          "Tiket Kereta Api"),
                      SizedBox(width: 80),
                      SizedBox(width: 80),
                      SizedBox(width: 80),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
