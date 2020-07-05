import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/item_size.dart';
import 'package:virtual_shop/models/product.dart';

class CartProduct extends ChangeNotifier {
  String id;
  String productId;
  int quantity;
  String size;

  num fixedPrice;

  Product _product;
  Product get product => _product;
  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  CartProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['product_id'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;

    _getProduct();
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    productId = document.data['product_id'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;

    _getProduct();
  }

  Map<String, dynamic> toCartItemMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,
    };
  }

  final Firestore firestore = Firestore.instance;

  void _getProduct() {
    firestore.document('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
        notifyListeners();
      },
    );
  }

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
    if (product != null && product.deleted) return false;

    final size = itemSize;

    if (size == null) {
      return false;
    }

    return size.stock >= quantity;
  }
}
