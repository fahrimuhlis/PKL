import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class WhatsappBox extends StatelessWidget {
  MainModel model;
  //
  String pesanWA;
  WhatsappBox(this.model, this.pesanWA);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
        ),
        // height: 45,
        // color: Colors.green[600],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/whatsapp.png', width: 25),
            SizedBox(width: 7),
            Text('Ingatkan Teller', style: TextStyle(color: Colors.white))
          ],
        ),
        onPressed: () async {
          launchWhatsApp(model.nohpTeller1, pesanWA);
        },
      ),
    );
  }

  launchWhatsApp(String nomerWA, String pesan) async {
    nomerWA = nomerWA.substring(1);

    final link = WhatsAppUnilink(
      phoneNumber: '+62' + nomerWA,
      text: pesan,
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }
}
