import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {
  final bool  showFavs;

  const ProductGrid({super.key, required this.showFavs});

  @override
  Widget build(BuildContext context) {
    final productsData =Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items ;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemCount: products.length,
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
          //  create: (context) => products[i] ,
            value: products[i],
            child: ProductItems()) );
  }
}