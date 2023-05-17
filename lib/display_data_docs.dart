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
            itemBuilder: (BuildContext c, itemcount) {
 
  return AnimationConfiguration.staggeredList(
    position: itemcount,
    delay: Duration(milliseconds: 100),
    child: SlideAnimation(
      duration: Duration(milliseconds: 2500),
      curve: Curves.fastLinearToSlowEaseIn,
      horizontalOffset: 30,
      verticalOffset: 300.0,
      child: FlipAnimation(
        duration: Duration(milliseconds: 3000),
        curve: Curves.fastLinearToSlowEaseIn,
        flipAxis: FlipAxis.y,
        child: Container(
          margin: EdgeInsets.only(bottom: _w / 20),
          height: _w / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),


              
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
                    color: Color(0xff2cb1e4),
                    shadowColor: Color(0xff9ec34a,),
                    elevation: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              entry.key.replaceFirst(entry.key[0],entry.key[0].toUpperCase()),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Center(
                            child: Text(
                              entry.value.toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
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

/*

itemBuilder: (BuildContext c, int i) {
 
  return AnimationConfiguration.staggeredList(
    position: i,
    delay: Duration(milliseconds: 100),
    child: SlideAnimation(
      duration: Duration(milliseconds: 2500),
      curve: Curves.fastLinearToSlowEaseIn,
      horizontalOffset: 30,
      verticalOffset: 300.0,
      child: FlipAnimation(
        duration: Duration(milliseconds: 3000),
        curve: Curves.fastLinearToSlowEaseIn,
        flipAxis: FlipAxis.y,
        child: Container(
          margin: EdgeInsets.only(bottom: _w / 20),
          height: _w / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Text(
              itemText,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    ),
  );
}, */