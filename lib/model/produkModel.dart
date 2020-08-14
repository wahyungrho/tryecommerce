class ProdukModel {
  final String idProduk;
  final String namaProduk;
  final int harga;
  final String deskripsi;
  final String image;
  final String currentDate;
  final String status;

  ProdukModel(
      {this.idProduk,
      this.namaProduk,
      this.harga,
      this.deskripsi,
      this.image,
      this.currentDate,
      this.status});

      factory ProdukModel.fromJson(Map<String, dynamic> json) {
        return ProdukModel(
          idProduk: json['idProduk'],
          namaProduk: json['namaProduk'],
          harga: json['harga'],
          deskripsi: json['deskripsi'],
          image: json['image'],
          currentDate: json['currentDate'],
          status: json['status'],
        );
      }
}
