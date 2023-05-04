import 'package:flutter/material.dart';
import 'package:ins_app/create_data.dart';
import 'existing_data.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateData('')),
            );
          },
          child: Text('Go to Existing Data'),
        ),
      ),
    );
  }
}
