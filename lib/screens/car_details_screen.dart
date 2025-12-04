import 'package:flutter/material.dart';
import '../models/car_model.dart';
import 'booking_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final CarModel car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(car.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCarImage(),

            const SizedBox(height: 12),

            _buildCarInfoCard(),

            const SizedBox(height: 12),

            _buildFeaturesRow(),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(car: car),
                      ),
                    );
                  },
                  child: const Text(
                    "Book Now",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // FIXED: imageUrl is ALWAYS non-null in CarModel
  // ---------------------------------------------------------
  Widget _buildCarImage() {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: (car.imageUrl.isNotEmpty)
          ? Image.network(
              car.imageUrl,
              fit: BoxFit.cover,
            )
          : Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.car_rental, size: 120, color: Colors.grey),
              ),
            ),
    );
  }

  // ---------------------------------------------------------
  // Car Information Card
  // ---------------------------------------------------------
  Widget _buildCarInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 2,
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              car.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              car.brand,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),

            const SizedBox(height: 16),

            Text(
              "${car.pricePerDay.toStringAsFixed(0)} SAR / day",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Car Features Row
  // ---------------------------------------------------------
  Widget _buildFeaturesRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFeature(Icons.calendar_today, "${car.modelYear}"),
            _buildFeature(Icons.settings, car.automatic ? "Automatic" : "Manual"),
            _buildFeature(Icons.location_on, "City ${car.cityId}"),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
