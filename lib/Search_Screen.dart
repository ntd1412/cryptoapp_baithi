import 'dart:async';
import 'package:cryptoapp_baithi/Chart_Screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  final double currentPrice;
  final String id;

  const SearchScreen({Key? key, required this.currentPrice, required this.id}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> cryptoData = [];
  List<dynamic> cryptoData1 = [];
  Map<String, List<dynamic>> cryptoDataResults = {};
  late String id;
  dynamic responseData2;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }
  Future<void> fetchCryptoData(String query1, String query2) async {
    try {
      final response1 = await http.get(Uri.parse('https://api.coingecko.com/api/v3/search?query=$query1'));

      if (response1.statusCode == 200) {
        final responseData1 = json.decode(response1.body);
        if (responseData1['coins'] != null && responseData1['coins'].isNotEmpty) {
          final List<dynamic> data = responseData1['coins'];
          setState(() {
            cryptoData = data;
          });
          final id = responseData1['coins'][0]['id'];
          final response2 = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$id&order=market_cap_desc&per_page=20&page=1&sparkline=false'));
          if (response2.statusCode == 200) {
            final responseData2 = json.decode(response2.body);
            if (responseData2 is List && responseData2.isNotEmpty) {
              cryptoDataResults[query1] = responseData2;
              setState(() {
                cryptoData1 = responseData2;
              });
            } else {
              print('Data null');
            }
          } else {
            throw Exception('Lỗi 2');
          }
        } else {
          print('Lỗi 3');
        }
      } else {
        throw Exception('Error fetching id');
      }
    } catch (e) {
      print('Error: $e');
      // Handle errors, show a message to the user, etc.
    }
  }
  void _onSearch() async {
    String query1 = _searchController.text;

    if (query1.isNotEmpty) {
      try {
        await fetchCryptoData(query1, id);
      } catch (e) {
        print('Error: $e');
        // Handle errors, show a message to the user, etc.
      }
    } else {
      print('Empty search query');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nhập từ khóa tìm kiếm (bitcoin hoặc btc)',
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onSearch,
              child: Text('Tìm kiếm'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cryptoData.length,
                itemBuilder: (context, index) {
                  final crypto = cryptoData[index];
                  final symbol = crypto['symbol'];
                  final large = crypto['large'];
                  return GestureDetector(
                    onTap: () {
                      _onSearch1(crypto);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        tileColor: Color.fromRGBO(0, 0, 0, 0.6),
                        textColor: Colors.white,
                        leading: Image.network(large),
                        title: Text(
                          '${symbol.toUpperCase()}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearch1(Map<String, dynamic> crypto) async {
    String query1 = crypto['name'];

    if (query1.isNotEmpty) {
      try {
        final currentResults = cryptoDataResults[query1];
        if (currentResults != null && currentResults.isNotEmpty) {
          setState(() {
            cryptoData1 = currentResults;
          });
        } else {
          await fetchCryptoData(query1, id);
        }

        final currentPriceString = cryptoData1.isNotEmpty
            ? cryptoData1[0]['current_price'].toString()
            : '0.0';
        final currentPrice = double.parse(currentPriceString);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              try {
                return ChartScreen(
                  id: crypto['id'],
                  name: crypto['name'],
                  image: crypto['large'],
                  currentPrice: currentPrice,
                  last_updated: crypto['last_updated'] != null
                      ? DateTime.parse(crypto['last_updated'])
                      : DateTime.now(),
                );
              } catch (e) {
                print('Error parsing date: $e');
                return Container();
              }
            },
          ),
        );
      } catch (e) {
        print('Error: $e');
        // Handle errors, show a message to the user, etc.
      }
    } else {
      print('Empty search query');
    }
  }


}

