import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:virtual_shop/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_shop/common/custom_icon_button.dart';
import 'package:virtual_shop/common/empty_card.dart';
import 'package:virtual_shop/models/orders/admin_orders_manager.dart';
import 'package:virtual_shop/common/order/order_tile.dart';
import 'package:virtual_shop/models/orders/order.dart';

class AdminOrdersScreen extends StatefulWidget {
  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(builder: (_, adminOrdersManager, __) {
        final filteredOrders = adminOrdersManager.filteredOrders;

        return SlidingUpPanel(
          controller: panelController,
          body: Column(
            children: <Widget>[
              if (adminOrdersManager.userFilter != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Pedidos de ${adminOrdersManager.userFilter.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CustomIconButton(
                        iconData: Icons.close,
                        color: Colors.white,
                        onTap: () => adminOrdersManager.setUserFilter(null),
                      ),
                    ],
                  ),
                ),
              if (filteredOrders.isEmpty)
                Expanded(
                  child: EmptyCard(
                    title: 'Nenhuma venda realizada!',
                    iconData: Icons.border_clear,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (_, index) {
                      final order = filteredOrders.reversed.toList()[index];
                      return OrderTile(
                        order: order,
                        showControls: true,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 120),
            ],
          ),
          minHeight: 40,
          maxHeight: 240,
          panel: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => panelController.isPanelClosed
                    ? panelController.open()
                    : panelController.close(),
                child: Container(
                  height: 40,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Text(
                    'Filtros',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: Status.values.map((s) {
                    return CheckboxListTile(
                      title: Text(Order.getStatusText(s)),
                      dense: true,
                      activeColor: Theme.of(context).primaryColor,
                      value: adminOrdersManager.statusFilter.contains(s),
                      onChanged: (v) {
                        adminOrdersManager.setStatusFilter(
                          status: s,
                          enabled: v,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
