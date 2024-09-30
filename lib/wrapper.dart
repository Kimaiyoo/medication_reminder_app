import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_app/screens/home_screen.dart';
import 'package:medication_reminder_app/screens/login.dart';
import 'package:medication_reminder_app/screens/welcome_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isNewUser = true; // Flag to track if the user is new

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading spinner while waiting for auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Handling errors in fetching authentication state
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong. Please try again."),
            );
          }

          // If no user is signed in, show the LoginScreen or WelcomePage for new users
          if (!snapshot.hasData) {
            if (_isNewUser) {
              // New users will be taken to WelcomePage
              return const WelcomePage();
            } else {
              // Returning users who sign out will be taken to LoginScreen
              return const LoginScreen();
            }
          }

          // If a user is signed in, navigate to the Dashboard
          final User? user = snapshot.data;
          if (user != null) {
            _isNewUser =
                false; // Once signed in, the user is not considered new anymore
            return const HomeScreen();
          }

          // Default case: go to LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}
