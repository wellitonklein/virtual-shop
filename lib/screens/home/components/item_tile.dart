import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_shop/models/home_manager.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/models/product_manager.dart';
import 'package:virtual_shop/models/section.dart';
import 'package:virtual_shop/models/section_item.dart';
import 'package:provider/provider.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;

  const ItemTile({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final HomeManager homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        if (item.productId != null && item.productId.isNotEmpty) {
          final product =
              context.read<ProductManager>().findProductById(item.productId);

          if (product != null) {
            Navigator.of(context)
                .pushNamed('/product-detail', arguments: product);
          }
        }
      },
      onLongPress: !homeManager.editing
          ? null
          : () => showDialog(
                context: context,
                builder: (_) {
                  final Product product = context
                      .read<ProductManager>()
                      .findProductById(item.productId);

                  return AlertDialog(
                    title: const Text('Editar produto'),
                    content: product == null
                        ? null
                        : ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.network(product.images.first,
                                fit: BoxFit.cover),
                            title: Text(product.name),
                            subtitle: Text(
                                'R\$ ${product.basePrice.toStringAsFixed(2)}'),
                          ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          context.read<Section>().removeItem(item);
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.red,
                        child: const Text('Excluir'),
                      ),
                      FlatButton(
                        onPressed: () async {
                          if (product != null) {
                            item.productId = null;
                          } else {
                            final Product product = await Navigator.of(context)
                                .pushNamed('/select-product') as Product;

                            item.productId = product?.id;
                          }

                          Navigator.of(context).pop();
                        },
                        child:
                            Text(product != null ? 'Desvincular' : 'Vincular'),
                      )
                    ],
                  );
                },
              ),
      child: AspectRatio(
        aspectRatio: 1,
        child: item.image is String
            ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.image as String,
                fit: BoxFit.cover,
              )
            : Image.file(item.image as File, fit: BoxFit.cover),
      ),
    );
  }
}
