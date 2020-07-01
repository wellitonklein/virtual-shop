import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/orders/order.dart';
import 'package:virtual_shop/models/user.dart';

class OrdersManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  User user;
  List<Order> orders = [];

  void updateUser(User user) {
    this.user = user;
    orders.clear();
    _subscription?.cancel();

    if (user != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore
        .collection('orders')
        .where('user_id', isEqualTo: user.id)
        .snapshots()
        .listen(
      (event) {
        orders.clear();

        for (final doc in event.documents) {
          orders.add(Order.fromDocument(doc));
        }

        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
