import 'package:bookshop/pages/LoginPage.dart';
import 'package:bookshop/pages/SignupPage.dart';
import 'package:flutter/material.dart';
import 'package:bookshop/pages/WelcomePage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
