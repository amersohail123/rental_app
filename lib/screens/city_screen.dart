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
    try {
      final response = await ApiService.getCities();
      setState(() {
        cities = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading cities: $e");
      setState(() => isLoading = false);
    }
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
                final city = cities[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
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
