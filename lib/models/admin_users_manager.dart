import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/user.dart';
import 'package:virtual_shop/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  List<User> _users = [];
  StreamSubscription _subscription;

  List<User> get users => [..._users];
  List<String> get names => _users.map((user) => user.name).toList();

  void updateUser(UserManager userManager) {
    _subscription?.cancel();

    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      _users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _subscription =
        firestore.collection('users').snapshots().listen((snapshot) {
      _users = snapshot.documents.map((doc) => User.fromDocument(doc)).toList();
      _users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
