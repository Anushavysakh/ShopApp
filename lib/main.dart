import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', [], ''),
            update: (context, auth, previousProducts) {
              return Products(
                  auth.token,
                  previousProducts == '' ? [] : previousProducts!.items,
                  auth.userId
              );
            }),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders([], null, ''),
          update: (ctx, auth, previousOrders) {
            return Orders(
                previousOrders == ''  ? [] : previousOrders!.orders,auth.userId,auth.userId.toString() );
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) =>
            MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                debugShowCheckedModeBanner: false,
                home: auth.isAuth ? ProductOverviewScreen() :
                FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                        ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(), ),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductScreen.routeName: (context) => UserProductScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    ),);
  }
}
