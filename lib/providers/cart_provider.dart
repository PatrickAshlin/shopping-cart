import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];

  List<Product> get cart => _cart;

  void addToCart(Product product) {
    // Check if the product already exists in the cart
    int index = _cart.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      _cart[index].quantity++; // Increase quantity
    } else {
      _cart.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    int index = _cart.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      _cart[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    int index = _cart.indexWhere((item) => item.id == product.id);
    if (index != -1 && _cart[index].quantity > 1) {
      _cart[index].quantity--;
    } else {
      _cart.removeAt(index); // Remove if quantity reaches 0
    }
    notifyListeners();
  }

  double get totalPrice {
    return _cart.fold(0, (sum, item) => sum + item.discountedPrice);
  }
}
