import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/user_product_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
   // final productsData = Provider.of<Products>(context);
    print('rebuilding');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh:()=> _refreshProducts(context),
                        child: Consumer<Products>(
                          builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, index) => Column(
                                children: [
                                  UserProductItem(
                                    productsData.items[index].title,
                                    productsData.items[index].imageUrl,
                                    productsData.items[index].id,
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                          ),
                        ),
                      )));
  }
}
