import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Edimu/UI/Registrasi/registration_confirm.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;
import 'package:Edimu/konfigurasi/api.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class RegistrationCommunity_Page extends StatefulWidget {
  String nama;
  String email;
  String noHape;
  String password;

  RegistrationCommunity_Page(this.nama, this.email, this.noHape, this.password);

  @override
  _RegistrationCommunity_PageState createState() =>
      _RegistrationCommunity_PageState();
}

class _RegistrationCommunity_PageState
    extends State<RegistrationCommunity_Page> {
  List _dataKomunitas;
  int selectedKomunitas = 0;
  String selectedNamaKomunitas;
  String selectedAlamatKomunitas;
  String selectedTeleponKomunitas;
  // request komunitas mumtaza
  String labelWaliMurid = "wali murid";

  Widget childLoginButton = textLogin();

  void getKomunitas() async {
    final response = await http.get(UrlAPI.pradaftar);
    var listData = json.decode(response.body);
    //debugPrint('isi dari var listData = ${listData['komunitas'].toString()}');

    setState(() {
      _dataKomunitas = listData["komunitas"];
    });
    //debugPrint('=========================================');
    //debugPrint('isi dari var _dataKomunitas = ${_dataKomunitas.toString()}');
  }

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

  @override
  void initState() {
    super.initState();
    getKomunitas();
  }

  // TextEditingController formBMT = TextEditingController()
  //   ..text = "BMT Aluswah - Surabaya";
  TextEditingController formPassword = TextEditingController();
  TextEditingController formKonfirmasiPassword = TextEditingController();
  TextEditingController formEmail = TextEditingController();
  TextEditingController formNoHape = TextEditingController();

  int idGrup = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendaftaran akun"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Warna.hijauBG2,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
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
                  height: 17,
                ),
                dropdownKomunitas(),
                // TextField(
                //   controller: formBMT,
                //   readOnly: true,
                //   focusNode: new AlwaysDisabledFocusNode(),
                //   onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                //   textInputAction: TextInputAction.next,
                //   decoration: InputDecoration(
                //     enabled: false,
                //     labelText: "Komunitas :",
                //     icon: Icon(Icons.account_balance),
                //   ),
                // ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.group, color: Colors.grey),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pilih Grup Nasabah :",
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 7,
                        ),
                        ToggleSwitch(
                          minWidth: 131,
                          minHeight: 39,
                          fontSize: 15,
                          initialLabelIndex: 0,
                          activeBgColor: Colors.blue[800],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white70,
                          labels: ["nasabah umum", labelWaliMurid],
                          onToggle: (index) {
                            if (index == 0) {
                              idGrup = 1;
                              //debugPrint(
                                  // 'isi idGrup saat ini adalah = ${idGrup.toString()}');
                              //debugPrint(
                                  // "isi index adalah = ${index.toString()}");
                            } else if (index == 1) {
                              idGrup = 2;
                              //debugPrint(
                                  // 'isi idGrup saat ini adalah = ${idGrup.toString()}');
                              //debugPrint(
                                  // "isi index adalah = ${index.toString()}");
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 49,
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
                      if (selectedKomunitas != 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegistrationConfirmation_Page(
                                        widget.noHape,
                                        widget.nama,
                                        widget.email,
                                        widget.password,
                                        idGrup,
                                        selectedKomunitas,
                                        selectedNamaKomunitas,
                                        selectedAlamatKomunitas,
                                        selectedTeleponKomunitas)));
                        // if (formPassword.text.isNotEmpty &&
                        //     formKonfirmasiPassword.text.isNotEmpty &&
                        //     formKonfirmasiPassword.text == formPassword.text) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             RegistrationConfirmation_Page(
                        //               widget.noHape,
                        //               widget.nama,
                        //               widget.email,
                        //               formPassword.text,
                        //               idGrup
                        //             )),
                        //   );
                        // } else {
                        //   Alert(
                        //           type: AlertType.error,
                        //           context: context,
                        //           title: "Gagal Daftar",
                        //           desc: "Silahkan isi data dengan lengkap")
                        //       .show();
                        // }
                      } else {
                        Alert(
                          type: AlertType.error,
                          context: context,
                          title: "Pilih komunitas terlebih dahulu",
                          // desc: "Periksa kembali Email & Password anda",
                        ).show();
                      }
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

  Widget dropdownKomunitas() {
    if (_dataKomunitas != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.account_balance, color: Colors.grey),
          SizedBox(width: 15),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: DropdownButton(
              // icon: Icon(Icons.account_balance),

              isExpanded: true,
              hint: Text(selectedNamaKomunitas ?? "Pilih Komunitas",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              items: _dataKomunitas.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nama_komunitas']),
                  value: item['id'],
                  onTap: () {
                    setState(() {
                      selectedNamaKomunitas = item['nama_komunitas'];
                      selectedKomunitas = item['id'];
                      selectedAlamatKomunitas = item['alamat'];
                      selectedTeleponKomunitas = item['telepon'];
                      //
                      if (item['id'] == 52) {
                        labelWaliMurid = "santri";
                      } else {
                        labelWaliMurid = "wali murid";
                      }
                      setState(() {});
                    });
                  },
                );
              }).toList(),
              onChanged: (value) {},
              // onChanged: (value) {
              //   setState(() {
              //     selectedKomunitas = value;
              //   });
              //   //debugPrint("ID yang dipilih adalah ${value.toString()}");
              // },
            ),
          )
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        child: Center(child: Text('Data Komunitas belum di-muat')),
      );
    }
  }
}
