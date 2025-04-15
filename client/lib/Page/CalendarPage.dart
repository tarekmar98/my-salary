import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Service/HttpService.dart';
import '../Service/ServiceLocator.dart';
import '../Model/WorkDay.dart';

class CalendarPage extends StatefulWidget {
  final dynamic jobId;
  const CalendarPage({super.key, this.jobId});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final HttpService _httpService = getIt<HttpService>();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _workedDays = {};
  List<WorkDay> _workDaysList = [];

  @override
  void initState() {
    super.initState();
    initResources();
  }

  Future<void> initResources() async {
    final response = await _httpService.get('myWorkDays/${widget.jobId}/${_focusedDay.month}/${_focusedDay.year}');
    List<dynamic> jsonList = List.from(json.decode(response.body));

    final Set<DateTime> days = {};
    final List<WorkDay> list = [];

    for (final item in jsonList) {
      WorkDay workDay = WorkDay.fromJson(item);
      list.add(workDay);
      days.add(DateTime(workDay.workYear!, workDay.workMonth!, workDay.workDate!.day));
    }

    setState(() {
      _workDaysList = list;
      _workedDays = days;
    });
  }

  List<WorkDay> getWorkedDays(DateTime date) {
    return _workDaysList.where((wd) {
      final d = wd.workDate!;
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  Future<void> deleteWorkDays(List<WorkDay> workDays) async {
    for (var workDay in workDays) {
      await _httpService.delete('deleteWorkDay/${workDay.id}');
    }
    await initResources();
  }

  Future<void> _pickMonthYear() async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selected != null) {
      setState(() {
        _focusedDay = DateTime(selected.year, selected.month);
      });
      await initResources();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Calendar"),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickMonthYear,
              icon: const Icon(Icons.calendar_month),
              label: const Text("Pick Month & Year"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                    initResources();
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) {
                      final isWorked = _workedDays.any((d) => isSameDay(d, day));
                      if (isWorked) {
                        return Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black87,
                          ),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(6),
                          child: Text('${day.day}', style: const TextStyle(color: Colors.white)),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedDay != null && getWorkedDays(_selectedDay!).isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final days = getWorkedDays(_selectedDay!);
                        await deleteWorkDays(days);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Delete Selected Day"),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Work Day"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/addManually', arguments: {'jobId': widget.jobId});
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade400),
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}
