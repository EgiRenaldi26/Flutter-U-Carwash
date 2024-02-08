import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:cucimobil_app/pages/create/transactions_create.dart';
import 'package:cucimobil_app/pages/detail/transactions_detail.dart';
import 'package:cucimobil_app/pages/invoice/transaksi_all.dart';
import 'package:cucimobil_app/pages/invoice/transaksi_invoice.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final AuthController _authController = Get.find<AuthController>();
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final CollectionReference transaksiCollection =
      FirebaseFirestore.instance.collection('transactions');
  var searchQuery = '';

  DateTime? selectedDate;
  List<DocumentSnapshot> transaksiList = [];
  List<DocumentSnapshot> filteredTransaksi = [];

  @override
  void initState() {
    super.initState();
    getTransaksi();
  }

  void queryProduk(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      cariTransaksi();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        cariTransaksi();
      });
    }
  }

  void getTransaksi() {
    transaksiCollection.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          transaksiList = snapshot.docs;
          cariTransaksi();
        });
      } else {
        setState(() {
          transaksiList = [];
          filteredTransaksi = [];
        });
      }
    }, onError: (error) {
      print('Error getting transaksi: $error');
    });
  }

  void cariTransaksi() {
    filteredTransaksi = transaksiList.where((transactions) {
      final namapelanggan =
          transactions['namapelanggan'].toString().toLowerCase();
      final tanggalTransaksiString = transactions['created_at'];
      final tanggalTransaksi = DateTime.parse(tanggalTransaksiString);

      final isTanggalSelected = selectedDate != null
          ? (tanggalTransaksi.day == selectedDate!.day &&
              tanggalTransaksi.month == selectedDate!.month &&
              tanggalTransaksi.year == selectedDate!.year)
          : true;

      return namapelanggan.contains(searchQuery) && isTanggalSelected;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    UserRole currentUserRole = _authController.getCurrentUserRole();
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
            'Transaksi',
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (currentUserRole == UserRole.Owner) ...[
                      Container(
                          alignment: AlignmentDirectional.bottomEnd,
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: warna.ungu,
                              ),
                              onPressed: () async {
                                if (selectedDate != null) {
                                  await printPdfByDate(
                                      selectedDate!, filteredTransaksi);
                                } else {
                                  // Handle jika tanggal belum dipilih
                                  print(
                                      'Please select a date before generating PDF.');
                                }
                              },
                              child: Text(
                                "Generate",
                                style: TextStyle(color: Colors.white),
                              ))),
                    ],
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: Icon(
                          Icons.date_range,
                          color: warna.ungu,
                        ),
                      ),
                    ),
                    Text(
                      "Filtering by Tanggal",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Transaksi',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Actions',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: filteredTransaksi.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          size: 50,
                          color: warna.ungu,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Transaksi tidak ditemukan',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTransaksi.length,
                    itemBuilder: (context, index) {
                      var transaksiData = filteredTransaksi[index].data()
                          as Map<String, dynamic>;
                      String namapelanggan = transaksiData['namapelanggan'];
                      String namaproduk = transaksiData['namaproduk'];
                      int nomorunik = transaksiData['nomorunik'];
                      int qty = transaksiData['qty'];
                      double uangbayar =
                          transaksiData['uangbayar']?.toDouble() ?? 0.0;
                      double hargaproduk =
                          transaksiData['hargaproduk']?.toDouble() ?? 0.0;
                      double totalbelanja =
                          transaksiData['totalbelanja']?.toDouble() ?? 0.0;
                      double uangkembali =
                          transaksiData['uangkembali']?.toDouble() ?? 0.0;
                      String created_at = transaksiData['created_at'] ?? '';

                      DateTime dateTime =
                          DateTime.tryParse(created_at) ?? DateTime.now();
                      String formattedDate =
                          DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);

                      return GestureDetector(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(20),
                          height: 94,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Circle with shopping icon
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: warna.ungu,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.swap_horizontal_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          namapelanggan,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Total Belanja : ${currencyFormatter.format(totalbelanja)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            width: 220,
                                            child: Positioned(
                                              child: AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Navigate to Detail screen
                                                        Navigator.pop(context);
                                                        Get.to(
                                                            () =>
                                                                TransaksiDetail(),
                                                            arguments: {
                                                              'id':
                                                                  filteredTransaksi[
                                                                          index]
                                                                      .id,
                                                              'namapelanggan':
                                                                  namapelanggan,
                                                              'namaproduk':
                                                                  namaproduk,
                                                              'qty': qty,
                                                              'uangbayar':
                                                                  uangbayar,
                                                              'totalbelanja':
                                                                  totalbelanja,
                                                            });
                                                      },
                                                      child: Text("Detail"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Get.to(
                                                            () =>
                                                                TransaksiPdf(),
                                                            arguments: {
                                                              'id':
                                                                  filteredTransaksi[
                                                                          index]
                                                                      .id,
                                                              'nomorunik':
                                                                  nomorunik,
                                                              'namapelanggan':
                                                                  namapelanggan,
                                                              'namaproduk':
                                                                  namaproduk,
                                                              'uangbayar':
                                                                  uangbayar,
                                                              'hargaproduk':
                                                                  hargaproduk,
                                                              'qty': qty,
                                                              'totalbelanja':
                                                                  totalbelanja,
                                                              'uangkembali':
                                                                  uangkembali,
                                                              'created_at':
                                                                  created_at,
                                                            });
                                                      },
                                                      child: Text("Laporan"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.more_horiz),
                                color: warna.ungu,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: currentUserRole == UserRole.Kasir
          ? FloatingActionButton(
              backgroundColor: warna.ungu,
              onPressed: () {
                Get.to(() => TransactionsCreate());
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
