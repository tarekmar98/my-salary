import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Service/AuthUserService.dart';
import '../Service/HttpService.dart';
import '../Service/ServiceLocator.dart';
import '../Service/StorageService.dart';
import 'VerifyPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _authUserService = getIt<AuthUserService>();
  final _storageService = getIt<StorageService>();
  String _fullPhoneNumber = '';
  bool _buttonIsEnabled = true;

  Future<void> _submit() async {
    _buttonIsEnabled = false;
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authUserService.signUp(_fullPhoneNumber);
        if (response.statusCode == 200) {
          _storageService.save('phoneNumber', _fullPhoneNumber);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyPage(),
            ),
          );
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
    }
    _buttonIsEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up Page')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _buttonIsEnabled ? _submit : null,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
