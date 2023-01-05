import 'package:Edimu/UI/TarikTunai/tariktransfer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

List listDaftarBank = [
  {"idBank": 1, "namaBank": "BCA", "gambar": "BCA.png"},
  {"idBank": 2, "namaBank": "Mandiri", "gambar": "Mandiri.png"},
  {"idBank": 3, "namaBank": "Bank Syariah Indonesia", "gambar": "BSI.png"},
  {"idBank": 4, "namaBank": "BNI", "gambar": "BNI.png"},
  {"idBank": 5, "namaBank": "BRI", "gambar": "BRI.png"},
  {"idBank": 6, "namaBank": "Bank Permata", "gambar": "Permata.png"},
  {"idBank": 7, "namaBank": "Jenius BTPN", "gambar": "Jenius.png"},
  {"idBank": 8, "namaBank": "HSBC", "gambar": "HSBC.png"},
  {"idBank": 9, "namaBank": "Bank UOB", "gambar": "UOB.png"},
  {"idBank": 10, "namaBank": "Bukopin", "gambar": "Bank Bukopin.png"},
];

class TambahRekeningPage extends StatefulWidget {
  final MainModel model;
  TambahRekeningPage(this.model);

  @override
  _TambahRekeningPageState createState() => _TambahRekeningPageState();
}

class _TambahRekeningPageState extends State<TambahRekeningPage> {
  String _selectedNamaBank;
  Map selectedDataBank = {"namaBank": null};

  var isianNorekBank = TextEditingController();
  var isianAtasNama = TextEditingController();

  @override
  @override
  void initState() {
    isianAtasNama.text = widget.model.nama;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Rekening"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kotakPeringatan(),
              SizedBox(
                height: 25,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: Icon(Icons.credit_card),
                title: Transform.translate(
                  offset: Offset(-15, 0),
                  child: DropdownButtonFormField(
                      // decoration: InputDecoration(
                      //     prefixIcon: Icon(
                      //   Icons.credit_card,
                      //   color: Colors.grey,
                      // )),
                      isExpanded: true,
                      hint: Text(
                          selectedDataBank["namaBank"] ?? "Pilih bank tujuan"),
                      items: listDaftarBank.map((item) {
                        return DropdownMenuItem(
                            onTap: () {
                              _selectedNamaBank = item["namaBank"];
                              setState(() {});
                            },
                            value: item["namaBank"],
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 1,
                                ),
                                Image.asset(
                                  "lib/assets/bank_icons/${item['gambar']}",
                                  height: 31,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  item["namaBank"],
                                )
                              ],
                            ));
                      }).toList(),
                      onChanged: (value) {
                        //debugPrint(value.toString());
                      }),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              TextField(
                controller: isianAtasNama,
                enabled: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Nama pemilik rekening"),
              ),
              TextField(
                controller: isianNorekBank,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.credit_card_rounded),
                    labelText: "No. rekening bank"),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 45,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                    ),
                    // minWidth: MediaQuery.of(context).size.width * 0.75,
                    // height: 45,
                    // color: Colors.blue[800],
                    onPressed: () {
                      if (isianAtasNama.text.length > 2 &&
                          isianNorekBank.text.length > 2 &&
                          _selectedNamaBank != null) {
                        alertPIN();
                      } else {
                        Alert(
                                type: AlertType.error,
                                context: context,
                                title: "Perhatian",
                                desc:
                                    "Mohon untuk lengkapi form data rekening terlebih dahulu")
                            .show();
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Tambah",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  alertPIN() {
    var isianPIN = TextEditingController();

    Alert(
        context: context,
        title: "Masukkan PIN anda",
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: isianPIN,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "PIN",
                labelStyle: TextStyle(fontSize: 25),
                icon: Icon(Icons.vpn_key),
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.blue[800],
            child: Text("Konfirmasi", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              EasyLoading.show(
                dismissOnTap: true,
                status: 'sedang diproses',
                maskType: EasyLoadingMaskType.black,
              );

              String responseTambahRekening = await widget.model
                  .tambahRekeningBank(_selectedNamaBank, isianNorekBank.text,
                      isianAtasNama.text, isianPIN.text);

              if (responseTambahRekening == 'sukses') {
                //debugPrint('tarik tunai sukses');

                EasyLoading.dismiss();
                Alert(
                    type: AlertType.success,
                    context: context,
                    title: "SUKSES",
                    desc: "Penambahan rekening berhasil.",
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
                          Navigator.pop(context);
                        },
                      )
                    ]).show();
              } else if (responseTambahRekening == 'pin salah') {
                debugPrint(responseTambahRekening.toString());
                EasyLoading.dismiss();
                Alert(
                    type: AlertType.error,
                    context: context,
                    title: "Salah PIN",
                    desc:
                        "Masukkan PIN yang benar atau cek PIN Anda di fitur Profil.",
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
              } else if (responseTambahRekening == 'Rekening sudah ada') {
                debugPrint(responseTambahRekening.toString());
                EasyLoading.dismiss();
                Alert(
                    type: AlertType.error,
                    context: context,
                    title: responseTambahRekening,
                    desc:
                        "Silahkan masukkan Rekening lainnya atau cek daftar Rekening Anda di fitur Profil.",
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
              } else {
                //debugPrint(responseTambahRekening.toString());
                EasyLoading.dismiss();
                Alert(
                    type: AlertType.error,
                    context: context,
                    title: "Maaf",
                    desc: "Penambahan Rekening Gagal",
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
            },
          )
        ]).show();
  }

  Widget kotakPeringatan() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.amber[500],
          borderRadius: BorderRadius.all(Radius.circular(11))),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                size: 25,
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                "Perhatian",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Dianjurkan untuk menggunakan rekening dengan atas nama yang sama dengan nama akun Edimu anda.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
