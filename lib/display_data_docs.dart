// necessaire pour afficher les données d'un document dans une collection
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_data.dart';
import 'modify_data.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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

            return AnimationLimiter(
              child: ListView.builder(
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
                              ),
                            ));
                          } else if (snapshot.data!.id == 'General info') {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AddData(collectionName: widget.collectionName),
                            ));
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
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: Duration(milliseconds: 100),
                      child: SlideAnimation(
                        duration: Duration(milliseconds: 500),
                        verticalOffset: 50.0,
                        child: Card(
                          color: Color(0xff1C69AE),
                          shadowColor: Color(0xff2EB1E3),
                          elevation: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      _getIconForEntry(entry.key), // Get the icon based on entry.key
                                      SizedBox(width: 8.0),
                                      Text(
                                        entry.key.replaceFirst(entry.key[0], entry.key[0].toUpperCase()),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        entry.value.toString(),
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Icon _getIconForEntry(String key) {
    // Define the icon mapping based on your requirements
    switch (key) {
      case 'nutrition':
        return Icon(Icons.food_bank_outlined);
      case 'vetements':
        return Icon(Icons.shopping_bag_outlined);
      case 'devertissement':
        return Icon(Icons.sports_esports_outlined);
      case 'sante':
        return Icon(Icons.medical_services_outlined);
      case 'profession':
        return Icon(Icons.work_outline_outlined);
      case 'nombre_p':
        return Icon(Icons.people_alt_outlined);
      case 'decile':
        return Icon(Icons.money_off_outlined);
      case 'zone':
        return Icon(Icons.location_on_outlined);
      case 'salaire':
        return Icon(Icons.money_outlined);
      case 'type':
        return Icon(Icons.category_outlined);
      default:
        // Return a default icon if no mapping is found
        return Icon(Icons.info);
    }
  }
}
