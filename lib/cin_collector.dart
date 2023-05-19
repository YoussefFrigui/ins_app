import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/data_view.dart';

class CollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents in Collection'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Citoyen').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = documents[index];

              return Card(
                child: ListTile(
                  title: Text(document.id), // Display the document ID
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text(
                                    "Are you sure you want to delete this document?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Delete"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      String cin = documents[index].id;
                                      bool collectionExists =
                                          await checkCollectionExists(cin);
                                      if (collectionExists) {
                                        await deleteAllDocumentsInCollection(
                                            cin);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Document deleted!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Document not found!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Handle edit icon tap
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DataView(
                          cin: document.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> checkCollectionExists(String cin) async {
    bool exists = false;
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Citoyen').doc(cin).get();
      exists = snapshot.exists;
    } catch (e) {
      print(e);
    }
    return exists;
  }

  Future<void> deleteAllDocumentsInCollection(String cin) async {
    await FirebaseFirestore.instance.collection('Citoyen').doc(cin).delete();
  }
}
