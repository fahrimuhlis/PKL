import 'package:flutter/material.dart';
import 'package:Edimu/UI/Marketplace/marketplace_lokal_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:indonesia/indonesia.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ReceiptCart extends StatefulWidget {
  @override
  _ReceiptCartState createState() => _ReceiptCartState();
}

class _ReceiptCartState extends State<ReceiptCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(11),
          child: Column(
            children: [
              Container(
                color: Colors.amber,
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 45,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Transaksi Berhasil",
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
