import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final List<CartItemData> products;
  final double amount;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.products,
      @required this.amount,
      this.dateTime});
}

class Orders with ChangeNotifier {
  final String token;
  final String userId;
Orders(this.token, this.userId ,this._items);

  List<OrderItem> _items = [];
  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> addItem(List<CartItemData> products, double total) async {
    final url =
        'https://shop-app-adbb6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': products
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'imageUrl': cp.imageUrl,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList(),
          }));
      _items.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: products,
            dateTime: timeStamp),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchOrderData() async {
    final url =
        'https://shop-app-adbb6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(url);
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if(extractData == null){
      return;
    }
    final List<OrderItem> loadingData = [];
    extractData.forEach((orderID, orderData) {
      loadingData.add(
        OrderItem(
          id: orderID,
          products: (orderData['products'] as List<dynamic>)
              .map((pro) => CartItemData(
                    id: pro['id'],
                    title: pro['title'],
                    price: pro['price'],
                    imageUrl: pro['imageUrl'],
                    quantity: pro['quantity'],
                  ))
              .toList(),
          amount: orderData['amount'],
          dateTime: DateTime.parse(
            orderData['dateTime'],
          ),
        ),
      );
    });
    _items = loadingData.reversed.toList();
    notifyListeners();
  }
}
