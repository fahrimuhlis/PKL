import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UbahPassword_Page extends StatefulWidget {
  MainModel model;

  UbahPassword_Page(this.model);

  @override
  _UbahPassword_PageState createState() => _UbahPassword_PageState();
}

class _UbahPassword_PageState extends State<UbahPassword_Page> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  bool showCurrentPassword = true;
  bool showNewPassword = true;
  bool showConfirmNewPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hijauBG2,
      appBar: AppBar(
        title: Text("Ubah Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(11),
          padding: EdgeInsets.all(7),
          child: Column(
            children: [
              SizedBox(height: 25),
              TextField(
                // onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                // textInputAction: TextInputAction.next,
                style: TextStyle(color: hijauMain),
                controller: currentPassword,
                obscureText: showCurrentPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  // hintText: "masukkan password yang sekarang",
                  hintStyle:
                      TextStyle(color: hijauMain, fontWeight: FontWeight.w300),
                  labelText: 'Password saat ini',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  fillColor: hijauMain,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: hijauMain, width: 1)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      showCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        showCurrentPassword = !showCurrentPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                // onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                // textInputAction: TextInputAction.next,
                style: TextStyle(color: hijauMain),
                controller: newPassword,
                obscureText: showNewPassword,
                decoration: InputDecoration(
                  // icon: Icon(Icons.vpn_key),
                  prefixIcon: Icon(Icons.vpn_key),
                  // hintText: "masukkan password yang baru",
                  hintStyle:
                      TextStyle(color: hijauMain, fontWeight: FontWeight.w300),
                  labelText: 'Password baru',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  fillColor: hijauMain,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: hijauMain, width: 1)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      showNewPassword ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        showNewPassword = !showNewPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                // onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                // textInputAction: TextInputAction.next,
                style: TextStyle(color: hijauMain),
                controller: confirmNewPassword,
                obscureText: showConfirmNewPassword,
                decoration: InputDecoration(
                  // icon: Icon(Icons.vpn_key),
                  prefixIcon: Icon(Icons.vpn_key),
                  // hintText: "konfirmasi password yang baru",
                  hintStyle:
                      TextStyle(color: hijauMain, fontWeight: FontWeight.w300),
                  labelText: 'Konfirmasi password baru',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  fillColor: hijauMain,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: hijauMain, width: 1)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      showConfirmNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        showConfirmNewPassword = !showConfirmNewPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              tombolSubmit(),
              SizedBox(height: 1),
              tombolCancel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tombolSubmit() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.only(left: 0, right: 0),
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          "Ubah Password",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.1), // <-- Radius
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(4.1),
        // ),
        // color: Colors.blue[800],
        onPressed: () async {
          EasyLoading.show(
            dismissOnTap: true,
            status: 'sedang diproses...',
            maskType: EasyLoadingMaskType.black,
          );

          if (newPassword.text.isEmpty || confirmNewPassword.text.isEmpty) {
            EasyLoading.dismiss();
            popupPasswordKosong();
          } else if (newPassword.text == currentPassword.text) {
            EasyLoading.dismiss();
            popupErrorPasswordTidakBolehSama();
          } else if (newPassword.text.length < 8) {
            EasyLoading.dismiss();
            popupPasswordMinimal8Digit();
            newPassword.clear();
            confirmNewPassword.clear();
          } else if (newPassword.text == confirmNewPassword.text &&
              newPassword.text.length > 7 &&
              confirmNewPassword.text.isNotEmpty) {
            String response = await widget.model.ubahPassword(currentPassword.text, newPassword.text);

            if (response == "0") {
              EasyLoading.dismiss();
              Alert(
                  type: AlertType.success,
                  context: context,
                  title: "SUKSES",
                  desc: "Password anda berhasil dirubah",
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
                      },
                    )
                  ]).show();
            } else if (response == "1") {
              EasyLoading.dismiss();
              popupErrorCurrentPassword();
            } else if (response == "2") {
              EasyLoading.dismiss();
              popupErrorPasswordTidakBolehSama();
            } else {
              // error Ketika jaringan / server bermasalah
              EasyLoading.dismiss();
              popupJaringan();
            }
          } else {
            // error ketika konfirmasi password tidak sama/benar
            EasyLoading.dismiss();
            popupErrorConfirmPassword();
          }
        },
      ),
    );
  }

  popupPasswordKosong() {
    return Alert(
        type: AlertType.warning,
        context: context,
        title: "Password kosong",
        desc: "Harap lengkapi password diatas",
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

  popupPasswordMinimal8Digit() {
    return Alert(
        type: AlertType.error,
        context: context,
        title: "Password tidak valid",
        desc:
            "Maaf password yang Anda buat kurang dari 8 karakter, silahkan buat password baru",
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

  popupErrorConfirmPassword() {
    return Alert(
        type: AlertType.error,
        context: context,
        title: "Konfirmasi password salah",
        desc: "Masukkan konfirmasi password sesuai dengan password yang baru.",
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

  popupErrorPasswordTidakBolehSama() {
    return Alert(
        type: AlertType.error,
        context: context,
        title: "Password baru harus berbeda",
        desc: "Password baru anda harus berbeda dengan password yang lama",
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

  popupErrorCurrentPassword() {
    return Alert(
        type: AlertType.error,
        context: context,
        title: "Password lama anda keliru",
        desc: "Masukkan password lama yang benar",
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

  popupJaringan() {
    return Alert(
        type: AlertType.error,
        context: context,
        title: "Ubah Password Gagal",
        desc: "Periksa kembali sinyal anda",
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

  Widget tombolCancel() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.only(left: 0, right: 0),
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          "Batalkan",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.1), // <-- Radius
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(4.1),
        // ),
        // color: Colors.grey[300],
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
    );
  }
}
