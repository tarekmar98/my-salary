import 'package:client/Page/JobDashboardPage.dart';
import 'package:client/Page/SalaryInfoPage.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalCupertinoLocalizations, GlobalMaterialLocalizations, GlobalWidgetsLocalizations;

import 'Page/AddWorkDayPage.dart';
import 'Page/JobInfoPage.dart';
import 'Page/ProfilePage.dart';
import 'Page/HomePage.dart';
import 'Page/SignUpPage.dart';
import 'Page/VerifyPage.dart';
import 'Page/CalendarPage.dart';
import 'Service/ServiceLocator.dart';

void main() {
  configureDependencies();
  runApp(const MySalaryApp());
}

class MySalaryApp extends StatelessWidget {
  const MySalaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mySalary',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/home',
      routes: {
        '/signUp': (_) => const SignUpPage(),
        '/verify': (_) => const VerifyPage(),
        '/profile': (_) => const ProfilePage(),
        '/home': (_) => const HomePage(),
        '/addJob': (_) => JobInfoPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/jobInfo') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => JobInfoPage(jobId: args['jobId'] as int),
          );
        }

        if (settings.name == '/jobDashboard') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => JobDashboardPage(jobId: args['jobId'] as int),
          );
        }

        if (settings.name == '/calendar') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CalendarPage(jobId: args['jobId'] as int),
          );
        }

        if (settings.name == '/addManually') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => AddWorkDayPage(jobId: args['jobId'] as int),
          );
        }

        if (settings.name == '/salaryInfo') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => SalaryInfoPage(jobId: args['jobId'] as int),
          );
        }

        return MaterialPageRoute(builder: (_) => const HomePage());
      },
      debugShowCheckedModeBanner: false,
    );
  }
}