import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

alertSaldoTidakCukup(BuildContext context) {
  Alert(
    type: AlertType.info,
    context: context,
    title: "Saldo tidak cukup",
    buttons: [
      DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          })
    ],
    content: Column(children: [
      // Container(
      //   alignment: Alignment.centerLeft,
      //   child: Text("Maaf saldo tidak cukup",
      //       style: TextStyle(fontWeight: FontWeight.w700)),
      // ),
      SizedBox(
        height: 20,
      ),
      Container(
        child: Text(
          "Silahkan isi saldo anda terlebih dahulu",
          style: TextStyle(fontSize: 17),
          textAlign: TextAlign.center,
        ),
      )
    ]),
    // title: "Saldo tidak Mencukupi",
    // desc:
    //     "Silahkan isi saldo anda terlebih dahulu",
  ).show();
}
