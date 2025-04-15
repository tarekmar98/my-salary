import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Service/HttpService.dart';
import '../Service/ServiceLocator.dart';
import '../Model/WorkDay.dart';
import '../Model/SalaryInfo.dart';

class SalaryInfoPage extends StatefulWidget {
  dynamic jobId;
  SalaryInfoPage({super.key, this.jobId});

  @override
  _SalaryInfoPageState createState() => _SalaryInfoPageState();
}

class _SalaryInfoPageState extends State<SalaryInfoPage> {
  final HttpService _httpService = getIt<HttpService>();

  DateTime _focusedDay = DateTime.now();
  int? _focusedMonth;
  int? _focusedYear;
  SalaryInfo? _salaryInfo = new SalaryInfo();

  static const labelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const valueStyle = TextStyle(fontSize: 16, color: Colors.black87);
  static const iconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    initResources();
  }

  void initResources() async {
    setState(() {
      _focusedMonth = _focusedDay.month;
      _focusedYear = _focusedDay.year;
    });

    final response = await _httpService.get('salaryInfo/'
        '${widget.jobId}/'
        '${_focusedMonth}/'
        '${_focusedYear}');

    setState(() {
      _salaryInfo = SalaryInfo.fromJson(json.decode(response.body));
    });
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

  Widget buildMonthYearHeader() {
    String month = _getMonthName(_focusedMonth!);
    String year = _focusedYear.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month, color: Colors.blueGrey.shade700),
          const SizedBox(width: 8),
          Text(
            '$month $year',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int monthNumber) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[monthNumber - 1];
  }

  Widget buildRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: labelStyle)),
          Text(value, style: valueStyle),
        ],
      ),
    );
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
              const SizedBox(height: 16),

              buildMonthYearHeader(),
              const SizedBox(height: 16),

              buildRow('Regular Hours', '${_salaryInfo!.regularHours} hrs', Icons.schedule),
              buildRow('Overtime (125%)', '${_salaryInfo!.overTimeHours125} hrs', Icons.timer_outlined),
              buildRow('Overtime (150%)', '${_salaryInfo!.overTimeHours150} hrs', Icons.timer),
              buildRow('Overtime (200%)', '${_salaryInfo!.overTimeHours200} hrs', Icons.timelapse),
              const Divider(height: 24),

              buildRow('Weekend Hours', '${_salaryInfo!.weekEndHours} hrs', Icons.weekend),
              buildRow('Sick Hours', '${_salaryInfo!.sickHours} hrs', Icons.healing),
              buildRow('Vacation Hours', '${_salaryInfo!.vacationHours} hrs', Icons.beach_access),
              const Divider(height: 24),

              buildRow('Morning Hours', '${_salaryInfo!.morningHours} hrs', Icons.wb_sunny),
              buildRow('Evening Hours', '${_salaryInfo!.eveningHours} hrs', Icons.wb_twilight),
              buildRow('Night Hours', '${_salaryInfo!.nightHours} hrs', Icons.nights_stay),
              const Divider(height: 24),

              buildRow('Travel Days', '${_salaryInfo!.travelsCount}', Icons.directions_bus),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'Total Salary: ₪${_salaryInfo!.salary?.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
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