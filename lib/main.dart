import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import 'package:SiFood/history_page.dart';
import 'package:SiFood/models/menu_model.dart';
import 'package:http/http.dart' as myHttp;
import 'package:SiFood/profile_page.dart';
import 'package:SiFood/providers/cart_provider.dart';
import 'package:SiFood/providers/orderhistory_provider.dart';
import 'package:provider/provider.dart';
import 'package:SiFood/order_summary_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderHistoryProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController nomorMejaController = TextEditingController();
  final String urlMenu =
      "https://script.google.com/macros/s/AKfycbyKACTIHrYgWyd-2zc_Uw0zCX7TYc35hDMu0KftWJBZI1isUrzTCeoadx4xmjE--w02oA/exec";

  int _selectedIndex = 0; // Untuk menyimpan indeks halaman yang dipilih

  // List halaman yang akan ditampilkan berdasarkan tab yang dipilih
  final List<Widget> _pages = [
    HomePageContent(), // Halaman konten utama (Home)
    HistoryPage(), // History
    ProfilePage(), // Settings
  ];

  // Fungsi untuk mengubah tab yang aktif
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 280,
            child: Column(
              children: [
                Text(
                  "Nama",
                  style: GoogleFonts.montserrat(),
                ),
                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nomor Meja",
                  style: GoogleFonts.montserrat(),
                ),
                TextFormField(
                  controller: nomorMejaController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<CartProvider>(
                  builder: (context, value, _) {
                    String strPesanan = "";
                    value.cart.forEach((element) {
                      strPesanan = strPesanan +
                          "\n" +
                          element.name +
                          "(" +
                          element.quantity.toString() +
                          ")";
                    });

                    return ElevatedButton(
                      onPressed: () {
                        String strPesanan = "";
                        value.cart.forEach((element) {
                          strPesanan = strPesanan +
                              "\n" +
                              element.name +
                              " (" +
                              element.quantity.toString() +
                              ")";
                        });

                        String nama = namaController.text;
                        String nomorMeja = nomorMejaController.text;

                        if (nama.isNotEmpty && nomorMeja.isNotEmpty) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryPage(
                                nama: nama,
                                nomorMeja: nomorMeja,
                                pesanan: strPesanan,
                              ),
                            ),
                            (route) => false,
                          ).then((_) {
                            Future.microtask(() {
                              Provider.of<CartProvider>(context, listen: false)
                                  .resetCart();
                            });
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Peringatan"),
                                content: Text("Harap isi semua kolom"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Menutup dialog
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text("Pesan Sekarang"),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Image.asset(
            width: 150,
            height: 150,
            'assets/image/SiFood.png',
          ), // Ganti dengan path gambar Anda
        ),
        backgroundColor: const Color.fromARGB(255, 200, 150, 200),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        child: badges.Badge(
          badgeContent: Consumer<CartProvider>(
            builder: (context, value, _) {
              return Text(
                (value.total > 0) ? value.total.toString() : "",
                style: GoogleFonts.montserrat(color: Colors.white),
              );
            },
          ),
          child: Icon(Icons.shopping_bag),
        ),
      ),
      body: SafeArea(
        child: _pages[_selectedIndex], // Menampilkan halaman sesuai indeks
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Mengubah halaman berdasarkan tab yang dipilih
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Daftar Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Kasir',
          ),
        ],
      ),
    );
  }
}

// Halaman utama (Home)
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  // Fungsi untuk mengambil data menu dari API
  Future<List<MenuModel>> getAllData() async {
    List<MenuModel> listMenu = [];
    final String urlMenu =
        "https://script.google.com/macros/s/AKfycbyKACTIHrYgWyd-2zc_Uw0zCX7TYc35hDMu0KftWJBZI1isUrzTCeoadx4xmjE--w02oA/exec";
    var response = await myHttp.get(Uri.parse(urlMenu));
    List data = json.decode(response.body);

    data.forEach((element) {
      listMenu.add(MenuModel.fromJson(element));
    });

    return listMenu;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                MenuModel menu = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(menu.image),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.name,
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              menu.description,
                              style: GoogleFonts.montserrat(fontSize: 13),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rp. " + menu.price.toString(),
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .addRemove(menu.name, menu.id,
                                                  menu.price, false);
                                        },
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Consumer<CartProvider>(
                                      builder: (context, value, _) {
                                        var id = value.cart.indexWhere(
                                            (element) =>
                                                element.menuId ==
                                                snapshot.data![index].id);
                                        return Text(
                                          (id == -1)
                                              ? "0"
                                              : value.cart[id].quantity
                                                  .toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .addRemove(menu.name, menu.id,
                                                  menu.price, true);
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.green,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Tidak ada data"),
            );
          }
        }
      },
    );
  }
}
