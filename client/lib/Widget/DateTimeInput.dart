import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeInput extends StatefulWidget {
  dynamic weekDayEnabled;
  final ValueChanged<({String? weekday, DateTime? hour})>? onChanged;
  final ({String? weekday, DateTime? hour})? initialVal;

  DateTimeInput({
    super.key,
    this.onChanged,
    this.weekDayEnabled,
    this.initialVal
  });

  @override
  State<DateTimeInput> createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  String? _selectedWeekday;
  DateTime? _selectedHour = DateTime(0, 1, 1, 0, 0); // Initialize with a base date and time

  final List<String> _weekdays = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
  final List<int> _hours = List.generate(24, (i) => i);
  final List<int> _minutes = List.generate(60, (i) => i);

  @override
  void initState() {
    super.initState();
    if (widget.initialVal?.weekday != null) {
      _selectedWeekday = widget.initialVal?.weekday;
    } else {
      _selectedWeekday = "MONDAY";
    }

    if (widget.initialVal?.hour != null) {
      _selectedHour = widget.initialVal?.hour;
    } else {
      _selectedHour = DateFormat("HH:MM:SS").parse("00:00:00");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.weekDayEnabled == true) // Ensure it's treated as a boolean
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Weekday',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            value: _selectedWeekday,
            items: _weekdays.map((day) => DropdownMenuItem(value: day, child: Text(day))).toList(),
            onChanged: (value) {
              setState(() {
                _selectedWeekday = value;
              });
              _notifyParent();
            },
          ),
        if (widget.weekDayEnabled == true) // Add SizedBox only if weekday is enabled
          const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Hour (0-23)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                value: _selectedHour?.hour,
                items: _hours.map((hour) => DropdownMenuItem(
                    value: hour, child: Text(hour.toString().padLeft(2, '0')))).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHour = DateTime(_selectedHour!.year, _selectedHour!.month, _selectedHour!.day, value!, _selectedHour!.minute);
                  });
                  _notifyParent();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Minute (0-59)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                value: _selectedHour!.minute,
                items: _minutes.map((minute) => DropdownMenuItem(
                    value: minute, child: Text(minute.toString().padLeft(2, '0')))).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHour = DateTime(_selectedHour!.year, _selectedHour!.month, _selectedHour!.day, _selectedHour!.hour, value!);
                  });
                  _notifyParent();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _notifyParent() {
    if (widget.onChanged != null) {
      widget.onChanged!((weekday: _selectedWeekday, hour: _selectedHour));
    }
  }
}
