class CartModel {
  final String name;
  final int menuId;
  final double price; // Harga satuan
  double quantity;    // Kuantitas

  CartModel({
    required this.name,
    required this.menuId,
    required this.price,
    required this.quantity,
  });

}
