import 'dart:convert';
import 'package:async/async.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:project_ecommerce/model/kategoriProdukModel.dart';
import 'package:project_ecommerce/network/api.dart';
import 'package:project_ecommerce/screen/produk/pilihKategori.dart';

class TambahProduk extends StatefulWidget {
  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  File image;

  _gallery() async {
    var _image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      image = _image;
    });
  }

  _camera() async {
    var _image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      image = _image;
    });
  }

  // controller untuk TextField
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();

  KategoriProdukModel model;

  pilihKategori() async {
    model = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PilihKategoriProduk()));

    setState(() {
      // trigger ketika namaKategori di klik akan membawa nilai kategori
      kategoriController = TextEditingController(text: model.namaKategori);
    });
  }

  save() async {
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
    try {
      var stream = http.ByteStream(DelegatingStream.typed(image
          .openRead())); // delegating strem must be import package async.dart
      var length = await image.length();
      var url = Uri.parse(BaseURL.tambahProduk);
      var request = http.MultipartRequest('POST', url);
      var multipartFile = http.MultipartFile("image", stream, length,
          filename: path.basename(image.path));
      request.fields['idKategori'] = model.idKategori;
      request.fields['namaProduk'] = namaController.text;
      request.fields['harga'] = hargaController.text;
      request.fields['deskripsi'] = deskripsiController.text;
      request.files.add(multipartFile);
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        final data = jsonDecode(value);
        int getValue = data['value'];
        String getPesan = data['message'];
        if (getValue == 1) {
          setState(() {
            Navigator.pop(context);
            print(getPesan);
          });
        } else {
          setState(() {
            Navigator.pop(context);
            print(getPesan);
          });
        }
      });
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text("Tambah Produk"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                pilihKategori();
              },
              child: TextField(
                enabled: false,
                controller: kategoriController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Kategori Product",
                ),
              ),
            ),
            TextField(
              controller: namaController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Nama Product",
              ),
            ),
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Harga",
              ),
            ),
            TextField(
              controller: deskripsiController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Deskripsi Produk",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: _camera,
              child: image == null
                  ? Image.asset(
                      "././assets/images/placeholder.png",
                      fit: BoxFit.cover,
                    )
                  : Image.file(image, height: 200.0, fit: BoxFit.fill),
            ),
            SizedBox(
              height: 16.0,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  save();
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.orange,
                        Colors.orangeAccent,
                        Colors.deepOrange
                      ]),
                ),
                child: Text(
                  "Save Menu",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
