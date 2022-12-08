import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String? authToken;
  final String userId;

    Orders(this._orders, this.authToken, this.userId,);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shopapp-e0d5d-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity']))
            .toList(),
      ));
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://shopapp-e0d5d-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    var response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': DateTime.now().toIso8601String(),
        'products': cartProduct
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList()
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProduct,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
