import 'dart:convert';
import 'package:client/Service/HttpService.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'ServiceLocator.dart';
import 'StorageService.dart';

@injectable
class AuthUserService {
  final _storageService = getIt<StorageService>();
  final _httpService = getIt<HttpService>();

  Future<dynamic> signUp(String phoneNumber) async {
    final uri = Uri.parse('http://localhost:8080/signUp/$phoneNumber');
    final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((onError) => throw Exception());

    return response;
  }

  Future<dynamic> verifySignUp(String phoneNumber, String OTP) async {
    final uri = Uri.parse('http://localhost:8080/verifySignUp/$phoneNumber/$OTP');
    final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        }
    ).catchError((onError) => throw Exception());

    String token = json.decode(response.body)['token'];
    _storageService.save('phoneNumber', '$phoneNumber');
    _storageService.save('token', 'Bearer ${token}');
    _httpService.setHeaders(response.body, phoneNumber);
    return response;
  }
}