class BaseURL {
  static String urlProduk = "http://192.168.43.3/ecommerce/api/produk";
  static String urlFavourite = "http://192.168.43.3/ecommerce/api/favourite";
  static String urlKeranjang = "http://192.168.43.3/ecommerce/api/keranjang";
  static String urlAuth = "http://192.168.43.3/ecommerce/api/auth";
  static String urlCheckout = "http://192.168.43.3/ecommerce/api/checkout/checkout.php";
  static String urlHistory = "http://192.168.43.3/ecommerce/api/history/getHistory.php?idUsers=";
  static String tambahProduk = "$urlProduk/tambahProduk.php";
  static String lihatProduk = "$urlProduk/lihatProduk.php";
  static String lihatProdukKategori = "$urlProduk/getProdukWithCategory.php";
  static String getImageUpload = "http://192.168.43.3/ecommerce/upload/";
  static String tambahFavouritNotLogin = "$urlFavourite/favouriteNotLogin.php";
  static String getFavouritNotLogin = "$urlFavourite/getFavouriteNotLogin.php?deviceInfo=";
  static String tambahKeranjang = "$urlKeranjang/tambahKeranjang.php";
  static String getKeranjang = "$urlKeranjang/getKeranjang.php?unikId=";
  static String totalKeranjang = "$urlKeranjang/totalKeranjang.php?unikId=";
  static String ubahQuantity = "$urlKeranjang/ubahQuantityProduk.php";
  static String getSumTotal = "$urlKeranjang/getHargaQty.php?unikId=";
  static String login = "$urlAuth/cekEmail.php";
  static String registrasi = "$urlAuth/registrasi.php";
  static String getProductDetail = "$urlProduk/getProdukDetail.php?idProduk="; // firebase dinamic link

}