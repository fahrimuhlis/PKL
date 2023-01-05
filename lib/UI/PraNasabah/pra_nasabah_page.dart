import 'package:flutter/material.dart';
import 'package:Edimu/UI/Login/login_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:url_launcher/url_launcher.dart';

class Pra_Nasabah_Page extends StatefulWidget {
  MainModel model;
  Pra_Nasabah_Page(this.model);

  @override
  _Pra_Nasabah_PageState createState() => _Pra_Nasabah_PageState();
}

class _Pra_Nasabah_PageState extends State<Pra_Nasabah_Page> {
  String teleponKomunitas;

  @override
  void initState() {
    teleponKomunitas = widget.model.teleponKomunitas.replaceAll(' ', '');
    teleponKomunitas = teleponKomunitas.replaceAll('-', '');
    teleponKomunitas = teleponKomunitas.substring(1);
    //debugPrint('isi dari teleponKomunitas = $teleponKomunitas');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pemberitahuan"),
        centerTitle: true,
      ),
      backgroundColor: hijauBG,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            // height: MediaQuery.of(context).size.height - 85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                    ),
                    // shape: new RoundedRectangleBorder(
                    //     borderRadius: new BorderRadius.circular(25.0)),
                    // color: Colors.red,
                    onPressed: () {
                      widget.model.logOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => loginPage()));
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 7),
                          Text('Keluar', style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: 11,
                ),
                Text("Akun Edimu anda BELUM AKTIF"),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Silahkan datang langsung ke BMT untuk meng-aktif-kan akun Edimu anda.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    // margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    width: 351,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.account_balance,
                            color: Colors.white,
                          ),
                          title: Text(
                            widget.model.namaKomunitas,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.room,
                            color: Colors.white,
                          ),
                          title: Text(widget.model.alamatKomunitas,
                              style: TextStyle(color: Colors.white)),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.alarm,
                            color: Colors.white,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("senin - jum'at",
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5),
                              Text("08.00-14.00 WIB",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          title: Text(widget.model.teleponKomunitas,
                              style: TextStyle(color: Colors.white)),
                        ),
                        Center(
                          child: SizedBox(
                            width: 211,
                            height: 57,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[300],
                              ),
                              // color: Colors.blue[300],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AsetLokal.iconGoogleMap,
                                    width: 35,
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Text("Buka di Google-Map")
                                ],
                              ),
                              onPressed: _launchMAP,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: _hubungi,
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, color: Colors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Hubungi Sekarang Juga",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white)),
                            ],
                          )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchMAP() async {
    const url = 'https://goo.gl/maps/RRWggVXPooJr87GA6';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _hubungi() async {
    String url = 'tel:+62' + teleponKomunitas;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
