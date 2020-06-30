import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/custom_drawer/custom_drawer_header.dart';
import 'package:virtual_shop/common/custom_drawer/drawer_tile.dart';
import 'package:virtual_shop/models/user_manager.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 203, 236, 241),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              DrawerTile(iconData: Icons.home, title: 'Início', page: 0),
              DrawerTile(iconData: Icons.list, title: 'Produtos', page: 1),
              DrawerTile(
                iconData: Icons.playlist_add,
                title: 'Meus Pedidos',
                page: 2,
              ),
              DrawerTile(iconData: Icons.location_on, title: 'Lojas', page: 3),
              Consumer<UserManager>(
                builder: (_, userManager, __) => !userManager.adminEnabled
                    ? Container()
                    : Column(
                        children: <Widget>[
                          const Divider(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text('Área administrativa'),
                          ),
                          DrawerTile(
                            iconData: Icons.people,
                            title: 'Usuários',
                            page: 4,
                          ),
                          DrawerTile(
                            iconData: Icons.playlist_add_check,
                            title: 'Pedidos',
                            page: 5,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
