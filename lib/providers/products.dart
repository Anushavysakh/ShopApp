import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  // var _showFavoritesOnly = false;
   String? authToken;
   String? userId;

  Products(this.authToken, this._items, this.userId,);

  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopapp-e0d5d-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if(extractedData == null){
        return;
      }
      url = 'https://shopapp-e0d5d-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken';
      final favoritesResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoritesResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
            favoriteData == null ? false : favoriteData[prodId] ?? false));
      });

      _items = loadedProducts;
      notifyListeners();

    } catch (error) {
      rethrow;
    }

  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp-e0d5d-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(
        (Uri.parse(url)),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId' : userId
        }),
      );
      print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();

      // _items.insert(0, newProduct); // at the start of the list

    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shopapp-e0d5d-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';

      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("edit  product");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopapp-2602f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
      _items.removeAt(existingProductIndex);
      notifyListeners();
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product');
      }
      existingProduct = null;

      // _items.removeAt(existingProductIndex);
      // notifyListeners();

  }
}
