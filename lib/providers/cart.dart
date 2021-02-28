import 'package:flutter/foundation.dart';

class CartItemData {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItemData({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItemData> _items = {};

  Map<String, CartItemData> get items {
    return {..._items};
  }

  double totalPrice() {
    var total = 0.0;
    _items.forEach((key, product) {
      total += product.price * product.quantity;
    });
    return total;
  }

  int cartAmount() {
    var total = 0;
    _items.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void addItem(String productID, String title, String imageUrl, double price) {
    if (_items.containsKey(productID)) {
      _items.update(
        productID,
        (existingCartItem) => CartItemData(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productID,
        () => CartItemData(
            id: productID,
            title: title,
            price: price,
            imageUrl: imageUrl,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItemData(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          quantity: existingCartItem.quantity -1,
        ),
      );
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }
}
