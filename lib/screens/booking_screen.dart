import 'package:flutter/material.dart';
import '../models/car_model.dart';

class BookingScreen extends StatefulWidget {
  final CarModel car;

  const BookingScreen({super.key, required this.car});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final pricePerDay = widget.car.pricePerDay;

    int totalDays = 0;
    double totalPrice = 0;

    if (startDate != null && endDate != null) {
      totalDays = endDate!.difference(startDate!).inDays;
      if (totalDays < 1) totalDays = 1;

      totalPrice = totalDays * pricePerDay;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Book ${widget.car.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.car.brand,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            Text("Price per day: ${pricePerDay.toStringAsFixed(2)} SAR",
                style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (selected != null) setState(() => startDate = selected);
              },
              child: Text(startDate == null
                  ? "Select Start Date"
                  : "Start: ${startDate.toString().split(' ')[0]}"),
            ),

            ElevatedButton(
              onPressed: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: startDate ?? DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (selected != null) setState(() => endDate = selected);
              },
              child: Text(endDate == null
                  ? "Select End Date"
                  : "End: ${endDate.toString().split(' ')[0]}"),
            ),

            const SizedBox(height: 20),

            if (startDate != null && endDate != null)
              Text("Total Days: $totalDays", style: const TextStyle(fontSize: 18)),

            if (startDate != null && endDate != null)
              Text("Total Price: ${totalPrice.toStringAsFixed(2)} SAR",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
