import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._service) {
    // Keep local user in sync with FirebaseAuth stream.
    _service.authStateChanges.listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  final AuthService _service;

  User? _user;
  User? get user => _user;

  bool _loading = false;
  bool get isLoading => _loading;

  Future<void> signIn(String phone, String password) async {
    _setLoading(true);
    try {
      await _service.signIn(phone, password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String fullName, String phone, String password) async {
    _setLoading(true);
    try {
      await _service.signUp(fullName, phone, password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() => _service.signOut();

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
