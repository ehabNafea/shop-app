import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/widget/product_item.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem ordersData;
  OrderItemWidget({this.ordersData});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.ordersData.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.ordersData.dateTime),),
            trailing: IconButton(icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more, size: 30.0,), onPressed: (){
              setState(() {
                _expanded = !_expanded;
              });
            }),
          ),
          if(_expanded) Container(
            height: min(widget.ordersData.products.length * 20.0 + 100, 180),
            child: ListView(
             children: widget.ordersData.products.map((pro) => Row(
               children: [
                 Expanded(
                   child: ListTile(
                     leading: Image.asset(pro.imageUrl, width: getProportionateScreenWidth(60),),
                     title: Padding(
                       padding:  EdgeInsets.only(bottom: 5.0),
                       child: Text(pro.title),
                     ),
                     subtitle: Text.rich(
                       TextSpan(
                         text: '\$${pro.price.toString()} ',
                         style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                         children: [
                           TextSpan(
                             text: '  x${pro.quantity.toString()}',
                             style: TextStyle(color: kTextColor)
                           )
                         ],
                       ),
                     ),
                   ),
                 ),
                 // Text(pro.title)
               ],
             ),
             ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
