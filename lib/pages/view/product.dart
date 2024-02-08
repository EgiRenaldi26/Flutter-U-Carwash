import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/pages/create/product_create.dart';
import 'package:cucimobil_app/pages/detail/product_detail.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  var refreshFlag = false;
  var searchQuery = '';

  void queryProduk(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warna.background,
      appBar: AppBar(
        backgroundColor: warna.ungu,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15), // Atur nilai sesuai keinginan
          ),
        ),
        title: Center(
          child: Text(
            'Paket',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: warna.putih,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    queryProduk(value);
                  },
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: productsCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<DocumentSnapshot> products = snapshot.data!.docs;

                final filteredProducts = searchQuery.isEmpty
                    ? products
                    : products.where((products) {
                        final namaproduk =
                            products['namaproduk'].toString().toLowerCase();
                        return namaproduk.contains(searchQuery);
                      }).toList();
                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          size: 50,
                          color: warna.ungu,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 20,
                    childAspectRatio:
                        0.75, // Adjust this value to increase card size
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    var productsData =
                        filteredProducts[index].data() as Map<String, dynamic>;
                    String nama_produk =
                        productsData['namaproduk'] ?? 'No Name';
                    double harga_produk =
                        productsData['hargaproduk']?.toDouble() ?? 0.0;
                    String formattedPrice =
                        currencyFormatter.format(harga_produk);
                    String Deskripsi = productsData['deskripsi'] ?? 'No Name';

                    return Card(
                      margin: EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      elevation: 4, // Set elevation for the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                padding: EdgeInsets.all(8.0),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  nama_produk,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formattedPrice,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.to(() => ProductDetail(),
                                            arguments: {
                                              'id': filteredProducts[index].id,
                                              'namaproduk': nama_produk,
                                              'hargaproduk': harga_produk,
                                              'deskripsi': Deskripsi,
                                            });
                                      },
                                      icon: Icon(Icons.more_vert),
                                      color: warna.ungu,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 40),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: warna.ungu, width: 3), // Add border color
          borderRadius: BorderRadius.circular(30), // Border radius
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Get.to(() => ProductCreate());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: warna.ungu,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Add Produk',
                    style: TextStyle(
                      color: warna.ungu,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
