import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce/custom/prefProfile.dart';
import 'package:project_ecommerce/network/api.dart';
import 'package:project_ecommerce/screen/registrasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String namaLengkap, id;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString(PrefProfile.id);
      namaLengkap = pref.getString(PrefProfile.namaLengkap);
      print("Nama Lengkap dan ID User Preference : $namaLengkap , $id");
      id != null ? sessionLogin() : sessionLogout();
    });
  }

  sessionLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Menu()));
  }

  sessionLogout() {}

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // authentikasi untuk validasi real akun user
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  void handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    if (user != null) {
      // print(user.providerData[1].email);
      print(user.providerData[1].displayName);
      cekLogin(user.providerData[1].email);
    }
  }

  String fcmToken;
  generateToken() async {
    fcmToken = await _firebaseMessaging.getToken();
    print("Token Device : $fcmToken");
  }

  void cekLogin(String email) async {
    final response = await http.post(BaseURL.login, body: {
      "email": email, // constructor method (String email)\
      "token": fcmToken,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String idUser = data['idUsers'];
    String namaLengkap = data['namaLengkap'];
    String emailUser = data['email'];
    String phone = data['phone'];
    String createdDate = data['createdDate'];
    String level = data['level'];
    // String kode = data['kode'];
    if (value == 1) {
      // print(data);
      // print(pesan);
      // call method savePref with parameter variable key data['value']
      setState(() {
        savePref(idUser, emailUser, phone, namaLengkap, createdDate, level);
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu()));
    } else {
      print(pesan);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Registrasi(email, fcmToken)));
    }
  }

  savePref(String idUsers, String email, String phone, String namaLengkap,
      String createdDate, String level) async {
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
  void initState() {
    super.initState();
    generateToken();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: InkWell(
            onTap: handleGoogleSignIn,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.red,
                  Colors.purple[200],
                ],
              )),
              child: Text(
                "Google Sign In",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
