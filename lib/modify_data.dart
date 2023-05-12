import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModifyData extends StatefulWidget {
  final String cin;
  final String docId;

  ModifyData({required this.cin, required this.docId});
  @override
  _ModifyDataState createState() => _ModifyDataState();
}

class _ModifyDataState extends State<ModifyData> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _vetementsController;
  late TextEditingController _nutritionController;
  late TextEditingController _santeController;
  late TextEditingController _devertissementController;

  @override
  void initState() {
    super.initState();
    _vetementsController = TextEditingController();
    _nutritionController = TextEditingController();
    _santeController = TextEditingController();
    _devertissementController = TextEditingController();
    getVetements();
    getNutrition();
    getSante();
    getDevertissement();
  }

  Future<void>? getVetements() async {
    final documentRef = firestore.collection(widget.cin).doc(widget.docId);
    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      if (data.containsKey('vetements')) {
        _vetementsController.text = data['vetements'].toString();
      }
    }
  }

  Future<void>? getNutrition() async {
    final documentRef = firestore.collection(widget.cin).doc(widget.docId);
    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      if (data.containsKey('nutrition')) {
        _nutritionController.text = data['nutrition'].toString();
      }
    }
  }

  Future<void>? getSante() async {
    final documentRef = firestore.collection(widget.cin).doc(widget.docId);
    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      if (data.containsKey('sante')) {
        _santeController.text = data['sante'].toString();
      }
    }
  }

  Future<void>? getDevertissement() async {
    final documentRef = firestore.collection(widget.cin).doc(widget.docId);
    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      if (data.containsKey('devertissement')) {
        _devertissementController.text = data['devertissement'].toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Modify Data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _vetementsController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      labelText: "Vetements",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff9e9e9e),
                      ),
                      filled: true,
                      fillColor: Color(0x00f2f2f3),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter vetements';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nutritionController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      labelText: "Nutrition",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff9e9e9e),
                      ),
                      filled: true,
                      fillColor: Color(0x00f2f2f3),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter nutrition';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _santeController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      labelText: "Sante",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff9e9e9e),
                      ),
                      filled: true,
                      fillColor: Color(0x00f2f2f3),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter sante';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _devertissementController,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff9e9e9e), width: 1),
                      ),
                      labelText: "Devertissement",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff9e9e9e),
                      ),
                      filled: true,
                      fillColor: Color(0x00f2f2f3),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter devertissement';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.0),
                  MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final vetements =
                            int.tryParse(_vetementsController.text.trim()) ?? 0;
                        final nutrition =
                            int.tryParse(_nutritionController.text.trim()) ?? 0;
                        final sante =
                            int.tryParse(_santeController.text.trim()) ?? 0;
                        final devertissement = int.tryParse(
                                _devertissementController.text.trim()) ??
                            0;
                        final documentRef =
                            firestore.collection(widget.cin).doc(widget.docId);
                        await documentRef.set({'vetements': vetements.toInt()},
                            SetOptions(merge: true));
                        await documentRef.set(
                            {'sante': sante.toInt()}, SetOptions(merge: true));
                        await documentRef.set(
                            {'devertissement': devertissement.toInt()},
                            SetOptions(merge: true));
                        await documentRef.set({'nutrition': nutrition.toInt()},
                            SetOptions(merge: true));
                        Navigator.pop(context);
                      }
                    },
                    color: Color(0x2d3a57e8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Ajouter/Modifier",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xff3a57e8),
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
