import 'package:cucimobil_app/model/TransactionsItem.dart';

class TransactionsM {
  final int nomorunik;
  final String namapelanggan;
  final List<TransactionItem> items;
  final double uangbayar;
  final double totalbelanja;
  final double uangkembali;
  final String created_at;
  final String updated_at;

  TransactionsM({
    required this.nomorunik,
    required this.namapelanggan,
    required this.items,
    required this.uangbayar,
    required this.totalbelanja,
    required this.uangkembali,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'nomorunik': nomorunik,
      'namapelanggan': namapelanggan,
      'items': items.map((item) => item.toMap()).toList(),
      'uangbayar': uangbayar,
      'totalbelanja': totalbelanja,
      'uangkembali': uangkembali,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory TransactionsM.fromMap(Map<String, dynamic> map) {
    return TransactionsM(
      nomorunik: map['nomorunik'],
      namapelanggan: map['namapelanggan'],
      items: List<TransactionItem>.from(
          map['items']?.map((x) => TransactionItem.fromMap(x))),
      uangbayar: map['uangbayar'],
      totalbelanja: map['totalbelanja'],
      uangkembali: map['uangkembali'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );
  }
}
