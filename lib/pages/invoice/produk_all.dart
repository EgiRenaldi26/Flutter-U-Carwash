import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> printPdfAllProducts(List<DocumentSnapshot> products) async {
  final pdf = pw.Document();

  if (products.isNotEmpty) {
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            children: [
              pw.Text('LAPORAN TRANSAKSI', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(
                height: 10,
              ),
              pw.Divider(
                thickness: 2,
              ),
              pw.SizedBox(height: 25),
              pw.Container(
                width: double.infinity,
                child: pw.Table.fromTextArray(
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                  ),
                  cellStyle: pw.TextStyle(
                    fontSize: 6, // Adjust the font size for data cells
                  ),
                  headers: [
                    'Nama Pelanggan',
                    'Total Belanja',
                    'Uang Bayar',
                    'Uang Kembali',
                    'Created At',
                  ],
                  data: List<List<String>>.generate(
                    products.length,
                    (index) => [
                      products[index]['namaproduk'],
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format(products[index]['hargaproduk']),
                      products[index]['deskripsi'],
                      DateFormat('yyyy-MM-dd').format(
                          DateTime.parse(products[index]['created_at'])),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    ));

    // Save the generated PDF to a temporary file
    final Uint8List pdfBytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final tempFile = await File('${tempDir.path}/LAPORAN TRANSAKSI ALL.pdf')
        .writeAsBytes(pdfBytes);

    // Open the PDF using the open_file package
    OpenFile.open(tempFile.path);
  } else {
    // Show a message if no transactions found
    print('No transactions found.');
  }
}
