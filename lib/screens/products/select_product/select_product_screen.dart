import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/product_manager.dart';

class SelectProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) => ListView.builder(
          itemCount: productManager.allProducts.length,
          itemBuilder: (_, index) {
            final product = productManager.allProducts[index];

            return ListTile(
              leading: Image.network(product.images.first),
              title: Text(product.name),
              subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
              onTap: () => Navigator.of(context).pop(product),
            );
          },
        ),
      ),
    );
  }
}
