// import 'package:flutter/material.dart';
// import 'package:Edimu/scoped_model/main.dart';
// import 'package:indonesia/indonesia.dart';
// import 'package:json_table/json_table.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:scoped_model/scoped_model.dart';

// class AdminSekolah_Page extends StatefulWidget {
//   final MainModel model;
//   AdminSekolah_Page(this.model);

//   @override
//   _AdminSekolah_PageState createState() => _AdminSekolah_PageState();
// }

// class _AdminSekolah_PageState extends State<AdminSekolah_Page> {
//   var childLoginButton = textLogin();

//   List listData = [];

//   Future upload() {}

//   @override
//   void initState() {
//     widget.model.getDataSekolah();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Data Sekolah"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Container(
//             margin: EdgeInsets.all(9),
//             padding: EdgeInsets.all(7),
//             child: Column(
//               children: [tabelJson(), SizedBox(height: 35), tombolLogin()],
//             )),
//       ),
//     );
//   }

//   Widget tabelJson() {
//     return ScopedModelDescendant<MainModel>(
//       builder: (context, child, model) {
//         if (model.listDataSekolah.length > 0) {
//           return JsonTable(
//             model.listData,
//             showColumnToggle: true,
//             allowRowHighlight: true,
//             rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
//             paginationRowCount: 10,
//             onRowSelect: (index, map) {
//               return Alert(
//                   // type: AlertType.success,
//                   context: context,
//                   title: "Detail",
//                   content: Column(
//                     children: [
//                       ListTile(
//                         title: Text("Id :"),
//                         trailing: Text(map['id'].toString()),
//                       ),
//                       ListTile(
//                         title: Text("Bulan :"),
//                         trailing: Text(map['bulan'].toString()),
//                       ),
//                       ListTile(
//                         title: Text("No. Induk :"),
//                         trailing: Text(map['noinduk']),
//                       ),
//                       ListTile(
//                         title: Text("IPP :"),
//                         trailing: Text(rupiah(map['ipp'].toString())),
//                       ),
//                       ListTile(
//                         title: Text("BP3 :"),
//                         trailing: Text(rupiah(map['bp3'].toString())),
//                       ),
//                       ListTile(
//                         title: Text("Makan :"),
//                         trailing: Text(rupiah(map['makan'].toString())),
//                       ),
//                     ],
//                   ),
//                   buttons: [
//                     DialogButton(
//                       color: Colors.blue[800],
//                       child: Text(
//                         "OK",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     )
//                   ]).show();
//             },
//           );
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   Widget tombolLogin() {
//     return Container(
//       // color: Colors.white,
//       //minWidth: 50,
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(9.0)),
//       ),

//       child: ElevatedButton(
//         color: Colors.blue[800],
//         shape: new RoundedRectangleBorder(
//             borderRadius: new BorderRadius.circular(9.0)),
//         child: childLoginButton,
//         onPressed: () async {
//           setState(() {
//             childLoginButton = loadingBunder();
//           });

//           bool res = await widget.model.postDataSekolah();

//           if (res) {
//             Alert(
//                 type: AlertType.success,
//                 context: context,
//                 title: "Sukses",
//                 desc:
//                     "Data berhasil dimasukkan ke tabel DB Tabel 'DATA_PEMBAYARANCOBA'",
//                 buttons: [
//                   DialogButton(
//                     color: Colors.blue[800],
//                     child: Text(
//                       "OK",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   )
//                 ]).show();
//           } else {
//             Alert(
//                     type: AlertType.error,
//                     context: context,
//                     title: "Error",
//                     desc: "Data belum berhasil dimasukkan ke tabel")
//                 .show();
//           }

//           setState(() {
//             childLoginButton = textLogin();
//           });
//         },
//       ),
//     );
//   }

//   static Widget textLogin() {
//     return Text(
//       "UPLOAD ke DB",
//       style: TextStyle(
//           color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
//     );
//   }

//   static Widget loadingBunder() {
//     return CircularProgressIndicator(
//       valueColor: AlwaysStoppedAnimation(Colors.white),
//       strokeWidth: 5.9,
//     );
//   }

//   // Widget pakeListView() {
//   //   widget.model.listData.length > 0
//   //       ? ListView.builder(
//   //           itemCount: widget.model.listData.length,
//   //           shrinkWrap: true,
//   //           itemBuilder: ((context, index) {
//   //             return Text(widget.model.listData[index]["noinduk"]);
//   //           }),
//   //         )
//   //       : Center(
//   //           child: CircularProgressIndicator(),
//   //         );
//   // }
// }
