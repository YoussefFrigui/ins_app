import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NameForm extends StatefulWidget {
  final CollectionReference<Map<String, dynamic>> firestore;

  NameForm(this.firestore);

  @override
  _NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _documentId;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Set the document ID to a random value
                    String docId = widget.firestore.doc().id;

                    // Create a reference to the document using the random ID
                    DocumentReference<Map<String, dynamic>> docRef =
                        widget.firestore.doc(docId);

                    // Set the document data using the form value
                    await docRef.set({
                      'name': _nameController.text,
                    });

                    // Show a message that the form was submitted
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Form submitted')));

                    // Clear the form field
                    _nameController.clear();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
