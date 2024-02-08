import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/model/Transactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransaksiController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<TransactionsM> transaksiList = <TransactionsM>[].obs;
  RxBool shouldUpdate = false.obs;

  Future<bool> addTransaksi(TransactionsM transactions) async {
    try {
      await _firestore.collection('transactions').add(transactions.toMap());
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error adding transaction: $e');
      return false;
    }
  }

  void clearTransaksiList() {
    transaksiList.clear();
  }

  Future<bool> deleteTransaksi(BuildContext context, String id) async {
    try {
      // Tampilkan dialog konfirmasi
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
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
        await _firestore.collection('transactions').doc(id).delete();
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

  Future<bool> updateTransaksi(
      String id,
      String namapelanggan,
      String namaproduk,
      double hargaproduk,
      int qty,
      double uangbayar,
      double totalbelanja,
      double uangkembali,
      String updated_at) async {
    try {
      await _firestore.collection('transactions').doc(id).update({
        'namapelanggan': namapelanggan,
        'namaproduk': namaproduk,
        'hargaproduk': hargaproduk,
        'qty': qty,
        'uangbayar': uangbayar,
        'totalbelanja': totalbelanja,
        'uangkembali': uangkembali,
        'updated_at': updated_at,
      });
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error updating transaction: $e');
      return false;
    }
  }

  Future<int> countTransactions() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }

  Future<double> income() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('transactions').get();

      double totalBelanja = 0;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Ambil nilai total belanja dari setiap dokumen transaksi
        double transaksiTotalBelanja = doc['totalbelanja'] ?? 0;

        // Akumulasi total belanja
        totalBelanja += transaksiTotalBelanja;
      }

      return totalBelanja;
    } catch (e) {
      print('Error calculating total belanja: $e');
      return 0;
    }
  }
}
