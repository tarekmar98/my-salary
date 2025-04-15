import 'dart:convert';

import 'package:client/Page/HomePage.dart';
import 'package:client/Service/HttpService.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Model/User.dart';
import '../Service/ServiceLocator.dart';
import '../Service/StorageService.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  HttpService _httpService = getIt<HttpService>();
  StorageService _storageService = getIt<StorageService>();

  User _user = new User();
  Map<String, dynamic> _locations = {};
  List<String> _countries = [];
  List<String> _cities = [];
  List<String> _religions = [];
  List<String> _languages = [];
  bool profileExists = false;

  @override
  void initState() {
    super.initState();
    if (_storageService.get('token') == null) {
      Navigator.pushReplacementNamed(context, '/home');
    }

    initResources();
  }

  void initResources() async {
    final response = await _httpService.get('myProfile');
    if (response.statusCode < 400) {
      profileExists = true;
      setState(() {
        _user = User.fromJson(json.decode(response.body));
      });
    } else {
      String? phoneNumber = await _storageService.get('phoneNumber');
      _user.phoneNumber = phoneNumber;
    }

    String jsonStringCountries = await rootBundle.loadString('assets/countries.json');
    String jsonStringReligions = await rootBundle.loadString('assets/religions.json');
    String jsonStringLanguages = await rootBundle.loadString('assets/languages.json');
    setState(() {
      _locations = json.decode(jsonStringCountries);
      _countries = _locations.keys.cast<String>().toList();
      _religions = List<String>.from(json.decode(jsonStringReligions)['religions']);
      _languages = List<String>.from(json.decode(jsonStringLanguages)['languages']);
      if (_user.country != null) {
        _cities = List<String>.from(_locations[_user.country]);
      }
    });

  }

  Future<void> _submit() async {
    try {
      if (profileExists) {
        _httpService.put('updateProfile', _user.toJson());
      } else {
        _httpService.put('addProfile', _user.toJson());
      }

      Navigator.pushNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _logout() async {
    await _storageService.clear();
    Navigator.pushReplacementNamed(context, '/signUp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          DropdownButton<String>(
            value: _user.country,
            hint: Text('Select your country'),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            items: _countries.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _cities = List<String>.from(_locations[newValue]);
                _user.country = newValue!;
              });
            },
          ),
          DropdownButton<String>(
            value: _user.city,
            hint: Text('Select your city'),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            items: _cities.map((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _user.city = newValue!;
              });
            },
          ),
          DropdownButton<String>(
            value: _user.religion,
            hint: Text('Select your religion'),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            items: _religions.map((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _user.religion = newValue!;
              });
            },
          ),
          DropdownButton<String>(
            value: _user.language,
            hint: Text('Select your language'),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            items: _languages.map((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _user.language = newValue!;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _submit(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Profile', style: TextStyle(fontSize: 16)),
          ),
          Spacer(),
          ElevatedButton.icon(
            onPressed: _logout,
            icon: Icon(Icons.logout),
            label: Text('Log Out'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/home'),
            ),
            const SizedBox(width: 40.0),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}