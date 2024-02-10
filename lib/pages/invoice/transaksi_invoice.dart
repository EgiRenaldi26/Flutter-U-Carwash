import 'package:cucimobil_app/model/TransactionsItem.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiPdf extends StatefulWidget {
  @override
  State<TransaksiPdf> createState() => _TransaksiPdfState();
}

class _TransaksiPdfState extends State<TransaksiPdf> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final int nomorunik = args?['nomorunik'] ?? '';
    final String namapelanggan = args?['namapelanggan'] ?? '';
    final double uangbayar = args?['uangbayar'] ?? 0.0;
    final double totalbelanja = args?['totalbelanja'] ?? 0.0;
    final double uangkembali = args?['uangkembali'] ?? 0.0;
    final String created_at = args?['created_at'] ?? '';
    final List<dynamic> items = args?['items'] ?? [];

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
            'Detail Transaksi',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: warna.putih,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        alignment: AlignmentDirectional.centerStart,
        color: warna.putih,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Container(
                child: Column(
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
                                "U - CARWASH",
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
                    SizedBox(
                      height: 10,
                    ),
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
                          "$created_at",
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
                          "$nomorunik",
                          style: TextStyle(
                            fontFamily: "Courier",
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Rincian Pembelian",
                            style: TextStyle(
                              fontFamily: "Courier",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                          "$namapelanggan",
                          style: TextStyle(
                            fontFamily: "Courier",
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 100.0,
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var item in items)
                                buildProductDetailRow(item),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                          "${currencyFormatter.format(totalbelanja)}",
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
                          "${currencyFormatter.format(uangbayar)}",
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
                          "${currencyFormatter.format(uangkembali)}",
                          style: TextStyle(
                            fontFamily: "Courier",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(thickness: 2),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF573F7B),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            minimumSize: Size(400, 50)),
                        child: Text(
                          "Selesai",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildProductDetailRow(TransactionItem item) {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  String formattedPrice = currencyFormatter.format(item.hargaProduk);
  String formattedTotal = currencyFormatter.format(item.totalBelanja);

  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${item.namaProduk}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'courier',
              ),
            ),
            Text(
              "Harga : ${item.totalBelanja}",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'courier',
              ),
            ),
          ],
        ),
        Text(
          "x ${item.qty}",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'courier',
          ),
        ),
      ],
    ),
  );
}
