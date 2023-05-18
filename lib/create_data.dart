// cREATION D UN NOVEAU CITOYEN
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'add_data.dart';

class CreateData extends StatefulWidget {
  final String cin;

  CreateData(this.cin);

  @override
  _CreateDataState createState() => _CreateDataState();
}

class _CreateDataState extends State<CreateData> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cinController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _cinController = TextEditingController(); // <-- initialize the controller
  }

  Future<String?> checkCollectionExists(String collectionName) async {
    final collectionRef = firestore.collection(collectionName);
    final docSnapshot = await collectionRef.doc('dummy').get();

    if (docSnapshot.exists) {
      return collectionRef.id;
    } else {
      return null;
    }
  }

  void createCollection() async {
    if (_formKey.currentState!.validate()) {
      final cin = _cinController.text.trim();
      if (cin.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter CIN')),
        );
      } else {
        final existingCollection = await firestore.collection(cin).get();

        if (existingCollection.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Collection with CIN $cin already exists!')),
          );
        } else {
          await firestore.collection(cin).doc('General info').set({});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Collection $cin created successfully!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddData(
                collectionName: cin,
              ),
            ),
          );
        }
      }
    } else {
      // Show an error message if the field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter CIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Page creation",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 22,
                      color: Color(0xff000000),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    child: OtpTextField(
                      numberOfFields: 8,
                      showFieldAsBox: false,
                      fieldWidth: 40,
                      filled: true,
                      fillColor: Color(0x00000000),
                      enabledBorderColor: Color(0xff898a8e),
                      focusedBorderColor: Color(0xff3a57e8),
                      borderWidth: 2,
                      margin: EdgeInsets.all(0),
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      obscureText: false,
                      borderRadius: BorderRadius.circular(4.0),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        color: Color(0xff000000),
                      ),
                      onCodeChanged: (String value) {
                        setState(() {
                          _cinController.text = value;
                        });
                      },
                      onSubmit: (String value) {
                        setState(() {
                          _cinController.text = value;
                        });
                      },
                    ),
                  ),
                  MaterialButton(
                    onPressed: createCollection,
                    color: Color(0x2d3a57e8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xff3a57e8),
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
