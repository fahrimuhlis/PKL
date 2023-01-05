import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class adssList {
  final List<adsModel> adsLists;

  adssList({
    this.adsLists,
  });
  factory adssList.fromJson(List<dynamic> parsedJson) {
    List<adsModel> adsListnya = List<adsModel>();
    adsListnya = parsedJson.map((i) => adsModel.fromJson(i)).toList();

    return adssList(adsLists: adsListnya);
  }
}
//contactModel = adsModel
//contactsList = adssList
//contactLists = adsLists

class adsModel {
  final int id;
  final String title;
  final String description;
  final String owner;
  final String usernameOwner;
  final double price;
  final String formatedPrice;
  final String images;
  final int catagory;
  final String catagoryName;
  final String kodeLayanan;

  adsModel(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.owner,
      @required this.usernameOwner,
      @required this.price,
      @required this.formatedPrice,
      this.images,
      @required this.catagory,
      @required this.catagoryName,
      this.kodeLayanan});

  factory adsModel.fromJson(Map<String, dynamic> json) {
    if (json["images"] == null) {
      return new adsModel(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          owner: json["owner"]["name"],
          usernameOwner: json['owner']['username'],
          price: json['price'],
          formatedPrice: json['formattedPrice'],
          images: json["images"] == null
              ? 'https://s.kaskus.id/r960x960/images/2014/06/21/5705483_201406211144530109.jpg'
              : json["images"][0]['fullUrl'],
          catagory: json['category']['id'],
          catagoryName: json['category']['name'],
          kodeLayanan: json['customValues'][0]['value']);

//      return new historyModel(
//        id: json["id"],
//        formatedDate: json["formattedDate"],
//        formatedAmount: json["formattedAmount"],
//        transferTypeId: json["transferType"]['id'],
//        // transferTypeName == null? 'empty' : json["transferType"]['name'],
//        // transferTypeName: json["transferType"]['name'] ,
//        transferTypeName: json["transferType"]['name'] == null? 'kosong' :json["transferType"]['name'],
//        description: json["description"],
//        toMember: json["member"]['name'],
//
//      );
    } else {
      return new adsModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        owner: json["owner"]["name"],
        usernameOwner: json['owner']['username'],
        price: json['price'],
        formatedPrice: json['formattedPrice'],
        images: json['images'][0]['fullUrl'],
        catagory: json['category']['id'],
        catagoryName: json['category']['name'],
      );
    }
//    return new adsModel(
//      id: json['id'],
//      title: json['title'],
//      description: json['description'],
//      owner: json["owner"]["name"],
//      usernameOwner: json['owner']['username'],
//      price: json['price'],
//      formatedPrice: json['formattedPrice'],
//     // images: json['images'][1]['fullUrl'],
//      catagory: json['category']['id'],
//      catagoryName: json['category']['name'],
//
//    );
  }
}

class ListBarang {
  static List listBarang_pangan = [
    {
      "namaBarang": "Beras kualitas super 5 Kg",
      "fotoBarang":
          "https://s4.bukalapak.com/img/9385045732/large/BERAS_LOKAL_212MART.jpg",
      "hargaBarang": "50000",
      "namaPenjual": "Muhaimin",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Selamat datang di lapak amin-store, disini kami menjual berbagai aneka kebutuhan pangan. tersedia untuk eceran maupun partai."
    },
    {
      "namaBarang": "Beras murah 10 Kg",
      "fotoBarang":
          "https://www.jambiupdate.co/foto_berita/2018/04/29/79beras-madiun.jpg",
      "hargaBarang": "100000",
      "namaPenjual": "Mas'ud",
      "komunitasPenjual" : "Koperasi 212 Jawa Barat",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Bandung",
      "deskripsi":
          "Selamat datang di lapak amin-store, disini kami menjual berbagai aneka kebutuhan pangan. tersedia untuk eceran maupun partai."
    },
    {
      "namaBarang": "Beras super rojolele 25 Kg",
      "fotoBarang":
          "https://ecs7.tokopedia.net/img/cache/700/VqbcmM/2020/6/17/d3f48b9a-7a10-4795-acce-25bb045c9615.jpg",
      "hargaBarang": "250000",
      "namaPenjual": "Imam",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Selamat datang di lapak amin-store, disini kami menjual berbagai aneka kebutuhan pangan. tersedia untuk eceran maupun partai."
    },
    {
      "namaBarang": "Gula pasir murah & sehat per/5 Kg",
      "fotoBarang":
          "https://awsimages.detik.net.id/community/media/visual/2020/03/13/9876e50d-cc62-4fe2-bc1b-60572e520607_169.jpeg?w=700&q=90",
      "hargaBarang": "60000",
      "namaPenjual": "Abdi",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Tuban",
      "deskripsi":
          "Selamat datang di lapak amin-store, disini kami menjual berbagai aneka kebutuhan pangan. tersedia untuk eceran maupun partai."
    },
    {
      "namaBarang": "Minyak goreng 212 murah halal & sehat",
      "fotoBarang":
          "https://www.swamedium.com/wp-content/uploads/2017/06/IMG-20170606-WA0041.jpg",
      "hargaBarang": "60000",
      "namaPenjual": "Amalia",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Selamat datang di lapak amin-store, disini kami menjual berbagai aneka kebutuhan pangan. tersedia untuk eceran maupun partai."
    },
    {
      "namaBarang": "Bawang merah murah & segar",
      "fotoBarang":
          "https://s1.bukalapak.com/img/11274458302/large/data.jpeg",
      "hargaBarang": "5000",
      "namaPenjual": "Amalia",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Selamat datang di lapak amin-store, disini kami menjual berbagai aneka kebutuhan pangan. tersedia untuk eceran maupun partai."
    },
  ];

