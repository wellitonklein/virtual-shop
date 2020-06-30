import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_shop/models/section.dart';
import 'package:virtual_shop/models/section_item.dart';
import 'package:virtual_shop/screens/products/edit_product/components/image_source_sheet.dart';
import 'package:provider/provider.dart';

class AddTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Section section = context.watch<Section>();

    void onImageSelected(File file) {
      section.addItem(SectionItem(image: file));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => Platform.isAndroid
            ? showModalBottomSheet(
                context: context,
                builder: (context) =>
                    ImageSourceSheet(onImageSelected: onImageSelected),
              )
            : showCupertinoModalPopup(
                context: context,
                builder: (context) =>
                    ImageSourceSheet(onImageSelected: onImageSelected),
              ),
        child: Container(
          color: Colors.white.withAlpha(30),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
