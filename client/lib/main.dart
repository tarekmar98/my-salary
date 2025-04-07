import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'Page/SignUpPage.dart';
import 'Page/VerifyPage.dart';
import 'Service/ServiceLocator.dart';

// void main() {
//   void main() {
//     runApp(MaterialApp(
//       initialRoute: '/',
//       routes: {
//         '/signUp': (context) => const SignUpPage(),
//         '/verify': (context) => const VerifyPage(),
//       },
//     ));
//   }
// }


void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SignUpPage(),
    );
  }
}