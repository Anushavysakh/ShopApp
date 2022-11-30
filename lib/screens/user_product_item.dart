import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl ;

   UserProductItem(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),trailing: Container(
       width: 110,
        child: Row(
          children: [
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
            }, icon: Icon(Icons.edit),color: Theme.of(context).primaryColor),
            IconButton(onPressed: () {

            }, icon: Icon(Icons.delete),color: Theme.of(context).errorColor,),

          ],
        ),
      ),
    );
  }
}
