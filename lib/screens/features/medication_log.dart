import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medication_reminder_app/screens/features/reminder_screen.dart';
import 'package:medication_reminder_app/services/scanner_service.dart';

class MedicationLog extends StatefulWidget {
  const MedicationLog({super.key});

  @override
  State<MedicationLog> createState() => _MedicationLogState();
}

class _MedicationLogState extends State<MedicationLog> {
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedPrescriptionType;
  DateTime? startTime;
  bool _isLoading = false; // Loader for async tasks
  String? _errorMessage;

  // Function to log medication to Firestore
  void _logMedication() async {
    if (_medNameController.text.isNotEmpty &&
        _prescriptionController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        startTime != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _firestore.collection('medications').add({
          'medication_name': _medNameController.text,
          'prescription': _prescriptionController.text,
          'amount': _amountController.text,
          'start_time': startTime!.toIso8601String(),
          'created_at': Timestamp.now(),
        });
        // Clear the inputs
        _medNameController.clear();
        _prescriptionController.clear();
        _amountController.clear();
        setState(() {
          startTime = null;
          selectedPrescriptionType = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Medication details logged successfully!')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to log medication: $e')));
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the fields.')));
    }
  }

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      final now = DateTime.now();
      setState(() {
        startTime =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
      });
    }
  }

  // Handle medication details from API response
  void _setMedicationDetails(Map<String, String> medDetails) {
    if (medDetails.containsKey('error')) {
      setState(() {
        _errorMessage = medDetails['error'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${medDetails['error']}')),
      );
    } else {
      setState(() {
        _medNameController.text = medDetails['medication_name'] ?? 'Unknown';
        _prescriptionController.text = medDetails['prescription_type'] ?? '';
        selectedPrescriptionType = medDetails['form'] ?? '';
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Medication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(), // Show loader while waiting
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _medNameController,
                      decoration: InputDecoration(
                        labelText: 'Medication Name',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            Map<String, String> medDetails =
                                await ScannerService.scanBarcodeOrQR();
                            setState(() {
                              _isLoading = false;
                            });
                            _setMedicationDetails(medDetails);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedPrescriptionType,
                      items: ['Pill', 'Liquid'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPrescriptionType = value;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Prescription Type'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: selectedPrescriptionType == 'Pill'
                            ? 'Amount (number of pills)'
                            : 'Amount (ml)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        startTime != null
                            ? 'Start Time: ${DateFormat.jm().format(startTime!)}'
                            : 'Pick Start Time',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: _pickStartTime,
                    ),
                    const SizedBox(height: 16),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _logMedication, // Disable button during loading
                      child: const Text('+ Add Reminder'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewRemindersPage(),
                                  ));
                            },
                      child: const Text('View Reminders'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
