import 'package:flutter/material.dart';

class FavoriteStatusProvider extends ChangeNotifier {
  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  void updateFavoriteStatus(bool status) {
    _isFavorite = status;
    notifyListeners();
  }
}
