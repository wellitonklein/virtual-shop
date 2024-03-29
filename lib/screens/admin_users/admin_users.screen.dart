import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_shop/models/admin_users_manager.dart';
import 'package:virtual_shop/models/orders/admin_orders_manager.dart';
import 'package:virtual_shop/models/page_manager.dart';
import 'package:virtual_shop/models/user.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(builder: (_, adminUsersManager, __) {
        return AlphabetListScrollView(
          itemBuilder: (_, index) {
            final User user = adminUsersManager.users[index];
            return ListTile(
              title: Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                user.email,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                context.read<AdminOrdersManager>().setUserFilter(user);
                context.read<PageManager>().setpage(5);
              },
            );
          },
          indexedHeight: (_) => 80,
          strList: adminUsersManager.names,
          showPreview: true,
          highlightTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        );
      }),
    );
  }
}
