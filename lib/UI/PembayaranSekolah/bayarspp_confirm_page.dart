// import 'dart:convert';
// import 'package:Edimu/UI/PembayaranSekolah/bayarspp_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:Edimu/UI/Transfer/transfer_ok_page.dart';
// import 'package:Edimu/fungsi_lib.dart';
// import 'package:Edimu/models/contacts_model.dart';
// import 'package:Edimu/scoped_model/main.dart';
// import 'package:Edimu/konfigurasi/style.dart';
// import 'package:indonesia/indonesia.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:vibration/vibration.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// class Confirm_BayarSpp extends StatefulWidget {
//   MainModel model;
//   List pembayaranUntuk;
//   int bulan;
//   int total;
//   Map dataSiswa;

//   Confirm_BayarSpp(
//       this.model, this.pembayaranUntuk, this.bulan, this.total, this.dataSiswa);
//   @override
//   _Confirm_BayarSppState createState() => _Confirm_BayarSppState();
// }

// class _Confirm_BayarSppState extends State<Confirm_BayarSpp> {
//   bool _canVibrate = false;

//   tesGetar() async {
//     _canVibrate = await Vibration.hasVibrator();
//   }

//   @override
//   void initState() {
//     tesGetar();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController pinController = TextEditingController();
//     return ScopedModelDescendant(
//         builder: (BuildContext context, Widget child, MainModel model) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: hijauMain,
//           title: Text("Konfirmasi Bayar SPP"),
//           centerTitle: true,
//         ),
//         body: ListView(
//           children: <Widget>[
//             ListTile(
//               title: Text("Nama Siswa"),
//               trailing: Text(widget.dataSiswa["nama"]),
//             ),
//             ListTile(
//               title: Text("Bulan Pembayaran :"),
//               trailing: Text(FungsiLib.namaBulan(widget.bulan)),
//             ),
//             ListTile(
//               title: Text("Nominal"),
//               trailing: Text(rupiah(widget.total.toString())),
//             ),
//             Container(
//               padding: EdgeInsets.only(left: 15, right: 15),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                     labelText: "Masukkan Pin Transaksi",
//                     enabledBorder: UnderlineInputBorder(
//                         borderSide:
//                             BorderSide(color: Color(0xff63a4ff), width: 3.0))),
//                 controller: pinController,
//                 obscureText: true,
//                 autofocus: true,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (pinController.text.length < 1) {
//                     return "masukkan pin";
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Container(
//                 margin: EdgeInsets.symmetric(horizontal: 9),
//                 width: MediaQuery.of(context).size.width - 250,
//                 height: 50,
//                 child: ElevatedButton(
//                   // padding: EdgeInsets.only(left: 50, right: 50),
//                   color: Colors.blue[800],
//                   child: Text(
//                     "BAYAR",
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4.0)),
//                   onPressed: () async {
//                     EasyLoading.show(
//                       status: 'sedang diproses',
//                       maskType: EasyLoadingMaskType.black,
//                       dismissOnTap: true,
//                     );

//                     bool response = await widget.model.bayarSekolah(
//                         pinController.text,
//                         widget.total,
//                         widget.pembayaranUntuk,
//                         widget.bulan);

//                     if (response) {
//                       await widget.model.refresh_getTagihan();
//                       if (_canVibrate) {
//                         Vibration.vibrate(
//                           pattern: [0, 50, 150, 50],
//                         );
//                       }

//                       EasyLoading.dismiss();

//                       Alert(
//                           type: AlertType.success,
//                           context: context,
//                           title: "SUKSES",
//                           desc: "Pembayaran anda berhasil",
//                           content: Container(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   height: 35,
//                                 ),
//                                 // SizedBox(
//                                 //   height: 11,
//                                 // ),
//                                 Text(widget.dataSiswa["nama"]),
//                                 ListTile(
//                                   title: Text("Bulan Pembayaran :"),
//                                   trailing:
//                                       Text(FungsiLib.namaBulan(widget.bulan)),
//                                 ),
//                                 ListTile(
//                                   title: Text("Nominal"),
//                                   trailing:
//                                       Text(rupiah(widget.total.toString())),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           buttons: [
//                             DialogButton(
//                               color: Colors.blue[800],
//                               child: Text(
//                                 "OK",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               onPressed: () async {
//                                 await widget.model.gettagihan();
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           BayarSpp_Page(widget.model)),
//                                 );
//                                 setState(() {});
//                               },
//                             )
//                           ]).show();
//                     } else {
//                       EasyLoading.dismiss();
//                       Alert(
//                           type: AlertType.warning,
//                           context: context,
//                           title: "ERROR",
//                           desc: "Periksa Kembali jaringan anda",
//                           buttons: [
//                             DialogButton(
//                               color: Colors.blue[800],
//                               child: Text(
//                                 "OK",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             )
//                           ]).show();
//                     }
//                   },
//                 )),
//           ],
//         ),
//       );
//     });
//   }
// }
