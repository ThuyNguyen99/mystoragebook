import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import './product_detail_screen.dart';
import 'products_manager.dart';

class ProbookGridTile extends StatelessWidget {
  const ProbookGridTile(
    this.probook, {
    super.key,
  });

  final Probook probook;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        footer: buildGridFooterBar(context),
        child: GestureDetector(
          child: Image.network(
            probook.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildGridFooterBar(BuildContext context) {
    return GridTileBar(
      backgroundColor: Color.fromARGB(136, 38, 38, 38),
      title: Text(
        probook.title,
        textAlign: TextAlign.center,
      ),
      leading: ValueListenableBuilder<bool>(
        valueListenable: probook.isStarListenable,
        builder: (ctx, isStar, child) {
          return IconButton(
            icon: Icon(
              isStar ? Icons.star : Icons.star_border,
            ),
            color: Color.fromARGB(255, 255, 251, 13),
            onPressed: () {
              ctx.read<ProbooksManager>().toggleStarStatus(probook);
            },
          );
        },
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.remove_red_eye,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            ProbookDetailScreen.routeName,
            arguments: probook.id,
          );
        },
        color: Color.fromARGB(255, 58, 199, 255),
      ),
    );
  }
}
