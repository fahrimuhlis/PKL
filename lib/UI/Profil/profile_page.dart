import 'dart:typed_data';
import 'package:Edimu/UI/Profil/list_rek_bank_nasabah.dart';
import 'package:Edimu/UI/Profil/alamat_user_page.dart';
import 'package:Edimu/UI/Profil/edit_alamat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/BottomNavBar/bottomNavBar.dart';
import 'package:Edimu/UI/UbahPassword/ubahpassword_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/login_page.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

class profilePage extends StatefulWidget {
  final MainModel model;

  profilePage(this.model);
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  var gambarQR;
  var passwordController = TextEditingController();

  List infoPribadi = [];
  List infoLain = [];

  initState() {
    infoPribadi = [
      {
        "label": "Nama Lengkap",
        "keterangan": widget.model.user.name.toUpperCase()
      },
      {"label": "Username", "keterangan": widget.model.idUser},
      {"label": "Rekening ediMU", "keterangan": widget.model.norek},
      {"label": "Nomor Telepon", "keterangan": widget.model.nohapeAktif},
      {"label": "Alamat Email", "keterangan": widget.model.user.email},
    ];
    infoLain = [
      {
        "label": "Ubah Password",
        "icon": Icons.arrow_forward_ios_rounded,
        "navigasi": UbahPassword_Page(widget.model),
      },
      {
        "label": "Lihat PIN",
        "icon": Icons.remove_red_eye,
        "navigasi": "",
      },
      {
        "label": "Rekening Bank",
        "icon": Icons.arrow_forward_ios_rounded,
        "navigasi": ListRekBankNasabahPage(widget.model),
      },
      {
        "label": "Daftar Alamat",
        "icon": Icons.arrow_forward_ios_rounded,
        "navigasi": DaftarAlamatUserPage(widget.model),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 35,
                // ),
                SizedBox(
                  height: 35,
                ),

                // kartuKredit(),
                InkWell(
                  onTap: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //           content: QrImage(
                    //         data: widget.model.usernameUser,
                    //         version: QrVersions.auto,
                    //         size: 351,
                    //         gapless: true,
                    //         // gambar error
                    //         // embeddedImage: AssetImage("lib/assets/logo_2.png"),
                    //       ));
                    //     },
                    //     barrierDismissible: true);
                    // debugPrint("QR Showed!");
                  },
                  child: widget.model.usernameUser == "087787516825"
                      ? ktam('lib/assets/ktam/ktam_agus_maksum.png')
                      : widget.model.usernameUser == "08161432801"
                          ? ktam('lib/assets/ktam/ktam_faiz_rafdhi.png')
                          : widget.model.usernameUser == "088298912154"
                              ? ktam('lib/assets/ktam/ktam_haikal_djauhari.png')
                              : Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  margin: EdgeInsets.all(15),
                                  child: Container(
                                    width: 351,
                                    child: QrImage(
                                      padding: EdgeInsets.all(20),
                                      data: widget.model.usernameUser,
                                      version: QrVersions.auto,
                                      gapless: true,
                                      // gambar error
                                      // embeddedImage: AssetImage("lib/assets/logo_2.png"),
                                    ),
                                  ),
                                ),
                ),
                //     Card(
                //   elevation: 5,
                //   shadowColor: Colors.grey[300],
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(7)),
                //   margin: EdgeInsets.all(15),
                //   child: Container(
                //     width: 351,
                //     child: QrImage(
                //       padding: EdgeInsets.all(20),
                //       data: widget.model.usernameUser,
                //       version: QrVersions.auto,
                //       gapless: true,
                //       // gambar error
                //       // embeddedImage: AssetImage("lib/assets/logo_2.png"),
                //     ),
                //   ),
                // )),

                SizedBox(
                  height: 35,
                ),

                listInfoPribadi(),
                listInfoLainnya(),

                // SizedBox(
                //   height: 45,
                // ),

                // ListTile(
                //   title: Text("Nama"),
                //   trailing: Text(widget.model.user.name),
                // ),
                // ListTile(
                //   title: Text("Username"),
                //   trailing: Text(widget.model.idUser),
                // ),
                // //
                // ListTile(
                //   title: Text("Password"),
                //   trailing: InkWell(
                //     child: Container(
                //       height: 55,
                //       width: 145,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Icon(Icons.lock),
                //           SizedBox(width: 5),
                //           Text(
                //             'Ubah Password',
                //             style: TextStyle(
                //                 color: Warna.accent,
                //                 decoration: TextDecoration.underline),
                //           )
                //         ],
                //       ),
                //     ),
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) =>
                //                   UbahPassword_Page(widget.model)));
                //     },
                //   ),
                // ),

                // ListTile(
                //   title: Text("PIN"),
                //   trailing: InkWell(
                //     child: Container(
                //       height: 55,
                //       width: 145,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Icon(Icons.remove_red_eye),
                //           SizedBox(width: 5),
                //           Text(
                //             'Lihat PIN',
                //             style: TextStyle(
                //                 color: Warna.accent,
                //                 decoration: TextDecoration.underline),
                //           )
                //         ],
                //       ),
                //     ),
                //     onTap: () async {
                //       //
                //       alertLihatPin();
                //     },
                //   ),
                // ),

                // ListTile(
                //   title: Text("Rekening Bank"),
                //   trailing: InkWell(
                //     child: Container(
                //       height: 55,
                //       width: 145,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Icon(Icons.account_balance),
                //           SizedBox(width: 5),
                //           Text(
                //             'Lihat Rekening',
                //             style: TextStyle(
                //                 color: Warna.accent,
                //                 decoration: TextDecoration.underline),
                //           )
                //         ],
                //       ),
                //     ),
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) =>
                //                   ListRekBankNasabahPage(widget.model)));
                //     },
                //   ),
                // ),

                // ListTile(
                //   title: Text("Rekening ediMU"),
                //   trailing: Text(widget.model.norek),
                // ),

                // ListTile(
                //   title: Text("No. HP aktif"),
                //   trailing: Text(widget.model.nohapeAktif),
                // ),

                // ListTile(
                //   title: Text("Email"),
                //   trailing: Text(widget.model.user.email),
                // ),
                // widget.model.alamatUser == ""
                //     ? alamatTidakada()
                //     : widget.model.alamatUser == null
                //         ? alamatTidakada()
                //         : ListTile(
                //             title: Text("Daftar Alamat"),
                //             trailing: InkWell(
                //               child: Container(
                //                 height: 55,
                //                 width: 145,
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.end,
                //                   children: [
                //                     Icon(Icons.home_outlined, size: 30),
                //                     SizedBox(width: 5),
                //                     Text(
                //                       'Lihat Alamat',
                //                       style: TextStyle(
                //                           color: Warna.accent,
                //                           decoration: TextDecoration.underline),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //               onTap: () {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                             DaftarAlamatUserPage(
                //                                 widget.model)));
                //               },
                //             ),
                //           ),

