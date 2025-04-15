import 'dart:convert';
import 'package:flutter/material.dart';

import '../Model/JobInfo.dart';
import '../Service/HttpService.dart';
import '../Service/ServiceLocator.dart';
import '../Service/StorageService.dart';

class JobDashboardPage extends StatefulWidget {
  final dynamic jobId;
  const JobDashboardPage({super.key, this.jobId});

  @override
  _JobDashboardPageState createState() => _JobDashboardPageState();
}

class _JobDashboardPageState extends State<JobDashboardPage> {
  final HttpService _httpService = getIt<HttpService>();
  final StorageService _storageService = getIt<StorageService>();

  String _workMode = 'workFromOffice';
  bool _isPressed = false;
  bool _isWorking = false;
  double timeDiffUtc = DateTime.now().timeZoneOffset.inHours as double;
  JobInfo _jobInfo = JobInfo();

  @override
  void initState() {
    super.initState();
    initResources();
  }

  Future<List<JobInfo>> fetchJobs() async {
    final response = await _httpService.get('myJobs');
    List<dynamic> jsonList = List.from(json.decode(response.body));
    List<JobInfo> jobs = jsonList.map((e) => JobInfo.fromJson(e)).toList();

    String jobsJsonString = json.encode(jobs.map((job) => job.toJson()).toList());
    _storageService.save('myJobs', jobsJsonString);

    return jobs;
  }

  void initResources() async {
    await fetchJobs();
    JobInfo? jobInfo = await _storageService.getJobById(widget.jobId!);
    if (jobInfo == null) return;

    setState(() {
      _jobInfo = jobInfo;
      _isPressed = jobInfo.currWorkType != null;
      _isWorking = _isPressed;
      _workMode = _isPressed ? jobInfo.currWorkType! : _workMode;
    });
  }

  Future<void> _delete() async {
    try {
      _httpService.delete('deleteWorkDay/${widget.jobId}');

      Navigator.pushReplacementNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job updated successfully')),
      );
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Work Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (!_isWorking)
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
              ),
            const SizedBox(height: 28),
            GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: () async {
                setState(() {
                  _isWorking = !_isWorking;
                });
                try {
                  await _httpService.put(
                      'startWorkDay/${widget.jobId}/$_workMode/$timeDiffUtc',
                      {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Work day submitted successfully')),
                  );
                } catch(e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _isPressed
                      ? (_isWorking ? Colors.red.shade700 : Colors.blue.shade700)
                      : (_isWorking ? Colors.red : Colors.blue),
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
            const SizedBox(height: 12),
            Text(
              _isWorking ? 'Stop Work Day' : 'Start Work Day',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 32),
            _buildDashboardButton(
              icon: Icons.work_outline,
              label: 'Job Info',
              onPressed: () => Navigator.pushNamed(
                context,
                '/jobInfo',
                arguments: {'jobId': widget.jobId},
              ),
            ),
            const SizedBox(height: 16),
            _buildDashboardButton(
              icon: Icons.calendar_month,
              label: 'Calendar',
              onPressed: () => Navigator.pushNamed(
                context,
                '/calendar',
                arguments: {'jobId': widget.jobId},
              ),
            ),
            const SizedBox(height: 16),
            _buildDashboardButton(
              icon: Icons.edit_calendar,
              label: 'Add Work Day Manually',
              onPressed: () => Navigator.pushNamed(
                context,
                '/addManually',
                arguments: {'jobId': widget.jobId},
              ),
            ),
            const SizedBox(height: 16),
            _buildDashboardButton(
              icon: Icons.attach_money,
              label: 'Salary Info',
              onPressed: () => Navigator.pushNamed(
                context,
                '/salaryInfo',
                arguments: {'jobId': widget.jobId},
              ),
            ),
            const SizedBox(height: 26),
            _buildDashboardButton(
              onPressed: _delete,
              icon: Icons.delete,
              label: 'Delete Job',
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(double.infinity, 48)),
                backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.grey[100],
        notchMargin: 6.0,
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

  Widget _buildDashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    ButtonStyle? style,
  }) {
    if (style == null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 24),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            side: BorderSide(color: Colors.grey.shade300),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.grey.shade100,
          ),
        ),
      );
    }
    else {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 24),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          style: style,
        ),
      );
    }
  }
}
