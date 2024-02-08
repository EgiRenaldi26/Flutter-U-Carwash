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
                    String namaProduk = productNameController.text.trim();
                    String deskripsi = productDescController.text.trim();
                    double hargaProduk =
                        double.tryParse(productPriceController.text.trim()) ??
                            0.0;

                    if (namaProduk.isNotEmpty && hargaProduk > 0) {
                      ProductM newProduct = ProductM(
                          namaproduk: namaProduk,
                          hargaproduk: hargaProduk,
                          deskripsi: deskripsi,
                          createdat: DateTime.now().toString(),
                          updatedat: DateTime.now().toString());
                      bool success =
                          await _productController.addProduct(newProduct);

                      if (success) {
                        _productController.shouldUpdate.value = true;
                        Get.back();
                        _addLog("Add Produk : $namaProduk");
                        Get.snackbar(
                          "Success",
                          "Product added successfully",
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors
                                .green, // Change the color to green or any other color
                          ),
                          snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.only(bottom: 75.0),
                          backgroundColor: warna.putih,
                          colorText: Colors.black,
                          titleText:
                              SizedBox.shrink(), // Menyembunyikan teks judul
                          snackStyle: SnackStyle.FLOATING,
                        );
                      } else {
                        Get.snackbar(
                          'error',
                          "Product gagal ditambahkan",
                          icon: Icon(
                            Icons.cancel,
                            color: Colors
                                .red, // Change the color to green or any other color
                          ),
                          snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.only(bottom: 75.0),
                          backgroundColor: warna.putih,
                          colorText: Colors.black,
                          titleText:
                              SizedBox.shrink(), // Menyembunyikan teks judul
                          snackStyle: SnackStyle.FLOATING,
                        );
                      }
                    } else {
                      Get.snackbar(
                        'error',
                        "Product gagal ditambahkan",
                        icon: Icon(
                          Icons.cancel,
                          color: Colors
                              .red, // Change the color to green or any other color
                        ),
                        snackPosition: SnackPosition.TOP,
                        margin: EdgeInsets.only(bottom: 75.0),
                        backgroundColor: warna.putih,
                        colorText: Colors.black,
                        titleText:
                            SizedBox.shrink(), // Menyembunyikan teks judul
                        snackStyle: SnackStyle.FLOATING,
                      );
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
