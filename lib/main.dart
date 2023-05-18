import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ins_app/AuthPage.dart';
import 'package:ins_app/Signup.dart';
import 'package:ins_app/add_data.dart';
import 'package:ins_app/create_data.dart';
import 'package:ins_app/data_view.dart';
import 'package:ins_app/display_data_docs.dart';
import 'package:ins_app/existing_data.dart';
import 'package:ins_app/modify_data.dart';
import 'password_reset.dart';

import 'delete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CreateData('')  ,
        );
  }
}
