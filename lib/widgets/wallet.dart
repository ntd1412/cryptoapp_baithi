import 'package:cryptoapp_baithi/widgets/data.dart';
import 'package:cryptoapp_baithi/Profile_Screen.dart';
import 'package:cryptoapp_baithi/widgets/wallets.dart';
import 'package:flutter/material.dart';

class Wallets extends StatefulWidget {
  @override
  _WalletsState createState() => _WalletsState();
}

class _WalletsState extends State<Wallets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: Data.coins.length,
        itemBuilder: (BuildContext context, int index) {
          Map coin = Data.coins[index];
          return wallets(
            name: coin['name'],
            icon: coin['icon'],
            rate: coin['rate'],
          );
        },
      ),
    );
  }
}
