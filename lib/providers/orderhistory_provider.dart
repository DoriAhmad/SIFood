import 'package:flutter/material.dart';

class OrderHistoryProvider with ChangeNotifier {
  // Daftar untuk menyimpan riwayat pesanan
  List<Map<String, dynamic>> _orderHistory = [];

  // Mengambil riwayat pesanan
  List<Map<String, dynamic>> get orderHistory => _orderHistory;

  // Menambahkan pesanan baru ke riwayat
  void addOrder(Map<String, dynamic> newOrder) {
    _orderHistory.add(newOrder);
    notifyListeners(); // Memberitahukan widget lain untuk memperbarui tampilan
  }

  // Menyimpan riwayat pesanan (opsional, jika Anda ingin menggunakan penyimpanan lokal)
  void saveOrderHistory() {
    // Implementasi untuk menyimpan ke penyimpanan lokal seperti SharedPreferences atau database
  }

  // Mengambil riwayat pesanan yang sudah disimpan (opsional)
  void loadOrderHistory() {
    // Implementasi untuk memuat riwayat pesanan yang sudah disimpan
  }
}
