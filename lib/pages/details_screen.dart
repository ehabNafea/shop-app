import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widget/default_btn.dart';
import 'package:shop_app/widget/rounded_btn.dart';

class DetailsScreen extends StatefulWidget  {
  static const routeName = 'product-detail';
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false)
        .findProductById(productID);
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: getProportionateScreenWidth(250.0),
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 0.9,
                  child: Image.asset(
                    product.imageUrl,
                  ),
                ),
              ),
              Positioned(
                top: 15.0,
                left: 15.0,
                child: RoundedBtn(
                  icon: Icons.arrow_back_ios_rounded,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          RoundedContainer(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    product.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(product.description),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RoundedContainer(
                  color: Color(0xFFF5F6F9),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'Price : \$${product.price.toString()}',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(20.0),
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              RoundedBtn(
                                onTap: () {},
                                icon: Icons.remove,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              RoundedBtn(
                                onTap: () {},
                                icon: Icons.add,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RoundedContainer(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: DefaultBtn(
                            onTap: () {
                              Provider.of<Cart>(context, listen: false).addItem(productID, product.title, product.imageUrl, product.price);
                            },
                            text: 'Add to Cart',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  const RoundedContainer({this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
              offset: Offset(2, 0),
            ),
          ]),
      child: child,
    );
  }
}




