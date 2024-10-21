import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // For API calls
import 'dart:convert'; // For JSON encoding/decoding

class ViewRemindersPage extends StatefulWidget {
  const ViewRemindersPage({super.key});

  @override
  State<ViewRemindersPage> createState() => _ViewRemindersPageState();
}

class _ViewRemindersPageState extends State<ViewRemindersPage> {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Stack(
        children: [
          // Background layer
          Container(color: Colors.white), // White background

          // Calendar at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildCalendar(),
          ),

          // Main content
          Positioned(
            top: 170, // Adjust based on the height of the calendar
            left: 10,
            right: 10,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('medications')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!
                            .uid) // Filter by current user's UID
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No reminders found.'));
                  }

                  final medications = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final med =
                          medications[index].data() as Map<String, dynamic>;
                      final medName = med['medication_name'] ?? 'Unknown';
                      final prescriptionType =
                          med['prescription_type'] ?? 'N/A';
                      final amount = med['amount'] ?? 'N/A';
                      final startTime = med.containsKey('start_time')
                          ? DateTime.parse(med['start_time'])
                          : null;

                      return _buildMedicationTile(
                        context,
                        medName,
                        prescriptionType,
                        amount,
                        startTime,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    int daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    currentMonth =
                        DateTime(currentMonth.year, currentMonth.month - 1);
                  });
                },
              ),
              Text(
                DateFormat('MMMM yyyy').format(currentMonth),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  setState(() {
                    currentMonth =
                        DateTime(currentMonth.year, currentMonth.month + 1);
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                DateTime date =
                    DateTime(currentMonth.year, currentMonth.month, index + 1);
                bool isSelected =
                    DateFormat('yyyy-MM-dd').format(selectedDate) ==
                        DateFormat('yyyy-MM-dd').format(date);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationTile(BuildContext context, String medName,
      String prescriptionType, String amount, DateTime? startTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading:
              Icon(Icons.medication, color: Theme.of(context).primaryColor),
          title: Text(
            medName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              'Type: $prescriptionType\nAmount: $amount\nStart Time: ${startTime != null ? DateFormat.jm().format(startTime) : 'N/A'}'),
          trailing: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _fetchDrugInfo(medName, context),
          ),
        ),
      ),
    );
  }

  void _fetchDrugInfo(String medName, BuildContext context) async {
    final url =
        'https://api.fda.gov/drug/label.json?search=drug_name:"$medName"&limit=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String details =
            data['results']?[0]?['description'] ?? 'No details available';

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(medName),
                content: Text(details),
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
      } else {
        if (context.mounted) {
          _showErrorDialog(context, 'Failed to fetch drug information.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'An error occurred while fetching data.');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    if (context.mounted) {
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
}
