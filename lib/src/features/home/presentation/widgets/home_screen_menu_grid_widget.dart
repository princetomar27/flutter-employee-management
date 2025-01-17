import 'package:flutter/material.dart';

import 'home_screen_menu_card_item_widget.dart';

class HomeScreenMenuGridWidget extends StatelessWidget {
  final List<HomeScreenMenuCardItem> cardItems;

  const HomeScreenMenuGridWidget({Key? key, required this.cardItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columnCount = 2;
        if (width > 600) {
          columnCount = 3;
        } else if (width > 400) {
          columnCount = 2;
        } else {
          columnCount = 3;
        }

        return GridView.count(
          crossAxisCount: columnCount,
          childAspectRatio: 0.8,
          children: cardItems,
        );
      },
    );
  }
}
