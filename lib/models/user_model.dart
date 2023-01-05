import 'package:flutter/material.dart';

class User {
  final int id;
  final String email;
  final String name;


  User({
    @required this.id,
    @required this.email,
    @required this.name,
  });


  factory User.fromJson(Map<String, dynamic> json){
    return new User(
      email: json["email"],
      id: json['id'],
      name: json["first_name"],

    );
  }
}
