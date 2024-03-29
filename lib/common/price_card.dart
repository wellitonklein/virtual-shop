import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/cart_manager.dart';

class PriceCard extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PriceCard({
    Key key,
    this.buttonText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final productPrice = cartManager.productsPrice;
    final deliveryPrice = cartManager.deliveryPrice;
    final totalPrice = cartManager.totalPrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Resumo do Pedido',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Subtotal'),
                Text('R\$ ${productPrice.toStringAsFixed(2)}')
              ],
            ),
            const Divider(),
            if (deliveryPrice != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Entrega'),
                  Text('R\$ ${deliveryPrice.toStringAsFixed(2)}')
                ],
              ),
              const Divider(),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'R\$ ${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RaisedButton(
              onPressed: onPressed,
              disabledColor: Theme.of(context).primaryColor.withAlpha(100),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