  static List listBarang_komunitas = [
    {
      "namaBarang": "Samsung galaxy S9 bekas tapi mulus",
      "fotoBarang":
          "https://www.lifewire.com/thmb/URAZH8lEwhXV46uV1ZWhZuDsiy0=/780x780/filters:no_upscale():max_bytes(150000):strip_icc()/4043781-6-HeroSquare-ff6cc4599b9d4120a540c5c3bbf74b20.jpg",
      "hargaBarang": "5000000",
      "namaPenjual": "Abdi",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Samsung galaxy fullset seken pemakaian 6 bulan & body masih mulus, siap tukar tambah."
    },
    {
      "namaBarang": "Beras murah 10 Kg",
      "fotoBarang":
          "https://www.jambiupdate.co/foto_berita/2018/04/29/79beras-madiun.jpg",
      "hargaBarang": "100000",
      "namaPenjual": "Mas'ud",
      "komunitasPenjual" : "Koperasi 212 Jawa Timur",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Dijual beras kualitas super dan terjamin, siap kirim-kirim dan COD"
    },
    {
      "namaBarang": "Baju taqwa murah kualitas import",
      "fotoBarang":
          "https://s0.bukalapak.com/img/0723335642/large/Baju_Koko_Lengan_Pendek_Murah_Baju_Muslim_Baju_Taqwa_Dewasa.jpg",
      "hargaBarang": "100000",
      "namaPenjual": "Cahyo",
      "komunitasPenjual" : "Koperasi 212 Jawa Timur",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Kami menyediakan berbagai macam busana muslim untuk pria dan wanita dalam berbagai ukuran, bisa COD daerah rungkut dan kirim2 ke seluruh indonesia."
    },
    {
      "namaBarang": "Mouse komputer/laptop merk asus",
      "fotoBarang":
          "https://www.asus.com/media/global/products/vddtMVA9CCXzltMp/P_setting_fff_1_90_end_500.png",
      "hargaBarang": "100000",
      "namaPenjual": "Cahyo",
      "komunitasPenjual" : "Koperasi 212 Jatim",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Mouse untuk komputer dan laptop, dijamin original dan asli. kualitas terjamin dan awet, untuk review lengkap silahkan cek youtube. siap kirim-kirim ke seluruh indonesia."
    },
    {
      "namaBarang": "Masker jahit tebal kualitas super",
      "fotoBarang":
          "https://s0.bukalapak.com/bukalapak-kontenz-production/content_attachments/50160/w-744/740_91_.jpg",
      "hargaBarang": "10000",
      "namaPenjual": "Amalia",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "081255678221",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Dijual masker murah & kuat serta tahan banting, ayo lindungi keluarga anda tercinta dari bahaya virus corona. siap COD area surabaya dan siap kirim2 ke seluruh indonesia."
    },
    {
      "namaBarang": "Hand Sanitizer wangi & tidak lengket",
      "fotoBarang":
          "https://ecs7.tokopedia.net/img/cache/700/product-1/2020/3/17/708779646/708779646_b18f2d9f-2e82-49bb-aceb-0a8a99904971_800_800.jpg",
      "hargaBarang": "15000",
      "namaPenjual": "Aisyah",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Dijual murah hand sanitizer merk jubaedah, dijamin produk asli & terjamin. siap COD area surabaya & kirim-kirim ke seluruh indonesia"
    },
    {
      "namaBarang": "HandBody lotion halal & aman merk Hijab",
      "fotoBarang": "https://www.gomuslim.co.id/uploaded/hjab.jpg",
      "hargaBarang": "15000",
      "namaPenjual": "Aisyah",
      "komunitasPenjual" : "Koperasi BMT Aluswah",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Dijual murah hand sanitizer merk jubaedah, dijamin produk asli & terjamin. siap COD area surabaya & kirim-kirim ke seluruh indonesia"
    },
    {
      "namaBarang": "1 dus air mineral santri ukuran 600 ml",
      "fotoBarang":
          "https://akusantri.id/wp-content/uploads/2017/11/Foto-Lap-Syifaul-Qolbi.jpg",
      "hargaBarang": "25000",
      "namaPenjual": "Aisyah",
      "komunitasPenjual" : "Koperasi 212 Jatim",
      "nopePenjual": "0878598764321",
      "lokasiBarang": "Surabaya",
      "deskripsi":
          "Dijual ecer maupun partai air mineral merk santri asal sidogiri pasuruan, dijamin produk asli & terjamin. siap COD & ambil langsung area rungkut surabaya & ready kirim-kirim ke seluruh indonesia",
    },
  ];
}

class BarangModel {
  String namaBarang;
  String fotoBarang;
  String hargaBarang;
  String namaPenjual;
  String nopePenjual;
  String lokasiBarang;

  BarangModel(
      {@required this.namaBarang,
      @required this.fotoBarang,
      @required this.hargaBarang,
      @required this.namaPenjual,
      @required this.nopePenjual,
      @required this.lokasiBarang});
}
