import 'package:flutter/material.dart';
import '../models/watch_model.dart';

class WishlistProvider with ChangeNotifier {
  final List<WatchModel> _items = [];

  List<WatchModel> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.length;

  bool isInWishlist(String watchId) {
    return _items.any((item) => item.id == watchId);
  }

  void toggleWishlist(WatchModel watch) {
    if (isInWishlist(watch.id)) {
      _items.removeWhere((item) => item.id == watch.id);
    } else {
      _items.add(watch);
    }
    notifyListeners();
  }

  void removeFromWishlist(String watchId) {
    _items.removeWhere((item) => item.id == watchId);
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}