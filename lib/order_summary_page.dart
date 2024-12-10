import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SiFood/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:SiFood/main.dart'; // Sesuaikan dengan lokasi file HomePage
import 'package:intl/intl.dart';

class OrderSummaryPage extends StatelessWidget {
  final String nama;
  final String nomorMeja;
  final String pesanan;

  OrderSummaryPage({
    required this.nama,
    required this.nomorMeja,
    required this.pesanan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ringkasan Pesanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: $nama',
              style: GoogleFonts.montserrat(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Nomor Meja: $nomorMeja',
              style: GoogleFonts.montserrat(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              "Pesanan: ",
              style: GoogleFonts.montserrat(fontSize: 16),
            ),
            Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                // Inisialisasi totalHarga yang akan digunakan untuk menjumlahkan harga
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cartProvider.cart.map((cartItem) {
                    double totalHargaMenu =
                        cartItem.price * cartItem.quantity.toDouble();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            cartItem.name,
                            style: GoogleFonts.montserrat(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            "Rp. ${NumberFormat('#,###').format(cartItem.price)}", // Harga per item
                            style: GoogleFonts.montserrat(fontSize: 14),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "x ${cartItem.quantity}",
                            style: GoogleFonts.montserrat(fontSize: 14),
                          ),
                          SizedBox(width: 10),
                          Text(
                            " = Rp. ${NumberFormat('#,###').format(totalHargaMenu)}", // Total harga per item
                            style: GoogleFonts.montserrat(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                double totalHarga = 0;
                // Menghitung total harga dari semua item
                cartProvider.cart.forEach((cartItem) {
                  totalHarga += cartItem.price * cartItem.quantity.toDouble();
                });

                // Pastikan totalHarga digunakan untuk menampilkan total harga keseluruhan
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Harga: Rp. ${NumberFormat('#,###').format(totalHarga)}", // Format total harga
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomePage()),
  (route) => false,
).then((_) {
  Provider.of<CartProvider>(context, listen: false).resetCart();
});
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(
                            Icons.check_circle, // Ikon centang hijau
                            color:
                                Colors.green, // Warna hijau untuk ikon centang
                          ),
                          SizedBox(width: 10),
                          Text("Berhasil"),
                        ],
                      ),
                      content: Text("Pesanan berhasil diproses!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Menutup dialog
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Pesan Sekarang"),
            ),
          ],
        ),
      ),
    );
  }
}
