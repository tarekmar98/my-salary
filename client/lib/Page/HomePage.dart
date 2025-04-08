import 'dart:convert';

import 'package:client/Service/StorageService.dart';
import 'package:flutter/material.dart';

import '../Model/JobInfo.dart';
import '../Service/HttpService.dart';
import '../Service/ServiceLocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final HttpService _httpService = getIt<HttpService>();
  final StorageService _storageService = getIt<StorageService>();

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  void checkPermission() async {
    String? token = await _storageService.get('token');
    String x = "12";
    if (token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/signUp');
    } else {
      x = '11';
    }
  }

  Future<List<JobInfo>> fetchJobs() async {
    final response = await _httpService.get('myJobs');
    List<dynamic> jsonList = List.from(response);
    List<JobInfo> jobs = [];
    for (int i = 0; i < jsonList.length; i ++) {
      jobs.add(JobInfo.fromJson(jsonList[i]));
    }

    List<Map<String, dynamic>> jobsJson = jobs.map((job) => job.toJson()).toList();
    String jobsJsonString = json.encode(jobsJson);
    _storageService.save('myJobs', jobsJsonString);
    return jobs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Jobs')),
      body: FutureBuilder<List<JobInfo>>(
        future: fetchJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jobs found.'));
          }

          final jobs = snapshot.data!;
          return ListView(
            children: jobs.map((job) {
              return ListTile(
                title: Text(job.employerName),
                onTap: () =>
                    Navigator.pushNamed(context, '/jobDashboard'),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/jobInfo'),
      ),
    );
  }
}
