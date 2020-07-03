import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_shop/models/address.dart';
import 'package:virtual_shop/models/cart_manager.dart';
import 'package:virtual_shop/models/cart_product.dart';

enum Status {
  canceled,
  preparing,
  transporting,
  delivered,
}

class Order {
  final Firestore firestore = Firestore.instance;

  String orderId;
  String userId;
  num price;
  List<CartProduct> items;
  Address address;
  Timestamp date;
  Status status;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
        break;
      case Status.preparing:
        return 'Em preparação';
        break;
      case Status.transporting:
        return 'Em transporte';
        break;
      case Status.delivered:
        return 'Entregue';
        break;
      default:
        return '';
    }
  }

  Function() get back {
    return status.index >= Status.transporting.index
        ? () {
            status = Status.values[status.index - 1];
            _updateStatus();
          }
        : null;
  }

  Function() get advance {
    return status.index <= Status.transporting.index
        ? () {
            status = Status.values[status.index + 1];
            _updateStatus();
          }
        : null;
  }

  void cancel() {
    status = Status.canceled;
    _updateStatus();
  }

  Future<void> _updateStatus() async {
    try {
      await firestore
          .collection('orders')
          .document(orderId)
          .updateData({'status': status.index});
    } catch (_) {}
  }

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc.data['status'] as int];
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.documentID;
    price = doc.data['price'] as num;
    userId = doc.data['user_id'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;
    items = (doc.data['items'] as List<dynamic>)
        .map((e) => CartProduct.fromMap(e as Map<String, dynamic>))
        .toList();
    status = Status.values[doc.data['status'] as int];
  }

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData({
      'items': items.map((item) => item.toOrderItemMap()).toList(),
      'price': price,
      'user_id': userId,
      'address': address.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
    });
  }
}
