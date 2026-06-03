import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/watch_model.dart';
import '../models/order_model.dart';
import '../data/static_data.dart';

class CartProvider with ChangeNotifier {
  final List<CartItemModel> _items = [];
  final List<OrderModel> _orders = [];

  List<CartItemModel> get items => List.unmodifiable(_items);
  List<OrderModel> get orders => [...StaticData.sampleOrders, ..._orders];
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool isInCart(String watchId) {
    return _items.any((item) => item.watch.id == watchId);
  }

  void addToCart(WatchModel watch) {
    if (!watch.inStock) return;
    
    final existingIndex = _items.indexWhere((item) => item.watch.id == watch.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItemModel(watch: watch));
    }
    notifyListeners();
  }

  void removeFromCart(String watchId) {
    _items.removeWhere((item) => item.watch.id == watchId);
    notifyListeners();
  }

  void updateQuantity(String watchId, int quantity) {
    if (quantity < 1) {
      removeFromCart(watchId);
      return;
    }
    
    final index = _items.indexWhere((item) => item.watch.id == watchId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<OrderModel> placeOrder(String shippingAddress, String paymentMethod) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_items),
      totalAmount: totalAmount,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.confirmed,
      orderDate: DateTime.now(),
    );
    
    _orders.add(order);
    clearCart();
    
    return order;
  }
}