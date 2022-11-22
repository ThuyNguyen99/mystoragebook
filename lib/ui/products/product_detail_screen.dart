import 'package:flutter/material.dart';

import '../../models/product.dart';

class ProbookDetailScreen extends StatelessWidget {
  static const routeName = '/probook-detail';

  ProbookDetailScreen(
    Probook? probook, {
    super.key,
  }) {
    if (probook == null) {
      this.probook = Probook(
        id: null,
        title: '',
        author: '',
        description: '',
        imageUrl: '',
      );
    } else {
      this.probook = probook;
    }
  }

  late final Probook probook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          probook.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
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
                width: 200,
                child: Image.network(
                  probook.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${probook.title}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${probook.author}',
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
                probook.description,
                textAlign: TextAlign.justify,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  findById(String probookId) {}
}
