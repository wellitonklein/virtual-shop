import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/orders/order.dart';
import 'package:virtual_shop/models/user.dart';

class AdminOrdersManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  final List<Order> _orders = [];
  User userFilter;
  List<Status> statusFilter = [Status.preparing];

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    if (userFilter != null) {
      output = output.where((o) => o.userId == userFilter.id).toList();
    }

    return output.where((o) => statusFilter.contains(o.status)).toList();
  }

  // ignore: avoid_positional_boolean_parameters
  void updateAdmin(bool adminEnabled) {
    _orders.clear();
    _subscription?.cancel();

    if (adminEnabled) {
      _listenToOrders();
    }
  }

  void setStatusFilter({Status status, bool enabled}) {
    if (enabled) {
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }

    notifyListeners();
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen(
      (event) {
        for (final change in event.documentChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              _orders.add(Order.fromDocument(change.document));
              break;
            case DocumentChangeType.modified:
              final modOrder = _orders.firstWhere(
                  (element) => element.orderId == change.document.documentID);
              modOrder.updateFromDocument(change.document);
              break;
            case DocumentChangeType.removed:
              debugPrint('Deu problema sério');
              break;
            default:
          }
        }

        notifyListeners();
      },
    );
  }

  void setUserFilter(User user) {
    userFilter = user;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
