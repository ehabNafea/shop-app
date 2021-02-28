
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/details_screen.dart';
import 'package:shop_app/providers/cart.dart';

import '../constants.dart';
import '../size_config.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productID;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;

  const CartItem(
      {this.id,
      this.productID,
      this.price,
      this.title,
      this.imageUrl,
      this.quantity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, DetailsScreen.routeName, arguments: id),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Dismissible(
          key: ValueKey(id),
          background: Container(
            color: Color(0xFFFFE6E6),
            child: Icon(
              Icons.delete,
              color: Color(0xFFFF4848),
              size: 40,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.0),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Are you sure!?'),
                content: Text('Do ou want ro remove this item from cart!!?'),
                actions: [
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(
                      context,
                      false,
                    ),
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () => Navigator.pop(
                      context,
                      true,
                    ),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            Provider.of<Cart>(context, listen: false).removeItem(productID);
          },
          child: Row(
            children: [
              Container(
                width: getProportionateScreenWidth(88),
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(15.0)),
                child: AspectRatio(
                  aspectRatio: .88,
                  child: Image.asset(
                    imageUrl,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text.rich(
                      TextSpan(
                        text: '\$${price.toString()} ',
                        style: TextStyle(
                            color: kPrimaryColor, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: ' x$quantity',
                            style: TextStyle(color: kTextColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
