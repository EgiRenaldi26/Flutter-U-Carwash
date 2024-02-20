import 'dart:math';

import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/productController.dart';
import 'package:cucimobil_app/model/Products.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCreate extends StatefulWidget {
  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  final ProductController _productController = Get.put(ProductController());
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productDescController = TextEditingController();
  final LogController logController = LogController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: warna.background,
          title: Text(
            'Form Paket',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          color: warna.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: 'Exm. Detailling',
                  label: Text(
                    'Nama Paket',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: productPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Exm. Rp. 100.000',
                  label: Text(
                    'Harga Paket',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: productDescController,
                decoration: InputDecoration(
                  hintText: 'Exm. Bersih mengkilap',
                  label: Text(
                    'Deskripsi',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String namaproduk = productNameController.text.trim();
                    double hargaproduk =
                        double.tryParse(productPriceController.text.trim()) ??
                            0.0;
                    String deskripsi = productDescController.text.trim();
                    if (namaproduk.isNotEmpty && hargaproduk > 0) {
                      ProductM newProducts = ProductM(
                          id: Random().nextInt(1000).toString(),
                          namaproduk: namaproduk,
                          hargaproduk: hargaproduk,
                          deskripsi: deskripsi,
                          createdat: DateTime.now().toString(),
                          updatedat: DateTime.now().toString());
                      bool success =
                          await _productController.addProduct(newProducts);

                      if (success) {
                        _productController.shouldUpdate.value = true;
                        _addLog(
                            'Created Produk ID : ${newProducts.id}, ${newProducts.namaproduk}');
                        Get.back();
                        Get.snackbar('Success', 'Produk added successfully!');
                      } else {
                        print('Failed to add Produk, staying on /produkcreate');
                      }
                    } else {
                      Get.snackbar('Error', 'Silakan lengkapi form.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        warna.ungu, // Set background color to orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      // Set border radius to 25%
                    ),
                    minimumSize:
                        Size(double.infinity, 50.0), // Set the height to 50.0
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    productNameController.clear();
                    productPriceController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 255, 255, 255), // Set background color to orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: warna.ungu, // Set border color
                        width: 2.0, // Set border width
                      ),
                      // Set border radius to 25%
                    ),
                    minimumSize:
                        Size(double.infinity, 50.0), // Set the height to 50.0
                  ),
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      color: warna.ungu, // Set text color to white
                    ),
                  ),
                ),
              ),

              // Tambahkan tombol aksi di sini
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addLog(String activity) async {
    try {
      await logController
          .addLog(activity); // Menambahkan log saat tombol ditekan
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
