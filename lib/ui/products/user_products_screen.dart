import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './user_product_list_tile.dart';
import './products_manager.dart';
import '../shared/app_drawer.dart';
import 'edit_product_screen.dart';

class UseProbooksScreen extends StatelessWidget {
  static const routeName = '/user-probooks';
  const UseProbooksScreen({super.key});

  Future<void> _refreshProbooks(BuildContext context) async {
    await context.read<ProbooksManager>().fetchProbooks(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Book',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          buildAddButton(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProbooks(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _refreshProbooks(context),
            child: buildUserProbookListView(),
          );
        },
      ),
    );
  }

  Widget buildUserProbookListView() {
    return Consumer<ProbooksManager>(
      builder: (ctx, probooksManager, child) {
        return ListView.builder(
          itemCount: probooksManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UseProbookListTile(
                probooksManager.items[i],
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
          EditProbookScreen.routeName,
        );
      },
    );
  }
}
