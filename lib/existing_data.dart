import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ins_app/add_data.dart';
import 'modify_data.dart';

class ExistingData extends StatefulWidget {
  @override
  _ExistingDataState createState() => _ExistingDataState();
}

class _ExistingDataState extends State<ExistingData> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();
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
              TextFormField(
                controller: _cinController,
                decoration: InputDecoration(labelText: 'CIN'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 8) {
                    return 'Please enter CIN';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final cin = _cinController.text.trim();
                    final created = await checkCollectionExists(cin);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          created ? 'Already created' : 'CIN added',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    if (created == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddData(
                            collectionName: cin,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text('Add CIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
