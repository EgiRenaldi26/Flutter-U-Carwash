import 'dart:typed_data';

import 'package:cucimobil_app/pages/invoice/transaksi_laporan.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class TransaksiSukses extends StatefulWidget {
  final int nomorunik;
  final String namapelanggan;
  final String namabarang;
  final double hargasatuan;
  final int qty;
  final double totalbelanja;
  final double uangbayar;
  final double uangkembali;
  final String created_at;

  const TransaksiSukses(
      {required this.nomorunik,
      required this.namapelanggan,
      required this.namabarang,
      required this.hargasatuan,
      required this.qty,
      required this.totalbelanja,
      required this.uangbayar,
      required this.uangkembali,
      required this.created_at});

  @override
  State<TransaksiSukses> createState() => _TransaksiSuksesState();
}

class _TransaksiSuksesState extends State<TransaksiSukses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF573F7B),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          width: 360,
          height: 520,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                alignment: AlignmentDirectional.centerStart,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Container(
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    child: Image(
                                      width: 100,
                                      height: 100,
                                      image: AssetImage("image/sukses.png"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rincian Pembelian",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
                                  "Nomor Unik :",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${widget.nomorunik}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Nama Pelanggan :",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${widget.namapelanggan}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Nama Produk :",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${widget.namabarang}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Harga Produk :",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Rp. ${widget.hargasatuan}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quantity :",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${widget.qty}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Bayar :",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Rp. ${widget.totalbelanja}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
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
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Rp. ${widget.uangkembali}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 80),
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Panggil fungsi generateEMSPDF untuk membuat PDF
                                  Uint8List pdfBytes =
                                      await EmsPdfService().generateEMSPDF(
                                    widget.nomorunik,
                                    widget.namapelanggan,
                                    widget.namabarang,
                                    widget.hargasatuan,
                                    widget.qty,
                                    widget.totalbelanja,
                                    widget.uangbayar,
                                    widget.uangkembali,
                                    widget.created_at,
                                  );

                                  // Simpan PDF ke file
                                  await EmsPdfService().savePdfFile(
                                      "Invoice Transaksi", pdfBytes);

                                  // Tampilkan PDF setelah disimpan
                                  OpenFile.open("path/ke/file/NamaFilePDF.pdf");
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
