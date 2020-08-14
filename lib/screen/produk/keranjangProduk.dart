import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_ecommerce/custom/prefProfile.dart';
import 'package:project_ecommerce/model/cartProdukModel.dart';
import 'package:project_ecommerce/network/api.dart';
import 'package:project_ecommerce/repository/checkoutRepository.dart';
import 'package:project_ecommerce/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeranjangProduk extends StatefulWidget {
  final VoidCallback method;
  // final String id;
  KeranjangProduk(this.method);
  @override
  _KeranjangProdukState createState() => _KeranjangProdukState();
}

class _KeranjangProdukState extends State<KeranjangProduk> {
  final price = NumberFormat("#,##0", 'en_US');
  List<CartProdukModel> list = [];

  String deviceID;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool login = false;
  String idUsers;
  getDeviceInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      deviceID = androidInfo.androidId;
      login = pref.getBool(PrefProfile.login) ?? false;
      idUsers = pref.getString(PrefProfile.id);
    });
    getKeranjangProduk();
  }

  var loading = false;
  var cekData = false;

  getKeranjangProduk() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(BaseURL.getKeranjang + deviceID);
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        setState(() {
          loading = false;
          cekData = false;
        });
      } else {
        // jika datanya tersedia dalam database
        final data = jsonDecode(response.body);
        setState(() {
          for (Map i in data) {
            list.add(CartProdukModel.fromJson(i));
          }
          loading = false;
          cekData = true;
        });
        getSumTotal();
      }
    } else {
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

  Future<void> onRefresh() async {
    getDeviceInfo();
  }

  updateQuantity(CartProdukModel model, String tipe) async {
    await http.post(BaseURL.ubahQuantity, body: {
      "idTmpcart": model.id,
      "tipe": tipe,
    });
    setState(() {
      widget.method();
      getKeranjangProduk();
    });
  }

  var totalHarga = "0";
  getSumTotal() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseURL.getSumTotal + deviceID);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      setState(() {
        loading = false;
        totalHarga = total;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  // patern / state management from class CheckoutRepository
  CheckoutRepository checkoutRepository = CheckoutRepository();
  loginTrue() async {
    await checkoutRepository.checkout(idUsers, deviceID, () {
      setState(() {
        widget.method();
      });
    }, context);
  }

  loginFalse() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keranjang", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : cekData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: onRefresh,
                            child: ListView(
                              children: [
                                ListView.builder(
                                  itemCount: list.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    final x = list[i];
                                    var totalPrice = int.parse(x.qty) * x.harga;
                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Text(
                                                  "Nama Produk : " +
                                                      x.namaProduk,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),

                                                SizedBox(
                                                  height: 5,
                                                ),

                                                Text(
                                                  "Harga : Rp ${price.format(totalPrice)}",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ), // x.harga.toString

                                                Container(
                                                  child: Divider(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                updateQuantity(x,
                                                    "tambah"); // x adalah model dan "tambah" adalah String tipe
                                              },
                                            ),
                                          ),
                                          Container(child: Text("${x.qty}")),
                                          Container(
                                            child: IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                updateQuantity(x, "kurang");
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        totalHarga == "0"
                            ? SizedBox()
                            : Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Total Harga : Rp ${price.format(int.parse(totalHarga))}",
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        login ? loginTrue() : loginFalse();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.orangeAccent,
                                        ),
                                        child: Text(
                                          "Checkout",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Maaf, Kamu belum memiliki produk dalam keranjang",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
    );
  }
}
