class TransactionItem {
  String productId;
  String namaProduk;
  double hargaProduk;
  int qty;
  double totalBelanja;

  TransactionItem({
    required this.productId,
    required this.namaProduk,
    required this.hargaProduk,
    required this.qty,
    required this.totalBelanja,
   
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'namaProduk': namaProduk,
      'hargaProduk': hargaProduk,
      'qty': qty,
      'totalBelanja': totalBelanja,
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      productId: map['productId'],
      namaProduk: map['namaProduk'],
      hargaProduk: map['hargaProduk'],
      qty: map['qty'],
      totalBelanja: map['totalBelanja'],
    );
  }
}
