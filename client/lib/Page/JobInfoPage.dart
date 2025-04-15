import 'package:client/Model/OverTimeInfo.dart';
import 'package:client/Model/ShiftsInfo.dart';
import 'package:client/Model/WeekEndInfo.dart';
import 'package:client/Widget/DateTimeInput.dart';
import 'package:flutter/material.dart';

import 'package:client/Model/JobInfo.dart';
import 'package:client/Service/HttpService.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../Service/ServiceLocator.dart';
import '../Service/StorageService.dart';

enum PaymentType { perHour, perDay, perMonth }

class JobInfoPage extends StatefulWidget {
  dynamic jobId;
  JobInfoPage({super.key, this.jobId});

  @override
  _JobInfoPageState createState() => _JobInfoPageState();
}

class _JobInfoPageState extends State<JobInfoPage> {
  final HttpService _httpService = getIt<HttpService>();
  final StorageService _storageService = getIt<StorageService>();

  final TextEditingController _employerNameController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _foodController = TextEditingController();
  TextEditingController _travelController = TextEditingController();
  TextEditingController _minHoursForBreakController = TextEditingController();
  TextEditingController _breakTimeController = TextEditingController();
  TextEditingController _workDayHourController = TextEditingController();
  TextEditingController _weekEndPercentageController = TextEditingController();
  TextEditingController _eveningPercentageController = TextEditingController();
  TextEditingController _nightPercentageController = TextEditingController();

