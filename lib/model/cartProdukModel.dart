class CartProdukModel {
  final String idProduk;
  final String namaProduk;
  final int harga;
  final String deskripsi;
  final String image;
  final String currentDate;
  final String status;
  final String qty;
  final String id;

  CartProdukModel({
    this.idProduk,
    this.namaProduk,
    this.harga,
    this.deskripsi,
    this.image,
    this.currentDate,
    this.status,
    this.qty,
    this.id,
  });

  factory CartProdukModel.fromJson(Map<String, dynamic> json) {
    return CartProdukModel(
      idProduk: json['idProduk'],
      namaProduk: json['namaProduk'],
      harga: json['harga'],
      deskripsi: json['deskripsi'],
      image: json['image'],
      currentDate: json['currentDate'],
      status: json['status'],
      qty: json['qty'],
      id: json['id'],
    );
  }
}
