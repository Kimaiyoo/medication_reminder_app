import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log("Signup failed: $e");
      if (e.code == 'email-already-in-use') {
        onError("This email is already in use.");
      } else if (e.code == 'weak-password') {
        onError("The password is too weak.");
      } else {
        onError(e.message ?? "An unknown error occurred.");
      }
      return null;
    } catch (e) {
      log("Unknown signup error: $e");
      onError("An unknown error occurred.");
      return null;
    }
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log("Login failed: $e");
      if (e.code == 'user-not-found') {
        onError("No user found with this email.");
      } else if (e.code == 'wrong-password') {
        onError("Incorrect password.");
      } else {
        onError(e.message ?? "An unknown error occurred.");
      }
      return null;
    } catch (e) {
      log("Unknown login error: $e");
      onError("An unknown error occurred.");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut(); // Also sign out from Google
    } catch (e) {
      log("Sign-out failed: $e");
    }
  }
}
