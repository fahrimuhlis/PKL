import 'package:flutter/material.dart';

import 'package:Edimu/UI/PembayaranSekolah/adminsekolah_page.dart';

import 'package:Edimu/UI/Registrasi/registration_page.dart';
import 'package:Edimu/UI/SuperAdmin/super_admin_page.dart';

import 'package:Edimu/scoped_model/main.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../konfigurasi/style.dart';
import '../HomePage/home_page.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController userName = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool passwordVisibility = false;

  Widget childLoginButton = textLogin();

  static Widget textLogin() {
    return Text(
      "MASUK",
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  static Widget loadingBunder() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white),
      strokeWidth: 5.9,
    );
  }

  @override
  Widget build(BuildContext context) {
//    TextEditingController userName;
//    TextEditingController password;
    // final bottom = MediaQuery.of(context).viewInsets.bottom;

    final focus = FocusNode();

    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Stack(
        children: [
          // Image.asset(
          //   "lib/assets/bg-geni.jpg",
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.cover,
          // ),
          bgSolidColor(),
          Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              // backgroundColor: Color(0xff1976d2),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 35),
                      Image.asset(
                        "lib/assets/logo.png",
                        height: 250,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          // color: Colors.white,

                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                          color: Colors.white,
                        ),
                        child: TextField(
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(color: Colors.blue[900]),
                          controller: userName,
                          decoration: InputDecoration(
                              hintText: "Contoh : 0813xxxxxxx",
                              hintStyle: TextStyle(color: Colors.blue[900]),
                              labelText: 'Nomor HP',
                              labelStyle: TextStyle(color: Colors.blue[900]),
                              border: OutlineInputBorder(),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0))),
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)),
                            color: Colors.white),
                        child: TextField(
                          // focusNode: focus,
                          style: TextStyle(color: Colors.blue[900]),
                          controller: password,
                          obscureText: passwordVisibility,

                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.blue[900]),
                              border: OutlineInputBorder(),
                              fillColor: Colors.blue[900],
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: 11),
                                  width: 85,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          passwordVisibility
                                              ? 'Lihat'
                                              : 'Tutup',
                                          style:
                                              TextStyle(color: Warna.primary)),
                                      SizedBox(width: 7),
                                      Icon(
                                        // Based on passwordVisible state choose the icon
                                        passwordVisibility
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Warna.primary,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0))),
                        ),
                      ),
                      Container(
                        height: 25,
                      ),
                      tombolLogin(model),
                      SizedBox(
                        height: 17,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register_Page()),
                          );
                        },
                        child: Container(
                          // color: Warna.hijauMain,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.blue[900]),
                                children: [
                                  TextSpan(text: "Belum punya akun? "),
                                  TextSpan(
                                      text: "KLIK UNTUK DAFTAR",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline))
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      );
    });
  }

  Widget tombolLogin(model) {
    return Container(
      // color: Colors.white,
      //minWidth: 50,
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(9.0)),
      ),

      child: ElevatedButton(
        // color: Colors.white,
        style: ElevatedButton.styleFrom(
          backgroundColor: Warna.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9), // <-- Radius
          ),
        ),
        // color: Warna.accent,
        // shape: new RoundedRectangleBorder(
        //     borderRadius: new BorderRadius.circular(9.0)),
        child: childLoginButton,
        //, Colors.white,

        onPressed: () async {
          setState(() {
            childLoginButton = loadingBunder();
          });

          await model.login(username: userName.text, password: password.text);
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => root(model)));
          // if (model.statusAuth == 200) {
          //   Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => Pra_Nasabah_Page(model)));
          //   setState(() {
          //     childLoginButton = textLogin();
          //   });
          // } else

          if (model.statusAuth == 203 || model.statusAuth == 200) {
            await model.getLapakLokal(1);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => homePage(model)),
            );
            setState(() {
              childLoginButton = textLogin();
            });
          } else if (model.statusAuth == 201) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SuperAdmin_Page(model)),
            );
            setState(() {
              childLoginButton = textLogin();
            });
          } else {
            Alert(
                    type: AlertType.error,
                    context: context,
                    title: "Gagal login",
                    desc: "Masukkan nomor handphone & password yang benar")
                .show();

            //debugPrint('sebelum muncul pop-up');

            setState(() {
              childLoginButton = textLogin();
            });

            // CONTOH DIALOG BAWAAN
            // showDialog(
            //     context: context,
            //     barrierDismissible: true,
            //     builder: (_) => AlertDialog(
            //           title: Text('Gagal login'),
            //           content: Text(
            //               'Masukkan Nomor handphone & password yang benar'),
            //         ));
          }
        },
      ),
    );
  }

  Widget bgSolidColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3E8ED),
            Color(0xFFFFFFFF),
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
    );
  }

  // Widget bgAnimasi() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         tileMode: TileMode.mirror,
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           Color(0xff514f4e),
  //           Color(0xff203B83),
  //           //#203B83
  //         ],
  //         stops: [
  //           0,
  //           1,
  //         ],
  //       ),
  //       backgroundBlendMode: BlendMode.srcOver,
  //     ),
  //     child: PlasmaRenderer(
  //       type: PlasmaType.infinity,
  //       particles: 20,
  //       color: Color(0xaf202220),
  //       blur: 0.3,
  //       size: 0.22,
  //       speed: 3.916667302449544,
  //       offset: 0,
  //       blendMode: BlendMode.plus,
  //       variation1: 0,
  //       variation2: 0,
  //       variation3: 0,
  //       rotation: 0,
  //     ),
  //   );
  // }
}
