import 'package:flutter/material.dart';
import 'package:virtual_shop/common/custom_icon_button.dart';
import 'package:virtual_shop/models/item_size.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/screens/products/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Product product;

  const SizesForm({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes.isEmpty) {
          return 'Insira um tamanho';
        } else {
          return null;
        }
      },
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ItemSize());
                    state.didChange(state.value);
                  },
                ),
              ],
            ),
            Column(
              children: state.value
                  .map(
                    (size) => EditItemSize(
                      key: ObjectKey(size),
                      size: size,
                      onRemove: () {
                        state.value.remove(size);
                        state.didChange(state.value);
                      },
                      onMoveDown: size == state.value.last
                          ? null
                          : () {
                              final int index = state.value.indexOf(size);
                              state.value.remove(size);
                              state.value.insert(index + 1, size);
                              state.didChange(state.value);
                            },
                      onMoveUp: size == state.value.first
                          ? null
                          : () {
                              final int index = state.value.indexOf(size);
                              state.value.remove(size);
                              state.value.insert(index - 1, size);
                              state.didChange(state.value);
                            },
                    ),
                  )
                  .toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
