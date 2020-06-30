import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/models/product_manager.dart';
import 'package:virtual_shop/screens/products/edit_product/components/images_form.dart';
import 'package:virtual_shop/screens/products/edit_product/components/sizes_form.dart';

class ProductEditScreen extends StatelessWidget {
  ProductEditScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Color _primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            editing ? 'Editando ${product.name}' : 'Criando Produto',
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(product: product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                      ),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (value) =>
                          value.length < 6 ? 'Título muito curto' : null,
                      onSaved: (value) => product.name = value,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A partir de',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(hintText: 'Descrição'),
                      maxLines: null,
                      validator: (value) =>
                          value.length < 10 ? 'Descrição muito curta' : null,
                      onSaved: (value) => product.description = value,
                    ),
                    SizesForm(product: product),
                    const SizedBox(height: 20),
                    Consumer<Product>(
                      builder: (_, product, __) => SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: product.loading
                              ? null
                              : () async {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    await product.save();

                                    context
                                        .read<ProductManager>()
                                        .update(product);

                                    Navigator.of(context).pop();
                                  }
                                },
                          disabledColor: _primaryColor.withAlpha(100),
                          color: _primaryColor,
                          textColor: Colors.white,
                          child: product.loading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Salvar',
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
