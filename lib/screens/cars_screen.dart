import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/car.dart'; // Ensure this matches your model filename

class CarsScreen extends StatefulWidget {
  final int cityId;
  final String cityName;

  const CarsScreen({super.key, required this.cityId, required this.cityName});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  late Future<List<Car>> futureCars;

  @override
  void initState() {
    super.initState();
    futureCars = fetchCars(widget.cityId);
  }

  Future<List<Car>> fetchCars(int cityId) async {
    final response = await http.get(
      Uri.parse('https://rental-api-98679704122.us-central1.run.app/cars?city_id=$cityId'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((car) => Car.fromJson(car)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cars in ${widget.cityName}')),
      body: FutureBuilder<List<Car>>(
        future: futureCars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cars available in this city.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final car = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: car.imageUrl.isNotEmpty
                      ? Image.network(
                          car.imageUrl,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.directions_car),
                        )
                      : const Icon(Icons.directions_car, size: 50),
                  title: Text('${car.brand} ${car.name}'),
                  subtitle: Text('Year: ${car.modelYear} • ${car.isAutomatic ? "Auto" : "Manual"}'),
                  trailing: Text(
                    '\$${car.pricePerDay.toStringAsFixed(2)}/day',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  onTap: () {
                    // Navigate to details screen if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
