import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = "";

  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  static Future<Map<String, dynamic>> coinFlip(int shots) async {
    final response = await http.post(
      Uri.parse("$baseUrl/coinflip"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"shots": shots}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> qrng(int bits) async {
    final response = await http.post(
      Uri.parse("$baseUrl/qrng"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"bits": bits}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> entanglement(int shots) async {
    final response = await http.post(
      Uri.parse("$baseUrl/entanglement"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"shots": shots}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> teleportation(
      int initialState, int shots) async {
    final response = await http.post(
      Uri.parse("$baseUrl/teleportation"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "initial_state": initialState,
        "shots": shots,
      }),
    );
    return jsonDecode(response.body);
  }
}
