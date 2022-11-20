import 'package:flutter/material.dart';
import 'package:myshop/ui/products/product_grid_tile.dart';
import '../../models/product.dart';
import '../../ui/products/products_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'edit_product_screen.dart';

class UseProductListTile extends StatelessWidget {
  final Product product;

  const UseProductListTile(
    this.product, {
      super.key,
    });
    @override 
    Widget build(BuildContext context) {
      return ListTile(
        title: Text(product.title),
        subtitle: Text(
          DateFormat().add_yMMMd().add_Hm().format(DateTime.now()),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              buildEditButton(context),
              buildDeleteButton(context),
              //buildDroButton(context),
            ],
          ),
        ),
      );
    }
    Widget buildDeleteButton(BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          context.read<ProductsManager>().deleteProduct(product.id!);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'Product deleted',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        color: Theme.of(context).errorColor,
      );
    }
    Widget buildEditButton(BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).pushNamed(
            EditProductScreen.routeName,
            arguments: product.id,
          );
        },
        color: Theme.of(context).primaryColor,
      );
    }
   
}