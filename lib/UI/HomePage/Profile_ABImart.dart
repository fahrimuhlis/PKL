import 'package:flutter/material.dart';

class ProfileABIMart extends StatefulWidget {
  @override
  _ProfileABIMartState createState() => _ProfileABIMartState();
}

class _ProfileABIMartState extends State<ProfileABIMart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ABI Mart"),
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset(
          "lib/assets/profiles/ABI_mart.jpeg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
