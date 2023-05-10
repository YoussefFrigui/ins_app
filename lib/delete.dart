import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DeleteTest extends StatefulWidget {
  DeleteTest();

  @override
  _DeleteTestState createState() => _DeleteTestState();
}

class _DeleteTestState extends State<DeleteTest> {
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();

  @override
  void dispose() {
    _cinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Collection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _cinController,
                  decoration: InputDecoration(
                    hintText: 'Enter CIN of collection to delete',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a CIN';
                    } else if (value.length != 8) {
                      return 'Please enter a valid 8-digit CIN number';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  String cin = _cinController.text;
                  if (cin.isNotEmpty) {
                    // Check if the collection exists
                    bool collectionExists = await checkCollectionExists(cin);
                    if (collectionExists) {
                      // Delete all documents in the collection
                      await deleteAllDocumentsInCollection(cin);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('All documents in collection deleted!'),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Collection not found!'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                    // Clear the form field
                    _cinController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to check if a collection exists
  Future<bool> checkCollectionExists(String cin) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.collection(cin).get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.exists) {
            exists = true;
          }
        });
      });
    } catch (e) {
      print(e);
    }
    return exists;
  }

  Future<void> deleteAllDocumentsInCollection(String cin) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(cin).get();
    querySnapshot.docs.forEach((document) {
      document.reference.delete();
    });
  }
}
