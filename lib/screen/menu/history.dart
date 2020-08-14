import 'package:flutter/material.dart';
import 'package:project_ecommerce/custom/prefProfile.dart';
import 'package:project_ecommerce/model/historyModel.dart';
import 'package:project_ecommerce/repository/historyRepository.dart';
import 'package:project_ecommerce/screen/login.dart';
import 'package:project_ecommerce/screen/menu/historyDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool login = false;
  String id, namaLengkap;
  HistoryRepository historyRepository = HistoryRepository();
  List<HistoryModel> list = [];
  var loading = false;
  var cekData = false;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      login = pref.getBool(PrefProfile.login) ?? false;
      id = pref.getString(PrefProfile.id);
      namaLengkap = pref.getString(PrefProfile.namaLengkap);
    });

    await historyRepository.fetchData(list, id, () {
      setState(() {
        loading = true;
      });
    }, cekData);
    print("list 0 : ${list[0].noInvoice}");
  }

  Future<void> refresh() async {
    getPref();
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
        ),
        body: login
            ? Container(
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView(
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.all(16.0),
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final x = list[i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HistoryDetail(x)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(x.noInvoice),
                                  Text(x.createdDate),
                                  Text(x.status == "0" ? "PENDING" : "SUCCES"),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text(
                            "Sign In",
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ));
  }
}
