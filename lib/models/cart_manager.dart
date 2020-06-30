import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/address.dart';
import 'package:virtual_shop/models/cart_product.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/models/user.dart';
import 'package:virtual_shop/models/user_manager.dart';
import 'package:virtual_shop/services/cepaberto_service.dart';

class CartManager extends ChangeNotifier {
  User user;
  num productsPrice = 0.0;

  Address _address;
  Address get address => _address;
  set address(Address value) {
    _address = value;
    notifyListeners();
  }

  List<CartProduct> _items = [];
  List<CartProduct> get items => [..._items];

  void updateUser(UserManager userManager) {
    user = userManager.user;
    _items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    try {
      final QuerySnapshot cartSnap = await user.cartReference.getDocuments();
      _items = cartSnap.documents
          .map(
            (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdate),
          )
          .toList();
    } catch (_) {}
  }

  void addToCart(Product product) {
    try {
      final e = _items.firstWhere((e) => e.stackable(product));
      e.increment();
    } catch (_) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdate);
      _items.add(cartProduct);
      user.cartReference.add(cartProduct.toCartItemMap()).then((doc) {
        cartProduct.id = doc.documentID;
        _onItemUpdate();
      });
    }
  }

  void removeOfCart(CartProduct cartProduct) {
    _items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdate);

    notifyListeners();
  }

  void _onItemUpdate() {
    productsPrice = 0.0;

    for (int i = 0; i < items.length; i++) {
      final CartProduct cartProduct = items[i];

      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    user.cartReference
        .document(cartProduct.id)
        .updateData(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) {
        return false;
      }
    }

    return true;
  }

  // ADDRESS

  Future<void> getAddress(String cep) async {
    final CepAbertoService cepAbertoService = CepAbertoService();

    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if (cepAbertoAddress != null) {
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
