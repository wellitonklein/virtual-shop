import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  final ImagePicker picker = ImagePicker();

  ImageSourceSheet({Key key, this.onImageSelected}) : super(key: key);

  Future<void> editImage(String path, BuildContext context) async {
    final File croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Editar imagem',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Editar imagem',
        cancelButtonTitle: 'Cancelar',
        doneButtonTitle: 'Concluir',
      ),
    );

    if (croppedFile != null) {
      onImageSelected(croppedFile);
    }
  }

  // ignore: avoid_void_async
  void onOpenCamera(BuildContext context) async {
    final PickedFile file = await picker.getImage(source: ImageSource.camera);
    editImage(file.path, context);
  }

  // ignore: avoid_void_async
  void onOpenGallery(BuildContext context) async {
    final PickedFile file = await picker.getImage(source: ImageSource.gallery);
    editImage(file.path, context);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton(
              onPressed: () => onOpenCamera(context),
              child: const Text('Câmera'),
            ),
            FlatButton(
              onPressed: () => onOpenGallery(context),
              child: const Text('Galeria'),
            ),
          ],
        ),
        onClosing: () {},
      );
    } else if (Platform.isIOS) {
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => onOpenCamera(context),
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => onOpenGallery(context),
            child: const Text('Galeria'),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
