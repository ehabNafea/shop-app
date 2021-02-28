import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/constants.dart';
import 'package:shop_app/pages/cart_screen.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widget/badge.dart';
import 'package:shop_app/widget/custom_drawer.dart';
import 'package:shop_app/widget/product_grid.dart';

enum FilterOption { Favourite, All }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showFavouriteOnly = false;
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Products>(context, listen: false).fetchProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError(
      (error) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error'),
          content: Text('Something went wrong'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _isLoading = false;
                });
              },
              child: Text('Okay'),
            ),
          ],
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tokoto'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favourite) {
                  showFavouriteOnly = true;
                } else {
                  showFavouriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourite'),
                value: FilterOption.Favourite,
              ),
              PopupMenuItem(
                child: Text('All Product'),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.cartAmount().toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFav: showFavouriteOnly),
    );
  }
}
