import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class HttpService {
  final String baseUrl = "https://localhost:8080/";
  String? _phoneNumber;
  String? _authToken;

  void setHeaders(String token, String phoneNumber) {
    _authToken = token;
    _phoneNumber = phoneNumber;
  }

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      uri,
      headers: _buildHeaders(),
    );

    _handleError(response);
    return json.decode(response.body);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      uri,
      headers: _buildHeaders(),
      body: json.encode(body),
    );

    _handleError(response);
    return json.decode(response.body);
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'phoneNumber': '$_phoneNumber',
      if (_authToken != null) 'Authorization': '$_authToken',
    };
  }

  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception(
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }
}
