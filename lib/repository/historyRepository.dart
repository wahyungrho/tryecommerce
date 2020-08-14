import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:project_ecommerce/model/historyModel.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce/network/api.dart';

class HistoryRepository {
  Future fetchData(
    List<HistoryModel> list,
    String idUsers,
    VoidCallback reload,
    bool cekData,
  ) async {
    reload(); // function state sederhana
    list.clear();
    final response = await http.get(BaseURL.urlHistory + idUsers);
    if (response.statusCode == 200) {
      reload();
      if (response.contentLength == 2) {
        cekData = false;
      } else {
        final data = jsonDecode(response.body);
        for (Map i in data) {
          list.add(HistoryModel.fromJson(i));
        }
        cekData = true;
      }
    } else {
      reload();
    }
  }
}
