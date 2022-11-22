import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_grid_tile.dart';
import 'products_manager.dart';
import '../../models/product.dart';

class ProbooksGrid extends StatelessWidget {
  final bool showStars;

  const ProbooksGrid(this.showStars, {super.key});

  @override
  Widget build(BuildContext context) {
    final probooksManager = ProbooksManager();
    // Đọc ra danh sách các product sẽ được hiển thị từ ProductsManager
    final probooks = context.select<ProbooksManager, List<Probook>>(
        (probooksManager) =>
            showStars ? probooksManager.starItems : probooksManager.items);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: probooks.length,
      itemBuilder: (ctx, i) => ProbookGridTile(probooks[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
