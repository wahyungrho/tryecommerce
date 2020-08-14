import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce/model/kategoriProdukModel.dart';
import 'package:project_ecommerce/network/api.dart';

class PilihKategoriProduk extends StatefulWidget {
  @override
  _PilihKategoriProdukState createState() => _PilihKategoriProdukState();
}

class _PilihKategoriProdukState extends State<PilihKategoriProduk> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProdukKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pilih Kategori Produk"),
          elevation: 1,
        ),
        body: Container(
            child: loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: listKategori.length,
                    itemBuilder: (context, i) {
                      final y = listKategori[i];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, y);
                        },
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(y.namaKategori),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        )),
                      );
                    })));
  }
}
