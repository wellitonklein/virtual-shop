import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/models/page_manager.dart';

class DrawerTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final int page;

  const DrawerTile({Key key, this.iconData, this.title, this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int _currPage = context.watch<PageManager>().page;
    final Color _primaryColor = Theme.of(context).primaryColor;

    Color _getCurrColor() {
      return _currPage == page ? _primaryColor : Colors.grey[700];
    }

    return InkWell(
      onTap: () => context.read<PageManager>().setpage(page),
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData,
                size: 32,
                color: _getCurrColor(),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: _getCurrColor(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
