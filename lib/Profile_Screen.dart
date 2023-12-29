import 'dart:math';

import 'package:cryptoapp_baithi/widgets/transactions.dart';
import 'package:cryptoapp_baithi/widgets/wallet.dart';
import 'package:cryptoapp_baithi/widgets/data.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static Random random = Random();
  String name = Data.names[random.nextInt(10)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      appBar: AppBar(
        leading: Icon(Icons.menu),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/cm${random.nextInt(10)}.jpeg"),
              radius: 25,
            ),
            title: Text(
              "Nguyễn Tiến Đạt",
              style: TextStyle(
                color: Colors.white, // Set text color to white
              ),
            ),
            subtitle: Text(
              "babywhite1412@gmail.com",
              style: TextStyle(
                color: Colors.white, // Set text color to white
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TabBar(
                    isScrollable: false,
                    tabs: <Widget>[
                      Tab(
                        text: "Wallets",
                      ),
                      Tab(
                        text: "Transactions",
                      ),
                      Tab(
                        text: "Buy/Sell",
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height * 2,
                    child: TabBarView(
                      children: <Widget>[
                        Wallets(),
                        Transactions(),
                        PlaceholderWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Buy/Sell Content"),

    );
  }
}
