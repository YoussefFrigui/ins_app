import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/display_data_docs.dart';
import 'package:marquee/marquee.dart';

class DataView extends StatelessWidget {
  final String cin;

  DataView({required this.cin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Container(
          width: 100,
          child: Transform.scale(
            scale: 1,
            child: Text(
              'Data View',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 40,
            width: 400,
            child: Card(
              color: Colors.white,
              child: Marquee(
                text:
                    'Vous trouvez ici les tableaux de données relatives à $cin',
                style: TextStyle(fontWeight: FontWeight.bold),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 20.0,
                velocity: 30.0,
                // pauseAfterRound: Duration(seconds: 1),
                // startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                //decelerationDuration: Duration(milliseconds: 500),
                //decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 210,
              child: StreamBuilder<QuerySnapshot>(
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

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: documents.map((document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        IconData? iconData = getIconData(document.id);

                        return Container(
                          width: 175,
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Perform actions on tap if needed
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DataDocDisplay(
                                  cin: cin,
                                  documentID: document.id,
                                ),
                              ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180.0,
                                  height: 120.0,
                                  margin: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 94, 6, 247),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    document.id,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData? getIconData(String documentId) {
    switch (documentId) {
      case 'Depense':
        return Icons.attach_money;
      case 'General info':
        return Icons.info;
      // Add more cases for other icons as needed
      default:
        return null;
    }
  }
}
