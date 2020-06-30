import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_shop/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_shop/models/home_manager.dart';
import 'package:virtual_shop/models/user_manager.dart';
import 'package:virtual_shop/screens/home/components/add_section_widget.dart';
import 'package:virtual_shop/screens/home/components/section_list.dart';
import 'package:virtual_shop/screens/home/components/section_staggered.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 118, 130),
                  Color.fromARGB(255, 253, 181, 168)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                snap: true,
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Sua loja aqui'),
                  centerTitle: true,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                  Consumer2<UserManager, HomeManager>(builder: (
                    _,
                    userManager,
                    homeManager,
                    __,
                  ) {
                    if (userManager.adminEnabled && !homeManager.loading) {
                      if (homeManager.editing) {
                        return PopupMenuButton(
                          onSelected: (e) => e == 'Salvar'
                              ? homeManager.saveEditing()
                              : homeManager.discardEditing(),
                          itemBuilder: (_) => ['Salvar', 'Descartar']
                              .map(
                                (e) => PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: homeManager.enterEditing,
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
              Consumer<HomeManager>(builder: (_, homeManager, __) {
                if (homeManager.loading) {
                  return SliverToBoxAdapter(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }

                final List<Widget> children =
                    homeManager.sections.map<Widget>((section) {
                  switch (section.type) {
                    case 'List':
                      return SectionList(section: section);
                      break;
                    case 'Staggered':
                      return SectionStaggered(section: section);
                      break;
                    default:
                      return SectionStaggered(section: section);
                  }
                }).toList();

                if (homeManager.editing) {
                  children.add(AddSectionWidget());
                }

                return SliverList(
                  delegate: SliverChildListDelegate(children),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
