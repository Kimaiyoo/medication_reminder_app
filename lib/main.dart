import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_app/firebase_options.dart';
import 'package:medication_reminder_app/services/notification_service.dart';
import 'package:medication_reminder_app/theme.dart';
import 'package:medication_reminder_app/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Future.delayed(const Duration(milliseconds: 100));
  FirebaseAuth.instance.setLanguageCode('en');

  NotificationService notificationService = NotificationService();
  await notificationService.initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medication Reminder App',
      theme: lightMode,
      home: const Wrapper(),
    );
  }
}
