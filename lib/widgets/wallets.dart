import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cryptoapp_baithi/widgets/data.dart';

class wallets extends StatefulWidget {
  final String name;
  final String icon;
  final String rate;

  const wallets({
    Key? key,
    required this.name,
    required this.icon,
    required this.rate,
  }) : super(key: key);

  @override
  _walletsState createState() => _walletsState();
}

class _walletsState extends State<wallets> {
  final List<Map<String, dynamic>> data = Data.transactions;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "${widget.icon}",
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${widget.name}",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${widget.rate}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            for (var transaction in data)
              ListTile(
                title: Text(transaction["name"]),
                subtitle: Text("${transaction["type"]} - ${transaction["amount"]}"),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(transaction["dp"]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
