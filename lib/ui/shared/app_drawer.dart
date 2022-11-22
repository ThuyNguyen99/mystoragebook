import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../products/user_products_screen.dart';
import '../auth/auth_manager.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text(
              'Menu',
              style: TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.manage_accounts_rounded),
            title: const Text('My Book'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UseProbooksScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}
