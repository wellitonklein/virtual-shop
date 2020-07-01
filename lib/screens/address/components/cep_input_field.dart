import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/custom_icon_button.dart';
import 'package:virtual_shop/models/address.dart';
import 'package:virtual_shop/models/cart_manager.dart';

class CepInputField extends StatefulWidget {
  final Address address;

  const CepInputField({Key key, this.address}) : super(key: key);

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CartManager cartManager = context.watch<CartManager>();
    final Color _primaryColor = Theme.of(context).primaryColor;

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
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
            onPressed: cartManager.loading
                ? null
                : () async {
                    if (Form.of(context).validate()) {
                      try {
                        await context
                            .read<CartManager>()
                            .getAddress(cepController.text);
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
            color: _primaryColor,
            disabledColor: _primaryColor.withAlpha(100),
            textColor: Colors.white,
            child: !cartManager.loading
                ? const Text('Buscar CEP')
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(_primaryColor),
                  ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: _primaryColor,
              size: 20,
              onTap: () => context.read<CartManager>().removeAddress(),
            ),
          ],
        ),
      );
    }
  }
}
