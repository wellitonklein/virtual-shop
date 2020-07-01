import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/cart_manager.dart';
import 'package:virtual_shop/models/orders/order.dart';
import 'package:virtual_shop/models/product.dart';

class CheckoutManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;

  CartManager cartManager;

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) => this.cartManager = cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> checkout({Function onStockFail, Function onSuccess}) async {
    loading = true;

    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading = false;
      return;
    }

    // TODO: PROCESSAR PAGAMENTO

    final orderId = await _getOrderId();
    final order = Order.fromCartManager(cartManager);

    order.orderId = orderId.toString();
    await order.save();
    await cartManager.clear();

    onSuccess(order);

    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(ref);
        final orderId = doc.data['current'] as int;

        await transaction.update(ref, {'current': orderId + 1});

        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock() async {
    // 1. Ler todos os estoques
    // 2. Decremento localmente os estoques
    // 3. Salvar os estoques no firebase

    return firestore.runTransaction((transaction) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc = await transaction.get(
            firestore.document('products/${cartProduct.productId}'),
          );
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);

        if ((size.stock - cartProduct.quantity) < 0) {
          productsWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
          '${productsWithoutStock.length} produtos sem estoque',
        );
      }

      for (final product in productsToUpdate) {
        transaction.update(
          firestore.document('products/${product.id}'),
          {'sizes': product.exportSizeList()},
        );
      }
    });
  }
}
