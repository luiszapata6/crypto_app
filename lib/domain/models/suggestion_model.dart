import 'dart:convert';

/* 
  Modelo de sugerencias obtenidas del buscador
 */

class SuggestionModel {
  factory SuggestionModel.fromMap(Map<String, dynamic> json) => SuggestionModel(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'] ?? '',
      );
  SuggestionModel({
    required this.id,
    required this.name,
    required this.symbol,
  });

  factory SuggestionModel.fromJson(String str) => SuggestionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  final String id;
  final String name;
  final String symbol;
}
