import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/home_manager.dart';
import 'package:virtual_shop/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeManager homeManager = context.watch<HomeManager>();

    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () => homeManager.addSection(Section(type: 'List')),
            textColor: Colors.white,
            child: const Text('Adicionar Lista'),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () => homeManager.addSection(Section(type: 'Staggered')),
            textColor: Colors.white,
            child: const Text('Adicionar Grade'),
          ),
        ),
      ],
    );
  }
}
