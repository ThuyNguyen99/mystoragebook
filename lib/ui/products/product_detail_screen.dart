import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../shared/dialog_utils.dart';
import './products_manager.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  ProductDetailScreen(
      Product? product, {
        super.key,
      }) {
      if (product == null) {
        this.product = Product(
          id: null,
          title: '',
          author: '',
          description: '',
          imageUrl: '',
        );
      } else {
          this.product = product;
      }
    }

    late final Product product;
  // const ProductDetailScreen(
  //   this.product, {
  //     super.key,
  //   });

  //   final Product product;

    @override 
    Widget build(BuildContext context) {
      return Scaffold(
        appBar:  AppBar(
          centerTitle: true,
          title:  Text(product.title,
        style: TextStyle(color: Colors.white),
        ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Color.fromARGB(66, 0, 0, 0),
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: SizedBox(
                height: 250,
                width:  200,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              Text(
                '${product.title}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  '${product.author}',
                  style: const TextStyle(
                  color: Color.fromARGB(255, 146, 146, 146),
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: Text(
                  product.description,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      );
    }

  findById(String productId) {}
}