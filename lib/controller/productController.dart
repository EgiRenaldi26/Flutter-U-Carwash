import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/model/Products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool shouldUpdate = false.obs;

  get products => null;

  Future<bool> addProduct(ProductM products) async {
    try {
      await _firestore.collection('products').add(products.toMap());
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error adding products');
      return false;
    }
  }

  Future<bool> deleteProducts(BuildContext context, String id) async {
    try {
      // Tampilkan dialog konfirmasi
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Batalkan
                },
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Konfirmasi ya
                },
                child: Text('Ya'),
              ),
            ],
          );
        },
      );

      // Jika pengguna mengkonfirmasi, hapus produk
      if (confirmed == true) {
        await _firestore.collection('products').doc(id).delete();
        shouldUpdate.toggle();
        return true;
      } else {
        return false; // Pengguna membatalkan penghapusan
      }
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }

  Future<bool> updateProducts(String id, String namaProduk, double hargaProduk,
      String deskripsi, String updated_at) async {
    try {
      await _firestore.collection('products').doc(id).update({
        'namaproduk': namaProduk,
        'hargaproduk': hargaProduk,
        'deskripsi': deskripsi,
        'updated_at': updated_at,
      });
      return true;
    } catch (e) {
      print('Error updating book: $e');
      return false;
    }
  }

  Future<int> countProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }
}
