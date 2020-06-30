import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/item_size.dart';
import 'package:virtual_shop/models/product.dart';

class CartProduct extends ChangeNotifier {
  Product product;

  String id;
  String productId;
  int quantity;
  String size;

  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    productId = document.data['product_id'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;

    firestore.document('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
        notifyListeners();
      },
    );
  }

  Map<String, dynamic> toCartItemMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  final Firestore firestore = Firestore.instance;

  ItemSize get itemSize {
    if (product != null) {
      return product.findSize(size);
    } else {
      return null;
    }
  }

  num get unitPrice {
    if (product != null) {
      return itemSize?.price ?? 0;
    } else {
      return 0;
    }
  }

  num get totalPrice => unitPrice * quantity;

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    final size = itemSize;

    if (size == null) {
      return false;
    }

    return size.stock >= quantity;
  }
}
