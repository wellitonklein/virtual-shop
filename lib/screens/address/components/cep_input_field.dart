import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/cart_manager.dart';

class CepInputField extends StatelessWidget {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color _primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: cepController,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'CEP',
            hintText: '12.345-678',
          ),
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            CepInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'Campo obrigatório';
            } else if (value.length != 10) {
              return 'CEP inválido';
            }

            return null;
          },
        ),
        RaisedButton(
          onPressed: () {
            if (Form.of(context).validate()) {
              context.read<CartManager>().getAddress(cepController.text);
            }
          },
          color: _primaryColor,
          disabledColor: _primaryColor.withAlpha(100),
          textColor: Colors.white,
          child: const Text('Buscar CEP'),
        ),
      ],
    );
  }
}
