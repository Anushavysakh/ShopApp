import 'package:flutter/material.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import 'package:shop_app/widgets/ordered_item.dart';

class OrderScreen extends StatelessWidget {
   OrderScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  //var _isLoading = false;


  @override
  Widget build(BuildContext context) {
    print('building orders');
   // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error occured'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index) =>
                        OrderItem(orderData.orders[index]),
                  ),
                );
              }
            }));
  }
}
