
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './user_product_list_tile.dart';
import './products_manager.dart';
import '../shared/app_drawer.dart';
import 'edit_product_screen.dart';

class UseProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UseProductsScreen ({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await context.read<ProductsManager>().fetchProducts(true);
  }
  
  @override 
  Widget build(BuildContext context) {
    //final productManager = ProductsManager();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Book',
        style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          buildAddButton(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: buildUserProductListView(),
          );
        },
      ),
    );
  }
  Widget buildUserProductListView() {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        return ListView.builder(
          itemCount: productsManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UseProductListTile(
                productsManager.items[i],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
  Widget buildAddButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
        );
      },
    );
  }
}