import 'dart:convert';
import 'dart:typed_data';
import 'package:Edimu/UI/TarikTunai/tambah_rekening_page.dart';
import 'package:Edimu/models/riwayat_PLNPascabayar.dart';
import 'package:Edimu/scoped_model/StatusTransaksiPPOB.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:Edimu/UI/Transfer/confirm_transfer_page.dart';
import 'package:Edimu/UI/Transfer/transfer_ok_page.dart';
import 'package:Edimu/main.dart';
import 'package:Edimu/models/ads_model.dart';
import 'package:Edimu/models/contacts_model.dart';
import 'package:Edimu/models/student_model.dart';
import 'package:Edimu/models/transactionHistory_model.dart';
import 'package:Edimu/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Edimu/konfigurasi/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../root.dart';

//https://gitlab.com/alkaffdt3/Edimu_app.git

mixin ConnectedModel on Model {
  // ini untuk pointer list, untuk mendapatkan listnya menggunakan getter
  User user;
  String idUser;
  String usernameUser;
  String passwordUser;
  String alamatUser;
  bool sudahVerifikasi = false;
  int idAktor = 0;
  bool apakahPunyaToko = false;

  //
  String pinTransaksi;

  //NO HP beneran (bukan ID Login(usernameUser))
  String nohapeAktif;

  String namaKomunitas = '....';
  int idKomunitas;
  int idGrup;
  String alamatKomunitas;
  String teleponKomunitas;
  Map dataBank = {'namaBank': null, 'norekBank': null, 'atasNama': null};

  List listTagihan;

  int statusAuth;

  String nama = '.....';

  String norek;

  int balance;
  String formatedBalance = "";
  int statusPayLater = 0;
  int statusPayLaterUser = 0;
  int limitPayLater = 0;
  int saldoPayLaterSekarang = 0;
  int penggunaanPayLater = 0;
  String isMinyak = "";

  int balanceEmas;
  String formatedBalanceEmas = "emas";

  int balanceSpp;
  String formatedBalanceSpp = "Plafon Spp";

  String token = "";

  String duhur;
  // ini authValue64 untuk header json bagian authnya
  String authVaue64;

  //ini list contactnya
  contactsList listContacts;

  //ini list historynye
  historysList listHistorys;

  //ini list ads
  adssList listAdss;

  //List<contactsList> listContacts = [];

  List formulaPembagianMarketPlace = [];

  bool isLoading = false;

  Map<String, String> headerJSON = {
    "Content-Type": "application/json",
  };

  Map<String, String> userMap = {"saldo": "0"};
}
// ======================== Transaksi di sini
mixin transactionModel on ConnectedModel {}

