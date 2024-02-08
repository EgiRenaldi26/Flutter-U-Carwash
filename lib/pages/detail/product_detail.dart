import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/productController.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetail extends StatelessWidget {
  final ProductController _productController = Get.put(ProductController());
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productDescController = TextEditingController();
  final LogController logController = LogController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final String namaproduk = args?['namaproduk'] ?? '';
    final double hargaproduk = args?['hargaproduk'] ?? 0.0;
    final String deskripsi = args?['deskripsi'] ?? '';

    productNameController.text = namaproduk;
    productDescController.text = deskripsi;
    productPriceController.text = hargaproduk.toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: warna.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        title: Center(
          child: Text(
            "Form Paket",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                hintText: 'Exm. Cuci VIP',
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
                hintText: 'Exm. Rp.10.000',
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
                hintText: 'Exm. Paket Bersih',
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
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String namaproduk = productNameController.text.trim();
                  double hargaproduk =
                      double.tryParse(productPriceController.text.trim()) ??
                          0.0;
                  String deskripsi = productDescController.text.trim();
                  String updated_at = DateTime.now().toString();
                  if (namaproduk.isNotEmpty && hargaproduk > 0) {
                    await _productController.updateProducts(
                      id,
                      productNameController.text,
                      double.parse(productPriceController.text),
                      productDescController.text,
                      updated_at,
                    );

                    _productController.shouldUpdate.value = true;
                    Get.back();

                    Get.snackbar(
                      'Success',
                      'Produk updated successfully!',
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors
                            .green, // Change the color to green or any other color
                      ),
                      snackPosition: SnackPosition.TOP,
                      margin: EdgeInsets.only(bottom: 75.0),
                      backgroundColor: warna.putih,
                      colorText: Colors.black,
                      titleText: SizedBox.shrink(), // Menyembunyikan teks judul
                      snackStyle: SnackStyle.FLOATING,
                    );
                    _addLog(" update: $namaproduk");
                  } else {
                    Get.snackbar(
                      'Failed',
                      'Gagal memperbarui Produk, silakan periksa kembali form.',
                      icon: Icon(
                        Icons.cancel,
                        color: Colors
                            .red, // Change the color to green or any other color
                      ),
                      snackPosition: SnackPosition.TOP,
                      margin: EdgeInsets.only(bottom: 75.0),
                      backgroundColor: warna.putih,
                      colorText: Colors.black,
                      titleText: SizedBox.shrink(), // Menyembunyikan teks judul
                      snackStyle: SnackStyle.FLOATING,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: warna.ungu, // Set background color to orange
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
                  bool success = await _productController.deleteProducts(
                    context, // Meneruskan BuildContext ke fungsi deleteProducts
                    id,
                  );
                  if (success) {
                    _addLog("Delete produk : $namaproduk");
                    Get.back();
                    Get.snackbar(
                      'Success',
                      'Produk Delete successfully!',
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      snackPosition: SnackPosition.TOP,
                      margin: EdgeInsets.only(bottom: 75.0),
                      backgroundColor: Colors.white,
                      colorText: Colors.black,
                      titleText: SizedBox.shrink(),
                      snackStyle: SnackStyle.FLOATING,
                    );
                  } else {
                    Get.snackbar(
                      'Failed',
                      'Failed to delete Produk',
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      snackPosition: SnackPosition.TOP,
                      margin: EdgeInsets.only(bottom: 75.0),
                      backgroundColor: Colors.white,
                      colorText: Colors.black,
                      titleText: SizedBox.shrink(),
                      snackStyle: SnackStyle.FLOATING,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(
                      color: warna.ungu,
                      width: 2.0,
                    ),
                  ),
                  minimumSize: Size(double.infinity, 50.0),
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: warna.ungu,
                  ),
                ),
              ),
            ),
            // Tambahkan tombol aksi di sini
          ],
        ),
      ),
    );
  }

  Future<void> _addLog(String activity) async {
    try {
      await logController.addLog(activity);
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
