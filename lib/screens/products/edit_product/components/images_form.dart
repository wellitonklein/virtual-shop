import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/product.dart';
import 'package:virtual_shop/screens/products/edit_product/components/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  const ImagesForm({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images) =>
          images.isEmpty ? 'Insira ao menos uma imagem' : null,
      onSaved: (value) => product.newImages = value,
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value
                    .map<Widget>(
                      (image) => Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          if (image is String)
                            Image.network(image, fit: BoxFit.cover)
                          else
                            Image.file(image as File, fit: BoxFit.cover),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              color: Colors.red,
                              onPressed: () {
                                state.value.remove(image);
                                state.didChange(state.value);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList()
                      ..add(
                        Material(
                          color: Colors.grey[100],
                          child: IconButton(
                            icon: Icon(Icons.add_a_photo),
                            color: Theme.of(context).primaryColor,
                            iconSize: 50,
                            onPressed: () {
                              if (Platform.isAndroid) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected,
                                  ),
                                );
                              } else if (Platform.isIOS) {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                autoplay: false,
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
