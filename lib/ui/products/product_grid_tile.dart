import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import './product_detail_screen.dart';
import 'products_manager.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(
    this.product, {
    super.key,
  });

  final Product product;

  @override 
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        footer: buildGridFooterBar(context),
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
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
        product.title,
        textAlign: TextAlign.center,
      ),
      leading: ValueListenableBuilder<bool>(
        valueListenable: product.isFavoriteListenable,
        builder: (ctx, isFavorite, child) {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
            ),
            color: Color.fromARGB(255, 255, 251, 13),
            onPressed: () {
              ctx.read<ProductsManager>().toggleFavoriteStatus(product);
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
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
         },
        color: Color.fromARGB(255, 58, 199, 255),
      ),
    );
  }
}