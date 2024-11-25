import 'package:flutter/material.dart';
import '../../models/cart.dart';
import '../../services/cart_service.dart';

class CartManager with ChangeNotifier {
  Cart? _cart;
  List<Cart> _carts = [];

  final CartService _cartService = CartService();

  Future<Cart?> fetchCart(String id) async {
    print(id);
    _cart = await _cartService.fetchCart(id);
    print(_cart);
    notifyListeners();
    return _cart;
  }

  Future<void> fetchAllCarts() async {
    _carts = await _cartService.fetchAllCarts();
    notifyListeners();
  }

  Future<void> fetchCartsByUser(String userid) async {
    _carts = await _cartService.fetchCartsByUser(userid);
    notifyListeners();
  }

  Future<void> fetchCartsByStore(String storeid) async {
    _carts = await _cartService.fetchCartsByStore(storeid);
    notifyListeners();
  }

  Future<void> fetchCartsByUserIdAndStoreId(
      String userid, String storeid) async {
    _carts = await _cartService.fetchCartsByUserIdAndStoreId(userid, storeid);
    notifyListeners();
  }

  Future<void> fetchCartsByOrderId(String orderid) async {
    _carts = await _cartService.fetchCartsByOrderId(orderid);
    notifyListeners();
  }

  int get cartCount {
    return _carts.length;
  }

  Future<String> addCart(Cart cart) async {
    try {
      final newCart = await _cartService.addCart(cart);
      if (newCart != null) {
        _carts.add(newCart);
        notifyListeners();
        return 'Cart added successfully';
      } else {
        return 'Failed to add cart';
      }
    } catch (error) {
      return 'Failed to add cart: $error';
    }
  }

  Cart? get cart {
    return _cart;
  }

  List<Cart> get carts {
    return [..._carts];
  }

  Future<bool> updateCart(Cart cart) async {
    final updated = await _cartService.updateCart(cart);
    if (updated) {
      final index = _carts.indexWhere((c) => c.id == cart.id);
      if (index != -1) {
        _carts[index] = cart;
        notifyListeners();
      }
    }
    return updated;
  }

  Future<bool> deleteCart(String id) async {
    final success = await _cartService.deleteCart(id);
    if (success) {
      _carts.removeWhere((cart) => cart.id == id);
      notifyListeners();
    }
    return success;
  }
}
