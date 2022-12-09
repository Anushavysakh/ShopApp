import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/user_product_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = "/user-products";

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    /*final productsData = Provider.of<Products>(context);*/
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
          onRefresh: () => _refreshProduct(context),
          child: Consumer<Products>(
            builder: (context,productsData, _)=>
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: productsData.items.length,
                    itemBuilder: (_, index) => Column(
                      children: [
                        UserProductItem(
                          title: productsData.items[index].title,
                          id: productsData.items[index].id,
                          imageUrl: productsData.items[index].imageUrl,
                        ),
                        Divider()
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}