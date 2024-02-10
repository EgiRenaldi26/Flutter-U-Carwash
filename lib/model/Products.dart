class ProductM {
  final String id;
  final String namaproduk;
  final double hargaproduk;
  final String deskripsi;
  final String createdat;
  final String updatedat;

  ProductM({
    required this.id,
    required this.namaproduk,
    required this.hargaproduk,
    required this.deskripsi,
    required this.createdat,
    required this.updatedat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaproduk': namaproduk,
      'hargaproduk': hargaproduk,
      'deskripsi': deskripsi,
      'createdat': createdat,
      'updatedat': updatedat,
    };
  }
}
