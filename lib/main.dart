import 'package:bookshop/pages/adminlogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:bookshop/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:bookshop/pages/loginpage.dart';
import 'package:bookshop/pages/signuppage.dart';
import 'package:bookshop/pages/welcomepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => HomePage(),
        '/adminlogin': (context) =>
            const AdminLoginPage() // Add route for HomePage
      },
    );
  }
}
