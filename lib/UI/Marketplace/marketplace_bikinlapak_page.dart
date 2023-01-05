import 'dart:convert';
import 'dart:html';
// import 'dart:io';
import 'dart:typed_data';
// import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:flutter/material.dart';
import 'package:Edimu/scoped_model/main.dart';
import 'package:Edimu/konfigurasi/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
// import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BikinLapak_Page extends StatefulWidget {
  MainModel model;

  BikinLapak_Page(this.model);

  @override
  _BikinLapak_PageState createState() => _BikinLapak_PageState();
}

class _BikinLapak_PageState extends State<BikinLapak_Page> {
  TextEditingController namaBarang = TextEditingController();
  TextEditingController noHapeLapak = TextEditingController();
  TextEditingController deskripsiBarang = TextEditingController();
  TextEditingController stokBarang = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController alamatPengambilanBarang = TextEditingController();

  TextEditingController nohapePenjual = TextEditingController();
  TextEditingController namaPenjual = TextEditingController();

  int selectedIdKategori;
  String selectedNamaKategori;
  int idMetodePengiriman = 0;

  List listKategori = [
    {'id_kategorilapak': '331', 'nama_kategorilapak': 'Bahan Pokok'},
    {'id_kategorilapak': '332', 'nama_kategorilapak': 'Rumah Tangga'},
    {'id_kategorilapak': '334', 'nama_kategorilapak': 'Alat Sekolah'},
    {'id_kategorilapak': '335', 'nama_kategorilapak': 'Alat Rumah Tangga'},
    {'id_kategorilapak': '336', 'nama_kategorilapak': 'Makanan & Minuman'},
    {'id_kategorilapak': '337', 'nama_kategorilapak': 'Teknologi Informasi'},
    {'id_kategorilapak': '338', 'nama_kategorilapak': 'Lainnya'},
    {'id_kategorilapak': '339', 'nama_kategorilapak': 'Fashion'},
    {'id_kategorilapak': '340', 'nama_kategorilapak': 'Preloved (bekas)'},
    {'id_kategorilapak': '341', 'nama_kategorilapak': 'UMKM'},
    {'id_kategorilapak': '342', 'nama_kategorilapak': 'Open PO'},
  ];

  File _image;
  var _imageFile;
  String name = '';
  String error;
  Uint8List data;

  List<bool> _selections = List.generate(2, (_) => false);

  // webPickImage() {
  //   final html.InputElement input = html.document.createElement('input');
  //   input
  //     ..type = 'file'
  //     ..accept = 'image/';

  //   input.onChange.listen((e) {
  //     if (input.files.isEmpty) return;
  //     final reader = html.FileReader();
  //     reader.readAsDataUrl(input.files[0]);
  //     reader.onError.listen((err) => setState(() {
  //           error = err.toString();
  //         }));

  //     reader.onLoad.first.then((res) {
  //       final encoded = reader.result as String;
  //       //remove data:image/*; base64 preambule
  //       final stripped =
  //           encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

  //       setState(() {
  //         name = input.files[0].name;
  //         data = base64.decode(stripped);
  //         error = null;
  //       });
  //     });
  //   });

  //   input.click();
  // }

  void initState() {
    noHapeLapak.text = widget.model.nohapeAktif;
    stokBarang.text = '1';
    alamatPengambilanBarang.text = '';

    super.initState();
  }

  var permissionCamera;
  var permissionGallery;

  // Future _imgFromCamera() async {
  //   // permissionCamera = await Permission.camera;

  //   if (await Permission.camera.request().isGranted) {
  //     // File image = await ImagePicker.pickImage(
  //     //     source: ImageSource.camera, imageQuality: 50);

  //     // setState(() {
  //     //   _image = image;
  //     // });

  //     PickedFile image =
  //         await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

  //     setState(() {
  //       _image = File(image.path);
  //     });
  //   }
  // }

  final ImagePicker _picker = ImagePicker();

