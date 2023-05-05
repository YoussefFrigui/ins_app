import 'package:flutter/material.dart';
// make it possible to retrieve data from Firebase and display it in a table and make it possible to modify the data

class ModifyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Data'),
      ),
      body: Center(
        child: Text(
          'Hello',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
