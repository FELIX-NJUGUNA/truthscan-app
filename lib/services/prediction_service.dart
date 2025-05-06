import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthscan_app/models/history_model.dart';
import 'package:truthscan_app/models/prediction_result.dart';
import 'package:truthscan_app/services/api_service.dart';

class PredictionService {
  final String baseUrl = ApiService.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<PredictionResult> analyzeText(String text) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Auth token not found');
    }
    if (text.trim().isEmpty) {
      throw Exception('Text input cannot be empty');
    }

    print('Sending request with token: $token');
    print('Input text: $text');
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'input_text': text}), // Changed 'text' to 'input_text'
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PredictionResult.fromJson(data);
    } else {
      throw Exception(
        'Failed to analyze text: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<PredictionResult> analyzePdfFile(
    Uint8List fileBytes,
    String filename,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Auth token not found');
    }
    if (fileBytes.isEmpty) {
      throw Exception('PDF file bytes cannot be empty');
    }
    if (filename.trim().isEmpty || !filename.toLowerCase().endsWith('.pdf')) {
      filename = 'document.pdf'; // Ensure valid filename
    }

    print('File size: ${fileBytes.length} bytes');
    print('Filename: $filename');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/predict'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      http.MultipartFile.fromBytes('pdf_file', fileBytes, filename: filename),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PredictionResult.fromJson(data);
    } else {
      throw Exception(
        'Failed to analyze PDF: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<HistoryItem>> fetchHistory() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Auth token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('History Response Status Code: ${response.statusCode}');
    print('History Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => HistoryItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch history: ${response.body}');
    }
  }
}
