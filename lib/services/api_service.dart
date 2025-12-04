import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Cloud Run backend URL
  static const String baseUrl =
      "https://rental-api-98679704122.us-central1.run.app";

  // ============================================================
  // GET ALL CITIES
  // ============================================================
  static Future<List<dynamic>> getCities() async {
    final url = Uri.parse("$baseUrl/cities");

    print("➡️ Fetching Cities: $url");

    final response = await http.get(url);

    print("⬅️ Cities Response: ${response.statusCode}");
    print("Cities Raw Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load cities");
    }
  }

  // ============================================================
  // GET CARS BY CITY ID
  // ============================================================
  static Future<List<dynamic>> getCarsByCity(int cityId) async {
    final url = Uri.parse("$baseUrl/cars?city_id=$cityId");

    print("➡️ Fetching Cars: $url");

    final response = await http.get(url);

    print("⬅️ Cars Response: ${response.statusCode}");
    print("RAW CARS RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      try {
        var decoded = jsonDecode(response.body);

        print("Decoded JSON Type: ${decoded.runtimeType}");
        return decoded;
      } catch (e) {
        print("❌ JSON Decode Error: $e");
        throw Exception("Invalid JSON from backend");
      }
    } else {
      print("❌ Cars API Error: ${response.body}");
      throw Exception("Failed to load cars");
    }
  }
}
