import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  final Set<int> _favoriteProductsId = {};
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Set<int> get favoriteProducts => _favoriteProductsId;
  bool isFavorite(int productId) => _favoriteProductsId.contains(productId);

  void toggleFavorite(int productId) {
    if (_favoriteProductsId.contains(productId)) {
      _favoriteProductsId.remove(productId);
    } else {
      _favoriteProductsId.add(productId);
    }
    notifyListeners();
  }

  Future<void> removeAllFromFavorite() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    _favoriteProductsId.clear();
    _isLoading = false;
    notifyListeners();
  }
}
