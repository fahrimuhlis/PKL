import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Edimu/UI/PembayaranSekolah/adminsekolah_page.dart';
import 'package:Edimu/UI/HomePage/home_page.dart';
import 'package:Edimu/UI/Login/login_page.dart';
import 'package:Edimu/konfigurasi/KonfigurasiAplikasi.dart';
import 'package:Edimu/scoped_model/connected_model.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class root extends StatefulWidget {
  final MainModel model;

  root(this.model);
  @override
  _rootState createState() => _rootState();
}

class _rootState extends State<root> {
  // simpanLogin(String nohape, String password) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('noHape', nohape);
  //   prefs.setString('password', password);
  // }

  ambilLogin() async {
    bool sudahLogin;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // widget.model.usernameUser = prefs.getString('noHape');
    // widget.model.passwordUser = prefs.getString('password');
    widget.model.token = prefs.getString('login');
    widget.model.statusAuth = prefs.getInt('statusAuth');

    //debugPrint(
    // "isi model.usernameUser = ${widget.model.usernameUser.toString()}");
    //debugPrint(
    // "isi model.passwordUser = ${widget.model.passwordUser.toString()}");
    // await Future.delayed(Duration(milliseconds: 1501));

    if (widget.model.token == null) {
      sudahLogin = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => loginPage()),
      );
    } else if (widget.model.statusAuth == 203 ||
        widget.model.statusAuth == 200) {
      await widget.model.login(tokenroot: widget.model.token);
      await widget.model.getLapakLokal(1);
      // await widget.model.getDataMinyak();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homePage(widget.model)),
      );
    }
  }

  Future<void> _deleteCacheDir() async {
    var tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    var appDocDir = await getApplicationDocumentsDirectory();

    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }

  hapusCache() async {
    var appDir = (await getTemporaryDirectory()).path;
    new Directory(appDir).delete(recursive: true);
  }

  @override
  void initState() {
    _deleteCacheDir();
    _deleteAppDir();
    hapusCache();
    ambilLogin();
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        // Widget content;

        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: Warna.bgGradient(Warna.warnaHome),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.17,
                    child: Image.asset(
                      'lib/assets/logo.png',
                      width: MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height
                          ? MediaQuery.of(context).size.width * 0.2
                          : MediaQuery.of(context).size.width * 0.65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.66,
                      child: LoadingBouncingGrid.square(
                        // backgroundColor: Colors.white,
                        size: 45,
                        backgroundColor: Warna.primary,
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.85,
                      child: Column(
                        children: [
                          Text("powered by"),
                          Text(
                            "ediMU",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Warna.primary),
                          ),
                        ],
                      )),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.03,
                    right: 5,
                    child: InkWell(
                        onTap: () {
                          widget.model.logOut();
                        },
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25), // <-- Radius
                            ),
                          ),
                          // shape: new RoundedRectangleBorder(
                          //     borderRadius: new BorderRadius.circular(25.0)),
                          // color: Colors.red,
                          onPressed: () {
                            widget.model.logOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => loginPage()));
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, color: Colors.white),
                                SizedBox(width: 7),
                                Text('Keluar',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        );

        // if (model.getUserName != null) {

        //   content = homePage(model);
        // } else {

        //   content = loginPage();
        //   // model.getSaldo;
        // }
        // return content;
      },
    );
  }
}
