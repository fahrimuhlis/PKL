
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class contactsList{
  final List<contactModel> contactLists;

  contactsList({
    this.contactLists,
  });
  factory contactsList.fromJson(List<dynamic> parsedJson){
    List<contactModel> contactListnya =  List<contactModel>();
    contactListnya = parsedJson.map((i)=>contactModel.fromJson(i)).toList();

    return contactsList(
        contactLists: contactListnya
    );

  }
}

class contactModel {
  final String name;
  final String id;

  contactModel({
    @required this.name,
    @required this.id
  });


  factory contactModel.fromJson(Map<String, dynamic> json){
    return new contactModel(
      name: json['name'],
      id: json['no_rekening'],

    );
  }}
