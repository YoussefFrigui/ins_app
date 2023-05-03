import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



class fill_test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Test',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Form Test'),
        ),
        body: FormTest(FirebaseFirestore.instance),
      ),
    );
  }
}
class FormTest extends StatefulWidget {
  final FirebaseFirestore firestore;

  FormTest(this.firestore);

  @override
  _FormTestState createState() => _FormTestState();
}

class _FormTestState extends State<FormTest> {
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();
  final _emailController = TextEditingController();
 String? _documentId; // ID of the document to update, if any

  @override
  void dispose() {
    _cinController.dispose();
    _emailController.dispose();
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
              controller: _cinController,
              decoration: InputDecoration(
                hintText: 'Enter your CIN',
              ),
               keyboardType: TextInputType.number, // Set the keyboard type to number
  validator: (value) {
    if (value!.isEmpty) {
      return 'Please enter your CIN';
    } else if (value.length != 8) { // Add validation for 8-digit CIN numbers
      return 'Please enter a valid 8-digit CIN number';
    }
    return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            Padding(
  padding: const EdgeInsets.symmetric(vertical: 16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      ElevatedButton(
        onPressed: () async {
  if (_formKey.currentState!.validate()) {
    // Set the document ID to the CIN number
    String docId = _cinController.text;

    // Create a reference to the document using the CIN number as the ID
    DocumentReference docRef =
        widget.firestore.collection(_cinController.text).doc(docId);

    // Set the document data using the form values
    await docRef.set({
      'cin': _cinController.text,
      'email': _emailController.text,
    });

    // Show a message that the form was submitted
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Form submitted')));

    // Clear the form fields
    _cinController.clear();
    _emailController.clear();

    // Reset the document ID to null
    setState(() {
      _documentId = null;
    });
  }
},

        child: Text('Submit'),
      ),
      ElevatedButton(
  onPressed: () async {
    String cin = _cinController.text;
    if (cin.isNotEmpty) {
      // Query the collection for documents with the specified CIN number
      QuerySnapshot querySnapshot = await widget.firestore
          .collection(cin)
          .where('cin', isEqualTo: cin)
          .get();

      // Delete each document in the query result
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }

      // Show a message that the documents were deleted
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document(s) deleted')));

      // Clear the form fields
      _cinController.clear();
      _emailController.clear();

      // Reset the document ID to null
      setState(() {
        _documentId = null;
      });
    }
  },
  child: Text('Delete'),
),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
