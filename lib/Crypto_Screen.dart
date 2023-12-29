import 'dart:async';

import 'package:cryptoapp_baithi/Chart_Screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({Key? key}) : super(key: key);

  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  List<dynamic> cryptoData = [];
  bool sortByPriceAscending = true;
  bool sortBy24hPercentageAscending = true;
  bool sortByMarketCapAscending = true;

  String formatMarketCap(int marketCap) {
    const int trillion = 1000000000000;
    const int billion = 1000000000;
    const int million = 1000000;

    if (marketCap >= trillion) {
      return (marketCap / trillion).toStringAsFixed(2) + 'T';
    } else if (marketCap >= billion) {
      return (marketCap / billion).toStringAsFixed(2) + 'B';
    } else if (marketCap >= million) {
      return (marketCap / million).toStringAsFixed(2) + 'M';
    } else {
      return marketCap.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchCryptoData() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false'));
    if (response.statusCode == 200) {
      setState(() {
        cryptoData = json.decode(response.body);
      });
    } else {
      throw Exception('Bị chặn API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Crypto App",
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Color.fromRGBO(11, 12, 54, 1),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 5.0),
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'Currency',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    sortByPriceAscending = !sortByPriceAscending;
                    cryptoData.sort((a, b) => sortByPriceAscending
                        ? a['current_price']
                            .toDouble()
                            .compareTo(b['current_price'].toDouble())
                        : b['current_price']
                            .toDouble()
                            .compareTo(a['current_price'].toDouble()));
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Price ${sortByPriceAscending ? '▲' : '▼'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    sortByMarketCapAscending = !sortByMarketCapAscending;
                    cryptoData.sort((a, b) => sortByMarketCapAscending
                        ? a['market_cap']
                            .toDouble()
                            .compareTo(b['market_cap'].toDouble())
                        : b['market_cap']
                            .toDouble()
                            .compareTo(a['market_cap'].toDouble()));
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Market Cap ${sortByMarketCapAscending ? '▲' : '▼'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 35.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    sortBy24hPercentageAscending =
                        !sortBy24hPercentageAscending;
                    cryptoData.sort((a, b) => sortBy24hPercentageAscending
                        ? a['price_change_percentage_24h'].toDouble().compareTo(
                            b['price_change_percentage_24h'].toDouble())
                        : b['price_change_percentage_24h'].toDouble().compareTo(
                            a['price_change_percentage_24h'].toDouble()));
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '24h (%) ${sortBy24hPercentageAscending ? '▲' : '▼'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cryptoData.length,
              itemBuilder: (context, index) {
                final crypto = cryptoData[index];
                final symbol = crypto['symbol'];
                final name = crypto['name'];
                final id = crypto['id'];
                final price_change_percentage_24h =
                    crypto['price_change_percentage_24h'].toDouble();
                final image = crypto['image'];
                final currentPrice = crypto['current_price'];
                final last_updated = crypto['last_updated'];
                final market_cap = crypto['market_cap'];
                String formattedMarketCap = formatMarketCap(market_cap);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChartScreen(
                          name: name,
                          id: id,
                          image: image,
                          currentPrice: currentPrice.toDouble(),
                          last_updated: DateTime.parse(last_updated),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 95.0,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        tileColor: Color.fromRGBO(0, 0, 0, 0.6),
                        leading: Container(
                          width: 50.0,
                          height: 60.0,
                          child: Image.network(image),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${symbol.toUpperCase()}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "\$${currentPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, right: 64),
                                  child: Text(
                                    "\$${formattedMarketCap}",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: price_change_percentage_24h >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                          child: Text(
                            "${price_change_percentage_24h.toStringAsFixed(2)}%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
