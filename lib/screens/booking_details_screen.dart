import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final dynamic car;
  final DateTime? pickupDate;
  final DateTime? dropoffDate;
  final TimeOfDay? pickupTime;
  final TimeOfDay? dropoffTime;

  const BookingDetailsScreen({
    super.key,
    required this.car,
    required this.pickupDate,
    required this.dropoffDate,
    required this.pickupTime,
    required this.dropoffTime,
  });

  @override
  Widget build(BuildContext context) {
    int totalDays = 1;
    if (pickupDate != null && dropoffDate != null) {
      totalDays = dropoffDate!.difference(pickupDate!).inDays;
      if (totalDays < 1) totalDays = 1;
    }

    // ✅ SAFE conversion: handles 45, 45.0, "45", "45.00"
    double pricePerDay = _safeDouble(car['price_per_day']);
    double totalPrice = totalDays * pricePerDay;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(car['image_url'] ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car["name"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${car['brand']} • ${car['model_year']}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _spec(Icons.people, "4 Seats"),
                      _spec(Icons.luggage, "2 Bags"),
                      _spec(Icons.settings,
                          car['automatic'] == true ? "Automatic" : "Manual"),
                      _spec(Icons.ac_unit, "AC"),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Booking Summary",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _summary("Pickup Date",
                      pickupDate?.toString().split(" ")[0] ?? "-"),
                  _summary(
                      "Pickup Time", pickupTime?.format(context) ?? "-"),
                  _summary("Dropoff Date",
                      dropoffDate?.toString().split(" ")[0] ?? "-"),
                  _summary(
                      "Dropoff Time", dropoffTime?.format(context) ?? "-"),

                  const Divider(height: 30),

                  _summary("Total Days", "$totalDays Days"),
                  _summary("Price per Day", "$pricePerDay SAR"),

                  const SizedBox(height: 5),

                  _summary(
                    "TOTAL PRICE",
                    "$totalPrice SAR",
                    bold: true,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Step-3 coming soon"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style:
                            TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _spec(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        const SizedBox(height: 5),
        Text(text),
      ],
    );
  }

  Widget _summary(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Helper to safely convert any dynamic value to double
double _safeDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
