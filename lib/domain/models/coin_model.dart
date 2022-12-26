import 'dart:convert';

/* 
  Modelo de crypto obtenidas de la API
 */

class CoinModel {
  factory CoinModel.fromMap(Map<String, dynamic> json) => CoinModel(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        image: json['image'],
        currentPrice: json['current_price'] != null ? json['current_price'].toDouble() : 0,
      );
  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
  });

  factory CoinModel.fromJson(String str) => CoinModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'id': id,
        'symbol': symbol,
        'name': name,
        'image': image,
        'current_price': currentPrice,
      };

  final String id;
  final String symbol;
  final String name;
  final String image;
  final num currentPrice;
}
