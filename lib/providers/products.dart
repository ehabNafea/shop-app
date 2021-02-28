import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   images: [
    //     "assets/images/products/ps4_console_white_1.png",
    //     "assets/images/products/ps4_console_white_2.png",
    //     "assets/images/products/ps4_console_white_3.png",
    //     "assets/images/products/ps4_console_white_4.png",
    //   ],
    //   title: "Wireless Controller for PS4™",
    //   price: 64.99,
    //   description: description,
    // ),
    // Product(
    //   id: 'p2',
    //   images: [
    //     "assets/images/products/Image Popular Product 2.png",
    //   ],
    //   title: "Nike Sport White - Man Pant",
    //   price: 50.5,
    //   description: description,
    // ),
    // Product(
    //   id: 'p3',
    //   images: [
    //     "assets/images/products/glap.png",
    //   ],
    //   title: "Gloves XC Omega - Polygon",
    //   price: 36.55,
    //   description: description,
    // ),
    // Product(
    //   id: 'p4',
    //   images: [
    //     "assets/images/products/wireless headset.png",
    //   ],
    //   title: "Logitech Head",
    //   price: 20.20,
    //   description: description,
    // ),
  ];

  final String token;
  final String userId;
  Products(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProducts([bool filter = false ]) async {
    final filterByUser = filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://shop-app-adbb6-default-rtdb.firebaseio.com/products.json?auth=$token&$filterByUser';
    try{
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if(extractData == null) {
        return;
      }
      final favUrl = 'https://shop-app-adbb6-default-rtdb.firebaseio.com/favoriteProducts/$userId.json?auth=$token';
      final responseFav = await http.get(favUrl);
      final favData = json.decode(responseFav.body);
      final List<Product> loadingData = [];
      extractData.forEach((prodId, prodData) {
        loadingData.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavourite: favData == null ? false : favData[prodId] ?? false,
          ),
        );
      });
      _items = loadingData;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-adbb6-default-rtdb.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

 Future<void> updateProduct(String productID, Product newProduct) async {
    final indexPro = _items.indexWhere((pro) => pro.id == productID);
    if(indexPro >= 0 ) {
      final url =
          'https://shop-app-adbb6-default-rtdb.firebaseio.com/products/$productID.json?auth=$token';
      await http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavourite': newProduct.isFavourite
      }));
      _items[indexPro] = newProduct;
      notifyListeners();
    }

  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-adbb6-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    final prodIndex = _items.indexWhere((pro) => pro.id == id);
    var existingProduct = _items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners();
    final response =  await http.delete(url);
    if(response.statusCode >= 400){
      _items.insert(prodIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: 'Could not Delete Product!!');
    }
    existingProduct = null;
  }

  List<Product> get favouriteItems {
    return _items.where((pro) => pro.isFavourite).toList();
  }

  Product findProductById(String id) {
    return items.firstWhere((pro) => pro.id == id);
  }
}
