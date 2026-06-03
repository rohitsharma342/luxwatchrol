import 'package:flutter/material.dart';
import '../models/watch_model.dart';
import '../data/static_data.dart';

class ProductProvider with ChangeNotifier {
  List<WatchModel> _products = [];
  List<WatchModel> _filteredProducts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<WatchModel> get products => _filteredProducts;
  List<WatchModel> get allProducts => _products;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  List<String> get categories => StaticData.categories;

  List<WatchModel> get trendingWatches => _products.take(5).toList();

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    
    _products = StaticData.watches;
    _filteredProducts = _products;
    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((watch) {
      final matchesCategory = _selectedCategory == 'All' || 
          watch.category == _selectedCategory;
      
      final matchesSearch = _searchQuery.isEmpty ||
          watch.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          watch.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesCategory && matchesSearch;
    }).toList();
    
    notifyListeners();
  }

  WatchModel? getWatchById(String id) {
    try {
      return _products.firstWhere((watch) => watch.id == id);
    } catch (e) {
      return null;
    }
  }

  List<WatchModel> getRelatedWatches(WatchModel watch) {
    return _products
        .where((w) => w.id != watch.id && 
            (w.category == watch.category || w.brand == watch.brand))
        .take(4)
        .toList();
  }
}