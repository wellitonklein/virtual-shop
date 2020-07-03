import 'package:flutter/material.dart';
import 'package:virtual_shop/models/orders/order.dart';
import 'package:virtual_shop/common/order/order_product_tile.dart';

class ConfirmationScreen extends StatelessWidget {
  final Order order;

  const ConfirmationScreen({Key key, this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido Confirmado'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      order.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'R\$ ${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: order.items
                    .map((e) => OrderProductTile(cartProduct: e))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
