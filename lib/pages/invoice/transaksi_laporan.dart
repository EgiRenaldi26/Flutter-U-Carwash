import 'dart:io';
import 'dart:typed_data';

import 'package:cucimobil_app/model/TransactionsItem.dart'; // Sesuaikan dengan path yang benar
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
    List<TransactionItem> items,
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
            children: [
              pw.Container(
                alignment: pw.Alignment.topCenter,
                child: pw.Text(
                  "U - CARWASH",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "Jl. Arief Rahman Hakim No.35, Cigadung, Kec. Subang, Kabupaten Subang, Jawa Barat 41213",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 8,
                    font: pw.Font.courier(),
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
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 10),
              for (var item in items)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "${item.namaProduk}",
                          style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.courier(),
                          ),
                        ),
                        pw.Text(
                          "Harga : ${currencyFormatter.format(item.totalBelanja)}",
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.courier(),
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      "x ${item.qty}",
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        font: pw.Font.courier(),
                      ),
                    ),
                  ],
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
                      "-- Terimakasih Atas Kunjungan Anda --",
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
