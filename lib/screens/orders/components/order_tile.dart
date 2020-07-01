import 'package:flutter/material.dart';
import 'package:virtual_shop/models/orders/order.dart';
import 'package:virtual_shop/screens/orders/components/order_product_tile.dart';

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({Key key, this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              'Em transporte',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: primaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items
                .map(
                  (e) => OrderProductTile(cartProduct: e),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
