import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../data/static_data.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.length >= 6) {
      _user = StaticData.sampleUser.copyWith(email: email);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: 'new_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phone: '',
        addresses: [],
        paymentMethods: [],
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Please fill all fields correctly';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
  }) {
    if (_user != null) {
      _user = _user!.copyWith(
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        phone: phone ?? _user!.phone,
      );
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}