import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';

class DetailAlamatPage extends StatefulWidget {
  final MainModel model;
  //
  DetailAlamatPage(this.model);

  @override
  State<DetailAlamatPage> createState() => _DetailAlamatPageState();
}

class _DetailAlamatPageState extends State<DetailAlamatPage> {
  var isianNamaPenerima = TextEditingController();
  var isianNohapePenerima = TextEditingController();
  var isianKotaKecamatan = TextEditingController();
  var isianAlamatPenerima = TextEditingController();
  var isianCatatan = TextEditingController();

  bool mauLanjut = false;
  var scrollController = ScrollController();
  final validator = GlobalKey<FormState>();

  @override
  void initState() {
    isianNamaPenerima.text = widget.model.nama;
    isianNohapePenerima.text = widget.model.nohapeAktif;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Detail Alamat'),
        centerTitle: false,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: validator,
        child: ListView(
          controller: scrollController,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(20, 15, 20, 40),
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  TextFormField(
                    enabled: !mauLanjut,
                    controller: isianNamaPenerima,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      labelText: "Nama Penerima",
                      // icon: Icon(Icons.person)
                    ),
                    maxLength: 50,
                    validator: (value) {
                      if (value.length < 1) {
                        return "Harap isi nama penerima";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    enabled: !mauLanjut,
                    keyboardType: TextInputType.number,
                    controller: isianNohapePenerima,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      labelText: "Nomor HP",
                      // icon: Icon(Icons.phone)
                    ),
                    validator: (value) {
                      if (value.length < 9) {
                        return "Harap isi nomor HP dengan lengkap";
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
              child: Column(
                children: [
                  TextFormField(
                    enabled: !mauLanjut,
                    controller: isianKotaKecamatan,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      labelText: "Kota & Kecamatan/Kelurahan",
                      // icon: Icon(Icons.phone)
                    ),
                    validator: (value) {
                      if (value.length < 1) {
                        return "Wajib diisi";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    enabled: !mauLanjut,
                    controller: isianAlamatPenerima,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      labelText: "Alamat Lengkap",
                      // icon: Icon(Icons.phone)
                    ),
                    validator: (value) {
                      if (value.length < 1) {
                        return "Wajib diisi";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    enabled: !mauLanjut,
                    controller: isianCatatan,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      labelText: "Catatan Untuk Kurir (Opsional)",
                      helperText: "Warna rumah, patokan, pesan khusus, dll."
                      // icon: Icon(Icons.description)
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                       
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                          color: Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Center(
                              child: Text(
                                'Simpan',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
