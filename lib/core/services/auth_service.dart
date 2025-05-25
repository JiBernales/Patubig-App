import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart'; // <-- add this

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔽 converts `09171234567` -> `09171234567@patubig.app`
  String _asEmail(String phone) => '${phone.trim()}$kPhoneEmailDomain';

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signIn(String phone, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: _asEmail(phone),
      password: password,
    );
    return cred.user;
  }

  Future<User?> signUp(
    String fullName,
    String phone,
    String password,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: _asEmail(phone),
      password: password,
    );

    // Store the friendly name so you can greet the farmer later.
    await cred.user?.updateDisplayName(fullName);

    // Optionally persist extra profile info to Firestore here.

    return cred.user;
  }

  Future<void> signOut() => _auth.signOut();
}
