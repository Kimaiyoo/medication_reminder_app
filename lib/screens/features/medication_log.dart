import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MedicationLog extends StatefulWidget {
  const MedicationLog({super.key});
  @override
  State<MedicationLog> createState() => _MedicationLogState();
}

class _MedicationLogState extends State<MedicationLog> {
  final _medNameController = TextEditingController();
  final _prescriptionTypeController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedStartTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Medication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _medNameController,
              decoration: const InputDecoration(labelText: 'Medication Name'),
            ),
            TextField(
              controller: _prescriptionTypeController,
              decoration: const InputDecoration(labelText: 'Prescription Type'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
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
            ElevatedButton(
              onPressed: _logMedication,
              child: const Text('Log Medication'),
            ),
          ],
        ),
      ),
    );
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
    final prescriptionType = _prescriptionTypeController.text;
    final amount = _amountController.text;

    if (medName.isEmpty ||
        prescriptionType.isEmpty ||
        amount.isEmpty ||
        _selectedStartTime == null) {
      _showErrorDialog('Please fill in all fields and select a start time.');
      return;
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance.collection('medications').add({
        'userId': userId,
        'medication_name': medName,
        'prescription_type': prescriptionType,
        'amount': amount,
        'start_time': _selectedStartTime!.toIso8601String(),
        'created_at': FieldValue.serverTimestamp(), // Optional: for ordering
      });

      // Clear fields after logging
      _medNameController.clear();
      _prescriptionTypeController.clear();
      _amountController.clear();
      setState(() {
        _selectedStartTime = null;
      });

      // Optionally, navigate back or show success message
    } catch (e) {
      _showErrorDialog('An error occurred while logging the medication: $e');
    }
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
