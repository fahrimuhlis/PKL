// To parse this JSON data, do
//
//     final listRiwayatPlnPascaBayar = listRiwayatPlnPascaBayarFromJson(jsonString);

import 'dart:convert';

ListRiwayatPlnPascaBayar listRiwayatPlnPascaBayarFromJson(String str) =>
    ListRiwayatPlnPascaBayar.fromJson(json.decode(str));

String listRiwayatPlnPascaBayarToJson(ListRiwayatPlnPascaBayar data) =>
    json.encode(data.toJson());

class ListRiwayatPlnPascaBayar {
  ListRiwayatPlnPascaBayar({
    this.riwayatPlnPascaBayar,
  });

  List<RiwayatPlnPascaBayar> riwayatPlnPascaBayar;

  factory ListRiwayatPlnPascaBayar.fromJson(Map<String, dynamic> json) =>
      ListRiwayatPlnPascaBayar(
        riwayatPlnPascaBayar: List<RiwayatPlnPascaBayar>.from(
            json["data"].map((x) => RiwayatPlnPascaBayar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RiwayatPLNPascaBayar":
            List<dynamic>.from(riwayatPlnPascaBayar.map((x) => x.toJson())),
      };
}

class RiwayatPlnPascaBayar {
  RiwayatPlnPascaBayar({
    this.timestamp,
    this.trId,
    this.refId,
    this.code,
    this.noPelanggan,
    this.namaPelanggan,
    this.nominal,
    this.periodeBulan,
    this.totalNominal,
    this.noref,
    this.userId,
  });

  DateTime timestamp;
  String trId;
  String refId;
  String code;
  String noPelanggan;
  String namaPelanggan;
  String nominal;
  String periodeBulan;
  String totalNominal;
  String noref;
  String userId;

  factory RiwayatPlnPascaBayar.fromJson(Map<String, dynamic> json) =>
      RiwayatPlnPascaBayar(
        timestamp: DateTime.parse(json["Timestamp"]),
        trId: json["tr_id"],
        refId: json["ref_id"],
        code: json["code"],
        noPelanggan: json["no_pelanggan"],
        namaPelanggan: json["nama_pelanggan"],
        nominal: json["nominal"],
        periodeBulan: json["periode_bulan"],
        totalNominal: json["total_nominal"],
        noref: json["noref"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "Timestamp": timestamp.toIso8601String(),
        "tr_id": trId,
        "ref_id": refId,
        "code": code,
        "no_pelanggan": noPelanggan,
        "nama_pelanggan": namaPelanggan,
        "nominal": nominal,
        "periode_bulan": periodeBulan,
        "total_nominal": totalNominal,
        "noref": noref,
        "user_id": userId,
      };
}
