import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/price_card.dart';
import 'package:virtual_shop/models/cart_manager.dart';
import 'package:virtual_shop/screens/address/components/address_card.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __) => PriceCard(
              buttonText: 'Continuar para o Pagamento',
              onPressed: !cartManager.isAddressValid
                  ? null
                  : () => Navigator.of(context).pushNamed('/checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
