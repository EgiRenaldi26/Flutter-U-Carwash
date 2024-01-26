import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image(
                    width: 100,
                    height: 100,
                    image: AssetImage("image/favicon.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Transactions Success!",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'inter',
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 360,
            height: 533,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                )),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: AlignmentDirectional.centerStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
