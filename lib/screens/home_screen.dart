import 'package:flutter/material.dart';
import 'package:medication_reminder_app/screens/features/medication_log.dart';
import 'package:medication_reminder_app/screens/features/reminder_screen.dart';
import 'package:medication_reminder_app/screens/profile/profile_screen.dart';
import 'package:medication_reminder_app/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _titles = ['Home', 'Reminders', 'My Profile'];

  final List<Widget> _pages = [
    const MedicationLog(),
    const ViewRemindersPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      title: (_titles[_currentIndex]),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Set the currently selected tab
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change selected tab index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.teal, // Color of the selected icon
        unselectedItemColor: Colors.grey, // Color of the unselected icons
        backgroundColor: Colors.white, // Background color of the bottom bar
      ),
    );
  }
}
