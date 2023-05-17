import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ins_app/add_data.dart';
import 'package:ins_app/create_data.dart';
import 'package:ins_app/data_view.dart';
import 'modify_data.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'display_data_docs.dart';

class ExistingData extends StatefulWidget {
  @override
  _ExistingDataState createState() => _ExistingDataState();
}

class _ExistingDataState extends State<ExistingData> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();
  String cin = '';
  List<String> _docIds = [];

  Future<bool> checkCollectionExists(String cin) async {
    try {
      final collectionRef = firestore.collection(cin);
      final collectionSnapshot = await collectionRef.get();
      if (collectionSnapshot.docs.isNotEmpty) {
        // Collection exists and has documents
        // Retrieve document IDs in collection
        final docs = collectionSnapshot.docs;
        final docIds = docs.map((doc) => doc.id).toList();
        setState(() {
          _docIds = docIds;
        });
        return true;
      } else {
        // Collection doesn't exist
        // Create new collection with CIN
        await collectionRef.doc('General info').set({
          // add fields and values to the document as desired
        });
        await collectionRef.doc('Depense').set({
          // add fields and values to the document as desired
        });
        setState(() {
          _docIds = ['General info', 'Depense'];
        });
        return false;
      }
    } catch (e) {
      // Handle error
      setState(() {
        _docIds = [];
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Collections'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OtpTextField(
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
                    cin = value;
                  });
                },
                onSubmit: (String value) {
                  setState(() {
                    cin = value;
                  });
                },
              ),
              SizedBox(height: 32.0),
              MaterialButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final created = await checkCollectionExists(cin);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          created ? 'CIN EXISTS' : 'CIN added',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    if (!created) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddData(
                            collectionName: cin,
                          ),
                        ),
                      );
                    } else {
                      final snapshot = await FirebaseFirestore.instance
                          .collection(cin)
                          .get();

                      setState(() {
                        _docIds = snapshot.docs.map((doc) => doc.id).toList();
                      });
                    }
                  }
                },
                color: Color(0xff3a57e8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Color(0xffffffff),
                height: 50,
                minWidth: 150,
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _docIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = _docIds[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      color: Color(0xff3a57e8),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        title: Center(
                          child: Text(
                            'Table ${_docIds[index]}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DataDocDisplay(
                                collectionName: cin,
                                documentID: document,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}