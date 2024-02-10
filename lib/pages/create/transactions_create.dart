import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/transactionController.dart';
import 'package:cucimobil_app/model/Transactions.dart';
import 'package:cucimobil_app/model/TransactionsItem.dart';
import 'package:cucimobil_app/pages/succestransaction.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsCreate extends StatefulWidget {
  const TransactionsCreate({Key? key});

  @override
  State<TransactionsCreate> createState() => _TransactionsCreateState();
}

class _TransactionsCreateState extends State<TransactionsCreate> {
  final TransaksiController _transaksiController =
      Get.put(TransaksiController());
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  String? _selectedProduct;
  String? _selectedProductId;
  List<String> produkList = [];
  double _hargaProduk = 0.0;
  double _totalBelanja = 0.0;

  final TextEditingController _namaPelangganController =
      TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _uangBayarController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();
  final LogController logController = LogController();

  List<Map<String, dynamic>> selectedProducts = [];

  void calculateTotalBelanja() {
    int qty = int.tryParse(_qtyController.text) ?? 0;

    if (_hargaProduk != null && _selectedProduct != null && qty > 0) {
      int existingProductIndex = selectedProducts
          .indexWhere((product) => product['product'] == _selectedProduct);

      if (existingProductIndex != -1) {
        setState(() {
          selectedProducts[existingProductIndex]['qty'] += qty;
          selectedProducts[existingProductIndex]['total'] += _hargaProduk * qty;
          _totalBelanja = selectedProducts.fold(
              0.0, (sum, product) => sum + product['total']);
        });
      } else {
        double totalBelanja = _hargaProduk * qty;
        Map<String, dynamic> selectedProductData = {
          'id': _selectedProductId!,
          'product': _selectedProduct!,
          'qty': qty,
          'total': totalBelanja,
        };

        setState(() {
          selectedProducts.add(selectedProductData);
          _totalBelanja = selectedProducts.fold(
              0.0, (sum, product) => sum + product['total']);
        });
      }
      setState(() {
        _selectedProduct = null;
        _hargaProdukController.clear();
        _qtyController.clear();
      });
    } else {
      print('Harga produk tidak ditemukan atau qty tidak valid.');
    }
  }

  Future<void> _submitTransaksi() async {
    String namapelanggan = _namaPelangganController.text.trim();
    double uangbayar = double.tryParse(
            _uangBayarController.text.replaceAll(RegExp('[^0-9]'), '')) ??
        0;

    if (selectedProducts.isNotEmpty &&
        uangbayar > 0 &&
        namapelanggan.isNotEmpty &&
        uangbayar >= _totalBelanja) {
      double totalbelanja = _totalBelanja;
      double uangkembali = uangbayar - totalbelanja;

      int _nomor_unik = Random().nextInt(1000000000);
      String _created_at = DateTime.now().toString();
      String _updated_at = DateTime.now().toString();

      List<TransactionItem> transactionItems = selectedProducts.map((product) {
        return TransactionItem(
          productId: product['id'],
          namaProduk: product['product'],
          hargaProduk: _hargaProduk,
          qty: product['qty'],
          totalBelanja: product['total'],
        );
      }).toList();

      TransactionsM newTransaksi = TransactionsM(
        nomorunik: _nomor_unik,
        namapelanggan: namapelanggan,
        items: transactionItems,
        uangbayar: uangbayar,
        totalbelanja: totalbelanja,
        uangkembali: uangkembali,
        created_at: _created_at,
        updated_at: _updated_at,
      );

      bool success = await _transaksiController.addTransaksi(newTransaksi);

      if (success) {
        Get.snackbar('Success', 'Transaksi added successfully');

        String newtransactionId = _nomor_unik.toString();

        _namaPelangganController.clear();
        _uangBayarController.clear();
        _hargaProdukController.clear();
        _totalBelanja = 0;
        setState(() {
          _selectedProduct = null;
          selectedProducts.clear();
          Get.to(() => TransaksiSukses(transactionId: newtransactionId));
        });
      } else {
        Get.snackbar('Failed', 'Failed to add transaction to the database');
      }
    } else {
      Get.snackbar('Failed', 'Please check your transaction details.');
    }
  }

  void fetchPrice(String? selectedBook) async {
    if (selectedBook != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('namaproduk', isEqualTo: selectedBook)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        double hargaproduk = querySnapshot.docs.first['hargaproduk'];
        String productId = querySnapshot.docs.first.id;

        setState(() {
          _hargaProduk = hargaproduk;
          _selectedProductId = productId; // Set selected product ID
          _hargaProdukController.text =
              "Rp. ${_hargaProduk.toStringAsFixed(2)}";
        });
      }
    } else {
      setState(() {
        _hargaProduk = 0.0;
        _hargaProdukController.text = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    setState(() {
      produkList = querySnapshot.docs
          .map((doc) => doc['namaproduk'].toString())
          .toList();
    });
  }

  void _updateQty(int index, int newQty) {
    if (newQty > 0) {
      setState(() {
        selectedProducts[index]['qty'] = newQty;
        selectedProducts[index]['total'] = _hargaProduk * newQty;
        _totalBelanja = selectedProducts.fold(
            0.0, (sum, product) => sum + product['total']);
      });
    }
  }

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
          'Form Transaksi',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: warna.background,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _namaPelangganController,
                  decoration: InputDecoration(
                    hintText: 'Exm. Egi Renaldi',
                    labelText: 'Nama Pelanggan',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: DropdownButton<String>(
                    hint: Text('Pilih Produk'),
                    value: _selectedProduct,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedProduct = newValue;
                        fetchPrice(newValue);
                      });
                    },
                    dropdownColor: Colors.white,
                    items: produkList
                        .map<DropdownMenuItem<String>>((String product) {
                      return DropdownMenuItem<String>(
                        value: product,
                        child: Text(product),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _hargaProdukController,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Exm. Rp. 100.000',
                    labelText: 'Harga Paket',
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
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    calculateTotalBelanja();
                  },
                  decoration: InputDecoration(
                    hintText: 'Exm. 50',
                    labelText: 'QTY',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                selectedProducts.isNotEmpty
                    ? Container(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                selectedProducts.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> product = entry.value;

                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('${product['product']}',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  _updateQty(index,
                                                      product['qty'] - 1);
                                                },
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          warna.ungu),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Ubah angka sesuai dengan radius yang diinginkan
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text('${product['qty']}',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              IconButton(
                                                onPressed: () {
                                                  _updateQty(index,
                                                      product['qty'] + 1);
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          warna.ungu),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Ubah angka sesuai dengan radius yang diinginkan
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedProducts.removeAt(index);
                                          _totalBelanja = selectedProducts.fold(
                                              0.0,
                                              (sum, product) =>
                                                  sum + product['total']);
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                TextField(
                  controller: _uangBayarController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Exm. Rp. 100.000',
                    labelText: 'Uang Bayar',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Belanja",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${currencyFormatter.format(_totalBelanja)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _submitTransaksi();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warna.ungu,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      minimumSize: Size(double.infinity, 50.0),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateTotalBelanja() {
    double hargaProduk = _hargaProduk;
    int qty = int.tryParse(_qtyController.text) ?? 0;
    double totalBelanja = hargaProduk * qty;

    setState(() {
      _totalBelanja = totalBelanja;
    });
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
