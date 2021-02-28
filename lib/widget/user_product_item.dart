
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/pages/edit_product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/size_config.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem({this.title, this.imageUrl, this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        leading: AspectRatio(
          aspectRatio: 1.02,
          child: Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(5.0)),
            decoration: BoxDecoration(
              color: kSecondColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Image.asset(imageUrl),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 14.0),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          width: 100.0,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.deepOrangeAccent,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, EditProduct.routeName,
                      arguments: id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: ()  {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Are you sure!?'),
                      content:
                          Text('Do ou want ro remove this item from cart!!?'),
                      actions: [
                        FlatButton(
                          child: Text('No'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              try {
                                Navigator.pop(context);
                                await Provider.of<Products>(context,
                                        listen: false)
                                    .deleteProduct(id);
                              } catch (error) {
                                scaffold.showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Could not delete product!!')),
                                );
                              }
                            }),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
