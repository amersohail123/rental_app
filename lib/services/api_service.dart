import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/city.dart';
import '../models/car_model.dart';

class ApiService {
  // Cloud Run backend URL
  static const String baseUrl =
      "https://rental-api-98679704122.us-central1.run.app";

  // -------------------------------------------------------------
  // GET ALL CITIES → returns List<City>
  // -------------------------------------------------------------
  static Future<List<City>> getCities() async {
    final url = Uri.parse("$baseUrl/cities");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((item) => City.fromJson(item)).toList();
    } else {
      print("Error loading cities: ${response.body}");
      throw Exception("Failed to load cities");
    }
  }

  // -------------------------------------------------------------
  // GET CARS BY CITY → returns List<CarModel>
  // -------------------------------------------------------------
  static Future<List<CarModel>> getCarsByCity(int cityId) async {
    final url = Uri.parse("$baseUrl/cars?city_id=$cityId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((item) => CarModel.fromJson(item)).toList();
    } else {
      print("Error loading cars: ${response.body}");
      throw Exception("Failed to load cars");
    }
  }
}
