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

  Future<void> getVetements() async {
    final documentRef = firestore.collection(widget.cin).doc(widget.docId);
    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      if (data.containsKey('vetements')) {
        _vetementsController.text = data['vetements'];
      }
    }
  }

  Future<void> getNutrition() async {
    final documentRef = firestore.collection(widget.cin).doc(widget.docId);
    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      if (data.containsKey('nutrition')) {
        _nutritionController.text = data['nutrition'];
      }
    }
  }
  Future<void> getSante() async {
    final documentRef = firestore.collection(widget.cin).doc(widget.docId);
    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      if (data.containsKey('sante')) {
        _santeController.text = data['sante'];
      }
    }
  }
  Future<void> getDevertissement() async {
    final documentRef = firestore.collection(widget.cin).doc(widget.docId);
    final docSnapshot = await documentRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      if (data.containsKey('devertissement')) {
        _devertissementController.text = data['devertissement'];
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _vetementsController,
                decoration: InputDecoration(labelText: 'Vetements'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vetements';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nutritionController,
                decoration: InputDecoration(labelText: 'Nutrition'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter nutrition';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _santeController,
                decoration: InputDecoration(labelText: 'Sante'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter sante';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _devertissementController,
                decoration: InputDecoration(labelText: 'Devertissement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter devertissement';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final vetements = _vetementsController.text.trim();
                    final nutrition = _nutritionController.text.trim();
                    final sante = _santeController.text.trim();
                    final devertissement = _devertissementController.text.trim();
                    final documentRef =
                        firestore.collection(widget.cin).doc(widget.docId);
                    await documentRef
                        .set({'vetements': vetements}, SetOptions(merge: true));
                    await documentRef
                        .set({'sante': sante}, SetOptions(merge: true));
                    await documentRef
                        .set({'devertissement': devertissement}, SetOptions(merge: true));
                    await documentRef
                        .set({'nutrition': nutrition}, SetOptions(merge: true));
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
