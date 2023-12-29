import 'dart:convert';
import 'package:cryptoapp_baithi/widgets/toggle_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cryptoapp_baithi/widgets/sliver_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartScreen extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final double currentPrice;
  final DateTime last_updated;

  ChartScreen({
    required this.name,
    required this.id,
    required this.image,
    required this.currentPrice,
    required this.last_updated,
  });

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<List<num>> bitcoinPrices = [];
  List<bool> _isSelected = [true, false, false, false];

  @override
  void initState() {
    super.initState();
    fetchData(widget.id, '1');
    fetchData(widget.id, '3');
    fetchData(widget.id, '7');
    fetchData(widget.id, '30');
  }

  Future<void> fetchData(String id, String timeRange) async {
    try {
      print('Fetching data for time range: $timeRange');
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=$timeRange&precision=0'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bitcoinPrices = List<List<double>>.from(data['prices'].map(
              (dynamicList) => List<double>.from(
                  dynamicList.map((value) => value.toDouble()))));
        });
      } else {
        throw Exception('Bị chặn API');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
            ),
            pinned: true,
            snap: true,
            floating: true,
            expandedHeight: 280,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                padding: const EdgeInsets.fromLTRB(16, 24, 4.4, 0),
                width: double.infinity,
                height: 56,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.image),
                    ),
                  ),
                  title: Row(
                    children: [
                      SizedBox(width: 1.0),
                      Text(
                        widget.name,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              background: Image.asset(
                "assets/images/chart.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: 360,
              maxHeight: 360,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    Text(
                      "\$" + widget.currentPrice.toStringAsFixed(2),
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Text(
                      "${DateFormat('dd/MM/yyyy HH:mm').format(widget.last_updated.toLocal())}",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                  color: const Color(0xff37434d), width: 1),
                            ),
                            minY: bitcoinPrices.isNotEmpty
                                ? bitcoinPrices
                                    .map((e) => e[1])
                                    .reduce((a, b) => a < b ? a : b)
                                    .toDouble()
                                : 0.0,
                            maxY: bitcoinPrices.isNotEmpty
                                ? bitcoinPrices
                                    .map((e) => e[1])
                                    .reduce((a, b) => a > b ? a : b)
                                    .toDouble()
                                : 0.0,
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  bitcoinPrices.length,
                                  (index) => FlSpot(
                                    index.toDouble(),
                                    bitcoinPrices[index][1].toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                curveSmoothness: 0.2,
                                colors: [Colors.blue],
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      borderColor: Colors.indigoAccent,
                      color: Colors.white,
                      fillColor: Colors.green,
                      selectedBorderColor: Colors.indigoAccent,
                      selectedColor: Colors.white,
                      children: [
                        ToggleButton(name: "Today"),
                        ToggleButton(name: "3D"),
                        ToggleButton(name: "7D"),
                        ToggleButton(name: "30D"),
                      ],
                      isSelected: _isSelected,
                      onPressed: (index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < _isSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              _isSelected[buttonIndex] = true;
                              fetchData(widget.id, getTimeRangeByIndex(index));
                            } else {
                              _isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedButton(
                    height: 40,
                    width: 100,
                    text: 'Buy',
                    isReverse: true,
                    selectedTextColor: Colors.black,
                    transitionType: TransitionType.LEFT_TO_RIGHT,
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.white,
                    borderRadius: 30,
                    borderWidth: 2,
                    selectedGradientColor: LinearGradient(
                        colors: [Colors.pinkAccent, Colors.orangeAccent]),
                    onPress: () {
                      print('Buy');
                    },
                  ),
                  AnimatedButton(
                    height: 40,
                    width: 100,
                    text: 'Sell',
                    isReverse: true,
                    selectedTextColor: Colors.black,
                    transitionType: TransitionType.LEFT_TO_RIGHT,
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.white,
                    borderRadius: 30,
                    borderWidth: 2,
                    selectedGradientColor: LinearGradient(
                        colors: [Colors.pinkAccent, Colors.orangeAccent]),
                    onPress: () {
                      print('Sell');
                    },
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

String getTimeRangeByIndex(int index) {
  switch (index) {
    case 1:
      return '3';
    case 2:
      return '7';
    case 3:
      return '30';
    default:
      return '1';
  }
}
