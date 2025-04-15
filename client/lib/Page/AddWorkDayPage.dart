import 'package:client/Model/WorkDay.dart';
import 'package:client/Service/HttpService.dart';
import 'package:flutter/material.dart';

import '../Service/ServiceLocator.dart';

class AddWorkDayPage extends StatefulWidget {
  final int jobId;
  const AddWorkDayPage({super.key, required this.jobId});

  @override
  State<AddWorkDayPage> createState() => _AddWorkDayPageState();
}

class _AddWorkDayPageState extends State<AddWorkDayPage> {
  HttpService _httpService = getIt<HttpService>();
  
  WorkDay _workDay = new WorkDay();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      _workDay.jobId = widget.jobId;
      _workDay.workType = 'workFromOffice';
      _workDay.timeDiffUtc = DateTime.now().timeZoneOffset.inHours as double;
    });
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _workDay.workDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _workDay.workDate = picked;
        _workDay.workYear = picked.year;
        _workDay.workMonth = picked.month;
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (_workDay.workDate != null && _startTime != null && _endTime != null && _workDay.workType != null) {
      setState(() {
        _workDay.startTime = combineDateAndTime(_workDay.workDate!, _startTime!);
        _workDay.endTime = combineDateAndTime(_workDay.workDate!, _endTime!);
      });
      try {
        await _httpService.put('addWorkDay', _workDay.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Work day submitted successfully')),
        );
        Navigator.pop(context);
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Work Day')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              const Text(
                'Work Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(_workDay.workDate == null
                    ? 'Select date'
                    : '${_workDay.workDate!.day}/${_workDay.workDate!.month}/${_workDay.workDate!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),
              const Text(
                'Work Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
                selected: {_workDay.workType!},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _workDay.workType = newSelection.first;
                  });
                },
                showSelectedIcon: false,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Start Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(_startTime == null
                    ? 'Select start time'
                    : _startTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(true),
              ),
              const SizedBox(height: 20),
              const Text(
                'End Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(_endTime == null
                    ? 'Select end time'
                    : _endTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(false),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('Save Work Day'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              )
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
