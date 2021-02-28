import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/details_screen.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, DetailsScreen.routeName,
              arguments: product.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(15.0)),
                  decoration: BoxDecoration(
                    color: kSecondColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Image.asset(product.imageUrl),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                product.title,
                style: TextStyle(
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.0,
        ),
        Row(
          children: [
            Text(
              '\$${product.price.toString()}',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18.0),
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer<Product>(
                    builder: (ctx, product, child) => GestureDetector(
                      onTap: () {
                        product.toggleFavouriteProduct(auth.token, auth.userId);
                      },
                      child: Icon(
                        product.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Color(0xFFFF4848),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 7.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      cart.addItem(
                        product.id,
                        product.title,
                        product.imageUrl,
                        product.price,
                      );
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added item to cart'),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(label: 'UNDO', onPressed: (){
                            cart.removeSingleItem(product.id);
                          },),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
