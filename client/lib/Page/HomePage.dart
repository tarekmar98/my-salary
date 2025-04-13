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
    if (token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/signUp');
    }
  }

  Future<List<JobInfo>> fetchJobs() async {
    final response = await _httpService.get('myJobs');
    List<dynamic> jsonList = List.from(response);
    List<JobInfo> jobs = [];
    for (int i = 0; i < jsonList.length; i++) {
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
      appBar: AppBar(
        title: const Text('My Jobs'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<JobInfo>>(
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          title: Text(
                            job.employerName ?? 'Unnamed Employer',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/jobDashboard',
                              arguments: {'jobId': job.id},
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                    backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                    WidgetStateProperty.all<Color>(Colors.white),
                    elevation: WidgetStateProperty.resolveWith<double>(
                          (states) =>
                      states.contains(WidgetState.pressed) ? 2 : 4,
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Job',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/add'),
                ),
              ),
            ],
          ),
        ),
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
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}
