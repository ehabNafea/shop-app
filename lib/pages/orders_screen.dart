import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widget/custom_drawer.dart';
import 'package:shop_app/widget/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'orders';
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrderData(),
        builder: (ctx, dataSnapshot) {
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else {
            if (dataSnapshot.error != null) {
              return Center(child: Text('An Error occurred'),);
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                return ListView.builder(
                  itemCount: orderData.items.length,
                  itemBuilder: (ctx, i) => OrderItemWidget(ordersData: orderData.items[i],),
                );
              });
            }
          }
        },
      ),
    );
  }
}
