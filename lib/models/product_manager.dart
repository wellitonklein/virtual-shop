import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final Firestore firestore = Firestore.instance;
  List<Product> _allProducts = [];
  String _search = '';

  List<Product> get allProducts => [..._allProducts];
  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(
        allProducts.where(
          (p) => p.name.toLowerCase().contains(search.toLowerCase()),
        ),
      );
    }

    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts = await firestore
        .collection('products')
        .where('deleted', isEqualTo: false)
        .getDocuments();

    _allProducts = snapProducts.documents
        .map(
          (d) => Product.fromDocument(d),
        )
        .toList();

    notifyListeners();
  }

  Product findProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void update(Product product) {
    _allProducts.removeWhere((p) => p.id == product.id);
    _allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    _allProducts.removeWhere((p) => p.id == product.id);

    notifyListeners();
  }
}
