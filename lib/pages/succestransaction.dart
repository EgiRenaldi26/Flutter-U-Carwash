import 'dart:typed_data';

import 'package:cucimobil_app/controller/transactionController.dart';
import 'package:cucimobil_app/model/Transactions.dart';
import 'package:cucimobil_app/model/TransactionsItem.dart';
import 'package:cucimobil_app/pages/invoice/transaksi_laporan.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiSukses extends StatefulWidget {
  final String transactionId;

  TransaksiSukses({required this.transactionId});

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  State<TransaksiSukses> createState() => _TransaksiSuksesState();
}

class _TransaksiSuksesState extends State<TransaksiSukses> {
  late Future<TransactionsM> _futureTransaction;
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    _futureTransaction = _fetchTransaksiData(int.parse(widget.transactionId));
  }

  Future<TransactionsM> _fetchTransaksiData(int nomorUnik) async {
    try {
      TransactionsM transaksi =
          await Get.find<TransaksiController>().getTransaksiByUnik(nomorUnik);
      return transaksi;
    } catch (e) {
      print('Error fetching transaction data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: warna.appbar,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15), // Atur nilai sesuai keinginan
          ),
        ),
        title: Center(
          child: Text(
            'Laporan Transaksi',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: warna.putih,
            ),
          ),
        ),
      ),
      body: FutureBuilder<TransactionsM>(
        future: _futureTransaction,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }
          TransactionsM transaksi = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image(
                            width: 75,
                            height: 80,
                            image: AssetImage("image/sukses1.png"),
                          ),
                          Text(
                            "TRANSAKSI SUKSES",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tgl :",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "${transaksi.created_at}",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "No Transaksi :",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "${transaksi.nomorunik}",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 2),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rincian Pembelian",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nama Pelanggan :",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${transaksi.namapelanggan}",
                      style: TextStyle(
                        fontFamily: "Courier",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text(
                        'Nama Produk',
                        style: TextStyle(
                          fontFamily: "courier",
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Jumlah',
                        style: TextStyle(
                          fontFamily: "courier",
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: "courier",
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                    rows: transaksi.items.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(item.namaProduk,
                            style: TextStyle(fontFamily: 'Courier'))),
                        DataCell(Text(item.qty.toString(),
                            style: TextStyle(fontFamily: 'Courier'))),
                        DataCell(Text(
                            currencyFormatter.format(item.totalBelanja),
                            style: TextStyle(fontFamily: 'Courier'))),
                      ]);
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Belanja :",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${currencyFormatter.format(transaksi.totalbelanja)}",
                      style: TextStyle(
                        fontFamily: "Courier",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Uang Bayar :",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${currencyFormatter.format(transaksi.uangbayar)}",
                      style: TextStyle(
                        fontFamily: "Courier",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Uang Kembali :",
                      style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${currencyFormatter.format(transaksi.uangkembali)}",
                      style: TextStyle(
                        fontFamily: "Courier",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Divider(thickness: 2),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final Uint8List pdfBytes =
                            await EmsPdfService().generateEMSPDF(
                          transaksi.nomorunik,
                          transaksi.namapelanggan,
                          transaksi
                              .items, // Sesuaikan dengan properti yang sesuai dari objek transaksi
                          transaksi.totalbelanja,
                          transaksi.uangbayar,
                          transaksi.uangkembali,
                          transaksi.created_at,
                        );

                        await EmsPdfService()
                            .savePdfFile("invoice Transaksi", pdfBytes);
                      } catch (e) {
                        print('Error generating PDF: $e');
                        // Handle error
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF573F7B),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      minimumSize: Size(400, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print, color: Colors.white),
                        SizedBox(width: 20),
                        Text("GENERATE INVOICE",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget buildProductDetailRow(TransactionItem item) {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${item.namaProduk} x ${item.qty}',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
        Text(
          '${currencyFormatter.format(item.totalBelanja)}',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
      ],
    ),
  );
}