  JobInfo _jobInfo = new JobInfo();
  bool jobExists = false;
  PaymentType? _selectedSalaryType = PaymentType.perHour;
  PaymentType? _selectedFoodType = PaymentType.perDay;
  PaymentType? _selectedTravelType = PaymentType.perDay;
  bool jobInfoUpdated = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _jobInfo.startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _jobInfo.startDate) {
      setState(() {
        _jobInfo.startDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    initResources();
  }

  void checkPermission() async {
    String? token = await _storageService.get('token');
    if (token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/signUp');
    }
  }

  void initResources() async {
    _jobInfo.userPhoneNumber = await _storageService.get('phoneNumber');
    if (widget.jobId != null) {
      _jobInfo.id = widget.jobId;
      JobInfo jobInfo = (await _storageService.getJobById(widget.jobId!))!;
      setState(() {
        jobExists = true;
        _jobInfo = jobInfo;
        _selectedSalaryType = jobInfo.salaryPerHour != null && jobInfo.salaryPerHour! > 0
            ? PaymentType.perHour
            : PaymentType.perDay;
        _selectedFoodType = jobInfo.foodPerDay != null && jobInfo.foodPerDay! > 0
            ? PaymentType.perDay
            : PaymentType.perMonth;
        _selectedTravelType = jobInfo.travelPerDay != null && jobInfo.travelPerDay! > 0
            ? PaymentType.perDay
            : PaymentType.perMonth;
        _employerNameController.text = jobInfo.employerName.toString();
        _startDateController.text = DateFormat('yyyy-MM-dd').format(jobInfo.startDate!);
        _salaryController.text = (_selectedSalaryType == PaymentType.perHour ? jobInfo.salaryPerHour : jobInfo.salaryPerDay).toString();
        _foodController.text = (_selectedFoodType == PaymentType.perDay ? jobInfo.foodPerDay : jobInfo.foodPerMonth).toString();
        _travelController.text = (_selectedTravelType == PaymentType.perDay ? jobInfo.travelPerDay : jobInfo.travelPerMonth).toString();
        _minHoursForBreakController.text = jobInfo.minHoursBreakTime!.toString();
        _breakTimeController.text = jobInfo.breakTimeMinutes!.toString();
        _workDayHourController.text = jobInfo.dayWorkHours!.toString();
        _weekEndPercentageController.text = (jobInfo.weekEndInfo?.weekEndPercentage)!.toString();
        if (jobInfo.shifts == true) {
          _eveningPercentageController.text =
              (jobInfo.shiftsInfo?.eveningPercentage)!.toString();
          _nightPercentageController.text =
              (jobInfo.shiftsInfo?.nightPercentage)!.toString();
        }
        jobInfoUpdated = true;
      });
    } else {
      setState(() {
        jobExists = false;
        _jobInfo.shifts = false;
        _jobInfo.overTimeInfo = new OverTimeInfo();
        _jobInfo.shiftsInfo = new ShiftsInfo();
        _jobInfo.weekEndInfo = new WeekEndInfo();
        jobInfoUpdated = true;
      });
    }
  }

  Future<void> _submit() async {
    try {
      if (jobExists) {
        _httpService.put('updateJob', _jobInfo.toJson());
      } else {
        _httpService.put('addJob', _jobInfo.toJson());
      }

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
    if (jobInfoUpdated == false) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Job Info')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
          children: [
            const SizedBox(height: 16.0),
            TextField(
              controller: _employerNameController,
              decoration: InputDecoration(
                labelText: 'Enter employer name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _jobInfo.employerName = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                labelText: 'Select start date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                const Text(
                  'Select your salary payment type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Radio<PaymentType>(
                      value: PaymentType.perHour,
                      groupValue: _selectedSalaryType,
                      onChanged: (PaymentType? value) {
                        setState(() {
                          _selectedSalaryType = value;
                        });
                      },
                    ),
                    const Text('Per Hour'),
                    Radio<PaymentType>(
                      value: PaymentType.perDay,
                      groupValue: _selectedSalaryType,
                      onChanged: (PaymentType? value) {
                        setState(() {
                          _selectedSalaryType = value;
                        });
                      },
                    ),
                    const Text('Per Day'),
                  ],
                ),
                if (_selectedSalaryType != null) ...[
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _salaryController,
                    decoration: InputDecoration(
                      labelText: 'Enter your salary ${_selectedSalaryType == PaymentType.perHour ? 'per hour:' : 'per day:'}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (_selectedSalaryType == PaymentType.perDay) {
                          _jobInfo.salaryPerDay = double.parse(value);
                          _jobInfo.salaryPerHour = 0.0;
                        } else {
                          _jobInfo.salaryPerHour = double.parse(value);
                          _jobInfo.salaryPerDay = 0.0;
                        }
                      });
                    },
                  ),
                ],
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                const Text(
                  'Select your food payment type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Radio<PaymentType>(
                      value: PaymentType.perDay,
                      groupValue: _selectedFoodType,
                      onChanged: (PaymentType? value) {
                        setState(() {
                          _selectedFoodType = value;
                        });
                      },
                    ),
                    const Text('Per Day'),
                    Radio<PaymentType>(
                      value: PaymentType.perMonth,
                      groupValue: _selectedFoodType,
                      onChanged: (PaymentType? value) {
                        setState(() {
                          _selectedFoodType = value;
                        });
                      },
                    ),
                    const Text('Per Month'),
                  ],
                ),
                if (_selectedFoodType != null) ...[
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _foodController,
                    decoration: InputDecoration(
                      labelText: 'Enter your food payment ${_selectedFoodType == PaymentType.perDay ? 'per day:' : 'per month:'}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (_selectedFoodType == PaymentType.perDay) {
                          _jobInfo.foodPerDay = double.parse(value);
                          _jobInfo.foodPerMonth = 0.0;
                        } else {
                          _jobInfo.foodPerMonth = double.parse(value);
                          _jobInfo.foodPerDay = 0.0;
                        }
                      });
                    },
                  ),
                ],
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16.0),
                const Text(
                  'Select your travel payment type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Radio<PaymentType>(
                      value: PaymentType.perDay,
                      groupValue: _selectedTravelType,
                      onChanged: (PaymentType? value) {
                        setState(() {
                          _selectedTravelType = value;
                        });
                      },
                    ),
                    const Text('Per Day'),
                    Radio<PaymentType>(
                      value: PaymentType.perMonth,
                      groupValue: _selectedTravelType,
                      onChanged: (PaymentType? value) {
                        setState(() {
                          _selectedTravelType = value;
                        });
                      },
                    ),
                    const Text('Per Month'),
                  ],
                ),
                if (_selectedTravelType != null) ...[
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _travelController,
                    decoration: InputDecoration(
                      labelText: 'Enter your travel payment ${_selectedTravelType == PaymentType.perDay ? 'per day:' : 'per month:'}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (_selectedTravelType == PaymentType.perDay) {
                          _jobInfo.travelPerDay = double.parse(value);
                          _jobInfo.travelPerMonth = 0.0;
                        } else {
                          _jobInfo.travelPerMonth = double.parse(value);
                          _jobInfo.travelPerDay = 0.0;
                        }
                      });
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _workDayHourController,
              decoration: InputDecoration(
                labelText: 'Enter work day hours',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _jobInfo.dayWorkHours = double.parse(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _breakTimeController,
              decoration: InputDecoration(
                labelText: 'Enter break time minutes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _jobInfo.breakTimeMinutes = int.parse(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _minHoursForBreakController,
              decoration: InputDecoration(
                labelText: 'Enter minimum hours for break time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _jobInfo.minHoursBreakTime = double.parse(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Enter minimum hours for over time percentage 125%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DateTimeInput(
              weekDayEnabled: false,
              onChanged: (value) {
                setState(() {
                  _jobInfo.overTimeInfo?.overTimeStartHour125 = value.hour;
                });
              },
              initialValHour: jobExists? _jobInfo.overTimeInfo!.overTimeStartHour125 : null,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Enter minimum hours for over time percentage 150%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DateTimeInput(
              weekDayEnabled: false,
              onChanged: (value) {
                setState(() {
                  _jobInfo.overTimeInfo?.overTimeStartHour150 = value.hour;
                });
              },
              initialValHour: jobExists? _jobInfo.overTimeInfo!.overTimeStartHour150 : null,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Enter minimum hours for over time percentage 200%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DateTimeInput(
              weekDayEnabled: false,
              onChanged: (value) {
                setState(() {
                  _jobInfo.overTimeInfo?.overTimeStartHour200 = value.hour;
                });
              },
              initialValHour: jobExists? _jobInfo.overTimeInfo!.overTimeStartHour200 : null,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Select your weekend start:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DateTimeInput(
              weekDayEnabled: true,
              onChanged: (value) {
                setState(() {
                  _jobInfo.weekEndInfo?.weekEndStartDay = value.weekday;
                  _jobInfo.weekEndInfo?.weekEndStartHour = value.hour;
                });
              },
              initialValHour: jobExists? _jobInfo.weekEndInfo!.weekEndStartHour : null,
              initialValWeekday: jobExists? _jobInfo.weekEndInfo!.weekEndStartDay : null
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Select your weekend end:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DateTimeInput(
              weekDayEnabled: true,
              onChanged: (value) {
                setState(() {
                  _jobInfo.weekEndInfo?.weekEndEndDay = value.weekday;
                  _jobInfo.weekEndInfo?.weekEndEndHour = value.hour;
                });
              },
              initialValHour: jobExists? _jobInfo.weekEndInfo!.weekEndEndHour : null,
              initialValWeekday: jobExists? _jobInfo.weekEndInfo!.weekEndEndDay : null
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _weekEndPercentageController,
              decoration: InputDecoration(
                labelText: 'Enter weekend percentage',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _jobInfo.weekEndInfo?.weekEndPercentage = double.parse(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                const Text('Enable shifts:'),
                const SizedBox(width: 10),
                Switch(
                  value: jobExists? _jobInfo.shifts! : false,
                  onChanged: (bool value) {
                    setState(() {
                      _jobInfo.shifts = value;
                    });
                  },
                ),
              ],
            ),
            if (jobExists && _jobInfo.shifts!) ...[
              const SizedBox(height: 16.0),
              const Text(
                'Select your morning shift start hour:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              DateTimeInput(
                weekDayEnabled: false,
                onChanged: (value) {
                  setState(() {
                    _jobInfo.shiftsInfo?.morningStartHour = value.hour;
                  });
                },
                initialValHour: jobExists? _jobInfo.shiftsInfo!.morningStartHour : null,
                initialValWeekday: null
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Select your evening shift start hour:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              DateTimeInput(
                weekDayEnabled: false,
                onChanged: (value) {
                  setState(() {
                    _jobInfo.shiftsInfo?.eveningStartHour = value.hour;
                  });
                },
                initialValHour: jobExists? _jobInfo.shiftsInfo!.eveningStartHour : null,
                initialValWeekday: null
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Select your night shift start hour:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              DateTimeInput(
                weekDayEnabled: false,
                onChanged: (value) {
                  setState(() {
                    _jobInfo.shiftsInfo?.nightStartHour = value.hour;
                  });
                },
                initialValHour: jobExists? _jobInfo.shiftsInfo!.nightStartHour : null,
                initialValWeekday: null
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _eveningPercentageController,
                decoration: InputDecoration(
                  labelText: 'Enter your evening shift percentage',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _jobInfo.shiftsInfo?.eveningPercentage = double.parse(value);
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nightPercentageController,
                decoration: InputDecoration(
                  labelText: 'Enter your night shift percentage',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _jobInfo.shiftsInfo?.nightPercentage = double.parse(value);
                  });
                },
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _submit(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Job', style: TextStyle(fontSize: 16)),
            ),
          ]),
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