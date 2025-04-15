import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'ServiceLocator.dart';
import 'StorageService.dart';

@injectable
class HttpService {
  final StorageService _storageService = getIt<StorageService>();
  // TODO replace http with https.
  final String baseUrl = "http://localhost:8080/";
  String? _phoneNumber;
  String? _token;

  void setHeaders(String token, String phoneNumber) {
    _token = token;
    _phoneNumber = phoneNumber;
  }

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    Future<Map<String, String>> headers = _buildHeaders();
    final response = await http.get(
      uri,
      headers: await headers,
    );

    return response;
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    Future<Map<String, String>> headers = _buildHeaders();
    final response = await http.put(
      uri,
      headers: await headers,
      body: json.encode(body),
    );

    return response;
  }

  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    Future<Map<String, String>> headers = _buildHeaders();
    final response = await http.delete(
      uri,
      headers: await headers,
    );

    return response;
  }

  Future<Map<String, String>> _buildHeaders() async {
    _phoneNumber ??= await _storageService.get('phoneNumber');
    _token ??= await _storageService.get('token');
    return {
      'Content-Type': 'application/json',
      'phoneNumber': '$_phoneNumber',
      if (_token != null) 'Authorization': '$_token',
    };
  }
}
