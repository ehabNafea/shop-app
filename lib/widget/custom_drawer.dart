

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/pages/orders_screen.dart';
import 'package:shop_app/pages/user_products_screen.dart';
import 'package:shop_app/providers/auth.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Ehab'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: Text('Shop', style: kDrawerTextStyle,),
            leading: Icon(Icons.shop,),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          Divider(),
          ListTile(
            title: Text('Orders', style: kDrawerTextStyle,),
            leading: Icon(Icons.payment,),
            onTap: () => Navigator.pushReplacementNamed(context, OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            title: Text('Mange Products', style: kDrawerTextStyle,),
            leading: Icon(Icons.payment,),
            onTap: () => Navigator.pushReplacementNamed(context, UserProductsScreen.routeName),
          ),
          Divider(),
          ListTile(
            title: Text('Logout', style: kDrawerTextStyle,),
            leading: Icon(Icons.exit_to_app,),
            onTap: () => Provider.of<Auth>(context, listen: false).logout(),
          ),
        ],
      ),
    );
  }
}
