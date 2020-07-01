import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_shop/common/empty_card.dart';
import 'package:virtual_shop/common/login_card.dart';
import 'package:virtual_shop/models/orders/orders_manager.dart';
import 'package:virtual_shop/screens/orders/components/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(builder: (_, ordersManager, __) {
        if (ordersManager.user == null) {
          return LoginCard();
        }

        if (ordersManager.orders.isEmpty) {
          return EmptyCard(
            title: 'Nenhuma compra encontrada!',
            iconData: Icons.border_clear,
          );
        }

        return ListView.builder(
          itemCount: ordersManager.orders.length,
          itemBuilder: (_, index) {
            final order = ordersManager.orders.reversed.toList()[index];
            return OrderTile(order: order);
          },
        );
      }),
    );
  }
}
