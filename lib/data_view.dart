//verifier citoyen existe si oui afficher ses données sinon faire rien
// importi display_data_docs.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/add_data.dart';
import 'package:ins_app/modify_data.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'display_data_docs.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
  final String cin;

  DataScreen({required this.cin});
}

class _DataScreenState extends State<DataScreen> {
  String collectionName = '';
  List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _otpTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
     if (widget.cin != null && widget.cin.isNotEmpty) {
    _otpTextController.text = widget.cin;
    collectionName = widget.cin;
  }
  }

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
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0x00ffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            "Verification",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 20,
              color: Color(0xff000000),
            ),
          ),
        ),
        body: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                    child: Text(
                      "Enter CIN",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: OtpTextField(
                        handleControllers: (controllers) => _otpTextController,
                        numberOfFields: 8,
                        showFieldAsBox: false,
                        fieldWidth: 40,
                        filled: true,
                        fillColor: Color(0x00000000),
                        enabledBorderColor: Color(0xff898a8e),
                        focusedBorderColor: Color(0xff3a57e8),
                        borderWidth: 2,
                        margin: EdgeInsets.all(0),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        obscureText: false,
                        borderRadius: BorderRadius.circular(4.0),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Color(0xff000000),
                        ),
                        onCodeChanged: (String value) {
                          setState(() {
                            collectionName = _otpTextController.text + value;
                          });
                        },
                        onSubmit: (String value) {
                          setState(() {
                            collectionName = _otpTextController.text + value;
                          });
                        }),
                  ),
                  SizedBox(height: 40.0),
                  MaterialButton(
                    onPressed: () async {
                      final snapshot = await FirebaseFirestore.instance
                          .collection(collectionName)
                          .get();

                      setState(() {
                        documents = snapshot.docs;
                      });
                    },
                    color: Color(0xff3a57e8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Verify",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffffffff),
                    height: 50,
                    minWidth: 150,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        final document = documents[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          color: Color(0xff3a57e8),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            title: Center(
                              child: Text(
                                'Table ${document.id}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DataDocDisplay(
                                        collectionName: collectionName,
                                        documentID: document.id)),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
            )));
  }
}
