import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/add_data.dart';
import 'package:ins_app/modify_data.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  String collectionName = '';
  List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];

  Widget buildDataTable(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    return SingleChildScrollView(
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
        },
        children: document
            .data()
            .entries
            .map<TableRow>((entry) => TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        entry.key,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(entry.value.toString()),
                    ),
                  ),
                ]))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Demo'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter collection name',
            ),
            onChanged: (value) {
              collectionName = value;
            },
          ),
          ElevatedButton(
            child: Text('Load data'),
            onPressed: () async {
              final snapshot = await FirebaseFirestore.instance
                  .collection(collectionName)
                  .get();

              setState(() {
                documents = snapshot.docs;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                final document = documents[index];
                return Card(
                  child: ListTile(
                    title: Text('Document ${document.id}'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Document ${document.id}'),
                            content: buildDataTable(document),
                            actions: [
                              SizedBox(
                                width: kMinInteractiveDimension,
                                height: kMinInteractiveDimension,
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              TextButton(
                                child: Text('Edit'),
                                onPressed: () {
                                  if (document.id == 'Depense') {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ModifyData(
                                                  cin: collectionName,
                                                  docId: 'Depense',
                                                )));
                                  } else if (document.id == 'General info') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => AddData(
                                                collectionName:
                                                    collectionName)));
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
