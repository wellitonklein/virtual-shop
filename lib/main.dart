import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/admin_users_manager.dart';
import 'package:virtual_shop/models/cart_manager.dart';
import 'package:virtual_shop/models/home_manager.dart';
import 'package:virtual_shop/models/orders/admin_orders_manager.dart';
import 'package:virtual_shop/models/orders/order.dart';
import 'package:virtual_shop/models/orders/orders_manager.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/models/product_manager.dart';
import 'package:virtual_shop/models/user_manager.dart';
import 'package:virtual_shop/screens/address/address_screen.dart';
import 'package:virtual_shop/screens/base/base_screen.dart';
import 'package:virtual_shop/screens/cart/cart_screen.dart';
import 'package:virtual_shop/screens/checkout/checkout_screen.dart';
import 'package:virtual_shop/screens/confirmation/confirmation_screen.dart';
import 'package:virtual_shop/screens/login/login_screen.dart';
import 'package:virtual_shop/screens/products/edit_product/product_edit_screen.dart';
import 'package:virtual_shop/screens/products/products_detail_screen.dart';
import 'package:virtual_shop/screens/products/select_product/select_product_screen.dart';
import 'package:virtual_shop/screens/signup/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager.adminEnabled),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) =>
              adminOrdersManager..updateAdmin(userManager.adminEnabled),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Loja do Fokushima',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
              break;
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
              break;
            case '/product-detail':
              return MaterialPageRoute(
                builder: (_) => ProductsDetailScreen(
                  product: settings.arguments as Product,
                ),
              );
              break;
            case '/product-edit':
              return MaterialPageRoute(
                builder: (_) => ProductEditScreen(
                  settings.arguments as Product,
                ),
              );
              break;
            case '/select-product':
              return MaterialPageRoute(builder: (_) => SelectProductScreen());
              break;
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
                settings: settings,
              );
              break;
            case '/address':
              return MaterialPageRoute(builder: (_) => AddressScreen());
              break;
            case '/checkout':
              return MaterialPageRoute(builder: (_) => CheckoutScreen());
              break;
            case '/confirmation':
              return MaterialPageRoute(
                builder: (_) =>
                    ConfirmationScreen(order: settings.arguments as Order),
              );
              break;
            case '/base':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
