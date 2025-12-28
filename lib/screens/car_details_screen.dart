import 'package:flutter/material.dart';
import '../models/car_model.dart'; // Step 2: Pointing to the unified model
import 'booking_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final CarModel car; // Changed from 'Car' to 'CarModel'

  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${car.brand} ${car.name}'), // Uses unified brand/name
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image Header
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: car.imageUrl.isNotEmpty
                  ? Image.network(
                      car.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.directions_car, size: 100),
                    )
                  : const Icon(Icons.directions_car, size: 100),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text(
                        car.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      // Safe formatting for the price double
                      Text(
                        '\$${car.pricePerDay.toStringAsFixed(2)}/day',
                        style: const TextStyle(
                          fontSize: 20, 
                          color: Colors.green, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Brand: ${car.brand}',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Specifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Model Year'),
                    trailing: Text(car.modelYear.toString()), // Converting int to String
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Transmission'),
                    // Matches the 'automatic' boolean in CarModel
                    trailing: Text(car.automatic ? 'Automatic' : 'Manual'),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Booking Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(car: car),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Book Now', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
