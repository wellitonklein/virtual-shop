import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_shop/models/address.dart';
import 'package:virtual_shop/models/cart_manager.dart';
import 'package:virtual_shop/models/cart_product.dart';

class Order {
  final Firestore firestore = Firestore.instance;

  String orderId;
  String userId;
  num price;
  List<CartProduct> items;
  Address address;
  Timestamp date;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.documentID;
    price = doc.data['price'] as num;
    userId = doc.data['user_id'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;
    items = (doc.data['items'] as List<dynamic>)
        .map((e) => CartProduct.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
  }

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData({
      'items': items.map((item) => item.toOrderItemMap()).toList(),
      'price': price,
      'user_id': userId,
      'address': address.toMap(),
    });
  }
}
