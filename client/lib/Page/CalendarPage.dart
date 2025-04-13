import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Service/HttpService.dart';
import '../Service/ServiceLocator.dart';
import '../Model/WorkDay.dart';

class CalendarPage extends StatefulWidget {
  dynamic jobId;
  CalendarPage({super.key, this.jobId});

  @override
  _CalendarPageState createState() => _CalendarPageState();
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

  void initResources() async {
    final response = await _httpService.get('myWorkDays/${widget.jobId}/${_focusedDay.month}/${_focusedDay.year}');
    List<dynamic> jsonList = List.from(response);
    Set<DateTime> days = {};
    setState(() {
      _workDaysList = [];
    });
    for (int i = 0; i < jsonList.length; i ++) {
      WorkDay workDay = WorkDay.fromJson(jsonList[i]);
      setState(() {
        _workDaysList.add(workDay);
      });

      days.add(DateTime(workDay.workYear!, workDay.workMonth!, workDay.workDate!.day));
    }

    setState(() {
      _workedDays = days;
    });
  }

  List<WorkDay> getWorkedDays(DateTime date) {
    List<WorkDay> workedDays = [];
    for (int i = 0; i < _workDaysList.length; i ++) {
      DateTime currDate = _workDaysList[i].workDate!;
      if (currDate.year == date.year
          && currDate.month == date.month
          && currDate.day == date.day) {
        workedDays.add(_workDaysList[i]);
      }
    }

    return workedDays;
  }

  void deleteWorkDays(workDays) async {
    for (WorkDay workDay in workDays) {
      _httpService.delete('deleteWorkDay/${workDay.id}');
    }
  }

  void _pickMonthYear() async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: 0.90,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                titleMedium: const TextStyle(fontSize: 14),
                bodyLarge: const TextStyle(fontSize: 14),
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: child!,
              ),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _focusedDay = DateTime(selected.year, selected.month);
        initResources();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Work Month')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  onPressed: _pickMonthYear,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Pick Month & Year'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TableCalendar(
                  headerStyle: HeaderStyle(
                    headerPadding: const EdgeInsets.all(12),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                    formatButtonVisible: false,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    headerMargin: const EdgeInsets.only(bottom: 16),
                  ),
                  availableGestures: AvailableGestures.none,
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      initResources();
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      bool worked = _workedDays.any((d) => isSameDay(d, day));
                      if (worked) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        );
                      }
                      return null; // default rendering
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    markersMaxCount: 1,
                    markerMargin: const EdgeInsets.all(16),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    List<WorkDay> selectedWorkDays = getWorkedDays(_selectedDay!);
                    deleteWorkDays(selectedWorkDays);
                  },
                  child: const Text(
                    'Delete work day',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addManual', arguments: {'jobId': widget.jobId});
                  },
                  child: const Text(
                    'Add work day',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        )
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    '/home'
                )
            ),
            const SizedBox(width: 40.0),
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    '/profile'
                )
            ),
          ],
        ),
      ),
    );
  }
}