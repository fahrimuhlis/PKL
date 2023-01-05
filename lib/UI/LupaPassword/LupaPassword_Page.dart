import 'package:flutter/material.dart';

class LupaPasswordPage extends StatefulWidget {
  @override
  _LupaPasswordPageState createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  List listDataTeller;

  @override
  void initState() {
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lupa Password"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(11),
        child: Column(
          children: [Text("Pilih komunitas:")],
        ),
      ),
    );
  }
}
