import 'package:project_ecommerce/model/produkModel.dart';

class KategoriProdukModel {
  final String idKategori;
  final String namaKategori;
  final String status;
  final String currentDate;
  final List<ProdukModel> produk;

  KategoriProdukModel({
    this.idKategori,
    this.namaKategori,
    this.status,
    this.currentDate,
    this.produk,
  });

  factory KategoriProdukModel.fromJson(Map<String, dynamic> json) {
    var list = json['produk'] as List;

    List<ProdukModel> produkList =
        list.map((i) => ProdukModel.fromJson(i)).toList();

    return KategoriProdukModel(
      produk: produkList,
      idKategori: json['idKategori'],
      namaKategori: json['namaKategori'],
      status: json['status'],
      currentDate: json['currentDate'],
    );
  }
}
