import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  final CarModel car;

  const BookingScreen({super.key, required this.car});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? startDate;
  DateTime? endDate;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isBooking = false;

  Future<void> bookCar() async {
    if (startDate == null || endDate == null) {
      _showMessage("Please select start and end dates");
      return;
    }

    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      _showMessage("Please enter your name and phone");
      return;
    }

    setState(() => isBooking = true);

    final url = Uri.parse("${ApiService.baseUrl}/book");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "car_id": widget.car.id,
          "customer_name": nameController.text.trim(),
          "customer_phone": phoneController.text.trim(),
          "start_date": startDate.toString().split(" ")[0],
          "end_date": endDate.toString().split(" ")[0],
        }),
      );

      setState(() => isBooking = false);

      if (response.statusCode == 200) {
        _showMessage("Booking successful!", success: true);
      } else {
        _showMessage("Failed: ${response.body}");
      }
    } catch (e) {
      setState(() => isBooking = false);
      _showMessage("Error: $e");
    }
  }

  void _showMessage(String msg, {bool success = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? "Success" : "Error"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

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
        child: ListView(
          children: [
            Text(widget.car.brand,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Price per day: ${pricePerDay.toStringAsFixed(0)} SAR",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            // -------------------------
            // Customer Name
            // -------------------------
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),

            // -------------------------
            // Phone Number
            // -------------------------
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // -------------------------
            // Date Pickers
            // -------------------------
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

            const SizedBox(height: 8),

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
            const SizedBox(height: 30),

            // -------------------------
            // Book Button
            // -------------------------
            isBooking
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: bookCar,
                    child: const Text(
                      "Confirm Booking",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
