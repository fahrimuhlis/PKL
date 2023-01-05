import 'package:Edimu/Widgets/IconMenu.dart';
import 'package:flutter/material.dart';
import 'package:Edimu/UI/PPOB/Pascabayar_Listrik/TagihanListrik_Page.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Pulsa/pulsa.dart';
import 'package:Edimu/UI/PPOB/Prabayar_Token_Listrik/TokenListrikPage.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';

class PulsaDanPLN extends StatelessWidget {
  MainModel model;

  PulsaDanPLN(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pulsa & PLN"),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 7,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    // margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue[800],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 25),
                      child: Text(
                        "Isi Ulang",
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
                      children: [
                        IconMenu('lib/assets/PPOB/pembayaran pulsa.png', "Pulsa",
                            Pulsa(model)),
                        IconMenu('lib/assets/PPOB/pembayaran listrik.png',
                            "Token Listrik", TokenListrikPage(model, 0)),
                        IconMenu('lib/assets/PPOB/pembayaran emoney.png',
                            "Uang Elektronik"),
                        IconMenu('lib/assets/PPOB/pembayaran voucher game.png',
                            "Voucher Game"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
