import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/city.dart';
import 'cars_screen.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  List<City> cities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    var response = await ApiService.getCities();

    /// 🔥 IMPORTANT: Convert JSON → City Model
    cities = response.map<City>((json) => City.fromJson(json)).toList();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select City")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];   // City object
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(city.name),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CarsScreen(cityId: city.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
