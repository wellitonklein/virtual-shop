import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:virtual_shop/models/home_manager.dart';
import 'package:virtual_shop/models/section.dart';
import 'package:virtual_shop/screens/home/components/add_tile_widget.dart';
import 'package:virtual_shop/screens/home/components/item_tile.dart';
import 'package:virtual_shop/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;

  const SectionStaggered({Key key, this.section}) : super(key: key);
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
            Consumer<Section>(
              builder: (_, section, __) => StaggeredGridView.countBuilder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                crossAxisCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: !homeManager.editing
                    ? section.items.length
                    : section.items.length + 1,
                itemBuilder: (_, index) => index < section.items.length
                    ? ItemTile(item: section.items[index])
                    : AddTileWidget(),
                staggeredTileBuilder: (index) => StaggeredTile.count(
                  2,
                  index.isEven ? 2 : 1,
                ),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
