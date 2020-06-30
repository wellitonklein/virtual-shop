import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  final Firestore firestore = Firestore.instance;

  bool editing = false;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final List<Section> _sections = [];
  List<Section> _editingSections = [];
  List<Section> get sections =>
      editing ? [..._editingSections] : [..._sections];

  Future<void> _loadSections() async {
    firestore.collection('home').orderBy('pos').snapshots().listen(
      (snapshot) {
        _sections.clear();

        for (final DocumentSnapshot document in snapshot.documents) {
          _sections.add(Section.fromDocument(document));
        }

        notifyListeners();
      },
    );
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  void enterEditing() {
    editing = true;

    _editingSections = _sections.map((s) => s.clone()).toList();

    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;

    for (final section in _editingSections) {
      valid = section.valid();
    }

    if (!valid) {
      return;
    }

    loading = true;

    int pos = 0;
    for (final section in _editingSections) {
      await section.save(pos);
      pos++;
    }

    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await section.delete();
      }
    }

    editing = false;
    loading = false;
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }
}
