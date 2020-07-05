import 'package:flutter/material.dart';
import 'package:virtual_shop/models/orders/order.dart';

class CancelOrderDialog extends StatelessWidget {
  final Order order;

  const CancelOrderDialog({Key key, this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedId} ?'),
      content: const Text('Esta ação não poderá ser desfeita!'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          textColor: Theme.of(context).primaryColor,
          child: const Text('Voltar'),
        ),
        FlatButton(
          onPressed: () {
            order.cancel();
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Cancelar Pedido'),
        ),
      ],
    );
  }
}
