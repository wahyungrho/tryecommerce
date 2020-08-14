import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_ecommerce/model/produkModel.dart';
import 'package:project_ecommerce/network/api.dart';
import 'package:project_ecommerce/screen/produk/produkDetail.dart';

class CariProduk extends StatefulWidget {
  @override
  _CariProdukState createState() => _CariProdukState();
}

class _CariProdukState extends State<CariProduk> {
  var loading = false;
  List<ProdukModel> list = [];
  List<ProdukModel> listCari = [];

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
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  final price = NumberFormat("#,##0", 'en_US');

  TextEditingController cariController = TextEditingController();

  cari(String text) async {
    listCari.clear();
    if (text.isEmpty) {
      setState(() {});
    }
    list.forEach((a) {
      if (a.namaProduk.toLowerCase().contains(text) ||
          a.harga.toString().contains(text)) listCari.add(a);
    });
    setState(() {});
  }

  Future<void> onRefresh() async {
    getProduk();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Container(
            height: 55,
            padding: EdgeInsets.all(8),
            child: TextField(
                autofocus: true,
                controller: cariController,
                onChanged: cari,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                    hintText: "Cari menu yang ada",
                    fillColor: Colors.white,
                    filled: true,
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
        body: Container(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : cariController.text.isNotEmpty || listCari.length != 0
                  ? GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: listCari.length,
                      itemBuilder: (context, i) {
                        final x = listCari[i];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProdukDetail(x, getProduk())));
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
                                  child: Image.network(
                                    BaseURL.getImageUpload + x.image,
                                    height: 180.0,
                                    fit: BoxFit.cover,
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
                  : Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "Mohon untuk mencari menu keinginan anda hari ini!", textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
        ));
  }
}
