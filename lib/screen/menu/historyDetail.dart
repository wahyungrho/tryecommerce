import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ecommerce/model/historyModel.dart';

class HistoryDetail extends StatefulWidget {
  final HistoryModel model;
  const HistoryDetail(this.model);
  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final price = NumberFormat("#,##0", 'eN_US');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(widget.model.noInvoice),
          Text(widget.model.createdDate),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          ListView.builder(
            itemCount: widget.model.detail.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final y = widget.model.detail[i];
              final totalHarga = int.parse(y.qty) * int.parse(y.price);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("${y.namaProduk}"),
                  Text("${y.qty}"),
                  Text("Rp ${price.format(int.parse(y.price))}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Belanja : ", style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("Rp ${price.format(totalHarga)}"),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
