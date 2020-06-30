import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/models/product_manager.dart';
import 'package:virtual_shop/models/user_manager.dart';
import 'package:virtual_shop/screens/products/components/product_list_tile.dart';
import 'package:virtual_shop/screens/products/components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) => (productManager.search.isEmpty)
              ? const Text('Produtos')
              : LayoutBuilder(
                  builder: (_, constraints) => GestureDetector(
                    onTap: () => _searchProduct(
                      context: context,
                      productManager: productManager,
                    ),
                    child: Container(
                      width: constraints.biggest.width,
                      child: Text(
                        productManager.search,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
        ),
        actions: <Widget>[
          Consumer<ProductManager>(
            builder: (_, productManager, __) => (productManager.search.isEmpty)
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchProduct(
                      context: context,
                      productManager: productManager,
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => productManager.search = '',
                  ),
          ),
          Consumer<UserManager>(
            builder: (_, usermanager, __) {
              if (usermanager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/product-edit'),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final List<Product> _filteredProducts =
              productManager.filteredProducts;

          return ListView.builder(
            padding: const EdgeInsets.all(4),
            itemCount: _filteredProducts.length,
            itemBuilder: (_, index) {
              return ProductListTile(
                product: _filteredProducts[index],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).pushNamed('/cart'),
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

Future<void> _searchProduct({
  BuildContext context,
  ProductManager productManager,
}) async {
  final search = await showDialog<String>(
    context: context,
    builder: (_) => SearchDialog(initialText: productManager.search),
  );

  if (search != null) {
    productManager.search = search;
  }
}
