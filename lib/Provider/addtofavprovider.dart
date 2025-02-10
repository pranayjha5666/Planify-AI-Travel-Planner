import 'package:flutter/material.dart';

class FavoriteStatusProvider extends ChangeNotifier {
  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  // Update the favorite status
  void updateFavoriteStatus(bool status) {
    _isFavorite = status;
    notifyListeners();  // Notify listeners when the status changes
  }
}
