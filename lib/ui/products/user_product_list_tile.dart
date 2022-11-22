import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/product.dart';
import '../../ui/products/products_manager.dart';
import 'edit_product_screen.dart';

class UseProbookListTile extends StatelessWidget {
  final Probook probook;

  const UseProbookListTile(
    this.probook, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(probook.title),
      subtitle: Text(
        DateFormat().add_yMMMd().add_Hm().format(DateTime.now()),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(probook.imageUrl),
      ),
      trailing: SizedBox(
        width: 180,
        child: Row(
          children: <Widget>[
            buildEditButton(context),
            buildDeleteButton(context),
            buildCompletedButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        context.read<ProbooksManager>().deleteProbook(probook.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Probook deleted',
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
          EditProbookScreen.routeName,
          arguments: probook.id,
        );
      },
      color: Theme.of(context).primaryColor,
    );
  }

  Widget buildCompletedButton(BuildContext context) {
    return GridTileBar(
      leading: ValueListenableBuilder<bool>(
        valueListenable: probook.isCompletedListenable,
        builder: (ctx, isCompleted, child) {
          return IconButton(
            icon: Icon(
              isCompleted ? Icons.verified : Icons.verified_outlined,
            ),
            color: Color.fromARGB(255, 0, 253, 59),
            onPressed: () {
              ctx.read<ProbooksManager>().toggleCompletedStatus(probook);
            },
          );
        },
      ),
    );
  }
}
