import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRemindersPage extends StatelessWidget {
  const ViewRemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reminders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medications')
            .orderBy('created_at',
                descending: true) // Sort reminders by creation time
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
              final med = medications[index];
              final medName = med['medication_name'] ?? 'Unknown';
              final prescription = med['prescription'] ?? 'N/A';
              final amount = med['amount'] ?? 'N/A';
              final startTime = med['start_time']?.toDate();

              return ListTile(
                title: Text(medName),
                subtitle: Text(
                    'Type: $prescription\nAmount: $amount\nStart Time: ${startTime != null ? startTime.toString() : 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}
