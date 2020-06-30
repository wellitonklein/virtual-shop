import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/price_card.dart';
import 'package:virtual_shop/models/cart_manager.dart';
import 'package:virtual_shop/screens/cart/components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map(
                      (cartProduct) => CartTile(cartProduct: cartProduct),
                    )
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: !cartManager.isCartValid
                    ? null
                    : () => Navigator.of(context).pushNamed('/address'),
              ),
            ],
          );
        },
      ),
    );
  }
}
