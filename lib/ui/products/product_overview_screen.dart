
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
//import 'package:myshop/ui/cart/cart_screen.dart';
import 'package:myshop/ui/products/products_manager.dart';
import 'package:provider/provider.dart';
import 'products_grid.dart';
import '../shared/app_drawer.dart';
//import '../cart/cart_manager.dart';
import 'top_right_badge.dart';
enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override 
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  List<String> imageList = [
    "https://i.pinimg.com/736x/6b/91/90/6b91908898d9201678f8c321e087252f.jpg",
    "https://i.pinimg.com/736x/6b/91/90/6b91908898d9201678f8c321e087252f.jpg",
    "https://i.pinimg.com/736x/6b/91/90/6b91908898d9201678f8c321e087252f.jpg",
    "https://i.pinimg.com/736x/6b/91/90/6b91908898d9201678f8c321e087252f.jpg"
  ];
  late Future<void> _fetchProducts;

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Book',
        style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          buildProductFilterMenu(),
          //buildShoppingCartIcon(),
          
        ],
        
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20.0),
          
          child: CarouselSlider(items: imageList.map((e) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              
              fit: StackFit.expand,
              children: [
                Image.network(e,
                height: 200,
                width: 100,
                fit: BoxFit.cover,
                ),
                
              ],
            ),
          )).toList(), options: CarouselOptions(
            
            autoPlay: true,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            height: 180,
          )),
          
        ),
       Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 200.0),
              child: ListTile(
                leading: const Icon(Icons.home, color:  Color.fromARGB(255, 16, 139, 241)),
                
                title: const Text('Home',
                style: TextStyle(color: Color.fromARGB(255, 16, 139, 241)),),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                
              ),
              
            ),
          const Divider(),
        ],
       ),
      //  Column(
      //   children: <Widget>[
      //     Container(
      //       margin: const EdgeInsets.only(top: 200.0, left: 200),
      //         child: ListTile(
                
      //         ),
              
      //       ),
      //     const Divider(),
      //   ],
      //  ),
        Container(
          margin: const EdgeInsets.only(top: 280.0),
          child: FutureBuilder(
            future: _fetchProducts,
            
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ValueListenableBuilder<bool>(
                  valueListenable: _showOnlyFavorites,
                  builder: (context, onlyFavorites, child) {
                    return ProductsGrid(onlyFavorites);
                  }
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            
          ),
        ),
        ],
      ),
    );
  }

  // Widget buildSlideField(BuildContext context) {
  //   return Column(
  //     children: [
        
  //       Container(
  //         margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
  //         decoration: BoxDecoration(
  //           color: Colors.grey,
  //           borderRadius: BorderRadius.all(Radius.circular(10)),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.all(Radius.circular(10)),
  //           child: AspectRatio(
  //             aspectRatio: 16/9,
  //             child: Container(
  //               color: Colors.grey,
  //             ),
              
  //           ),
  //         ),
  //       ),
        
  //     ],
  //   );
  // }

  // Widget buildShoppingCartIcon() {
  //   return Consumer<CartManager>(
  //     builder: (ctx, cartManager, child) {
  //       return TopRightBadge(
  //         data: cartManager.productCount,
  //         child: IconButton(
  //           icon: const Icon(
  //             Icons.shopping_cart,
  //           ),
  //           onPressed: () {
  //             Navigator.of(ctx).pushNamed(CartScreen.routeName);
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
  
  Widget buildProductFilterMenu(){
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.favorites) {
          _showOnlyFavorites.value = true;
        } else {
          _showOnlyFavorites.value = false;
        }
      },
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Icon(
            Icons.star
          ),
        ),
        // const PopupMenuItem(
        //   value: FilterOptions.all,
        //   child: Text('Book All'),
        // ),
      ],
    );
  }
}