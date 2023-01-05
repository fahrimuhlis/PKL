import 'package:flutter/material.dart';

class historysList {
  final List<historyModel> historyLists;

  historysList({
    this.historyLists,
  });

  factory historysList.fromJson(List<dynamic> parsedJson) {
    List<historyModel> historyListnya = List<historyModel>();
    historyListnya = parsedJson.map((i) => historyModel.fromJson(i)).toList();

    return historysList(historyLists: historyListnya);
  }
}

class historyModel {
  final String idKwitansi;
  final String waktu;
  final String jumlah;
  final String jenisTransaksi;
  final String deskripsi;
  final String norekPenerima;
  final String norekPengirim;
  final String namaPenerima;
  final String namaPengirim;
  final String nomorPelanggan;
  final String message;

  historyModel(
      {this.idKwitansi,
      this.waktu,
      this.jumlah,
      this.jenisTransaksi,
      this.deskripsi,
      this.norekPengirim,
      this.norekPenerima,
      this.namaPenerima,
      this.namaPengirim,
      this.nomorPelanggan,
      this.message,});

  factory historyModel.fromJson(Map<String, dynamic> json) {
//    if(json["transferType"]['name'] == null){
    if (json['list riwayat'] == null) {
      return new historyModel(
          idKwitansi: json["kwitansi"],
          waktu: json["waktu"],
          jumlah: json["jumlah"],
          jenisTransaksi: json["jenistransaksi"],
          // transferTypeName == null? 'empty' : json["transferType"]['name'],
          // transferTypeName: json["transferType"]['name'] ,
          deskripsi: json["deskripsi"],
          norekPenerima: json["rekke"],
          namaPenerima: json["ke"],
          namaPengirim: json["dari"],
          nomorPelanggan: json["nopelanggan"],
          message: json["message"]);
    }
//       return new historyModel(
//         id: json["id"],
//         formatedDate: json["formattedDate"],
//         formatedAmount: json["formattedAmount"],
//         transferTypeId: json["transferType"]['id'],
//         // transferTypeName == null? 'empty' : json["transferType"]['name'],
//         // transferTypeName: json["transferType"]['name'] ,
//         transferTypeName: ' ',
//         description: json["description"],
//         //toMember: json["member"]['name'],
// //          toMember: ""
//         toMember: json["member"]['name'],

//       );

//    return new historyModel(
//        id: json["id"],
//        formatedDate: json["formattedDate"],
//        formatedAmount: json["formattedAmount"],
//        transferTypeId: json["transferType"]['id'],
//      // transferTypeName == null? 'empty' : json["transferType"]['name'],
//       // transferTypeName: json["transferType"]['name'] ,
//      transferTypeName: json["transferType"]['name'] == null? 'kosong' :json["transferType"]['name'],
//        description: json["description"],
//      toMember: json["member"]['name'],
//
//    );
  }
}
