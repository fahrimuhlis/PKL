import 'package:flutter/material.dart';

class studentsList {
  final List<studentModel> studentLists;

  studentsList({
    this.studentLists,
  });

  factory studentsList.fromJson(List<dynamic> parsedJson) {
    List<studentModel> studentListsnya = List<studentModel>();
    studentListsnya = parsedJson.map((i) => studentModel.fromJson(i)).toList();

    return studentsList(studentLists: studentListsnya);
  }
}

class studentModel {
  final String id;
  final String name;
  final String nis;
  final String kelas;
  final String idKelas;
  final String foto;
  final String alamat;
  final String waliKelas;
  final String ayah;
  final String ibu;
  final String telpAyah;
  final String telpIbu;
  final String idSekolah;
  studentModel(
      {@required this.id,
        @required this.name,
        @required this.nis,
        @required this.kelas,
        @required this.idKelas,
        @required this.foto,
        @required this.alamat,
        @required this.waliKelas,
        @required this.ayah,
        @required this.ibu,
        @required this.telpAyah,
        @required this.telpIbu,
        @required this.idSekolah,

      });


  factory studentModel.fromJson(Map<String, dynamic> json) {
    return new studentModel(
        id: json["id"],
      name: json["formattedDate"],
      nis: json["formattedAmount"],
      kelas: json["transferType"],
      idKelas: json["transferType"],
      foto: json["description"],
      alamat: json["id"],
      waliKelas: json["formattedDate"],
      ayah: json["formattedAmount"],
      ibu: json["transferType"],
      telpAyah: json["transferType"],
      telpIbu: json["description"],
      idSekolah: json["description"]


    );
  }
}
