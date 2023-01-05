import 'package:flutter/material.dart';
import 'package:Edimu/UI/Registrasi/registration_komunitas_page.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';

class Register_Page extends StatefulWidget {
  @override
  _Register_PageState createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {
  Widget childLoginButton = textLogin();

  bool emailTersedia;

  static Widget textLogin() {
    return Text(
      "LANJUT",
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

  TextEditingController formNama = TextEditingController();
  TextEditingController formPassword = TextEditingController();
  TextEditingController formKonfirmasiPassword = TextEditingController();
  TextEditingController formEmail = TextEditingController();
  TextEditingController formNoHape = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendaftaran akun"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                  width: 351,
                  child: Text(
                    '''Lengkapi data diri anda
dengan lengkap dan benar''',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
                TextField(
                  controller: formNama,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Nama Lengkap",
                    icon: Icon(Icons.person),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: formNoHape,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "contoh : 0813xxxxxx",
                    labelText: "Nomor Handphone",
                    icon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: formEmail,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Email",
                    icon: Icon(Icons.email),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                TextField(
                  controller: formPassword,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  // autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    icon: Icon(Icons.vpn_key),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: formKonfirmasiPassword,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Konfirmasi Password",
                    icon: Icon(Icons.vpn_key),
                  ),
                ),
                SizedBox(
                  height: 51,
                ),
                Container(
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
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9), // <-- Radius
                      ),
                    ),
                    // color: Colors.blue[800],
                    // shape: new RoundedRectangleBorder(
                    //     borderRadius: new BorderRadius.circular(9.0)),
                    child: childLoginButton,
                    //, Colors.white,

                    onPressed: () async {
                      setState(() {
                        childLoginButton = loadingBunder();
                      });

                      if (formEmail.text.isNotEmpty &&
                          formNama.text.isNotEmpty &&
                          formNoHape.text.length > 9 &&
                          formPassword.text.length > 7 &&
                          formPassword.text == formKonfirmasiPassword.text) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationCommunity_Page(
                                  formNama.text,
                                  formEmail.text,
                                  formNoHape.text,
                                  formPassword.text)),
                        );
                      } else if (formNoHape.text.length < 10) {
                        Alert(
                                type: AlertType.error,
                                context: context,
                                title: "Nomor Handphone tidak valid",
                                desc: "Nomor handphone harus minimal 10 digit")
                            .show();
                        formNoHape.clear();
                      } else if (formPassword.text.length < 8) {
                        Alert(
                                type: AlertType.error,
                                context: context,
                                title: "Password tidak valid",
                                desc:
                                    "Maaf password yang Anda buat kurang dari 8 karakter, silahkan buat password baru")
                            .show();
                        formPassword.clear();
                        formKonfirmasiPassword.clear();
                      } else if (formPassword.text !=
                          formKonfirmasiPassword.text) {
                        Alert(
                                type: AlertType.error,
                                context: context,
                                title: "Password tidak valid",
                                desc:
                                    'Pastikan "password" dengan "konfirmasi password" yang Anda masukkan sama')
                            .show();
                        formPassword.clear();
                        formKonfirmasiPassword.clear();
                      } else {
                        Alert(
                                type: AlertType.error,
                                context: context,
                                title: "Gagal Daftar",
                                desc: "Silahkan isi data dengan lengkap")
                            .show();
                      }

                      setState(() {
                        childLoginButton = textLogin();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
