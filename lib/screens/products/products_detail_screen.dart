import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/cart_manager.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/models/user_manager.dart';
import 'package:virtual_shop/screens/products/components/size_widget.dart';

class ProductsDetailScreen extends StatelessWidget {
  final Product product;

  const ProductsDetailScreen({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(product.name),
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) => !userManager.adminEnabled
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed(
                        '/product-edit',
                        arguments: product,
                      ),
                    ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) => NetworkImage(url)).toList(),
                autoplay: false,
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: _primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${product.basePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes
                        .map((size) => SizeWidget(itemSize: size))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  if (product.hasStock)
                    Consumer2<UserManager, Product>(
                      builder: (_, userManger, product, __) => SizedBox(
                        height: 44,
                        child: RaisedButton(
                          color: _primaryColor,
                          textColor: Colors.white,
                          onPressed: product.selectedSize == null
                              ? null
                              : () {
                                  if (userManger.isLoggedIn) {
                                    context
                                        .read<CartManager>()
                                        .addToCart(product);
                                    Navigator.of(context).pushNamed('/cart');
                                  } else {
                                    Navigator.of(context).pushNamed('/login');
                                  }
                                },
                          child: Text(
                            userManger.isLoggedIn
                                ? 'Adicionar no Carrinho'
                                : 'Entre para Comprar',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
