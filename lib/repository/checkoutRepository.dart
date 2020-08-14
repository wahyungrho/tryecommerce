import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce/network/api.dart';

class CheckoutRepository {
  checkout(
    String idUsers,
    String deviceID,
    VoidCallback method,
    BuildContext context,
  ) async {
    final response = await http.post(BaseURL.urlCheckout, body: {
      "idUsers": idUsers,
      "unikId": deviceID,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      method();
      showDialog(
          context: context,
          builder: (context) {
            return Platform.isAndroid
                ? AlertDialog(
                    title: Text("Information"),
                    content: Text("$pesan"),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Ok"),
                      )
                    ],
                  )
                : CupertinoAlertDialog(
                    title: Text("Information"),
                    content: Text("$pesan"),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Ok"),
                      )
                    ],
                  );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Platform.isAndroid
                ? AlertDialog(
                    title: Text("Warning !"),
                    content: Text("$pesan"),
                    actions: [
                      FlatButton(
                        onPressed: () {},
                        child: Text("Ok"),
                      )
                    ],
                  )
                : CupertinoAlertDialog(
                    title: Text("Warning !"),
                    content: Text("$pesan"),
                    actions: [
                      FlatButton(
                        onPressed: () {},
                        child: Text("Ok"),
                      )
                    ],
                  );
          });
    }
  }
}
