import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ecommerce/model/produkModel.dart';
import 'package:project_ecommerce/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce/screen/produk/produkDetail.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<ProdukModel> list = [];
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;

  getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // print("Device Info : ${androidInfo.androidId}");
    setState(() {
      deviceID = androidInfo.androidId;
    });
    getProduk();
  }

  var loading = false;
  var cekData = false;

  getProduk() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(BaseURL.getFavouritNotLogin + deviceID);
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        setState(() {
          loading = false;
          cekData = false;
        });
      } else {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          for (Map i in data) {
            list.add(ProdukModel.fromJson(i));
          }
          loading = false;
          cekData = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

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
        getProduk();
        loading = false;
      });
    } else {
      print(pesan);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> onRefresh() async {
    // getProduk();
    getDeviceInfo();
  }

  final price = NumberFormat("#,##0", 'en_US');

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[
            loading
                ? Center(child: CircularProgressIndicator())
                : cekData
                    ? GridView.builder(
                        padding: EdgeInsets.all(10.0),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                      builder: (context) =>
                                          ProdukDetail(x, getProduk)));
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      )
                    : Container(
                      margin: EdgeInsets.only(top: 50.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "Maaf, Kamu belum memiliki produk Favorit",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                    ),
          ],
        ),
      ),
    );
  }
}
