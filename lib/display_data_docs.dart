import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_data.dart';
import 'modify_data.dart';

class DataDocDisplay extends StatefulWidget {
  final String collectionName;
  final String documentID;

  DataDocDisplay({required this.collectionName, required this.documentID});

  @override
  _DataDocDisplayState createState() => _DataDocDisplayState();
}

class _DataDocDisplayState extends State<DataDocDisplay> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _futureDocument;

  @override
  void initState() {
    super.initState();
    _futureDocument = FirebaseFirestore.instance
        .collection(widget.collectionName)
        .doc(widget.documentID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Data')),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _futureDocument,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data found.'));
            }

            final data = snapshot.data!.data()!;

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: MaterialButton(
                      onPressed: () {
                        if (snapshot.data!.id == 'Depense') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ModifyData(
                                    cin: widget.collectionName,
                                    docId: 'Depense',
                                  )));
                        } else if (snapshot.data!.id == 'General info') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddData(
                                  collectionName: widget.collectionName)));
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8.0),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  );
                } else {
                  final entry = data.entries.elementAt(index);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            entry.value.toString(),
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
