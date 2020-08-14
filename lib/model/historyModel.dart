class HistoryModel {
  final String id;
  final String noInvoice;
  final String createdDate;
  final String status;

  // data at history detail > 1 use List
  final List<HistoryDetailModel> detail;

  HistoryModel({
    this.id,
    this.noInvoice,
    this.createdDate,
    this.status,
    this.detail,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    // variable untuk parsing list detail
    var list = json['detail'] as List;
    List<HistoryDetailModel> dataListDetail =
        list.map((e) => HistoryDetailModel.fromJson(e)).toList();
    return HistoryModel(
      id: json['id'],
      noInvoice: json['noInvoice'],
      createdDate: json['createdDate'],
      status: json['status'],
      detail: dataListDetail,
    );
  }
}

class HistoryDetailModel {
  final String id;
  final String idProduct;
  final String qty;
  final String price;
  final String discount;
  final String namaProduk;
  final String image;

  // change to properti
  HistoryDetailModel({
    this.id,
    this.idProduct,
    this.qty,
    this.price,
    this.discount,
    this.namaProduk,
    this.image,
  });

  //call method class must be call factory
  factory HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailModel(
      id: json['id'],
      idProduct: json['idProduct'],
      qty: json['qty'],
      price: json['price'],
      discount: json['discount'],
      namaProduk: json['namaProduk'],
      image: json['image'],
    );
  }
}