// ======================== User management di sini
mixin userModel on ConnectedModel {
  simpanLogin(
    String tokenroot,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login', tokenroot);
    // prefs.setString('noHape', nohape);
    // prefs.setString('password', password);
    prefs.setInt('statusAuth', statusAuth);
  }

  Future<Null> login(
      {String username, String password, String tokenroot}) async {
    // String credentials = "$username:$password";
    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // String encoded = stringToBase64.encode(credentials);
    // String authValue = "Basic $encoded";
    // authVaue64 = authValue;

    usernameUser = username;
    passwordUser = password;

    final bodyJSON = jsonEncode({'id': usernameUser, 'password': passwordUser});

    var responseLogin;
    if (tokenroot == null) {
      responseLogin = await http.post(
        Uri.parse(UrlAPI.login),
        headers: headerJSON,
        body: bodyJSON,
      );
    } else {
      headerJSON = {
        // "Authorization": authVaue64,
        "Accept": "application/json",
        "Authorization": "Bearer $tokenroot",
        "Content-Type": "application/json",
      };
      responseLogin = await http.post(
        Uri.parse(UrlAPI.baseInfo),
        headers: headerJSON,
      );
    }

    //debugPrint('1 step sebelum decode response');

    var data = json.decode(responseLogin.body);

    // //debugPrint("isi response login :");
    // //debugPrint(data.toString());

    if (responseLogin.statusCode == 200) {
      // 200 = belum verif
      statusAuth = 200;
      sudahVerifikasi = false;

      // statusAuth = 203;

      //debugPrint('login sukses');
      final User usernya = User(
        id: int.parse(data['user_id']),
        email: data['email'],
        name: data['name'],
      );

      if (tokenroot != null) {
        usernameUser = data['user_id'];
      }

      user = usernya;
      idUser = data['user_id'];
      formatedBalance = data['saldo'];
      formatedBalance =
          formatedBalance.substring(0, formatedBalance.length - 3);
      nama = data['name'];
      norek = data['no_rekening'].toString();
      alamatUser = data['alamat_nasabah'];
      nohapeAktif = data['nohape'];

      idKomunitas = data['komunitas_id'];
      idGrup = data['grup_id'];
      idAktor = data['aktor_id'];

      namaKomunitas = data['nama_komunitas'];
      alamatKomunitas = data['alamat'];
      teleponKomunitas = data['telepon'];

      statusPayLater = data['status_paylater'];
      statusPayLaterUser = data['status_paylater_user'];
      limitPayLater = data['limit_paylater'];
      // limitPayLater = limitPayLater.substring(0, limitPayLater.length - 3);
      saldoPayLaterSekarang = data['saldo_sekarang'];
      // saldoPayLaterSekarang =
      //     saldoPayLaterSekarang.substring(0, saldoPayLaterSekarang.length - 3);
      penggunaanPayLater = limitPayLater - saldoPayLaterSekarang;
      isMinyak = data["isMinyak"];

      if (tokenroot == null) {
        token = data["authorisation"]["token"];
        headerJSON = {
          // "Authorization": authVaue64,
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        };
      }

      dataBank['namaBank'] = data['nama_bank'];
      dataBank['norekBank'] = data['norek_bank'];
      dataBank['atasNama'] = data['rekening_atas_nama'];

      if (data['id_toko'] != null) {
        apakahPunyaToko = true;
      }

      simpanLogin(token);

      // if (idGrup == 2) {
      //   getTagihanBaru();
      // }

      notifyListeners();
    } else if (responseLogin.statusCode == 201) {
      statusAuth = 201;
    } else if (responseLogin.statusCode == 202) {
      statusAuth = 202;
      simpanLogin(token);
    } else if (responseLogin.statusCode == 203) {
      //
      //
      // 203 = Verified User
      //
      //
      statusAuth = 203;
      //debugPrint('login sukses');
      final User usernya = User(
        id: int.parse(data['user_id']),
        email: data['email'],
        name: data['name'],
      );

      pinTransaksi = data['pin_transaksi'];

      if (tokenroot != null) {
        usernameUser = data['user_id'];
      }

      user = usernya;
      idUser = data['user_id'];
      formatedBalance = data['saldo'];
      formatedBalance =
          formatedBalance.substring(0, formatedBalance.length - 3);
      nama = data['name'];
      norek = data['no_rekening'].toString();
      alamatUser = data['alamat_nasabah'];
      nohapeAktif = data['nohape'];

      sudahVerifikasi = true;

      idKomunitas = data['komunitas_id'];
      idGrup = data['grup_id'];
      idAktor = data['aktor_id'];

      namaKomunitas = data['nama_komunitas'];
      alamatKomunitas = data['alamat'];
      teleponKomunitas = data['telepon'];

      statusPayLater = data['status_paylater'];
      statusPayLaterUser = data['status_paylater_user'];
      limitPayLater = data['limit_paylater'];
      // limitPayLater = limitPayLater.substring(0, limitPayLater.length - 3);
      saldoPayLaterSekarang = data['saldo_sekarang'];
      // saldoPayLaterSekarang =
      //     saldoPayLaterSekarang.substring(0, saldoPayLaterSekarang.length - 3);
      penggunaanPayLater = limitPayLater - saldoPayLaterSekarang;
      isMinyak = data["isMinyak"];

      if (tokenroot == null) {
        token = data["authorisation"]["token"];
        headerJSON = {
          // "Authorization": authVaue64,
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        };
      }

      dataBank['namaBank'] = data['nama_bank'];
      dataBank['norekBank'] = data['norek_bank'];
      dataBank['atasNama'] = data['rekening_atas_nama'];

      if (data['id_toko'] != null) {
        apakahPunyaToko = true;
      }

      simpanLogin(token);

      // if (idGrup == 2) {
      //   getTagihanBaru();
      // }

      //debugPrint(
      // 'nilai formatedBalance adalah = ${formatedBalance.toString()}');

      //debugPrint("======id user $idUser ==========");

      //debugPrint("idAktor adalah = $idAktor");

      notifyListeners();
      getContacts();
      main();
    } else {
      //debugPrint('LOGIN Edimu GAGAL');
      // //debugPrint(data.toString());
    }
  }

  Future cekPin(passwordInputan) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      'password': passwordInputan,
    });

    final response =
        await http.post(UrlAPI.cekPin, body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    bool status = false;

    // //debugPrint("respons cekPin()");
    // //debugPrint(data.toString());

    if (response.statusCode == 200) {
      status = true;
      return status;
    } else {
      return status;
    }
  }

  Future editAlamat(alamatBaru) async {
    final bodyJSON = jsonEncode({
      'id': usernameUser,
      // 'password': passwordUser,
      'address': alamatBaru
    });

    final response =
        await http.post(UrlAPI.editAlamat, body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    bool status = false;
    debugPrint("respons editAlamat()");
    debugPrint(data.toString());

    if (response.statusCode == 200) {
      refreshApi();
      status = true;
      return status;
    } else {
      return status;
    }
  }

  // =================================================================
  // =================================================================
  // ===================== CART/KERANJANG BELANJA ====================
  // =================================================================
  // =================================================================

  int idLayanan = 0;
  int biayaLayananAplikasi = 0;

  //BUKA TOKO BARU
  Future bukaToko(tokoName, tokoDescription, tokoAddress, tokoPhone) async {
    Map rawBody = {
      'nohape': usernameUser,
      // 'password': passwordUser,
      'tokoName': tokoName,
      'tokoDescription': tokoDescription,
      'tokoAddress': tokoAddress,
      'tokoPhone': tokoPhone
    };

    final bodyJSON = jsonEncode(rawBody);

    final response =
        await http.post(UrlAPI.setToko, body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    String responServer;

    if (response.statusCode == 200) {
      if (data['sukses'] == true) {
        //debugPrint("isi response bukaToko :");
        //debugPrint(data.toString());

        apakahPunyaToko = true;

        notifyListeners();

        responServer = "sukses";
        return responServer;
      } else {
        //debugPrint('response : 200 tapi belum sukses, isi respons adalah :');
        //debugPrint(data.toString());

        responServer = "pin salah";
        return responServer;
      }
    } else {
      //debugPrint("API belanjaCart belum berhasil:");
      //debugPrint(data.toString());

      responServer = "tidak diketahui";
      return responServer;
    }
  }

  //bikin lapak
  Future bikinLapakJuli2021(
    int id_kategorilapak,
    String namaBarang,
    String hargaBarang,
    String stokBarang,
    String deskripsiBarang,
    List<int> image,
  ) async {
    var postUri = Uri.parse(UrlAPI.jualBarang14juli2021);
    var request = new http.MultipartRequest('POST', postUri);

    // Uint8List data = await image.readAsBytes();
    // List<int> list = data.cast();

    // var stream = new http.ByteStream(DelegatingStream(image.openRead()));
    // int length = data.length;

    request.headers["Access-Control-Allow-Origin"] = "*";
    request.headers['Accept'] = "application/json";
    request.headers['Authorization'] = "Bearer $token";
    request.headers['Content-Type'] = "application/json";

    request.fields['nohape'] = usernameUser;
    // request.fields['password'] = passwordUser;
    request.fields['idKategori'] = id_kategorilapak.toString();
    request.fields['namaBarang'] = namaBarang;
    request.fields['hargaBarang'] = hargaBarang;
    request.fields['stokBarang'] = stokBarang;
    request.fields['deskripsiBarang'] = deskripsiBarang;
    request.files.add(
        await http.MultipartFile.fromBytes('file', image, filename: "file_up"));

    var response = await request.send();
    var printedResponse = await http.Response.fromStream(response);

    String apakahSukses;

    // final response = await http.post(urlAPI.bikinLapak,
    //     headers: headerJSON, body: bodyJSON);

    // var data = json.decode(response.body);

    //debugPrint("isi Map yang di.post :");
    //debugPrint("nohape : ${request.fields['nohape']}");
    //debugPrint("password : ${request.fields['password']}");
    //debugPrint("idKategori : ${request.fields['idKategori']}");
    //debugPrint("namaBarang : ${request.fields['namaBarang']}");
    //debugPrint("hargaBarang : ${request.fields['hargaBarang']}");
    //debugPrint("stokBarang : ${request.fields['stokBarang']}");
    //debugPrint("deskripsiBarang : ${request.fields['deskripsiBarang']}");
    // //debugPrint("file : ${image.path}");
    //debugPrint("file : ${stream}");

    if (response.statusCode == 200) {
      //debugPrint('isi response = ' + response.statusCode.toString());
      //debugPrint(printedResponse.body.toString());
      apakahSukses = "sukses";
      getLapakLokal(1);
      notifyListeners();
      return apakahSukses;
    } else {
      //debugPrint("fungsi upload-lapak belum berhasil");
      //debugPrint(response.statusCode.toString());
      apakahSukses = "gagal";
      return apakahSukses;
    }
  }

  // view ke cart
  Map<String, dynamic> isiKeranjang = {};

  addToCart(
      int idLapak,
      String rekPenjual,
      int jumlahBarang,
      int hargaSatuan,
      String catatan,
      String urlGambar,
      String namaBarang,
      String namaToko,
      String alamatToko,
      String idToko,
      String nohapePenjual,
      String namaPenjual) async {
    bool rekPenjualSudahAda = isiKeranjang.containsKey(rekPenjual);
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (rekPenjualSudahAda) {
      bool idItemSudahAda = isiKeranjang[rekPenjual].containsKey(idLapak);

      if (idItemSudahAda) {
        isiKeranjang[rekPenjual].update(
            idLapak,
            (value) => {
                  "idLapak": idLapak,
                  "namaBarang": namaBarang,
                  "norekPenjual": rekPenjual,
                  "jumlahBarang": value["jumlahBarang"] + jumlahBarang,
                  "catatan": catatan,
                  "hargaSatuan": hargaSatuan,
                  "total": value["total"] + (hargaSatuan * jumlahBarang),
                  "urlGambar": urlGambar,
                  "namaToko": namaToko,
                  "alamatToko": alamatToko,
                  "idToko": idToko,
                  "nohapePenjual": nohapePenjual,
                  "namaPenjual": namaPenjual
                });
      } else {
        isiKeranjang[rekPenjual].addAll({
          idLapak: {
            "idLapak": idLapak,
            "namaBarang": namaBarang,
            "norekPenjual": rekPenjual,
            "jumlahBarang": jumlahBarang,
            "catatan": catatan,
            "hargaSatuan": hargaSatuan,
            "total": jumlahBarang * hargaSatuan,
            "urlGambar": urlGambar,
            "namaToko": namaToko,
            "alamatToko": alamatToko,
            "idToko": idToko,
            "nohapePenjual": nohapePenjual,
            "namaPenjual": namaPenjual
          }
        });
      }
      notifyListeners();
      //debugPrint("idLapak sudah ada di keranjang");
    } else {
      isiKeranjang.addAll({
        rekPenjual: {
          idLapak: {
            "idLapak": idLapak,
            "namaBarang": namaBarang,
            "norekPenjual": rekPenjual,
            "jumlahBarang": jumlahBarang,
            "catatan": catatan,
            "hargaSatuan": hargaSatuan,
            "total": jumlahBarang * hargaSatuan,
            "urlGambar": urlGambar,
            "namaToko": namaToko,
            "alamatToko": alamatToko,
            "idToko": idToko,
            "nohapePenjual": nohapePenjual,
            "namaPenjual": namaPenjual
          }
        }
      });
      notifyListeners();
      //debugPrint("idLapak tidak ditemukan di keranjang");
    }
    //debugPrint("isi keranjang :");
    //debugPrint(isiKeranjang.toString());

    // String jsonEncoded = encodemap;

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("isiKeranjang", jsonEncoded);
  }

  Map<String, dynamic> isiKeranjangSembako = {};

  addToCartSembako(
      String namaBarang,
      int idSembako,
      int idMinyak,
      String rekPenjual,
      String satuan,
      int jumlahBarang,
      int hargaSatuan,
      String urlGambar,
      String namaToko,
      String alamatToko,
      String idToko,
      String nohapePenjual,
      String namaPenjual) async {
    bool rekPenjualSudahAda = isiKeranjangSembako.containsKey(rekPenjual);
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (rekPenjualSudahAda) {
      bool idItemSudahAda =
          isiKeranjangSembako[rekPenjual].containsKey(idSembako);

      if (idItemSudahAda) {
        isiKeranjangSembako[rekPenjual].update(
            idSembako,
            (value) => {
                  "namaBarang": namaBarang,
                  "idMinyak": idMinyak,
                  "idSembako": idSembako,
                  "norekPenjual": rekPenjual,
                  "jumlahBarang": value["jumlahBarang"] + jumlahBarang,
                  "satuan": satuan,
                  "hargaSatuan": hargaSatuan,
                  "total": value["total"] + (hargaSatuan * jumlahBarang),
                  "urlGambar": urlGambar,
                  "namaToko": namaToko,
                  "alamatToko": alamatToko,
                  "idToko": idToko,
                  "nohapePenjual": nohapePenjual,
                  "namaPenjual": namaPenjual,
                });
      } else {
        isiKeranjangSembako[rekPenjual].addAll({
          idSembako: {
            "namaBarang": namaBarang,
            "idMinyak": idMinyak,
            "idSembako": idSembako,
            "norekPenjual": rekPenjual,
            "jumlahBarang": jumlahBarang,
            "satuan": satuan,
            "hargaSatuan": hargaSatuan,
            "total": jumlahBarang * hargaSatuan,
            "urlGambar": urlGambar,
            "namaToko": namaToko,
            "alamatToko": alamatToko,
            "idToko": idToko,
            "nohapePenjual": nohapePenjual,
            "namaPenjual": namaPenjual,
          }
        });
      }
      notifyListeners();
      debugPrint("idSembako sudah ada di keranjang");
    } else {
      isiKeranjangSembako.addAll({
        rekPenjual: {
          idSembako: {
            "namaBarang": namaBarang,
            "idMinyak": idMinyak,
            "idSembako": idSembako,
            "norekPenjual": rekPenjual,
            "jumlahBarang": jumlahBarang,
            "satuan": satuan,
            "hargaSatuan": hargaSatuan,
            "total": jumlahBarang * hargaSatuan,
            "urlGambar": urlGambar,
            "namaToko": namaToko,
            "alamatToko": alamatToko,
            "idToko": idToko,
            "nohapePenjual": nohapePenjual,
            "namaPenjual": namaPenjual,
          }
        }
      });
      notifyListeners();
      debugPrint("idSembako tidak ditemukan di keranjang");
    }
    debugPrint("isi keranjang :");
    debugPrint(isiKeranjangSembako.toString());

    // String jsonEncoded = encodemap;

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("isiKeranjang", jsonEncoded);
  }

  Future postTransaksiMinyak(
      int idSembako,
      String norekPenjual,
      int totalBayar,
      int jumlahBarang,
      String pinTransaksi,
      String namaPenerima,
      String nohapePenerima,
      String alamatPenerima,
      List _isiKeranjang,
      int idMetodePengiriman,
      int idMetodePembayaran,
      int biayalayanan) async {
    Map rawBody = {
      'id': usernameUser,
      // 'password': passwordUser,
      'jumlah_barang': jumlahBarang,
      'total_bayar': totalBayar,
      'rek_seller': norekPenjual,
      'rek_buyer': norek,
      'pin': pinTransaksi,
      'id_sembako': idSembako,
      'id_metode_bayar': idMetodePembayaran,
      'id_metode_kirim': idMetodePengiriman,
      'biayalayanan': biayalayanan,
      'detailpembeli': {
        'hp': nohapePenerima,
        'alamat': alamatPenerima,
        'penerima': namaPenerima,
      },
      'listbeli': [],
    };
  }

  Future confirmBayarCart(
      int idToko,
      int rekPenjual,
      int totalBayar,
      String catatanBelanja,
      String pinTransaksi,
      String namaPenerima,
      String nohapePenerima,
      String alamatPenerima,
      List _isiKeranjang,
      int idMetodePengiriman,
      int idMetodePembayaran,
      int margin) async {
    Map rawBody = {
      'nohape': usernameUser,
      // 'password': passwordUser,
      'idToko': idToko,
      'rekBuyer': norek,
      'rekSeller': rekPenjual,
      'totalBayar': totalBayar,
      'catatan': catatanBelanja,
      'pinTransaksi': pinTransaksi,
      'margin': margin,
      'detailPembeli': {
        'penerima': namaPenerima,
        'hp': nohapePenerima,
        'alamat': alamatPenerima,
      },
      'listBeli': [],
      'metodepembayaran': idMetodePembayaran
    };

    _isiKeranjang.forEach((item) {
      List _penampung = [];
      rawBody["listBeli"].add({
        'idBarang': item["idLapak"],
        'jumlah': item["jumlahBarang"],
        'totalHarga': item["total"]
      });
    });

    final bodyJSON = jsonEncode(rawBody);

    final response = await http.post(UrlAPI.confirmBeli14juli2021,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    String responServer;

    if (response.statusCode == 200) {
      if (data['sukses'] == true) {
        //debugPrint("isi response belanjaCart :");
        //debugPrint(data.toString());

        responServer = "sukses";
        await refreshApi();

        return responServer;
      } else if (data['saldoTidakCukup'] == true) {
        //debugPrint('saldo tidak cukup');
        //debugPrint(data.toString());

        responServer = "saldo tidak cukup";
        return responServer;
      } else if (data["pinSalah"] == true) {
        //debugPrint('response : 200 tapi belum sukses, isi respons adalah :');
        //debugPrint(data.toString());

        responServer = "pinSalah";
        return responServer;
      }
    } else {
      //debugPrint("API belanjaCart belum berhasil:");
      //debugPrint(data.toString());

      responServer = "tidak diketahui";
      return responServer;
    }
  }

  Future getLapakku() async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser
    });

    final response =
        await http.post(UrlAPI.getLapakku, body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      //debugPrint('isi list lapakku :');
      //debugPrint(data['data'].toString());
      return data["data"];
    } else {
      List _list = [];
      return _list;
    }
  }

  Future editLapakJuli2021(
      int id_kategorilapak,
      String namaBarang,
      String hargaBarang,
      String stokBarang,
      String deskripsiBarang,
      int idBarang) async {
    var postUri = Uri.parse(UrlAPI.editLapakJuli2021);
    var request = new http.MultipartRequest('POST', postUri);

    request.headers['Accept'] = "application/json";
    request.headers['Authorization'] = "Bearer $token";
    request.headers['Content-Type'] = "application/json";

    request.fields['nohape'] = usernameUser;
    // request.fields['password'] = passwordUser;
    request.fields['idBarang'] = idBarang.toString();
    request.fields['idKategori'] = id_kategorilapak.toString();
    request.fields['namaBarang'] = namaBarang;
    request.fields['hargaBarang'] = hargaBarang;
    request.fields['stokBarang'] = stokBarang;
    request.fields['deskripsiBarang'] = deskripsiBarang;

    var response = await request.send();
    var printedResponse = await http.Response.fromStream(response);

    String apakahSukses;

    // final response = await http.post(urlAPI.bikinLapak,
    //     headers: headerJSON, body: bodyJSON);

    if (response.statusCode == 200) {
      //debugPrint('isi response = ' + response.statusCode.toString());
      //debugPrint(printedResponse.body.toString());
      apakahSukses = "sukses";
      getLapakLokal(1);
      notifyListeners();
      return apakahSukses;
    } else {
      //debugPrint("fungsi upload-lapak belum berhasil");
      //debugPrint(response.statusCode.toString());
      apakahSukses = "gagal";
      return apakahSukses;
    }
  }

  // =================================================================
  // =================================================================
  // ==================== API Tarik Tunai Transfer ===================
  // =================================================================
  // =================================================================

  List listRekeningBankNasabah;

  Future getRekeningNasabah() async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser
    });

    final response = await http.post(UrlAPI.getDataBankNasabah,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    //debugPrint('isi data bank nasabah :');
    //debugPrint(data['data'].toString());
    if (response.statusCode == 200) {
      listRekeningBankNasabah = data["data"];
      listRekeningBankNasabah.forEach((item) {
        item["isSelected"] = false;
        //
        item["gambar"] = listDaftarBank
            .where((item2) =>
                item["nama_bank"].toLowerCase() ==
                item2["namaBank"].toLowerCase())
            .toList()[0]["gambar"];
      });
      //debugPrint("isi dataBankNasabah setelah diproses :");
      //debugPrint(listRekeningBankNasabah.toString());
    } else {
      listRekeningBankNasabah = [];
    }
    notifyListeners();
  }

  //hapus rekening bank
  Future hapusRekeningBank(idBank) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'id_bank_nasabah': idBank,
    });

    final response = await http.post(Uri.parse(UrlAPI.hapusBankNasabah),
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data['sukses'] == true) {
        debugPrint("hapus rekening sukses");
        await getRekeningNasabah();
        return 'sukses';
      } else {
        return 'gagal';
      }
    } else {
      debugPrint("hapus rekening gagal, ayo coba lagi");
      return 'error';
    }
  }

  //tambah rekening bank
  Future tambahRekeningBank(namaBank, norekBank, atasNama, pin) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'namaBank': namaBank,
      'norekBank': norekBank,
      'atasNama': atasNama,
      'idKomunitas': idKomunitas,
      'pin': pin,
    });

    final response = await http.post(UrlAPI.tambahBankNasabah,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data['sukses'] == true) {
        //debugPrint("tambah rekening sukses");
        await getRekeningNasabah();
        return 'sukses';
      } else if (data['sukses'] == false && data['status'] == 'pin salah') {
        return 'pin salah';
      } else if (data['sukses'] == false &&
          data['status'] == 'Rekening sudah ada') {
        return 'Rekening sudah ada';
      } else {
        return 'gagal';
      }
    } else {
      //debugPrint("tambah rekening gagal, ayo coba lagi");
      return 'error';
    }
  }

  //tambah rekening bank
  Future requestTarikTransfer(int jumlah, idBankNasabah, pin) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'pin': pin,
      'jumlah': jumlah,
      'norek_pengirim': norek,
      'jenis': 'cashout transfer',
      'id_bank_nasabah': idBankNasabah
    });

    final response = await http.post(UrlAPI.requestTarikTransfer,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    //
    //debugPrint("response request cashoutTransfer");
    //debugPrint(data.toString());
    try {
      if (response.statusCode == 200 && data["kode"] == "sukses") {
        //debugPrint("request tarik taransfer sukses");
        nohpTeller1 = data["nohpTeller"];
        // lupa kok kenapa harus getRekeningNasabah lagi
        // await getRekeningNasabah();
        return 'sukses';
      } else if (data["kode"] == "pin salah") {
        //debugPrint("tarik transfer : salah pin");
        return 'pin salah';
      } else {
        //debugPrint("tambah rekening gagal");
        return 'error';
      }
    } catch (e) {
      //debugPrint("error karena :");
      //debugPrint(e.toString());
      return "error";
    }
  }

  // =================================================================
  // =================================================================
  // ==================== API MERCHANT & QR-CODE =====================
  // =================================================================
  // =================================================================

  //CARI USER berdasarkan ID

  Future getUserById(String userID) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'user_id': userID
    });

    final response = await http.post(UrlAPI.getUserById,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    var informasiUser = {};

    bool apakahSukses = false;

    if (response.statusCode == 200) {
      if (data["data"].length > 0) {
        //debugPrint("data $userID ditemukan");
        apakahSukses = true;

        informasiUser = data["data"][0];
        informasiUser["saldo"] = informasiUser["saldo"]
            .substring(0, informasiUser['saldo'].length - 3);

//        formatedBalance.substring(0, formatedBalance.length - 3);

        return informasiUser;
      } else {
        //debugPrint("data $userID TIDAK ditemukan");
        apakahSukses = false;
        return informasiUser;
      }
    } else {
      //debugPrint(data.toString());
      //debugPrint("fungsi getRiwayatPembelian belum berhasil");
      return informasiUser;
    }
  }

  Future confirmBelanjaMerchant(
      String pin, String idPembeli, int totalBelanja, String deskripsi) async {
    deskripsi = deskripsi ?? "tidak ada catatan";

    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'pin': pin,
      'id_pembeli': idPembeli,
      'total_belanja': totalBelanja,
      'deskripsi': deskripsi
    });

    final response = await http.post(UrlAPI.confirmBelanjaMerchant,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    bool apakahSukses = false;

    if (response.statusCode == 200) {
      if (data['sukses'] == true) {
        //debugPrint("isi response belanjaMerchant :");
        //debugPrint(data.toString());

        apakahSukses = true;
        return apakahSukses;
      } else if (data['saldoTidakCukup'] == true) {
        //debugPrint('saldo tidak cukup');
        //debugPrint(data.toString());
        return apakahSukses;
      } else {
        //debugPrint('response : 200 tapi belum sukses, isi respons adalah :');
        //debugPrint(data.toString());
        return apakahSukses;
      }
    } else {
      //debugPrint("API belanjaMerchant belum berhasil:");
      //debugPrint(data.toString());

      apakahSukses = false;
      return apakahSukses;
    }
  }

  Future<void> refreshApi() async {
    final response = await http.post(
      Uri.parse(UrlAPI.baseInfo),
      headers: headerJSON,
    );

    var data = json.decode(response.body);

    var status;

    if (response.statusCode == 203) {
      formatedBalance = data['saldo'];
      formatedBalance =
          formatedBalance.substring(0, formatedBalance.length - 3);
      statusPayLater = data['status_paylater'];
      statusPayLaterUser = data['status_paylater_user'];
      limitPayLater = data['limit_paylater'];
      // limitPayLater = limitPayLater.substring(0, limitPayLater.length - 3);
      saldoPayLaterSekarang = data['saldo_sekarang'];
      // saldoPayLaterSekarang =
      //     saldoPayLaterSekarang.substring(0, saldoPayLaterSekarang.length - 3);
      penggunaanPayLater = limitPayLater - saldoPayLaterSekarang;
      alamatUser = data['alamat_nasabah'];
      isMinyak = data["isMinyak"];

      debugPrint('berhasil refresh data');
      status = 1;
      getLapakLokal(1);
      // gettagihan();
    } else {
      status = 0;
      return status;
    }

    notifyListeners();
  }

  Future topup(amount) async {
    // String credentials = "$username:$password";
    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // String encoded = stringToBase64.encode(credentials);
    // String authValue = "Basic $encoded";
    // authVaue64 = authValue;

    //debugPrint('ini password dari $usernameUser = $passwordUser');

    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'nominal': amount,
      'norek_pengirim': norek
    });

    final response =
        await http.post(UrlAPI.topup, headers: headerJSON, body: bodyJSON);

    //debugPrint('1 step sebelum decode response');

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      //debugPrint('TOPUP SUKSESSSSS');
      // //debugPrint(data.toString());

      //debugPrint(
      // 'nilai formatedBalance adalah = ${formatedBalance.toString()}');

      //debugPrint("======id user $idUser ==========");

      notifyListeners();
      return data;
    } else if (response.statusCode > 399 && response.statusCode < 500) {
      //debugPrint('TOPUP Edimu GAGAL');
      //debugPrint(data.toString());
      return data;
    }
  }

  //get QRIS
  Future getQRIS() async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser
    });

    final response = await http.post(UrlAPI.getQRISKomunitas,
        headers: headerJSON, body: bodyJSON);

    var data = json.decode(response.body);
    //debugPrint(data.toString());

    if (response.statusCode == 200) {
      if (data["data"]["qris"].length > 3) {
        return data["data"]["qris"];
      } else {
        return "belum";
      }
    } else {
      return 'error';
    }
  }

  List listTeller = [];

  Future getTeller() async {
    String status = 'error';
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser
    });

    final response =
        await http.post(UrlAPI.getTeller, headers: headerJSON, body: bodyJSON);

    // //debugPrint("isi dari response.body contact");
    // //debugPrint(response.body);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data['list_teller'].length > 0) {
        listTeller = data['list_teller'];
        notifyListeners();

        //debugPrint('isi list_teller adalah : ');
        //debugPrint(listTeller.toString());

        status = 'sukses';
        return status;
      } else {
        status = 'kosong';
        return status;
      }
    } else {
      return status;
    }
  }

  Future<Null> getContacts() async {
    isLoading = true;
    notifyListeners();

    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser
    });

    final response = await http.post(UrlAPI.getContacts,
        headers: headerJSON, body: bodyJSON);

    // //debugPrint("isi dari response.body contact");
    // //debugPrint(response.body);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      contactsList contacts = contactsList.fromJson(data['list contact']);

      listContacts = contacts;

      // //debugPrint(contacts.contactLists[0].name);

      isLoading = false;
      notifyListeners();

      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> transfer(
      String norek_penerima, int jumlah, String deskripsi, String pin) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'jumlah': jumlah,
      'jenis': 'transfer',
      'deskripsi': deskripsi,
      'norek_pengirim': norek,
      'norek_penerima': norek_penerima,
      'pin': pin
    });

    final response = await http.post(UrlAPI.transfer16feb21,
        headers: headerJSON, body: bodyJSON);

    var data = json.decode(response.body);

    String status;

    if (response.statusCode == 200) {
      //debugPrint(
      // 'transfer sukses, dibawah ini adalah response dari API transfer');
      //debugPrint(data.toString());

      status = 'sukses';

      refreshApi();

      return status;
    } else if (response.statusCode == 201) {
      //debugPrint('PIN SALAH, dibawah ini adalah response dari API transfer');
      //debugPrint(data.toString());

      status = 'pin salah';

      return status;
    } else {
      //debugPrint('server error');
      //debugPrint(data.toString());
    }
  }

  Future ubahPassword(currentPassword, passwordBaru) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'current-password': currentPassword,
      'new-password': passwordBaru
    });

    String status = "";

    final response = await http.post(UrlAPI.ubahPassword,
        headers: headerJSON, body: bodyJSON);

    //debugPrint('1 step sebelum decode response');

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      //debugPrint('UBAH SUKSESSSSS');
      //debugPrint(data.toString());

      //debugPrint(
      // 'nilai formatedBalance adalah = ${formatedBalance.toString()}');

      //debugPrint("======id user $idUser ==========");

      status = "0";

      return status;
    } else if (data['error'] == "1" || data['error'] == "2") {
      status = data['error'];
      return status;
    } else if (response.statusCode > 399 && response.statusCode < 500) {
      //debugPrint('UBAH PASSWORD Edimu GAGAL');
      //debugPrint('isi response :');
      //debugPrint(data.toString());
      status = "4";

      return status;
    }
  }

  // get getListHistory {
  //   isLoading = true;
  //   notifyListeners();
  //   getHistoryTransaction();
  //   if (listHistorys != null) {
  //     isLoading = false;
  //     notifyListeners();
  //     return listHistorys;
  //   } else {
  //     isLoading = false;
  //     notifyListeners();
  //     return [];
  //   }
  //   // return listHistorys;
  // }

  List listRiwayatBelanjaMerchant;

  Future getHistoryTransaction() async {
    isLoading = true;
    notifyListeners();

    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser
    });

    final response =
        await http.post(UrlAPI.getHistory, headers: headerJSON, body: bodyJSON);

    //debugPrint("==========999==========");
    //debugPrint(response.body);
    //debugPrint("==========999==========");
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      //userMap.addEntries(data);
      historysList historys = historysList.fromJson(data['list riwayat']);
      listHistorys = historys;

      listRiwayatBelanjaMerchant = data["riwayat belanja"];
      //debugPrint("isi listRiwayatBelanja :");
      //debugPrint(listRiwayatBelanjaMerchant.toString());

      isLoading = false;

      notifyListeners();
      return listHistorys;
    }
    isLoading = false;
    notifyListeners();
  }

  Future getHistoryPaylater() async {
    isLoading = true;
    notifyListeners();

    final bodyJSON = jsonEncode({
      'id': usernameUser,
      // 'password': passwordUser
    });

    final response = await http.post(UrlAPI.getHistoryPaylater,
        headers: headerJSON, body: bodyJSON);

    debugPrint("==========999==========");
    debugPrint(response.body);
    debugPrint("==========999==========");
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      //userMap.addEntries(data);

      listRiwayatBelanjaMerchant = data["riwayat belanja"];
      debugPrint("isi listRiwayatBelanja :");
      debugPrint(listRiwayatBelanjaMerchant.toString());

      isLoading = false;

      notifyListeners();
      return listHistorys;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<Map> tarikTunai(String pin, int jumlah) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'pin': pin,
      'jumlah': jumlah,
      'norek_pengirim': norek,
    });

    final response =
        await http.post(UrlAPI.tarikTunai, headers: headerJSON, body: bodyJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      //debugPrint(
      // 'transfer sukses, dibawah ini adalah response dari API transfer');
      //debugPrint(data.toString());
      return data;
    }
  }

  Future<Map> register(String noHape, String name, String email,
      String password, int idGrup) async {
    final bodyJSON = jsonEncode({
      "nohape": noHape,
      "name": name,
      "email": email,
      "password": password,
      "confirmation": password,
      "grup": idGrup,
      "komunitas": 1
    });

    final response =
        await http.post(UrlAPI.register, headers: headerJSON, body: bodyJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      //debugPrint(
      // 'transfer sukses, dibawah ini adalah response dari API transfer');
      //debugPrint(data.toString());
      return data;
    }
  }

  ////////////////////////////////////////////////
  ////////////////////////////////////////////////
  ////////////  TAGIHAN PEMBAYARAN SEKOLAH
  ////////////////////////////////////////////////
  ////////////////////////////////////////////////

  List dataSiswa = [];
  List listTagihanSekolah = [];
  int grandTotalTagihanSekolah = 0;
  //
  List listRiwayatPembayaranSekolah = [];

  Future getTagihanSekolah() async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
    });

    final response = await http.post(UrlAPI.getDataTagihanSekolahFebruari2022,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    //debugPrint("isi fungsi getTagihanSekolah");
    //debugPrint(data.toString());

    if (response.statusCode == 200) {
      listTagihanSekolah = data['list_tagihan'];
      dataSiswa = data['data_siswa'];

      grandTotalTagihanSekolah = 0;

      //debugPrint("totalTagihan saat ini = $grandTotalTagihanSekolah");
      listTagihanSekolah.forEach((item) {
        grandTotalTagihanSekolah +=
            int.parse(item["totaltagihan"].replaceAll('.00', ''));
        //
        item["detailtagihan"].forEach((item2) {
          item2["apakahDipilih"] = true;
        });
      });

      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future getRiwayatPembayaranSekolahFebruari2022() async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
    });

    final response = await http.post(
        UrlAPI.getRiwayatPembayaranSekolahFebruari2022,
        body: bodyJSON,
        headers: headerJSON);

    var data = json.decode(response.body);
    //debugPrint("isi fungsi getRiwayatPembayaranSekolah");
    //debugPrint(data.toString());

    if (response.statusCode == 200) {
      listRiwayatPembayaranSekolah = data["list riwayat"];
      //debugPrint("fungsi get riwayat tagihan sekolah berhasil");
      notifyListeners();
    } else {
      //debugPrint("fungsi getRiwayat tagihan BELUM BERHASIL");
      notifyListeners();
    }
  }

  Future bayarTagihanSekolah(String pin, List listTagihanYangDipilih) async {
    Map rawBody = {
      'nohape': usernameUser,
      // 'password': passwordUser,
      'pin': pin,
      'listBayar': []
    };

    listTagihanYangDipilih.forEach((item) {
      rawBody["listBayar"]
          .add({'id_tagihan': item["id_tagihan"], 'jumlah': item["jumlah"]});
    });

    debugPrint("============= ini isi rawBody ===============");
    debugPrint(rawBody.toString());
    final bodyJSON = jsonEncode(rawBody);

    final response = await http.post(UrlAPI.bayarTagihanSekolahFebruari2022,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    //debugPrint("isi response bayarTagihanSekolah :");
    //debugPrint(data.toString());

    try {
      if (response.statusCode == 200 &&
          data["status"] == "data berhasil dimasukkan") {
        //debugPrint("pemabayaran sukses");
        notifyListeners();
        getTagihanSekolah();
        return "sukses";
      } else if (response.statusCode == 200 && data["status"] == "pin salah") {
        //debugPrint("pin salah");
        notifyListeners();
        return "pin salah";
      } else {
        //debugPrint("error");
        notifyListeners();
        return "error";
      }
    } catch (e) {
      //debugPrint("server error");
      return "error";
    }
  }

  // ========================================================================
  // ========================================================================
  // ======================    Edimu MARKETPLACE     ========================
  // ========================================================================
  // ========================================================================

  List listLapak = [];
  int lastPageMarketplace;

  Future getLapakLokal(int page) async {
    listLapak = [];
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
    });

    final response = await http.post(
        UrlAPI.getMarketplace14juli2021 + '?page=' + page.toString(),
        body: bodyJSON,
        headers: headerJSON);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      // //debugPrint('isi listLapak setelah paginasi :');
      // //debugPrint(data.toString());

      listLapak = data['data store']['data'];
      lastPageMarketplace = data['data store']['last_page'];
      idLayanan = data['id layanan'];
      // biayaLayananAplikasi =
      //     int.parse(data['biaya layanan'].replaceAll(".00", ""));

      formulaPembagianMarketPlace = data["data konstanta"];

      //debugPrint("idLayanan = ${idLayanan}");
      //debugPrint("biayaLayananAplikasi = ${biayaLayananAplikasi}");

      notifyListeners();
    } else {
      //debugPrint("fungsi GETTAGIH belum berhasil");
      return null;
    }
  }

  List listRiwayatPembelian = [];

  Future getRiwayatPembelian(int page) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
    });

    final response = await http.post(
        UrlAPI.getRiwayatMarketplace + page.toString(),
        body: bodyJSON,
        headers: headerJSON);

    var data = json.decode(response.body);

    bool apakahSukses = false;

    if (response.statusCode == 200) {
      // //debugPrint(data.toString());
      listRiwayatPembelian.addAll(data['data']);

      //debugPrint('isi listRiwayatPembelian :');
      //debugPrint(listRiwayatPembelian.toString());
      //debugPrint(data.toString());

      apakahSukses = true;
      notifyListeners();
      return apakahSukses;
    } else {
      //debugPrint(data.toString());
      //debugPrint("fungsi getRiwayatPembelian belum berhasil");
      return apakahSukses;
    }
  }

  List listRiwayatPenjualan = [];

  Future getRiwayatPenjualan(int page) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
    });

    final response = await http.post(
        UrlAPI.getRiwayatPenjualan + page.toString(),
        body: bodyJSON,
        headers: headerJSON);

    var data = json.decode(response.body);

    bool apakahSukses = false;

    if (response.statusCode == 200) {
      // //debugPrint(data.toString());
      listRiwayatPenjualan.addAll(data['data']);

      // //debugPrint('isi listRiwayatPenjualan :');
      // //debugPrint(listRiwayatPenjualan.toString());

      apakahSukses = true;
      notifyListeners();
      return apakahSukses;
    } else {
      // //debugPrint(data.toString());
      // //debugPrint("fungsi getRiwayatPembelian belum berhasil");
      return apakahSukses;
    }
  }

  Future uploadBarang(
      int id_kategorilapak,
      String judul,
      String harga,
      String stok,
      String deskripsi,
      String nohapeLapak,
      File image,
      alamatPengambilan,
      idMetodePengiriman) async {
    var postUri = Uri.parse(UrlAPI.bikinLapakJan2021);
    var request = new http.MultipartRequest('POST', postUri);

    request.headers['Accept'] = "application/json";
    request.headers['Authorization'] = "Bearer $token";
    request.headers['Content-Type'] = "application/json";

    request.fields['nohape'] = usernameUser;
    // request.fields['password'] = passwordUser;
    request.fields['id_kategorilapak'] = id_kategorilapak.toString();
    request.fields['id_komunitas'] = idKomunitas.toString();
    request.fields['judul'] = judul;
    request.fields['harga'] = harga;
    request.fields['stok'] = stok;
    request.fields['deskripsi'] = deskripsi;
    request.fields['nohape_penjual'] = nohapeLapak;
    request.fields['alamat_pengambilan'] = alamatPengambilan;
    request.fields['idmetodepengiriman'] = idMetodePengiriman.toString();
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    var response = await request.send();

    bool apakahSukses = false;

    // final response = await http.post(urlAPI.bikinLapak,
    //     headers: headerJSON, body: bodyJSON);

    // var data = json.decode(response.body);

    if (response.statusCode == 200) {
      //debugPrint('isi response = ' + response.statusCode.toString());
      apakahSukses = true;
      getLapakLokal(1);
      notifyListeners();
      return apakahSukses;
    } else {
      //debugPrint("fungsi upload-lapak belum berhasil");
      //debugPrint(response.statusCode.toString());
      return apakahSukses;
    }
  }

  Future konfirmasiBeli(
      lapakId,
      stok,
      totalBayar,
      catatan,
      pin,
      idPenjual,
      alamatPembeli,
      rekPenjual,
      idMetodePengiriman,
      noHapePenerima,
      nohapePenjual,
      namaPenerima) async {
    if (nohapePenjual == '') {
      nohapePenjual = 0;
    }

    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'lapakid': lapakId,
      'stok': stok,
      'totalbayar': totalBayar,
      'catatan': catatan,
      'pin': pin,
      'rek_pembeli': norek,
      'idpenjual': idPenjual,
      'alamat_pembeli': alamatPembeli,
      'rek_penjual': rekPenjual,
      'id_metodepengiriman': idMetodePengiriman,
      'nohape_penerima': noHapePenerima,
      'nohape_penjual': nohapePenjual,
      'nama_penerima': namaPenerima
    });

    Map respon;

    final response = await http.post(UrlAPI.konfirmasiBeli,
        headers: headerJSON, body: bodyJSON);

    var data = json.decode(response.body);

    //debugPrint(data.toString());

    if (response.statusCode == 200) {
      //debugPrint(
      // 'response statusCode adalah = ${response.statusCode.toString()}');
      //debugPrint('isi response = ');
      //debugPrint(data.toString());
      respon = {
        'status': 'sukses',
        'kwitansi': data['kwitansi'],
        'waktu': data['jam']
      };
      return respon;
    } else {
      //debugPrint("fungsi post ke DB belum berhasil");
      //debugPrint("statusCode = ${response.statusCode.toString()}");
      //debugPrint(data.toString());
      respon = {'status': 'gagal'};
      return respon;
    }
  }

  // ========================================================================
  // ============================= P P O B ==================================
  // ========================================================================

  String idLayananPPOB;
  String nohpTeller1;

  //PPOB
  //get riwayat pembayaran
  Future getPricelistPulsaPrepaid() async {
    final bodyJSON = jsonEncode({
      'id': usernameUser,
      // 'password': passwordUser,
    });

    List _pricelistPulsa = [];

    final response = await http.post(UrlAPI.getPricelistPulsa,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    //debugPrint(data.toString());

    if (response.statusCode == 200) {
      idLayananPPOB = data['idBiayaLayanan'];
      //debugPrint("isi idBiayaLanan = ${idLayananPPOB}");
      //
      _pricelistPulsa = data['result'];
      return _pricelistPulsa;
    } else {
      //debugPrint("fungsi getPricelistPulsa belum berhasil");
      _pricelistPulsa = [];
      return _pricelistPulsa;
    }
  }

  Future beliPulsaPrepaid(Map itemYangDibeli, String noHPTujuan, String pin,
      int metodePembayaran) async {
    final bodyJSON = jsonEncode({
      'id': usernameUser,
      // 'password': passwordUser,
      'pulsa_code': itemYangDibeli["pulsa_code"],
      'operator': itemYangDibeli['pulsa_op'],
      'deskripsi_nominal': itemYangDibeli['pulsa_nominal'],
      'hpTujuan': noHPTujuan,
      'rek_user': norek,
      'total_bayar': itemYangDibeli['harga_enduser'],
      'idBiayaLayanan': idLayananPPOB,
      'pin': pin,
      'metodepembayaran': metodePembayaran,
    });

    final response = await http.post(UrlAPI.topupPulsaPrepaid,
        headers: headerJSON, body: bodyJSON);

    var data = json.decode(response.body);

    //debugPrint(data.toString());
    try {
      if (data['status'] == 'OK') {
        //debugPrint(
        // 'beli pulsa sukses, dibawah ini adalah response dari API beli pulsa');
        //debugPrint(data.toString());
        refreshApi();
        return StatusPPOB.sukses;
      } else if (data['status'] == 'pin salah') {
        return StatusPPOB.salahPin;
      } else if (data['status'] == 'saldo komunitas tidak cukup') {
        nohpTeller1 = data["nohpTeller"];
        //debugPrint("nohpTeller = ${nohpTeller1}");
        return StatusPPOB.saldoKomunitasTidakCukup;
      } else {
        //debugPrint('beli pulsa gagal');
        //debugPrint("isi bodyJson");
        //debugPrint(bodyJSON.toString());
        return StatusPPOB.error;
      }
    } catch (error) {
      //debugPrint(error.toString());
      return StatusPPOB.error;
    }
  }

  // Beli token listrik prepaid

  Future beliTokenListrikPrepaid(Map itemYangDibeli, String noMeter,
      String idLayananPPOB, String pin, int metodePembayaran) async {
    final bodyJSON = jsonEncode({
      'id': usernameUser,
      // 'password': passwordUser,
      //
      'pulsa_code': itemYangDibeli["pulsa_code"],
      'operator': itemYangDibeli['pulsa_op'],
      'deskripsi_nominal': itemYangDibeli['pulsa_nominal'],
      'noMeter': noMeter,
      'rek_user': norek,
      'total_bayar': itemYangDibeli['harga_enduser'],
      'idBiayaLayanan': idLayananPPOB,
      'pin': pin,
      'metodepembayaran': metodePembayaran
    });

    final response = await http.post(UrlAPI.beliTokenPLNPrepaid,
        headers: headerJSON, body: bodyJSON);

    var data = json.decode(response.body);

    //debugPrint(data.toString());

    try {
      if (response.statusCode == 200) {
        if (data['apakahSukses'] == true) {
          //debugPrint(
          // 'beli pulsa sukses, dibawah ini adalah response dari API beli pulsa');
          //debugPrint(data.toString());
          refreshApi();
          return StatusPPOB.sukses;
        } else if (data["status"] == "pin salah") {
          //debugPrint("pin salah");
          return StatusPPOB.salahPin;
        } else if (data["status"] == "saldo komunitas tidak cukup") {
          nohpTeller1 = data["nohpTeller"];
          //debugPrint("nohpTeller = ${nohpTeller1}");
          //debugPrint("saldo komunitas gak cukup");
          return StatusPPOB.saldoKomunitasTidakCukup;
        } else {
          //debugPrint('beli token PLN gagal');
          //debugPrint("isi bodyJson");
          //debugPrint(bodyJSON.toString());
          return StatusPPOB.error;
        }
      } else if (response.statusCode == 0) {
        //debugPrint("tidak ada internet");
        //debugPrint('response.status = ${response.statusCode}');
        return StatusPPOB.tidakAdaInternet;
      }
    } catch (error) {
      //debugPrint("pembelian token listrik error, log error :");
      //debugPrint(error.toString());
      return StatusPPOB.error;
    }
  }

  Future getPricelistTokenPLNPrepaid(nomorMeteran) async {
    final bodyJSON = jsonEncode({
      'id': usernameUser,
      // 'password': passwordUser,
      'noMeter': nomorMeteran
    });

    Map _pricelistTokenListrik = {};

    final response = await http.post(UrlAPI.getPricePLNPrabayar,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    //debugPrint(data.toString());

    if (response.statusCode == 200 && data["data_pelanggan"]["status"] == "1") {
      //debugPrint("data_pelanggan ditemukan");
      _pricelistTokenListrik = data;
      return _pricelistTokenListrik;
    } else if (response.statusCode == 200 &&
        data["data_pelanggan"]["status"] == "2") {
      //response ketika idPelanggan tidak ditemukan
      //debugPrint("data_pelanggan tidak ditemukan");
      _pricelistTokenListrik = data;
      return _pricelistTokenListrik;
    } else {
      //debugPrint("fungsi getPricelistTokenPLN belum berhasil");
      //debugPrint("data_pelanggan:");
      //debugPrint(data["data_pelanggan"].toString());
      _pricelistTokenListrik = {
        "data_pelanggan": {"status": 0}
      };
      return _pricelistTokenListrik;
    }
  }

  Future getRiwayatTokenListrik() async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
    });

    List _listRiwayat = [];

    final response = await http.post(UrlAPI.getRiwayatTokenPLNPrepaid,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    //debugPrint(data.toString());

    if (response.statusCode == 200) {
      //debugPrint("riwayat pembelian PLN ditemukan");
      //
      Map _filteringArray = {};

      data["data"].forEach((item) {
        _filteringArray[item["ref_id"]] = item;
      });

      //debugPrint("isi _filteringArray = ");
      //debugPrint(_filteringArray.toString());

      _filteringArray.forEach((key, value) => _listRiwayat.add(value));
      //debugPrint("isi _listRiwayat = ");
      //debugPrint(_listRiwayat.toString());

      return _listRiwayat;
    } else {
      //debugPrint("fungsi getRiwayat belum berhasil");
      return [];
    }
  }

  ////////////////////////////
  /// TAGIHAN PASCA BAYAR  ///
  ////////////////////////////

  // cek pelanggan
  Future getTagihanListrikPascaBayar(nomorMeteran, String kodePasca,
      {int jumlahBulan = 1, String noKTP = ""}) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'noMeter': nomorMeteran,
      'code': kodePasca,
      'bulan': jumlahBulan,
      'nomor_identitas': noKTP,
    });

    final response = await http.post(UrlAPI.getTagihanPascaBayar,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    Map _pricelistTokenListrik = {};

    //debugPrint(data.toString());

    if (response.statusCode == 200 && data["status"] == 1) {
      //debugPrint("data_pelanggan ditemukan");
      _pricelistTokenListrik = data;
      _pricelistTokenListrik["status"] = StatusPPOB.pelangganDitemukan;
      return _pricelistTokenListrik;
    } else if (data['message']['message'] == "TAGIHAN SUDAH LUNAS") {
      //debugPrint("Tagihan sudah lunas");
      _pricelistTokenListrik = data;
      _pricelistTokenListrik["status"] = StatusPPOB.tagihanSudahLunas;
      return _pricelistTokenListrik;
    } else if (response.statusCode == 200 && data["status"] == 0) {
      //response ketika idPelanggan tidak ditemukan
      //debugPrint("data_pelanggan tidak ditemukan");
      _pricelistTokenListrik = data;
      _pricelistTokenListrik["status"] = StatusPPOB.pelangganTidakDitemukan;
      return _pricelistTokenListrik;
    } else {
      //debugPrint("fungsi getPricelistTokenPLN belum berhasil");
      //debugPrint("data_pelanggan:");
      //debugPrint(data["data_pelanggan"].toString());
      _pricelistTokenListrik["status"] = StatusPPOB.error;
      return _pricelistTokenListrik;
    }
  }

  Future bayarTagihanPascaBayar(int trID, int totalBayar, String kodePasca,
      bool apakahDev, String pin, int metodePembayaran,
      {int bulan = 0}) async {
    //
    //
    trID += 18429;

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encodedPassword = stringToBase64.encode(passwordUser);
    String encodedtrID = stringToBase64.encode(trID.toString());

    //debugPrint("encoded trID = ${encodedtrID}");

    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      'password': encodedPassword,
      'tr_id': encodedtrID,
      'pin': pin,
      'code': kodePasca,
      'rek_user': norek,
      'totalBayar': totalBayar,
      'apakahDev': apakahDev,
      'bulan': bulan,
      'metodepembayaran': metodePembayaran,
    });

    final response = await http.post(UrlAPI.bayarTagihanPascaBayar,
        headers: headerJSON, body: bodyJSON);

    var data = json.decode(response.body);

    //debugPrint('response api bayarTagihanPascaBayar = $kodePasca');
    //debugPrint(data.toString());
    List result = [];

    try {
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          //debugPrint('beli pulsa sukses');
          refreshApi();
          result = [StatusPPOB.sukses];
          return result;
        } else if (data["status"] == 2) {
          //debugPrint("pin salah");
          result = [StatusPPOB.salahPin];
          return result;
        } else if (data["status"] == 0) {
          nohpTeller1 = data["nohpTeller"];
          //debugPrint("nohpTeller = ${nohpTeller1}");
          //debugPrint("saldo komunitas gak cukup");
          result = [StatusPPOB.saldoKomunitasTidakCukup, data["message"]];
          return result;
        } else {
          //debugPrint('bayar tagihan $kodePasca gagal');
          //debugPrint("isi bodyJson");
          //debugPrint(bodyJSON.toString());
          result = [
            StatusPPOB.error,
          ];
          return result;
        }
      } else if (response.statusCode == 0) {
        //debugPrint("tidak ada internet");
        //debugPrint('response.status = ${response.statusCode}');
        result = [
          StatusPPOB.tidakAdaInternet,
        ];
        return result;
      }
    } catch (error) {
      //debugPrint("pembelian token listrik error, log error :");
      //debugPrint(error.toString());
      result = [
        StatusPPOB.error,
      ];
      return result;
    }
  }

  List<RiwayatPlnPascaBayar> listRiwayatPLNPascabayar = [];

  // cek pelanggan
  Future getRiwayatListrikPascaBayar(String code) async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
      'code': code
    });

    final response = await http.post(UrlAPI.getRiwayatPascaPLN,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);

    //debugPrint("isi response getRiwayatPascaPLN");
    //debugPrint(data.toString());

    try {
      if (response.statusCode == 200 && data["status"] == 1) {
        //debugPrint("riwayat pascaPLN ditemukan");
        // historysList historys = historysList.fromJson(data['list riwayat']);
        // listHistorys = historys;

        // listRiwayatBelanjaMerchant = data["riwayat belanja"];
        // //debugPrint("isi listRiwayatBelanja :");
        // //debugPrint(listRiwayatBelanjaMerchant.toString());

        listRiwayatPLNPascabayar =
            ListRiwayatPlnPascaBayar.fromJson(data).riwayatPlnPascaBayar;

        //debugPrint("isi listRiwayatPLNPascaBayar :");
        //debugPrint(listRiwayatPLNPascabayar.toString());
      } else if (response.statusCode == 200 && data["status"] == 0) {
        //debugPrint("riwayat PascaPLN tidak ditemukan");
      } else {
        //debugPrint("riwayat PascaPLN pelanggan error");
      }
    } catch (error) {
      //debugPrint("get riwayat error, isi error:");
      //debugPrint(error.toString());
    }
    notifyListeners();
  }

  ////////////////////////////
  //////////// PDAM  /////////
  ////////////////////////////

  List listWilayahPDAM = [];
  String asalKota = "";

  Future getWilayahPDAM() async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
    });

    final response = await http.post(UrlAPI.getWilayahPDAM,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    //
    debugPrint("isi getDataWilayah");
    debugPrint(data.toString());
    //
    try {
      if (response.statusCode == 200) {
        debugPrint("getWilayahPDAM berhasil");
        listWilayahPDAM = data["data"];
        asalKota = data["kota"];
      } else {}
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  ////////////////////////////
  //////////// PDAM  /////////
  ////////////////////////////
  Future getWilayahSamsat() async {
    final bodyJSON = jsonEncode({
      'nohape': usernameUser,
      // 'password': passwordUser,
    });

    final response = await http.post(UrlAPI.getWilayahSamsat,
        body: bodyJSON, headers: headerJSON);

    var data = json.decode(response.body);
    //
    debugPrint("isi getDataWilayah");
    debugPrint(data.toString());
    //
    try {
      if (response.statusCode == 200) {
        debugPrint("getWilayahPDAM berhasil");
        listWilayahPDAM = data["data"];
        asalKota = data["kota"];
      } else {}
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  ///
  ///

  //Edimu logout
  Future<Null> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('noHape');
    // prefs.remove('password');
    prefs.remove('login');
    prefs.remove('statusAuth');
    isiKeranjang = {};
    listRekeningBankNasabah = [];

    apakahPunyaToko = false;

    usernameUser = null;
    passwordUser = null;
    listContacts = null;
    authVaue64 = null;
    statusAuth = null;
    // dataSiswa = {};
    listTagihan = [];

    // main();
  }

  // ========================================================================
  // ========================================================================
  // ===================== BATAS MODEL UNTUK Edimu APP =======================
  // ========================================================================
  // ========================================================================

}

// ======================== Utility di sini

mixin UtilityModel on ConnectedModel {
  bool get isLoad {
    return isLoading;
  }
}