//          SizedBox(
//            height: 100,
//          ),
                //  Container(
                //    width: 260,
                //    child: Image.asset("lib/assets/card.png",
                //    ),
                //  ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Versi Aplikasi : 0.5.6",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          )),
                      SizedBox(
                        height: 3,
                      ),
                      Text("Pengembangan Versi : 11",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "KELUAR",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.logout, color: Colors.white),
                          ],
                        ),
                        onPressed: () async {
                          widget.model.logOut();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginPage()));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(3, widget.model),
    );
  }

  Widget ktam(String image) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 351,
        child: Image.asset(
          image,
        ),
      ),
    );
  }

  void alertLihatPin() {
    Alert(
        context: context,
        title: "PASSWORD",
        type: AlertType.info,
        content: TextField(
          obscureText: true,
          controller: passwordController,
          decoration: InputDecoration(hintText: "Masukkan password Anda"),
        ),
        buttons: [
          DialogButton(
              color: Colors.red[800],
              child: Text(
                "batal",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          DialogButton(
              color: Colors.blue[800],
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                EasyLoading.show(
                  status: 'sedang diproses',
                  maskType: EasyLoadingMaskType.black,
                  dismissOnTap: true,
                );
                //
                bool apakahSukses =
                    await widget.model.cekPin(passwordController.text);

                EasyLoading.dismiss();
                if (apakahSukses) {
                  Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Berhasil",
                      desc: "pin anda : " + widget.model.pinTransaksi,
                      buttons: [
                        DialogButton(
                          color: Colors.blue[800],
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, '/home_page');
                          },
                        )
                      ]).show();
                } else {
                  Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "gagal",
                      desc: "maaf password salah",
                      buttons: [
                        DialogButton(
                          color: Colors.blue[800],
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ]).show();
                }
              })
        ]).show();
  }

  Widget listInfoPribadi() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 17),
          // margin: EdgeInsets.only(
          //   top: 20,
          // ),
          child: Text(
            'Informasi Pribadi',
            style: TextStyle(
              color: Warna.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                child: Container(
                    height: 55.0 * infoPribadi.length,
                    child: ListView.builder(
                        itemCount: infoPribadi.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 55,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              infoPribadi[index]["label"],
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: textKeterangan(
                                              infoPribadi[index]["keterangan"]),
                                        ),
                                      ]),
                                ),
                                index != infoPribadi.length - 1
                                    ? Container(
                                        color: Colors.grey[200],
                                        height: 1.5,
                                      )
                                    : Container()
                              ],
                            ),
                          );
                        }))))
      ],
    );
  }

  Widget textKeterangan(String keterangan) {
    return Text(keterangan,
        style: TextStyle(
            color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w400),
        textAlign: TextAlign.right);
  }

  Widget listInfoLainnya() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 17),
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: Text(
            'Informasi Lainnya',
            style: TextStyle(
              color: Warna.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                child: Container(
                    height: 55.0 * infoLain.length,
                    child: ListView.builder(
                        itemCount: 5,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              infoLain[index]["label"] == "Lihat PIN"
                                  ? alertLihatPin()
                                  : infoLain[index]["label"] == "Daftar Alamat"
                                      ? (widget.model.alamatUser == ""
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditAlamatPage(
                                                        widget.model,
                                                        pageSebelumnya:
                                                            "profil_page",
                                                      )))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DaftarAlamatUserPage(
                                                          widget.model))))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  infoLain[index]["navigasi"]));
                            },
                            child: Container(
                              height: 55,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 2,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              infoLain[index]["label"] ==
                                                      "Daftar Alamat"
                                                  ? (widget.model.alamatUser ==
                                                          ""
                                                      ? "Tambah Alamat"
                                                      : "Daftar Alamat")
                                                  : infoLain[index]["label"],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Icon(
                                            infoLain[index]["icon"],
                                            size: infoLain[index]["navigasi"] !=
                                                    ""
                                                ? 17
                                                : 25,
                                            color: Colors.grey[400],
                                          ),
                                        ]),
                                  ),
                                  index != infoLain.length - 1
                                      ? Container(
                                          color: Colors.grey[200],
                                          height: 1.5,
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          );
                        }))))
      ],
    );
  }

  Widget kartuKreditBaru() {
    return CreditCard(
      cardNumber: widget.model.norek,
      cardHolderName: widget.model.nama,
      bankName: "BMT Al-Uswah",
      frontBackground: CardBackgrounds.black,
      backBackground: CardBackgrounds.black,
      showShadow: true,
    );
  }
}