  // _imgFromGallery() async {
  //   if (await Permission.photos.request().isGranted) {
  //     // File image = await ImagePicker.pickImage(
  //     //     source: ImageSource.gallery, imageQuality: 50);

  //     PickedFile image =
  //         await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

  //     setState(() {
  //       _image = File(image.path);
  //     });
  //   }
  // }

  Future<void> _imageForWeb() async {
    var image =
        //     // await ImagePickerWeb.getImageAsFile();
        await ImagePicker()
            .getImage(source: ImageSource.gallery, imageQuality: 50);

    // File image = await ImagePickerWeb.getImageAsFile();

    setState(() {
      _imageFile = image;
    });
    // html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    // uploadInput.click();
    // uploadInput.onChange.listen(
    //   (changeEvent) {
    //     final file = uploadInput.files.first;
    //     final fileName = uploadInput.files.first.name;
    //     final reader = html.FileReader();
    //     reader.readAsDataUrl(file);
    //     reader.onLoadEnd.listen(
    //       (loadEndEvent) async {
    //         setState(() {
    //           _image = file.relativePath;
    //           _imageFile = file;
    //         });
    //       },
    //     );
    //   },
    // );
  }

  List<int> _selectedFile;
  Uint8List _bytesData;
  String displayImage = '';

  startWebFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      displayImage = files.first.name;
      final file = files[0];
      final reader = new html.FileReader();
      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
        // debugPrint('Isi relativePath ==================');
        // debugPrint(file.relativePath);
      });
      reader.readAsDataUrl(file);
      // _file = file;
    });
  }

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });
    // createFileFromBytes(_selectedFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Lapak"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(9),
          padding: EdgeInsets.all(9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Foto Barang'),
              SizedBox(
                height: 9,
              ),
              imageContainer(),
              SizedBox(
                height: 9,
              ),
              uploadFoto(),
              SizedBox(height: 15),
              TextField(
                controller: namaBarang,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 5.0),
                    ),
                    labelText: "Nama barang",
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
                    // hintText: "contoh : 'Minyak goreng halal .....'",
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey)
                    // icon: Icon(Icons.person),
                    ),
              ),
              SizedBox(
                height: 15,
              ),
              fieldNamaBarang(),
              SizedBox(
                height: 15,
              ),
              dropDownKategori(),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: harga,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixText: "Rp. ",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 5.0),
                    ),
                    labelText: "Harga",
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
                    // hintText: "087859xxxxxx",
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey)
                    // icon: Icon(Icons.person),
                    ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: stokBarang,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 5.0),
                    ),
                    labelText: "Stok barang",
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
                    // hintText: "087859xxxxxx",
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey)
                    // icon: Icon(Icons.person),
                    ),
              ),
              SizedBox(height: 25),
              tombolSubmit()
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadFoto() {
    if (kIsWeb) {
      return Column(
        children: [
          Text('Upload Foto'),
          SizedBox(
            height: 9,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 51,
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library),
                        SizedBox(width: 7),
                        Text('Gallery')
                      ],
                    ),
                    onPressed: () {
                      startWebFilePicker();
                      // _imageForWeb();
                      // Navigator.of(context).pop();
                    },
                  )),
              // SizedBox(width: 13),
              // SizedBox(
              //     height: 51,
              //     width: MediaQuery.of(context).size.width * 0.42,
              //     child: ElevatedButton(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(Icons.camera_alt_rounded),
              //             SizedBox(width: 7),
              //             Text('Kamera')
              //           ],
              //         ),
              //         onPressed: () {})),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text('Upload Foto'),
          SizedBox(
            height: 9,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: 51,
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library),
                        SizedBox(width: 7),
                        Text('Gallery')
                      ],
                    ),
                    onPressed: () {
                      _imageForWeb();
                      // Navigator.of(context).pop();
                    },
                  )),
              SizedBox(width: 13),
              SizedBox(
                  height: 51,
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded),
                        SizedBox(width: 7),
                        Text('Kamera')
                      ],
                    ),
                    onPressed: () {
                      // _imgFromCamera();
                      // Navigator.of(context).pop();
                    },
                  )),
            ],
          ),
        ],
      );
    }
  }

  Widget fieldNamaBarang() {
    return TextField(
      controller: deskripsiBarang,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 5.0),
          ),
          labelText: "Deskripsi Barang",
          labelStyle: TextStyle(fontWeight: FontWeight.w400),
          // hintText:
          //     "Silahkan isi dengan detail & penjelasan barang yang akan anda jual",
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey)
          // icon: Icon(Icons.person),
          ),
    );
  }

  Widget metodePengiriman() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Metode Pengiriman'),
        SizedBox(height: 9),
        Container(
          width: MediaQuery.of(context).size.width,
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(5),
            borderWidth: 1.5,
            borderColor: hijauMain,
            selectedBorderColor: hijauMain,
            // =====================================
            isSelected: _selections,
            fillColor: hijauMain,
            selectedColor: Colors.white,
            children: [
              Container(
                  // color: Colors.grey[200],
                  width: MediaQuery.of(context).size.width * 0.41,
                  child: Center(
                      child: Text(
                    'Ambil sendiri',
                  ))),
              Container(
                  // color: Colors.grey[200],
                  width: MediaQuery.of(context).size.width * 0.41,
                  child: Center(
                      child: Text(
                    'Di-kirim',
                  )))
            ],
            onPressed: (int index) {
              setState(() {
                _selections[index] = !_selections[index];
              });
              if (!_selections[0] && !_selections[1]) {
                idMetodePengiriman = 0;
              } else if (_selections[0] && !_selections[1]) {
                idMetodePengiriman = 1;
              } else if (!_selections[0] && _selections[1]) {
                idMetodePengiriman = 2;
              } else if (_selections[0] && _selections[1]) {
                idMetodePengiriman = 3;
              }

              //debugPrint('isi dari _selections = ${_selections.toString()}');
              //debugPrint(
              // 'Maka isi dari idMetodePengiriman adalah ${idMetodePengiriman.toString()}');
            },
          ),
        ),
        SizedBox(height: 5),
        Container(
            child: _selections[0]
                ? TextField(
                    controller: alamatPengambilanBarang,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 5.0),
                        ),
                        labelText: "Masukkan Alamat Pengambilan Barang",
                        labelStyle: TextStyle(fontWeight: FontWeight.w400),
                        // hintText:
                        //     "Silahkan isi dengan detail & penjelasan barang yang akan anda jual",
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey)
                        // icon: Icon(Icons.person),
                        ),
                  )
                : SizedBox(height: 0))
      ],
    );
  }

  Widget dropDownKategori() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          hint: selectedNamaKategori != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedNamaKategori,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    // SizedBox(width: 25,),
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 29,
                    )
                  ],
                )
              : Text('Pilih Kategori'),
          items: listKategori.map((item) {
            return DropdownMenuItem(
              child: item['nama_kategorilapak'] == "UMKM"
                  ? Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text("UMKM")
                      ],
                    )
                  : Text(item['nama_kategorilapak']),
              value: item['id_kategorilapak'],
              onTap: () {
                setState(() {
                  selectedNamaKategori = item['nama_kategorilapak'];
                  selectedIdKategori = int.parse(item['id_kategorilapak']);
                  //debugPrint(
                  // 'isi dari selectedNamaKategori = $selectedNamaKategori & selected ID = ${selectedIdKategori.toString()}');
                });
              },
            );
          }).toList(),
          onChanged: (value) {},
        ),
      ),
    );
    // if (widget.model.idKomunitas != 15 ||
    //     widget.model.idUser == "081336366212") {

    // } else if (widget.model.idKomunitas == 15 &&
    //     widget.model.idUser != "081336366212") {
    //   return TextField(
    //     enabled: false,
    //     keyboardType: TextInputType.phone,
    //     decoration: InputDecoration(
    //         border: OutlineInputBorder(
    //           borderSide: BorderSide(color: Colors.green, width: 5.0),
    //         ),
    //         labelText: "Kategori : UMKM",
    //         disabledBorder: OutlineInputBorder(
    //           borderSide: BorderSide(color: Colors.grey, width: 1.0),
    //         ),
    //         suffixIcon: Icon(
    //           Icons.check_circle_rounded,
    //           color: Colors.green,
    //           size: 29,
    //         ),
    //         labelStyle:
    //             TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
    //         // hintText: "087859xxxxxx",
    //         hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
    //         // icon: Icon(Icons.person),
    //         prefix: Text("UMKM")),
    //   );
    // }
  }

  Widget tombolSubmit() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 57,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0)),
          ),
          // color: Colors.blue[800],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_business, color: Colors.white),
              SizedBox(width: 5),
              Text("JUAL", style: TextStyle(color: Colors.white)),
            ],
          ),
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
          onPressed: () async {
            if (_selectedFile != null &&
                selectedIdKategori != null &&
                namaBarang.text.isNotEmpty&&
                harga.text.isNotEmpty &&
                stokBarang.text.isNotEmpty &&
                deskripsiBarang.text.isNotEmpty &&
                int.parse(stokBarang.text) > 0) {
              //debugPrint("proses jual..........");

              EasyLoading.show(
                  status: 'sedang diproses',
                  maskType: EasyLoadingMaskType.black);

              String res = await widget.model.bikinLapakJuli2021(
                  selectedIdKategori,
                  namaBarang.text,
                  harga.text,
                  stokBarang.text,
                  deskripsiBarang.text,
                  _selectedFile);

              if (res == "sukses") {
                await EasyLoading.dismiss();
                setState(() {});
                Alert(
                    type: AlertType.success,
                    context: context,
                    title: "SUKSES",
                    desc: "Lapak Anda Berhasil diupload.",
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
              } else {
                await EasyLoading.dismiss();
                Alert(
                    type: AlertType.error,
                    context: context,
                    title: "Upload Gagal",
                    desc: "Upload lapak gagal, silahkan periksa sinyal anda",
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
            } else if (_selectedFile == null) {
              Alert(
                  title: "Tidak ada gambar",
                  desc: "Silahkan upload gambar/foto barang dahulu",
                  type: AlertType.warning,
                  context: context,
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
              Alert(
                  title: "Informasi lapak belum lengkap",
                  desc:
                      "Silahkan lengkapi informasi barang diatas terlebih dahulu",
                  type: AlertType.warning,
                  context: context,
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
        ));
  }

  Widget imageContainer() {
    if (kIsWeb) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: displayImage == '' ? Colors.amber[600] : Colors.green,
        child: Center(
          child: Text(
              displayImage == '' ? 'Foto belum di-upload' : displayImage,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: displayImage == '' ? Colors.black : Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 3),
        ),
      );
      //   return CircleAvatar(
      //       radius: 55,
      //       child: _imageFile != null
      //           ? ClipRRect(
      //               borderRadius: BorderRadius.circular(50),
      //               child: kIsWeb ? Image.network(_imageFile.path) : null
      //               // Image.file(_image,
      //               //     width: 100, height: 100, fit: BoxFit.cover),
      //               )
      //           : InkWell(
      //               onTap: () {
      //                 // _imgFromCamera();
      //                 // Navigator.of(context).pop();
      //               },
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                     color: Colors.grey[200],
      //                     borderRadius: BorderRadius.circular(50)),
      //                 width: 100,
      //                 height: 100,
      //                 child: Icon(Icons.camera_alt, color: Colors.grey[800]),
      //               ),
      //             ));
      //
    } else {
      return CircleAvatar(
          radius: 55,
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: kIsWeb ? null : null,
                )
              : InkWell(
                  onTap: () {
                    // _imgFromCamera();
                    // Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    width: 100,
                    height: 100,
                    child: Icon(Icons.camera_alt, color: Colors.grey[800]),
                  ),
                ));
    }
  }
}
