import 'package:flutter/cupertino.dart';

class TravelOption {
  final int id;
  final String title;
  final String desc;
  final Icon icon;
  final String people;

  TravelOption({
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
    required this.people,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'icon': icon.icon.toString(),
      'people': people,
    };
  }


}
