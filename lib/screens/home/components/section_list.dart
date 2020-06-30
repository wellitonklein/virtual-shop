import 'package:flutter/material.dart';
import 'package:virtual_shop/models/home_manager.dart';
import 'package:virtual_shop/models/section.dart';
import 'package:virtual_shop/screens/home/components/add_tile_widget.dart';
import 'package:virtual_shop/screens/home/components/item_tile.dart';
import 'package:virtual_shop/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {
  final Section section;

  const SectionList({Key key, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeManager homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(),
            SizedBox(
              height: 150,
              child: Consumer<Section>(
                builder: (_, section, __) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    if (index < section.items.length) {
                      return ItemTile(item: section.items[index]);
                    } else {
                      return AddTileWidget();
                    }
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 4),
                  itemCount: !homeManager.editing
                      ? section.items.length
                      : section.items.length + 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
