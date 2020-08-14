import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_ecommerce/custom/prefProfile.dart';
import 'package:project_ecommerce/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool login = false;
  String email, phone, namaLengkap;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      login = pref.getBool(PrefProfile.login) ?? false;
      email = pref.getString(PrefProfile.email);
      phone = pref.getString(PrefProfile.phone);
      namaLengkap = pref.getString(PrefProfile.namaLengkap);
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(PrefProfile.id);
    pref.remove(PrefProfile.email);
    pref.remove(PrefProfile.phone);
    pref.remove(PrefProfile.namaLengkap);
    pref.remove(PrefProfile.createdDate);
    pref.remove(PrefProfile.level);
    pref.remove(PrefProfile.kode);
    pref.remove(PrefProfile.login);
    _auth.signOut();
    googleSignIn.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        actions: [
          login
              ? IconButton(
                  onPressed: signOut,
                  icon: Icon(Icons.lock_open),
                )
              : SizedBox(),
        ],
      ),
      body: login
          ? Container(
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("$namaLengkap"),
                      Text("$email"),
                      Text("$phone"),
                    ],
                  )
                ],
              ),
            )
          : Container(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Silahkan Login dibawah ini",
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                      )),
                )
              ],
            )),
    );
  }
}
