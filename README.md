# Medication Reminder App

A Flutter-based application that helps users log and track their medications, set reminders, and manage prescription details effectively.

## Getting Started

This project serves as a starting point for the Medication Reminder app, designed to assist users in managing their medication schedules and staying on top of their health goals. The app integrates with Firebase for storing user data and reminders.

### Key Features:
- **Log Medications**: Add details about medications, including name, dosage, and schedule.
- **Set Reminders**: Schedule reminders to notify users when it's time to take medications.
- **QR Code Scanning**: Scan prescription details via QR code for easier medication logging.
- **Track Medication History**: View and manage past medication logs.
- **Firebase Integration**: Store user data, reminders, and medication logs securely using Firebase Firestore.

---

## Installation

To run this project locally, ensure that you have Flutter installed and set up. If you don't have Flutter installed, follow the instructions [here](https://flutter.dev/docs/get-started/install).

### Steps to run the project:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/medication_reminder_app.git
2. **Navigate to the project directory**:
   ```bash
   cd medication_reminder_app
3. **Install the Dependencies: Run the following command to install all the required Flutter dependencies**:
   ```bash
   flutter pub get
4. **Configure Firebase**:

5. **Create a Firebase project via the Firebase Console.**
   - Add an Android app using the package name com.myhealthapp.medicationreminderapp.
   - Download the google-services.json file and place it in your android/app directory.
   - Run the App: Run the following command to launch the app in debug mode on an emulator or connected device:

  ```bash
  flutter run
