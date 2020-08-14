import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/custom/dynamicLink.dart';
import 'package:project_ecommerce/custom/prefProfile.dart';
import 'package:project_ecommerce/screen/menu/account.dart';
import 'package:project_ecommerce/screen/menu/favourite.dart';
import 'package:project_ecommerce/screen/menu/history.dart';
import 'package:project_ecommerce/screen/menu/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcmToken;


  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Future handleStartupClass() async{
    await _dynamicLinkService.handleDynamicLink(context);
  }

  generateToken() async {
    fcmToken = await _firebaseMessaging.getToken();
    print("FCM Token :$fcmToken");
  }

  String namaLengkap;
  bool login = false;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      namaLengkap = pref.getString(PrefProfile.namaLengkap);
      login = pref.getBool(PrefProfile.login) ?? false;
    });
    print("$namaLengkap, $login");
  }

  int selectIndex = 0;
  @override
  void initState() {
    super.initState();
    generateToken();
    handleStartupClass();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // membuat trigger untuk konten berdasarkan bottom navbar
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: selectIndex != 0,
            child: TickerMode(
              enabled: selectIndex == 0,
              child: Home(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 1,
            child: TickerMode(
              enabled: selectIndex == 1,
              child: Favourite(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 2,
            child: TickerMode(
              enabled: selectIndex == 2,
              child: History(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 3,
            child: TickerMode(
              enabled: selectIndex == 3,
              child: Account(),
            ),
          ),
        ],
      ),
      // design navbar bottom
      bottomNavigationBar: BottomAppBar(
        color: Colors.orangeAccent,
        child: Container(
          height: 55.0,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // sumbu x dalam row
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    selectIndex = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectIndex = 1;
                  });
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectIndex = 2;
                  });
                },
                child: Icon(
                  Icons.history,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectIndex = 3;
                  });
                },
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
