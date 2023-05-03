
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ins_app/delete.dart';
import 'package:ins_app/fill_test.dart';
import 'AuthPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(fill_test());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationPage(),
    );
  }
}
