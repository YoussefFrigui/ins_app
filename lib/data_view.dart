import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/display_data_docs.dart';


class DataView extends StatelessWidget {
  final String cin;

  DataView({required this.cin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data View'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Citoyen')
            .doc(cin)
            .collection('data')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          QuerySnapshot querySnapshot = snapshot.data!;
          List<QueryDocumentSnapshot> documents = querySnapshot.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot document = documents[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  // Perform actions on tap if needed
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DataDocDisplay(
                      cin: cin,
                      documentID: document.id,
                    ),
                  ));

                },
                child: Card(
                  child: ListTile(
                    title: Text(document.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
