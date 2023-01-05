import 'package:flutter/material.dart';
import 'package:Edimu/UI/HomePage/home_page.dart';
import 'package:Edimu/main.dart';
import 'package:Edimu/root.dart';

class transferOkPage extends StatefulWidget {
  String idTransaction;

  transferOkPage(this.idTransaction);

  @override
  _transferOkPageState createState() => _transferOkPageState();
}

class _transferOkPageState extends State<transferOkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 200,
          ),
          Text(
            "Transasi sukses",
            textAlign: TextAlign.center,
          ),
          Text("id transaksi #" + "${widget.idTransaction.toString()}",
              textAlign: TextAlign.center),
          Icon(
            Icons.check_circle,
            color: Color(0xff00BA60),
            size: 150,
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            margin: EdgeInsets.only(left: 35, right: 35),
            width: 130,
            height: 51,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7), // <-- Radius
                      ),
                    ),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(7.0)),
              // color: Colors.green,
              child: Text("Kembali ke Beranda",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          )
        ],
      ),
    );
  }
}
