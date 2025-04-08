import 'package:client/Service/HttpService.dart';
import 'package:client/Service/StorageService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Service/AuthUserService.dart';
import '../Service/ServiceLocator.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _authUserService = getIt<AuthUserService>();
  final _storageService = getIt<StorageService>();
  String _OTP = '';
  bool _buttonIsEnabled = true;

  Future<void> _submit() async {
    _buttonIsEnabled = false;
    String? _fullPhoneNumber = await _storageService.get('phoneNumber');
    debugPrint('Phone Number: $_fullPhoneNumber');
    try {
      final response = await _authUserService.verifySignUp(_fullPhoneNumber, _OTP);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verifying $_OTP')),
        );
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    _buttonIsEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Page')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _OTP = value;
                  if (value.length == 6) {
                    _submit();
                  }
                },
                validator: (value) => value == null || value.isEmpty ? 'Enter the verification code.' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _buttonIsEnabled ? _submit : null,
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
