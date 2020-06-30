import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/item_size.dart';
import 'package:virtual_shop/models/product.dart';

class SizeWidget extends StatelessWidget {
  final ItemSize itemSize;

  const SizeWidget({Key key, this.itemSize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final _selected = itemSize == product.selectedSize;

    Color _color;

    if (!itemSize.hasStock) {
      _color = Colors.red.withAlpha(50);
    } else if (_selected) {
      _color = Theme.of(context).primaryColor;
    } else {
      _color = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        if (itemSize.hasStock) {
          product.selectedSize = itemSize;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _color,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: _color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                itemSize.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$ ${itemSize.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: _color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
