import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class EmsPdfService {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  Future<Uint8List> generateEMSPDF(
    int nomorunik,
    String namapelanggan,
    String namaproduk,
    double hargaproduk,
    int qty,
    double totalbelanja,
    double uangbayar,
    double uangkembali,
    String created_at,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                alignment: pw.Alignment.topCenter,
                child: pw.Center(
                  child: pw.Text(
                    "CUCI MOBIL",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "No Transaksi : $nomorunik",
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: pw.Font.courier(),
                      ),
                    ),
                    pw.Text(
                      "Tgl : $created_at",
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(thickness: 2),
              pw.SizedBox(
                height: 20,
              ),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Nama Pelanggan : ",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: pw.Font.courier(),
                      ),
                    ),
                    pw.Text(
                      "$namapelanggan",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Nama Produk : ",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: pw.Font.courier(),
                      ),
                    ),
                    pw.Text(
                      "$namaproduk",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Harga Produk : ",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: pw.Font.courier(),
                      ),
                    ),
                    pw.Text(
                      "${currencyFormatter.format(hargaproduk)}",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Quantity : ",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: pw.Font.courier(),
                      ),
                    ),
                    pw.Text(
                      "$qty",
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Divider(thickness: 2),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 20),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Total Belanja :  ${currencyFormatter.format(totalbelanja)}",
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: pw.Font.courier(),
                      ),
                    ),
                    pw.Text(
                      "Total Bayar : ${currencyFormatter.format(uangbayar)}",
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(thickness: 2),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 20),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Uang Kembali : ${currencyFormatter.format(uangkembali)}",
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(thickness: 2),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      "-- Terimakasih --",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(filePath);
  }
}
