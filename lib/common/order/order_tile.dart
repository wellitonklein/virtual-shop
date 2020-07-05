import 'package:flutter/material.dart';
import 'package:virtual_shop/common/order/cancel_order_dialog.dart';
import 'package:virtual_shop/common/order/export_address_dialog.dart';
import 'package:virtual_shop/models/orders/order.dart';
import 'package:virtual_shop/common/order/order_product_tile.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final bool showControls;

  const OrderTile({Key key, this.order, this.showControls = false})
      : super(key: key);
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
              order.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color:
                    order.status == Status.canceled ? Colors.red : primaryColor,
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
          ),
          if (showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CancelOrderDialog(order: order),
                      );
                    },
                    textColor: Colors.red,
                    child: const Text('Cancelar'),
                  ),
                  FlatButton(
                    onPressed: order.back,
                    child: const Text('Recuar'),
                  ),
                  FlatButton(
                    onPressed: order.advance,
                    child: const Text('Avançar'),
                  ),
                  FlatButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            ExportAddressDialog(address: order.address),
                      );
                    },
                    textColor: primaryColor,
                    child: const Text('Endereço'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
