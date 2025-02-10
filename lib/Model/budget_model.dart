import 'package:flutter/cupertino.dart';

class BudgetModel {
  final int id;
  final String title;
  final String desc;
  final Icon icon;

  BudgetModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'icon': icon.icon.toString(),
    };
  }
}
