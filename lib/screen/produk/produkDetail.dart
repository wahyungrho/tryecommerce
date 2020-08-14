import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ecommerce/custom/dynamicLink.dart';
import 'package:project_ecommerce/model/produkModel.dart';
import 'package:project_ecommerce/network/api.dart';
import 'package:http/http.dart' as http;

class ProdukDetail extends StatefulWidget {
  final ProdukModel model;
  final VoidCallback reload;
  ProdukDetail(this.model, this.reload);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceID;

  getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // print("Device Info : ${androidInfo.androidId}");
    setState(() {
      deviceID = androidInfo.androidId;
    });
  }

  tambahKeranjang() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Processing"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Loading ..."),
                ],
              ),
            ),
          );
        });
    final response = await http.post(BaseURL.tambahKeranjang, body: {
      "unikId": deviceID,
      "idProduk": widget.model.idProduk,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Informasi"),
                content: Text(pesan),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                        widget.reload();
                      });
                    },
                    child: Text("Ok"),
                  )
                ],
              );
            });
      });
    } else {
      setState(() {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Warning"),
                content: Text(pesan),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Ok"),
                  )
                ],
              );
            });
      });
    }
  }

  DynamicLinkService _dynamicLinkService = DynamicLinkService();
  var url;
  createdLinkShare(idProduk) async {
    url = await _dynamicLinkService.createdShareLink(idProduk);
    print(url);
  }

  // var loading = false;
  // // var cekData = false;
  // List<ProdukModel> list = [];
  // lihatKeranjang() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   list.clear();
  //   final response = await http.get(BaseURL.getKeranjang + deviceID);
  //   if (response.statusCode == 200) {
  //     if (response.contentLength == 2) {
  //       setState(() {
  //         loading = false;
  //         // cekData = false;
  //       });
  //     } else {
  //       final data = jsonDecode(response.body);
  //       setState(() {
  //         for (Map i in data) {
  //           list.add(ProdukModel.fromJson(i));
  //         }
  //         loading = false;
  //       });
  //     }
  //   } else {
  //     loading = false;
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceInfo();
  }

  final price = NumberFormat("#,##0", 'en_US');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(icon: Icon(Icons.share), onPressed: (){
          createdLinkShare(widget.model.idProduk);
        },)],
        title: Text(widget.model.namaProduk),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                Image.network(
                  BaseURL.getImageUpload + widget.model.image,
                  height: 180.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  widget.model.namaProduk,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(color: Colors.grey),
                ),
                Text(
                  widget.model.deskripsi,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(16.0),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(16),
                //   color: Colors.orangeAccent,
                // ),
                child: Text(
                  "Rp. " + price.format(widget.model.harga),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  tambahKeranjang();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.orangeAccent,
                  ),
                  child: Text(
                    "Add to cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
