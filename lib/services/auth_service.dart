import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup with email and password
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required Function(String) onError,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      // Add user data to Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
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

  // Sign in with email and password
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

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Sign-out failed: $e");
    }
  }
}
