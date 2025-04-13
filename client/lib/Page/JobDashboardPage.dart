import 'dart:convert';

import 'package:client/Service/StorageService.dart';
import 'package:flutter/material.dart';

import '../Model/JobInfo.dart';
import '../Service/HttpService.dart';
import '../Service/ServiceLocator.dart';

class JobDashboardPage extends StatefulWidget {
  dynamic jobId;
  JobDashboardPage({super.key, this.jobId});

  @override
  _JobDashboardPageState createState() => _JobDashboardPageState();
}

class _JobDashboardPageState extends State<JobDashboardPage> {
  final HttpService _httpService = getIt<HttpService>();
  final StorageService _storageService = getIt<StorageService>();

  String _workMode = 'workFromOffice';
  bool _isPressed = false;
  bool _isWorking = false;
  JobInfo _jobInfo = new JobInfo();
  
  @override
  void initState() {
    super.initState();
    initResources();
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
  
  void initResources() async {
    await fetchJobs();
    JobInfo? jobInfo = (await _storageService.getJobById(widget.jobId!))!;
    setState(() {
      _jobInfo = jobInfo;
      _isPressed = (_jobInfo.currWorkType == null) ? false : true;
      _isWorking = _isPressed;
      _workMode = (_isPressed) ? _jobInfo.currWorkType! : _workMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Work Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (!_isWorking) ...[
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'workFromOffice',
                    label: Text('Office'),
                    icon: Icon(Icons.apartment),
                  ),
                  ButtonSegment(
                    value: 'workFromHome',
                    label: Text('Home'),
                    icon: Icon(Icons.home_work),
                  ),
                ],
                selected: {_workMode},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _workMode = newSelection.first;
                  });
                },
                showSelectedIcon: false,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                ),

              ),
            ],
            const SizedBox(height: 28),
            GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: () {
                setState(() {
                  _isWorking = !_isWorking;
                });

                _httpService.put('startWorkDay/${widget.jobId}/$_workMode', {});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _isPressed
                      ? (_isWorking ? Colors.red.shade700 : Colors.green.shade700)
                      : (_isWorking ? Colors.red : Colors.green),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _isWorking ? Icons.stop : Icons.play_arrow,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isWorking ? 'Stop Work Day' : 'Start Work Day',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 28),
            _buildActionButton(
              context,
              icon: Icons.work_outline,
              label: 'Job Info',
              color: Colors.blueGrey,
              onPressed: () => Navigator.pushNamed(
                context,
                '/jobInfo',
                arguments: {
                  'jobId': widget.jobId
                }
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context,
              icon: Icons.calendar_month,
              label: 'Calendar',
              color: Colors.limeAccent,
              onPressed: () => Navigator.pushNamed(
                  context,
                  '/calendar',
                  arguments: {
                    'jobId': widget.jobId
                  }
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context,
              icon: Icons.edit_calendar,
              label: 'Add Work Day Manually',
              color: Colors.blue,
              onPressed: () => Navigator.pushNamed(
                  context,
                  '/addManually',
                  arguments: {
                    'jobId': widget.jobId
                  }
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context,
              icon: Icons.attach_money,
              label: 'Salary Info',
              color: Colors.green,
              onPressed: () => Navigator.pushNamed(
                  context,
                  '/salaryInfo',
                  arguments: {
                    'jobId': widget.jobId
                  }
              ),
            ),
          ],
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
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
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

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onPressed,
        Color? pressedColor,
      }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
              if (states.contains(WidgetState.pressed)) {
                return pressedColor ?? color;
              }
              return color;
            },
          ),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.resolveWith<double>(
                (states) => states.contains(WidgetState.pressed) ? 2 : 4,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
