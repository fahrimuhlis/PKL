import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CartPaymentConfirmationPage extends StatefulWidget {
  @override
  _CartPaymentConfirmationPageState createState() =>
      _CartPaymentConfirmationPageState();
}

class _CartPaymentConfirmationPageState
    extends State<CartPaymentConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Konfirmasi pembayaran"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [],
          )
        ],
      ),
    );
  }
}
