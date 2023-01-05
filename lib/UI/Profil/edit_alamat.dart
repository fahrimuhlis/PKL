import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Edimu/UI/Profil/alamat_user_page.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class EditAlamatPage extends StatefulWidget {
  final MainModel model;
  String alamatKotaKecamatan;
  String namaPenerima;
  String nohapePenerima;
  String alamatPenerima;
  String pageSebelumnya;
  //
  EditAlamatPage(this.model,
      {this.pageSebelumnya = "",
      this.alamatKotaKecamatan,
      this.namaPenerima,
      this.nohapePenerima,
      this.alamatPenerima});

  @override
  State<EditAlamatPage> createState() => _EditAlamatPageState();
}

class _EditAlamatPageState extends State<EditAlamatPage> {
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
    isianNamaPenerima.text = widget.namaPenerima ?? widget.model.nama;
    isianNohapePenerima.text =
        widget.nohapePenerima ?? widget.model.nohapeAktif;
    isianKotaKecamatan.text = widget.alamatKotaKecamatan ?? '';
    isianAlamatPenerima.text = widget.alamatPenerima ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageSebelumnya == "" ? 'Ubah' : 'Tambah Alamat'),
        centerTitle: false,
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context);
        //       Navigator.pop(context);
        //     }),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: validator,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
          margin: EdgeInsets.only(bottom: 10),
          child: ListView(
            controller: scrollController,
            children: [
              Column(
                children: [
                  // TextFormField(
                  //   enabled: !mauLanjut,
                  //   controller: isianNamaPenerima,
                  //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  //   decoration: InputDecoration(
                  //     labelText: "Nama Penerima",
                  //     // icon: Icon(Icons.person)
                  //   ),
                  //   maxLength: 50,
                  //   validator: (value) {
                  //     if (value.length < 1) {
                  //       return "Harap isi nama penerima";
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  // ),
                  // TextFormField(
                  //   enabled: !mauLanjut,
                  //   keyboardType: TextInputType.number,
                  //   controller: isianNohapePenerima,
                  //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  //   decoration: InputDecoration(
                  //     labelText: "Nomor HP",
                  //     // icon: Icon(Icons.phone)
                  //   ),
                  //   validator: (value) {
                  //     if (value.length < 9) {
                  //       return "Harap isi nomor HP dengan lengkap";
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  InkWell(
                    onTap: () {
                      showSearchAlamat();
                    },
                    child: Stack(children: [
                      TextFormField(
                        // enabled: !mauLanjut,
                        controller: isianKotaKecamatan,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          labelText: "Kota, Kecamatan, dan Kelurahan",
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
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // enabled: !mauLanjut,
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
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // TextField(
                  //   enabled: !mauLanjut,
                  //   controller: isianCatatan,
                  //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  //   decoration: InputDecoration(
                  //       labelText: "Catatan Untuk Kurir (Opsional)",
                  //       helperText: "Warna rumah, patokan, pesan khusus, dll."
                  //       // icon: Icon(Icons.description)
                  //       ),
                  // ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                        onTap: () async {
                          validator.currentState.validate();

                          if (validator.currentState.validate()) {
                            String alamatBaru =
                                '${isianAlamatPenerima.text}, ${isianKotaKecamatan.text}';

                            EasyLoading.show(
                              status: 'sedang diproses',
                              maskType: EasyLoadingMaskType.black,
                              dismissOnTap: true,
                            );
                            //
                            bool apakahSukses =
                                await widget.model.editAlamat(alamatBaru);

                            EasyLoading.dismiss();
                            if (apakahSukses) {
                              Alert(
                                  style: AlertStyle(
                                    isOverlayTapDismiss: false,
                                    isCloseButton: false,
                                    descTextAlign: TextAlign.center,
                                    // titleStyle: TextStyle(
                                    //     color: Colors.blue[800],
                                    // decoration:
                                    //     TextDecoration.underline
                                    // )
                                  ),
                                  context: context,
                                  title: "Alamat berhasil diperbarui",
                                  type: AlertType.success,
                                  buttons: [
                                    DialogButton(
                                      color: Colors.blue[800],
                                      child: Text("OK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                      onPressed: () {
                                        if (widget.pageSebelumnya == "") {
                                          Navigator.pop(context);
                                        }
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DaftarAlamatUserPage(
                                                        widget.model)));
                                      },
                                    ),
                                  ]).show();

                              // Alert(
                              //     context: context,
                              //     type: AlertType.success,
                              //     title: "Alamat berhasil diperbarui",
                              //     buttons: [
                              //       DialogButton(
                              //         color: Colors.blue[800],
                              //         child: Text(
                              //           "OK",
                              //           style: TextStyle(color: Colors.white),
                              //         ),
                              //         onPressed: () {
                              //           Navigator.pop(context);
                              //           Navigator.pop(context);
                              //           Navigator.pop(context);
                              //           Navigator.pop(context);
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       DaftarAlamatUserPage(
                              //                           widget.model)));
                              //         },
                              //       )
                              //     ]).show();
                            } else {
                              Alert(
                                  context: context,
                                  type: AlertType.warning,
                                  title:
                                      "Maaf alamat gagal diperbarui, silahkan coba lagi",
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
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSearchAlamat() {
    showModalBottomSheet(
        elevation: 5,
        enableDrag: true,
        isDismissible: true,
        // bounce: true,
        isScrollControlled: true,
        // duration: Duration(milliseconds: 350),
        context: context,
        builder: (context) => SearchAlamatCepat(
            widget.model,
            widget.pageSebelumnya,
            isianNamaPenerima.text,
            isianNohapePenerima.text,
            isianAlamatPenerima.text));
  }
}

class SearchAlamatCepat extends StatefulWidget {
  MainModel model;
  String pageSebelumnya;
  String namaPenerima;
  String nohapePenerima;
  String alamatPenerima;

  SearchAlamatCepat(this.model, this.pageSebelumnya, this.namaPenerima,
      this.nohapePenerima, this.alamatPenerima);

  @override
  State<SearchAlamatCepat> createState() => _SearchAlamatCepatState();
}

class _SearchAlamatCepatState extends State<SearchAlamatCepat> {
  TextEditingController searchController = TextEditingController();
  List pilihanAlamat = [];
  String query = '';
  String alamatOtomatis = '';
  bool sudahdiSearch = false;
  bool alamatDitemukan = true;

  static Widget loadingBunder() {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.blue[700]),
        strokeWidth: 5.9,
      ),
    );
  }

  Future searchKotaKecamatan(String alamat) async {
    // EasyLoading.show(
    //   status: 'sedang diproses',
    //   maskType: EasyLoadingMaskType.black,
    //   dismissOnTap: true,
    // );

    final response =
        await http.get('https://teller.klikgeni.com/post-app?q=' + alamat);

    var data = json.decode(response.body);

    if (data['code'] == 200 && data['status'] == true) {
      setState(() {
        pilihanAlamat = data['data'];
      });

      EasyLoading.dismiss();

      debugPrint(
          'Ini adalah isi data pilihanAlamat ===============================================================');
      debugPrint(pilihanAlamat.toString());

      // formulaPembagianMarketPlace = data["data konstanta"];

    } else {
      debugPrint("fungsi GET Riwayat Pay Later belum berhasil");
      setState(() {
        pilihanAlamat = [];
      });

      EasyLoading.dismiss();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    "Kota, Kecamatan, dan Kelurahan",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 2,
                color: Colors.grey[300],
              ),
              SizedBox(height: 10),
              isiMenuSearch(context),

              pilihanAlamat.length < 6
                  ? Container(height: 10)
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
                      child: Text(
                        'Untuk mempersingkat waktu, gunakan nama kecamatan atau kelurahan tujuan pengiriman',
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
              SizedBox(height: 10),
              sudahdiSearch == true && pilihanAlamat.length == 0
                  ? alamatNotFound()
                  : nampilindaftarAlamat()
              // FlatButton(
              //     height: 50,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10)),
              //     color: Colors.blue[800],
              //     onPressed: () {},
              //     child: Text(
              //       "Lanjut Pembelian",
              //       style: TextStyle(fontSize: 17, color: Colors.white),
              // )),
            ]),
      ),
    );
  }

  Widget alamatNotFound() {
    return Expanded(
      child: Center(
        child: Text(
          'Data tidak ditemukan',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget nampilindaftarAlamat() {
    return Expanded(
      // height: MediaQuery.of(context).size.height * 0.6,
      // padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        itemCount: pilihanAlamat.length,
        itemBuilder: (BuildContext context, int index) {
          return pilihanAlamat[index]['province'] == null
              ? Container()
              : InkWell(
                  onTap: () {
                    alamatOtomatis =
                        "Kel. ${pilihanAlamat[index]['urban']}, Kec. ${pilihanAlamat[index]['subdistrict']}, ${pilihanAlamat[index]['city']}, ${pilihanAlamat[index]['province']}, ${pilihanAlamat[index]['postalcode']}";
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAlamatPage(widget.model,
                                pageSebelumnya: widget.pageSebelumnya,
                                alamatKotaKecamatan: alamatOtomatis,
                                namaPenerima: widget.namaPenerima,
                                nohapePenerima: widget.nohapePenerima,
                                alamatPenerima: widget.alamatPenerima)));
                  },
                  child: Container(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey[700],
                              size: 35,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                "Kel. ${pilihanAlamat[index]['urban']}, Kec. ${pilihanAlamat[index]['subdistrict']}, ${pilihanAlamat[index]['city']}, ${pilihanAlamat[index]['province']}, ${pilihanAlamat[index]['postalcode']}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[300],
                        ),
                      )
                    ],
                  )),
                );
        },
      ),
    );
  }

  Widget isiMenuSearch(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      // padding: EdgeInsets.all(5),
      // height: 80,
      decoration: BoxDecoration(
        // color: Colors.lightGreen,
        borderRadius: BorderRadius.circular(30),
        // border: Border.all(
        //   color: Colors.grey[300],
        //   width: 1.5,
        // ),
      ),
      child: Container(
        height: 45,
        // width: MediaQuery.of(context).size.width,
        // margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: Colors.grey[200],
        ),
        child: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (_) async {
            setState(() {
              query = searchController.text;
              pilihanAlamat = [{}];

              EasyLoading.show(
                status: 'sedang diproses',
                maskType: EasyLoadingMaskType.black,
                dismissOnTap: true,
              );

              sudahdiSearch = true;
            });
            await searchKotaKecamatan(query);
          },
          controller: searchController,
          // autofocus: true,
          decoration: InputDecoration(
            fillColor: Colors.grey[100],
            hintText: "Tulis kota/kecamatan/kelurahan/desa",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            // border: OutlineInputBorder(
            //       borderSide: BorderSide(
            //         color: Colors.red,
            //       ),
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            hintStyle: TextStyle(color: Colors.grey),
          ),

          style: TextStyle(color: Colors.black, fontSize: 16.0),
          // onChanged: (keyword) async {
          //   setState(() {
          //     searchKotaKecamatan(keyword);
          //   });
          // },
        ),
      ),
    );
  }

  Widget searchProduk(context) {
    return IconButton(
        onPressed: () {
          setState(() {
            query = searchController.text;
          });
          searchKotaKecamatan(query);
        },
        icon: Icon(Icons.search, size: 30, color: Colors.grey));
  }
}
