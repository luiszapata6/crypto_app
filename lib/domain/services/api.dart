import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/* 
  Clase para realizar peticiones a través de http
  Se retorna un Future<dynamic> para parsearlo en el servicio
 */

class Api {
  static final Map<String, String> _headers = {};

  static Future<void> setHeaders() async {
    _headers[HttpHeaders.contentTypeHeader] = 'application/json';
  }

  static dynamic decode(String response) => json.decode(response);
  static String encode(Map<String, dynamic> response) => json.encode(response);

  static Future<dynamic> get(String path) async {
    await setHeaders();
    Uri uri = Uri.parse(path);

    try {
      final response = await http.get(
        uri,
        headers: _headers,
      );
      return decode(response.body);
    } catch (e) {
      throw Exception('Ocurrió un error, por favor inténtalo de nuevo');
    }
  }
}
