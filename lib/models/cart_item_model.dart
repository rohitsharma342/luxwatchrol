import 'watch_model.dart';

class CartItemModel {
  final WatchModel watch;
  int quantity;

  CartItemModel({
    required this.watch,
    this.quantity = 1,
  });

  double get totalPrice => watch.price * quantity;

  CartItemModel copyWith({
    WatchModel? watch,
    int? quantity,
  }) {
    return CartItemModel(
      watch: watch ?? this.watch,
      quantity: quantity ?? this.quantity,
    );
  }
}