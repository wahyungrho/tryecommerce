import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce/custom/prefProfile.dart';
import 'package:project_ecommerce/network/api.dart';
import 'package:project_ecommerce/screen/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registrasi extends StatefulWidget {
  // constructor variabel value email
  final String email;
  final String token;
  Registrasi(this.email, this.token);

  @override
  _RegistrasiState createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  TextEditingController namaLengkap = TextEditingController();
  TextEditingController phone = TextEditingController();

  // global key untuk formstate
  final _key = GlobalKey<FormState>();
  cek() {
    if (_key.currentState.validate()) {
      simpan();
    }
  }

  simpan() async {
    final response = await http.post(BaseURL.registrasi, body: {
      "email": widget.email,
      "phone": phone.text,
      "namaLengkap": namaLengkap.text,
      "token": widget.token,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String idUser = data['idUsers'];
    String namaLengkapUser = data['namaLengkap'];
    String emailUser = data['email'];
    String phoneUser = data['phone'];
    String createdDate = data['createdDate'];
    String level = data['level'];
    if (value == 1) {
      // print(pesan);
      setState(() {
        savePref(idUser, emailUser, phoneUser, namaLengkapUser, createdDate, level);
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu()));
    } else {
      print(pesan);
    }
  }
  
  savePref(
    String idUsers,
    String email,
    String phone,
    String namaLengkap,
    String createdDate,
    String level,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString(PrefProfile.id, idUsers);
      pref.setString(PrefProfile.email, email);
      pref.setString(PrefProfile.phone, phone);
      pref.setString(PrefProfile.namaLengkap, namaLengkap);
      pref.setString(PrefProfile.createdDate, createdDate);
      pref.setString(PrefProfile.level, level);
      pref.setBool(PrefProfile.login, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(
                controller: namaLengkap,
                validator: (e) {
                  if (e.isEmpty)
                    return "Silahkan masukkan Nama Lengkap anda";
                  else
                    null;
                },
                decoration: InputDecoration(hintText: "Nama Lengkap"),
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phone,
                validator: (e) {
                  if (e.isEmpty)
                    return "Silahkan masukkan Nomor Telepon anda";
                  else
                    null;
                },
                decoration: InputDecoration(hintText: "No Telepon"),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: cek,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.red,
                          Colors.purple[200],
                        ],
                      )),
                  child: Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
