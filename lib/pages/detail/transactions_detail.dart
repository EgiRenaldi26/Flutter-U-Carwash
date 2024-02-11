import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/transactionController.dart';
import 'package:cucimobil_app/model/Transactions.dart';
import 'package:cucimobil_app/model/TransactionsItem.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiDetail extends StatefulWidget {
  final int nomorUnik;

  TransaksiDetail({required this.nomorUnik});

  @override
  State<TransaksiDetail> createState() => _TransaksiDetailState();
}

class _TransaksiDetailState extends State<TransaksiDetail> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  String? _selectedProduct;
  int _qty = 0;
  List<String> produkList = [];
  double _hargaProduk = 0.0;
  double _totalBelanja = 0.0;

  final TextEditingController _namaPelangganController =
      TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _uangBayarController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();
  final TextEditingController _totalBelanjaController = TextEditingController();
  final LogController logController = LogController();
  final TransaksiController _transaksiController =
      Get.find<TransaksiController>();
  List<TransactionItem> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          )),
      body: Container(
        color: warna.background,
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _namaPelangganController,
              decoration: InputDecoration(
                hintText: 'Exm. Egi Renaldi',
                labelText: 'Nama Pembeli',
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
                    fetchBookPrice(newValue);
                    _selectedProductChanged(_selectedProduct, _qty);
                  });
                },
                items:
                    produkList.map<DropdownMenuItem<String>>((String product) {
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
              onChanged: (String newValue) {
                setState(() {
                  _qty = int.tryParse(newValue) ?? 0;
                  _selectedProductChanged(_selectedProduct, _qty);
                });
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
            selectedProducts.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedProducts.asMap().entries.map((entry) {
                          int index = entry.key;
                          TransactionItem product = entry.value;

                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${product.namaProduk}',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Tombol Remove
                                          IconButton(
                                            onPressed: () {
                                              _updateQty(
                                                  index, product.qty - 1);
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      warna.ungu),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Ubah angka sesuai dengan radius yang diinginkan
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text('${product.qty}',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                          IconButton(
                                            onPressed: () {
                                              _updateQty(
                                                  index, product.qty + 1);
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      warna.ungu),
                                              shape: MaterialStateProperty.all<
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
                                      calculateTotalBelanja();
                                    });
                                  },
                                  icon: Icon(Icons.delete),
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
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${_totalBelanjaController.text}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String namapelanggan = _namaPelangganController.text.trim();
                  double uangbayar = double.tryParse(_uangBayarController.text
                          .replaceAll(RegExp('[^0-9]'), '')) ??
                      0;
                  double totalBelanja = _totalBelanja;
                  String updatedat = DateTime.now().toString();
                  double uangKembali = uangbayar - totalBelanja;

                  if (selectedProducts.isNotEmpty &&
                      uangbayar > 0 &&
                      namapelanggan.isNotEmpty &&
                      uangbayar >= _totalBelanja) {
                    List<TransactionItem> items =
                        selectedProducts.map((product) {
                      return TransactionItem(
                        productId: product.productId,
                        namaProduk: product.namaProduk,
                        hargaProduk: product.hargaProduk,
                        qty: product.qty,
                        totalBelanja: product.totalBelanja,
                      );
                    }).toList();

                    await _transaksiController.updateTransaksi(
                      widget.nomorUnik,
                      namapelanggan,
                      items,
                      uangbayar,
                      totalBelanja,
                      uangKembali,
                      updatedat,
                    );

                    _addLog("Transaksi updated");
                    _showSuccessDialog();
                    Get.back();
                    Get.snackbar(
                        'Success', 'Transaction updated successfully!');
                  } else {
                    Get.snackbar('Failed', 'Failed to update transaction');
                  }
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
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bool success = await _transaksiController
                      .deleteTransaksi(widget.nomorUnik);
                  if (success) {
                    Get.back();
                    _showSuccessDialog();
                    Get.snackbar(
                        'Success', 'Transaction deleted successfully!');
                    _addLog("Deleted transaction with ID: ${widget.nomorUnik}");
                  } else {
                    Get.snackbar('Failed', 'Failed to delete transaction');
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
          ],
        ),
      ),
    );
  }

  void fetchData() async {
    try {
      TransactionsM transactions =
          await _transaksiController.getTransaksiByUnik(widget.nomorUnik);
      setState(() {
        _namaPelangganController.text = transactions.namapelanggan;
        _uangBayarController.text = transactions.uangbayar.toStringAsFixed(0);
        _totalBelanjaController.text =
            currencyFormatter.format(transactions.totalbelanja);
        selectedProducts = transactions.items;
      });
    } catch (e) {
      print('Error fetching data for update: $e');
    }
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

  Future<void> fetchBookPrice(String? selectedBook) async {
    if (selectedBook != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('namaproduk', isEqualTo: selectedBook)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        double hargaProduk = querySnapshot.docs.first['hargaproduk'];

        setState(() {
          _hargaProduk = hargaProduk; // Perbarui harga produk
          _hargaProdukController.text = currencyFormatter.format(hargaProduk);
          addSelectedProductToContainer(
              _qty); // Tambahkan produk baru setelah harga produk diperbarui
        });
      }
    } else {
      setState(() {
        _hargaProduk = 0.0;
        _hargaProdukController.text = '';
      });
    }
  }

  void _updateQty(int index, int newQty) {
    if (newQty > 0) {
      setState(() {
        selectedProducts[index].qty = newQty;
        selectedProducts[index].totalBelanja =
            selectedProducts[index].hargaProduk * newQty;
      });
      addSelectedProductToContainer(
          newQty); // Tambahkan produk baru setelah qty diperbarui
      calculateTotalBelanja();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Transaction updated successfully!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void calculateTotalBelanja() {
    double totalBelanja = selectedProducts.fold(
        0.0, (sum, product) => sum + product.totalBelanja);
    setState(() {
      _totalBelanja = totalBelanja;
      _totalBelanjaController.text = currencyFormatter.format(totalBelanja);
    });
  }

  void _selectedProductChanged(String? selectedProduct, int qty) {
    setState(() {
      _selectedProduct = selectedProduct;
      addSelectedProductToContainer(qty);
    });
  }

  void addSelectedProductToContainer(int qty) {
    if (_selectedProduct != null && qty > 0) {
      double totalBelanja = _hargaProduk * qty;

      TransactionItem newProduct = TransactionItem(
        productId: _selectedProduct!,
        namaProduk: _selectedProduct!,
        hargaProduk: _hargaProduk,
        qty: qty,
        totalBelanja: totalBelanja,
      );

      setState(() {
        selectedProducts.add(newProduct);
        calculateTotalBelanja(); // Panggil calculateTotalBelanja() setelah menambahkan produk
        _selectedProduct = null;
        _qtyController.clear();
        _hargaProdukController.clear();
        _qty = 0;
      });
    }
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
