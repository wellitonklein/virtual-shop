import 'package:flutter/material.dart';
import 'package:virtual_shop/common/custom_icon_button.dart';
import 'package:virtual_shop/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  const EditItemSize({
    Key key,
    this.size,
    this.onRemove,
    this.onMoveUp,
    this.onMoveDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
            validator: (value) => value.isEmpty ? 'Inválido' : null,
            onChanged: (value) => size.name = value,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            validator: (value) =>
                int.tryParse(value) == null ? 'Inválido' : null,
            onChanged: (value) => size.stock = int.tryParse(value),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$ ',
            ),
            validator: (value) =>
                num.tryParse(value) == null ? 'Inválido' : null,
            onChanged: (value) => size.price = num.tryParse(value),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),
        CustomIconButton(
          iconData: Icons.close,
          color: Colors.red,
          onTap: onRemove,
        ),
      ],
    );
  }
}
