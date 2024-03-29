import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:virtual_shop/models/address.dart';

class ExportAddressDialog extends StatelessWidget {
  final Address address;

  ExportAddressDialog({Key key, this.address}) : super(key: key);

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Text(
            '${address.street}, ${address.number} ${address.complement}\n'
            '${address.district}\n'
            '${address.city} - ${address.state}\n'
            '${address.zipCode}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final file = await screenshotController.capture();
            await GallerySaver.saveImage(file.path);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Exportar'),
        )
      ],
    );
  }
}
