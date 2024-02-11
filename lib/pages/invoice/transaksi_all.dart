import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

double calculateOverallTotal(List<DocumentSnapshot> transactions) {
  double overallTotal = 0;

  for (var transaction in transactions) {
    overallTotal += transaction['totalbelanja'];
  }

  return overallTotal;
}

Future<void> printPdfByDate(
    DateTime selectedDate, List<DocumentSnapshot> transactions) async {
  final pdf = pw.Document();

  // Filter transactions based on the selected date
  List<DocumentSnapshot> transactionsByDate = transactions.where((transaction) {
    final tanggalTransaksiString = transaction['created_at'];
    final tanggalTransaksi = DateTime.parse(tanggalTransaksiString);
    return tanggalTransaksi.day == selectedDate.day &&
        tanggalTransaksi.month == selectedDate.month &&
        tanggalTransaksi.year == selectedDate.year;
  }).toList();

  if (transactionsByDate.isNotEmpty) {
    // Calculate overall total
    double overallTotal = calculateOverallTotal(transactionsByDate);
    // Add content to the PDF using pdf package functions
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
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "PT U - CARWASH",
                    style: pw.TextStyle(
                        fontSize: 12, fontBold: pw.Font.helveticaBold()),
                  ),
                  pw.Text(
                    "Tanggal : ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
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
                    transactionsByDate.length,
                    (index) => [
                      transactionsByDate[index]['namapelanggan'],
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format(transactionsByDate[index]['totalbelanja']),
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format(transactionsByDate[index]['uangbayar']),
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format(transactionsByDate[index]['uangkembali']),
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "Total Keseluruhan : ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(overallTotal)}",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ));

    // Save the generated PDF to a temporary file
    final Uint8List pdfBytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final tempFile = await File(
            '${tempDir.path}/LAPORAN TRANSAKSI${DateFormat('yyyy-MM-dd').format(selectedDate)}.pdf')
        .writeAsBytes(pdfBytes);

    // Open the PDF using the open_file package
    OpenFile.open(tempFile.path);
  } else {
    // Show a message if no transactions found for the selected date
    print('No transactions found for the selected date.');
  }
}
