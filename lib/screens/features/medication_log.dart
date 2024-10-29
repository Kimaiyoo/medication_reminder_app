import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MedicationLog extends StatefulWidget {
  const MedicationLog({super.key});

  @override
  State<MedicationLog> createState() => _MedicationLogState();
}

class _MedicationLogState extends State<MedicationLog> {
  final _medNameController = TextEditingController();
  // final _prescriptionTypeController = TextEditingController();
  final _amountController = TextEditingController();
  final _dosageController = TextEditingController();
  DateTime? _selectedStartTime;
  String? _selectedMedicationType;
  bool _reminderEnabled = false;
  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  final List<String> _medicationTypes = [
    'Pill',
    'Tablet',
    'Liquid',
    'Injection'
  ];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _notificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Medication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _medNameController,
                    decoration:
                        const InputDecoration(labelText: 'Medication Name'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _scanMedication,
                  tooltip: 'Scan Medication',
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedMedicationType,
              onChanged: (value) {
                setState(() {
                  _selectedMedicationType = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Medication Type'),
              items: _medicationTypes
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              hint: const Text('Select Medication Type'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dosageController,
              decoration:
                  const InputDecoration(labelText: 'Dosage (e.g., 5ml * 3)'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  _selectedStartTime != null
                      ? 'Start Time: ${DateFormat.jm().format(_selectedStartTime!)}'
                      : 'No Start Time Chosen',
                ),
                const Spacer(),
                TextButton(
                  onPressed: _selectStartTime,
                  child: const Text('Select Start Time'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Enable Reminder:'),
                Switch(
                  value: _reminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      _reminderEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logMedication,
              child: const Text('Add Medication Log'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanMedication() async {
    // Implement scanner logic here using a package like barcode_scan
    // Example of scanner logic:
    // final result = await BarcodeScanner.scan();
    // setState(() {
    //   _medNameController.text = result.rawContent;
    // });
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final DateTime now = DateTime.now();
      setState(() {
        _selectedStartTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      });
    }
  }

  Future<void> _logMedication() async {
    final medName = _medNameController.text;
    // final prescriptionType = _prescriptionTypeController.text;
    final amount = _amountController.text;
    final dosage = _dosageController.text;

    // Debugging print statements
    log('medName: $medName');
    //log('prescriptionType: $prescriptionType');
    log('amount: $amount');
    log('dosage: $dosage');
    log('selectedStartTime: $_selectedStartTime');
    log('selectedMedicationType: $_selectedMedicationType');

    if (medName.isEmpty ||
        // prescriptionType.isEmpty ||
        amount.isEmpty ||
        dosage.isEmpty ||
        _selectedStartTime == null ||
        _selectedMedicationType == null) {
      _showErrorDialog('Please fill in all fields and select a start time.');
      return;
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance.collection('medications').add({
        'userId': userId,
        'medication_name': medName,
        //'prescription_type': prescriptionType,
        'amount': amount,
        'dosage': dosage,
        'prescription_type': _selectedMedicationType,
        'start_time': _selectedStartTime!.toIso8601String(),
        'reminder_enabled': _reminderEnabled,
        'created_at': FieldValue.serverTimestamp(),
      });

      if (_reminderEnabled) {
        await _scheduleNotification(medName);
      }

      // Clear fields after logging
      _medNameController.clear();
      //_prescriptionTypeController.clear();
      _amountController.clear();
      _dosageController.clear();
      setState(() {
        _selectedStartTime = null;
        _selectedMedicationType = null;
        _reminderEnabled = false;
      });

      // Optionally, navigate back or show success message
    } catch (e) {
      _showErrorDialog('An error occurred while logging the medication: $e');
    }
  }

  Future<void> _scheduleNotification(String medName) async {
    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(
      _selectedStartTime!, // Ensure _selectedStartTime is not null
      tz.local, // Ensure you set the local timezone
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medication_channel', // Your channel ID
      'Medication Reminders', // Channel name
      channelDescription:
          'Remind you to take your medication', // Channel description
      importance: Importance.max,
      priority: Priority.high,
      // Removed deprecated androidAllowWhileIdle
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule notification
    await _notificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Time to take your medication!', // Title
      'It\'s time to take $medName', // Body
      scheduledDateTime, // Use TZDateTime
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime, // Named parameter
      matchDateTimeComponents: DateTimeComponents.time, // Named parameter
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
