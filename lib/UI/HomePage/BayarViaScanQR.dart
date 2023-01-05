import 'package:flutter/material.dart';

class BayarViaScanQRPage extends StatefulWidget {
  @override
  _BayarViaScanQRPageState createState() => _BayarViaScanQRPageState();
}

class _BayarViaScanQRPageState extends State<BayarViaScanQRPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
      ),
    );
  }
}
