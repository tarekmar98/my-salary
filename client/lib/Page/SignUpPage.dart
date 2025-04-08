import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Service/AuthUserService.dart';
import '../Service/ServiceLocator.dart';
import '../Service/StorageService.dart';
import 'VerifyPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _authUserService = getIt<AuthUserService>();
  final _storageService = getIt<StorageService>();
  String _fullPhoneNumber = '';
  bool _enableButton = true;

  Future<void> _submit() async {
    _enableButton = false;
    try {
      final response = await _authUserService.signUp(_fullPhoneNumber);
      if (response.statusCode == 200) {
        _storageService.save('phoneNumber', _fullPhoneNumber);
        Navigator.pushNamed(context, '/verify');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signing up with $_fullPhoneNumber')),
        );
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
    _enableButton = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          child: Column(
            children: [
              const Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'IL',
                onChanged: (phone) {
                  _fullPhoneNumber = phone.completeNumber;
                },
                validator: (phone) =>
                phone == null || phone.number.isEmpty ? 'Enter your phone number' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _enableButton ? _submit() : null,
                child: const Text('Send Code'),
              )
            ]),
        )
      ),
    );
  }
}
