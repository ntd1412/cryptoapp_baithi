import 'dart:math';

class Data {
  static Random random = Random();

  static List<String> names = [
    "Anh Tuan",
    "Minh Hoa",
    "Khanh Duy",
    "Thanh Truc",
    "Van Hieu",
    "Ngoc Lan",
    "Quoc Bao",
    "Thuy Linh",
    "Dang Khoa",
    "Hong Nhung",
    "Nguyen Tien Dat",
  ];

  static List<String> types = ["received", "sent"];

  static List<Map<String, dynamic>> coins = [
    {
      "icon": "assets/btc.png",
      "name": "Bitcoin",
      "alt": "BTC",
      "rate": r"$10,297.66",
    },
    {
      "icon": "assets/eth.png",
      "name": "Etherium",
      "alt": "ETH",
      "rate": r"$215.56",
    },
    {
      "icon": "assets/xrp.png",
      "name": "Ripple",
      "alt": "XRP",
      "rate": r"$0.321697",
    },
    {
      "icon": "assets/ltc.png",
      "name": "Litecoin",
      "alt": "LTC",
      "rate": r"$94.29",
    },
    {
      "icon": "assets/xmr.png",
      "name": "Monero",
      "alt": "XMR",
      "rate": r"$82.57",
    },
  ];

  static List<Map<String, dynamic>> transactions = List.generate(15, (index) => {
    "name": names[random.nextInt(10)],
    "date": "${(random.nextInt(30)+1).toString().padLeft(2, "0")}/${(random.nextInt(11) + 1).toString().padLeft(2, "0")}/2023",
    "amount": "\$${random.nextInt(1000).toString()}",
    "type": types[random.nextInt(2)],
    "dp": "assets/cm${random.nextInt(10)}.jpeg",
  });
}
