import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/custom_drawer/custom_drawer.dart';

import 'package:virtual_shop/models/page_manager.dart';
import 'package:virtual_shop/models/user_manager.dart';
import 'package:virtual_shop/screens/admin_users/admin_users.screen.dart';
import 'package:virtual_shop/screens/home/home_screen.dart';
import 'package:virtual_shop/screens/orders/orders_screen.dart';
import 'package:virtual_shop/screens/products/products_screen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) => PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomeScreen(),
            ProductsScreen(),
            OrdersScreen(),
            Scaffold(
              drawer: CustomDrawer(),
              appBar: AppBar(
                title: const Text('Home 4'),
                centerTitle: true,
              ),
            ),
            if (userManager.adminEnabled) ...[
              AdminUsersScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Pedidos'),
                  centerTitle: true,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
