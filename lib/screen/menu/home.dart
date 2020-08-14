import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ecommerce/model/kategoriProdukModel.dart';
import 'package:project_ecommerce/model/produkModel.dart';
import 'package:project_ecommerce/network/api.dart';
import 'package:project_ecommerce/screen/produk/cariProduk.dart';
import 'package:project_ecommerce/screen/produk/keranjangProduk.dart';
import 'package:project_ecommerce/screen/produk/produkDetail.dart';
import 'package:project_ecommerce/screen/produk/tambahProduk.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;

  getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Device Info : ${androidInfo.androidId}");
    setState(() {
      deviceID = androidInfo.androidId;
    });
    getTotalKerangjang();
  }

  var loading;

  List<KategoriProdukModel> listKategori = [];

  getProdukKategori() async {
    setState(() {
      loading = true;
    });
    listKategori.clear();
    final response = await http.get(BaseURL.lihatProdukKategori);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      setState(() {
        for (Map i in data) {
          listKategori.add(KategoriProdukModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  var filter = false;

  List<ProdukModel> list = [];

  getProduk() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(BaseURL.lihatProduk);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      setState(() {
        for (Map i in data) {
          list.add(ProdukModel.fromJson(i));
          loading = false;
        }
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  var loadingCart = false;
  var jumlahCart = "0";
  getTotalKerangjang() async {
    setState(() {
      loadingCart = true;
    });
    final response = await http.get(BaseURL.totalKeranjang + deviceID);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String jumlah = data['jumlah'];
      setState(() {
        loadingCart = false;
        jumlahCart = jumlah;
      });
    } else {
      setState(() {
        loadingCart = false;
      });
    }
  }

  final price = NumberFormat("#,##0", 'en_US');

  Future<void> onRefresh() async {
    getProduk();
    // getTotalKerangjang();
    getProdukKategori();
    setState(() {
      filter = false;
    });
  }

  int index = 0;

  // menambahkan favorit
  addFavoritNotLogin(ProdukModel model) async {
    setState(() {
      loading = true;
    });
    final response = await http.post(BaseURL.tambahFavouritNotLogin,
        body: {"deviceInfo": deviceID, "idProduk": model.idProduk});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
        loading = false;
      });
    } else {
      print(pesan);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduk();
    // getTotalKerangjang();
    getProdukKategori();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: Stack(children: <Widget>[
                Icon(Icons.shopping_cart),
                jumlahCart == "0"
                    ? SizedBox()
                    : Positioned(
                        top: -4,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: Text(jumlahCart,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0)),
                        ))
              ]),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KeranjangProduk(getTotalKerangjang, )));
              },
            ),
          ],
          backgroundColor: Colors.orangeAccent,
          title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CariProduk()));
            },
            child: Container(
              height: 55,
              padding: EdgeInsets.all(8),
              child: TextField(
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                      hintText: "Cari menu yang ada",
                      fillColor: Colors.white,
                      filled: true,
                      enabled: false,
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(style: BorderStyle.none)))),
            ),
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TambahProduk()));
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.orangeAccent),
            child: Text(
              "Tambah Produk",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    // Kategori Produk
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      height: 50.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: listKategori.length,
                        itemBuilder: (context, i) {
                          final a = listKategori[i];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                filter = true;
                                index = i;
                                print(filter);
                              });
                            },
                            child: Container(
                              width: 120.0,
                              margin: EdgeInsets.only(
                                right: 10.0,
                                left: 10,
                              ),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: Text(
                                a.namaKategori,
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Produk
                    filter
                        ? listKategori[index].produk.length == 0
                            ? Container(
                                margin: EdgeInsets.only(top: 50.0),
                                child: Center(
                                  child: Text(
                                      "Maaf Produk dalam kategori ini belum tersedia ..."),
                                ))
                            : GridView.builder(
                                padding: EdgeInsets.all(10.0),
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemCount: listKategori[index].produk.length,
                                itemBuilder: (context, i) {
                                  final x = listKategori[index].produk[i];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProdukDetail(
                                                      x, getTotalKerangjang)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey[300],
                                        ),
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.grey[300],
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  BaseURL.getImageUpload +
                                                      x.image,
                                                  height: 180.0,
                                                  width: 180.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 40.0,
                                                      width: 40.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .favorite_border,
                                                          ),
                                                          onPressed: () {
                                                            addFavoritNotLogin(
                                                                x);
                                                          }),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            x.namaProduk,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Text(
                                            "Rp. " + price.format(x.harga),
                                            style: TextStyle(
                                              color: Colors.orangeAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                        : GridView.builder(
                            padding: EdgeInsets.all(10.0),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              final x = list[i];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProdukDetail(
                                              x, getTotalKerangjang)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey[300],
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        color: Colors.grey[300],
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              BaseURL.getImageUpload + x.image,
                                              height: 180.0,
                                              width: 180.0,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                                top: 0,
                                                right: 3,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white),
                                                  child: IconButton(
                                                      icon: Icon(
                                                        Icons.favorite_border,
                                                      ),
                                                      onPressed: () {
                                                        addFavoritNotLogin(x);
                                                      }),
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        x.namaProduk,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        "Rp. " + price.format(x.harga),
                                        style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
                onRefresh: onRefresh));
  }
}
