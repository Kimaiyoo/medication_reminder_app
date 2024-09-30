import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ScannerService {
  static Future<Map<String, String>> scanBarcodeOrQR() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        // Only checks for barcode
        String scannedCode = result.rawContent;
        // Call the API to get medication details
        Map<String, String> medDetails =
            await fetchMedicationDetails(scannedCode);
        return medDetails;
      } else {
        return {'error': 'Scan failed or unsupported type'};
      }
    } catch (e) {
      return {'error': 'Error occurred: $e'};
    }
  }

  // Fetch medication details from OpenFDA (or other API)
  static Future<Map<String, String>> fetchMedicationDetails(
      String barcode) async {
    // Example using OpenFDA API
    final url =
        'https://api.fda.gov/drug/label.json?search=openfda.product_ndc:$barcode';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final medication = data['results'][0]['openfda'];
          String medicationName =
              medication['brand_name']?.join(', ') ?? 'Unknown';
          String prescriptionType =
              medication['generic_name']?.join(', ') ?? '';
          String form = medication['dosage_form']?.join(', ') ?? '';
          return {
            'medication_name': medicationName,
            'prescription_type': prescriptionType,
            'form': form,
          };
        }
      }
      return {'error': 'No medication data found'};
    } catch (e) {
      return {'error': 'Failed to fetch medication data: $e'};
    }
  }
}
