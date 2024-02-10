import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/model/Transactions.dart';
import 'package:cucimobil_app/model/TransactionsItem.dart';
import 'package:get/get.dart';

class TransaksiController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<TransactionsM> transaksiList = <TransactionsM>[].obs;
  RxBool shouldUpdate = false.obs;

  final CollectionReference transaksiCollection =
      FirebaseFirestore.instance.collection('transactions');

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

  Future<bool> deleteTransaksi(int nomorUnik) async {
    try {
      await _firestore
          .collection('transactions')
          .where('nomorunik', isEqualTo: nomorUnik)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    }
  }

  Future<bool> updateTransaksi(
    int nomorUnik,
    String namaPelanggan,
    List<TransactionItem> items,
    double uangBayar,
    double totalBelanja,
    double uangKembali,
    String updatedat,
  ) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('transactions')
          .where('nomorunik', isEqualTo: nomorUnik)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String id = querySnapshot.docs.first.id;
        await _firestore.collection('transactions').doc(id).update({
          'namapelanggan': namaPelanggan,
          'items': items.map((item) => item.toMap()).toList(),
          'uangbayar': uangBayar,
          'totalbelanja': totalBelanja,
          'uangkembali': uangKembali,
          'updated_at': updatedat,
        });
        return true;
      } else {
        throw Exception('Transaction not found for nomorunik: $nomorUnik');
      }
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

  Future<bool> addMultipleTransaksi(List<TransactionsM> transaksiList) async {
    try {
      var batch = FirebaseFirestore.instance.batch();
      for (var transaksi in transaksiList) {
        batch.set(transaksiCollection.doc(), transaksi.toMap());
      }
      await batch.commit();
      return true;
    } catch (e) {
      print('Error adding multiple transaksi: $e');
      return false;
    }
  }

  Future<TransactionsM> getTransaksiByUnik(int nomorUnik) async {
    try {
      QuerySnapshot querySnapshot = await transaksiCollection
          .where('nomorunik', isEqualTo: nomorUnik)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return TransactionsM.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        throw Exception('Transaction not found for nomorunik: $nomorUnik');
      }
    } catch (e) {
      print('Error getting transaction by nomorunik: $e');
      rethrow;
    }
  }
}
