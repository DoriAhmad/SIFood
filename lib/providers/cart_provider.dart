import 'package:flutter/material.dart';

class CartModel {
  final String name;
  final int menuId;
  final int price; // Harga satuan
  int quantity;

  CartModel({
    required this.name,
    required this.menuId,
    required this.price,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  List<CartModel> _cart = [];
  List<CartModel> get cart => _cart;

  int _totalItems = 0;
  int get total => _totalItems;

  // Menghitung total harga berdasarkan harga dan kuantitas
  double calculateTotalHarga() {
    double totalPrice = 0;
    for (var item in _cart) {
      totalPrice += item.price * item.quantity; // Harga x Kuantitas
    }
    return totalPrice;
  }

  // Fungsi untuk mereset keranjang
  void resetCart() {
    _cart.clear();
    _totalItems = 0;
    print("Keranjang telah direset");
    notifyListeners(); // Memberi tahu bahwa state telah berubah
  }

  // Fungsi untuk menambah atau mengurangi item di keranjang
  void addRemove(String name, int menuId, int price, bool isAdd) {
    if (_cart.any((element) => menuId == element.menuId)) {
      var index = _cart.indexWhere((element) => element.menuId == menuId);

      if (isAdd) {
        _cart[index].quantity += 1;
        _totalItems += 1;
      } else {
        if (_cart[index].quantity > 0) {
          _cart[index].quantity -= 1;
          _totalItems -= 1;
        }

        if (_cart[index].quantity == 0) {
          _cart.removeAt(index);
        }
      }
    } else {
      // Jika isAdd == true, tambahkan item baru ke keranjang
      if (isAdd) {
        _cart.add(
            CartModel(name: name, menuId: menuId, price: price, quantity: 1));
        _totalItems += 1;
      }
    }

    notifyListeners(); // Memberi tahu bahwa state telah berubah
  }
}
