import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    print('product rebuilds');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
            leading: Consumer<Product>(
                builder: (context, product, _) => IconButton(
                    color: Colors.deepOrange,
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    },
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border))),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Added item to cart',
                      textAlign: TextAlign.center,
                    ),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              color: Colors.deepOrange,
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            )),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
