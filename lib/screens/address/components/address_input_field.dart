import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_shop/models/address.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/cart_manager.dart';

class AddressInputField extends StatelessWidget {
  final Address address;

  const AddressInputField({Key key, this.address}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color _primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    String emptyValidator(String value) =>
        value.isNotEmpty ? null : 'Campo obrigatório';

    if (address.zipCode != null && cartManager.deliveryPrice == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil',
            ),
            validator: emptyValidator,
            onSaved: (value) => address.street = value,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Número',
                    hintText: '123',
                  ),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (value) => address.number = value,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (value) => address.complement = value,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.district,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Centro',
            ),
            validator: emptyValidator,
            onSaved: (value) => address.district = value,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: address.city,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'Maringá',
                  ),
                  validator: emptyValidator,
                  onSaved: (value) => address.city = value,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'PR',
                    counterText: '',
                  ),
                  maxLength: 2,
                  validator: (e) {
                    if (e.isEmpty) {
                      return 'Campo obrigatório';
                    } else if (e.length != 2) {
                      return 'Inválido';
                    }

                    return null;
                  },
                  onSaved: (value) => address.state = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RaisedButton(
            color: _primaryColor,
            disabledColor: _primaryColor.withAlpha(100),
            textColor: Colors.white,
            onPressed: cartManager.loading
                ? null
                : () async {
                    if (Form.of(context).validate()) {
                      Form.of(context).save();

                      try {
                        await context.read<CartManager>().setAddress(address);
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
            child: !cartManager.loading
                ? const Text('Calcular Frete')
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(_primaryColor),
                  ),
          ),
        ],
      );
    } else if (address.zipCode != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          '${address.street}, ${address.number}\n${address.district}\n'
          '${address.city} - ${address.state}',
        ),
      );
    } else {
      return Container();
    }
  }
}
