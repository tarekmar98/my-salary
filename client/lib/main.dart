import 'package:flutter/material.dart';

import 'Page/ProfilePage.dart';
import 'Page/HomePage.dart';
import 'Page/SignUpPage.dart';
import 'Page/VerifyPage.dart';
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
        // '/jobDashboard': (_) => const JobDashboardPage(),
        // '/calendar': (_) => const CalendarPage(),
        // '/addManual': (_) => const AddManualWorkDayPage(),
        // '/salaryInfo': (_) => const SalaryInfoPage(),
      },
      // onGenerateRoute: (settings) {
      //   if (settings.name == '/jobInfo') {
      //     final args = settings.arguments as Map<String, dynamic>;
      //     return MaterialPageRoute(
      //       builder: (context) => JobInfoPage(jobId: args['jobId']),
      //     );
      //   }
      //   // fallback
      //   return MaterialPageRoute(builder: (_) => const HomePage());
      // },
      debugShowCheckedModeBanner: false,
    );
  }
}