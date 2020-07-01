import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:virtual_shop/models/address.dart';
import 'package:virtual_shop/models/cart_product.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/models/user.dart';
import 'package:virtual_shop/services/cepaberto_service.dart';

class CartManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;

  User user;
  num productsPrice = 0.0;
  num deliveryPrice;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  Address _address;
  Address get address => _address;
  set address(Address value) {
    _address = value;
    deliveryPrice = null;
    notifyListeners();
  }

  List<CartProduct> _items = [];
  List<CartProduct> get items => [..._items];

  void updateUser(User user) {
    this.user = user;
    productsPrice = 0.0;
    _items.clear();
    removeAddress();

    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
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

  Future<void> _loadUserAddress() async {
    if (user.address != null &&
        await calculateDelivery(
          user.address.lat,
          user.address.long,
        )) {
      address = user.address;
    }
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

  Future<void> clear() async {
    for (final cartProduct in items) {
      await user.cartReference.document(cartProduct.id).delete();
    }
    _items.clear();
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

  bool get isAddressValid => address != null && deliveryPrice != null;

  // ADDRESS

  Future<void> getAddress(String cep) async {
    loading = true;

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
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error(e);
    }
  }

  void removeAddress() => address = null;

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;

    if (await calculateDelivery(address.lat, address.long)) {
      user.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();
    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;
    final maxkm = doc.data['maxkm'] as num;
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;

    double dist =
        await Geolocator().distanceBetween(latStore, longStore, lat, long);

    dist /= 100.0;

    if (dist > maxkm) {
      return false;
    }

    deliveryPrice = base + dist * km;

    return true;
  }
}
