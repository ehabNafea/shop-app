import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widget/cart_item.dart';
import 'package:shop_app/widget/default_btn.dart';

class CartScreen extends StatefulWidget {
  static const routeName = 'cart';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Column(
          children: [
            Text(
              'Your Cart',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              '${cart.items.length.toString()} items',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (ctx, i) => CartItem(
          productID: cart.items.keys.toList()[i],
          id: cart.items.values.toList()[i].id,
          title: cart.items.values.toList()[i].title,
          imageUrl: cart.items.values.toList()[i].imageUrl,
          price: cart.items.values.toList()[i].price,
          quantity: cart.items.values.toList()[i].quantity,
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFDADADA).withOpacity(0.3),
              offset: Offset(0, -15),
              blurRadius: 20.0,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Total :\n',
                    children: [
                      TextSpan(
                        text: '\$${cart.totalPrice().toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(190),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                    onPressed: () async {
                      if(cart.totalPrice() > 0) {
                        setState(() {
                          _isLoading = true;
                        });
                        try{
                          await Provider.of<Orders>(context, listen: false).addItem(cart.items.values.toList(), cart.totalPrice());
                          setState(() {
                            _isLoading = false;
                          });
                          cart.clearCart();
                        }catch (error){
                         await showDialog(context: context, builder: (context) => AlertDialog(
                             content: Text('Failed'),
                            actions: [FlatButton(onPressed: () => Navigator.pop(context), child: Text('Okay'))],
                          ),);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: _isLoading ? CircularProgressIndicator() : Text('Order Now', style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: Colors.white,
                    ),),
                    color: _isLoading ? Colors.white : Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
