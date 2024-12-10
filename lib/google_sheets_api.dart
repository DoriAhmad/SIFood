import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetsApi {
  final String spreadsheetId;
  final String apiKey;

  GoogleSheetsApi({required this.spreadsheetId, required this.apiKey});

  Future<void> addOrder({
    required String orderId,
    required String itemName,
    required int quantity,
    required double price,
  }) async {
    final url =
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/Sheet1!A1:append?valueInputOption=USER_ENTERED&key=$apiKey';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'values': [
          [orderId, itemName, quantity, price],
        ],
      }),
    );

    if (response.statusCode == 200) {
      print('Order added successfully!');
    } else {
      print('Failed to add order: ${response.body}');
    }
  }
}