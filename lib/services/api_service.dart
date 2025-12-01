import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Your Cloud Run backend URL
  static const String baseUrl =
      "https://rental-api-98679704122.us-central1.run.app";

  // -------------------------------
  // Fetch all cities
  // -------------------------------
  static Future<List<dynamic>> getCities() async {
    final url = Uri.parse("$baseUrl/cities");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error loading cities: ${response.body}");
      throw Exception("Failed to load cities");
    }
  }

  // -------------------------------
  // Fetch cars by city
  // -------------------------------
  static Future<List<dynamic>> getCarsByCity(int cityId) async {
    final url = Uri.parse("$baseUrl/cars?city_id=$cityId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error loading cars: ${response.body}");
      throw Exception("Failed to load cars");
    }
  }
}
