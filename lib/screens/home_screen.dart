import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'booking_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedModule = 3;

  final List<Map<String, dynamic>> modules = [
    {"icon": Icons.flight, "name": "Flights"},
    {"icon": Icons.directions_bus, "name": "Bus"},
    {"icon": Icons.hotel, "name": "Hotel"},
    {"icon": Icons.directions_car, "name": "Car Rental"},
    {"icon": Icons.event, "name": "Events"},
    {"icon": Icons.movie, "name": "Movies"},
    {"icon": Icons.beach_access, "name": "Tours"},
  ];

  // Car Rental
  List cities = [];
  bool loadingCities = true;
  int? selectedCityId;

  DateTime? pickupDate;
  DateTime? dropoffDate;
  TimeOfDay? pickupTime;
  TimeOfDay? dropoffTime;

  bool withinCity = true;

  List carResults = [];
  bool loadingCars = false;
  bool showResults = false;

  int selectedSort = 0;

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    var response = await ApiService.getCities();
    setState(() {
      cities = response;
      loadingCities = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004AAD), Color(0xFF1E3C72)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                _buildTopModules(),
                const SizedBox(height: 20),

                if (selectedModule == 3) _buildCarRentalSearchUI(),

                if (showResults) _buildCarResults(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TOP MODULE BAR
  Widget _buildTopModules() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: modules.length,
        itemBuilder: (context, index) {
          bool active = selectedModule == index;
          return GestureDetector(
            onTap: () => setState(() => selectedModule = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.white24,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Icon(modules[index]["icon"],
                      color: active ? Colors.blue.shade700 : Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    modules[index]["name"],
                    style: TextStyle(
                      color: active ? Colors.blue.shade700 : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // CAR SEARCH BOX
  Widget _buildCarRentalSearchUI() {
    if (loadingCities) return const CircularProgressIndicator();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Search Rent A Car",
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Row(
            children: [
              _toggleButton("Within City", withinCity, () {
                setState(() => withinCity = true);
              }),
              const SizedBox(width: 10),
              _toggleButton("Out of City", !withinCity, () {
                setState(() => withinCity = false);
              }),
            ],
          ),

          const SizedBox(height: 20),
          _buildCityDropdown(),
          const SizedBox(height: 15),
          _buildDateBox(),
          const SizedBox(height: 15),
          _buildTimeBox(),
          const SizedBox(height: 20),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(text,
                style: TextStyle(
                  color: active ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonFormField<int>(
        decoration: const InputDecoration(border: InputBorder.none),
        hint: const Text("City"),
        value: selectedCityId,
        items: cities.map<DropdownMenuItem<int>>((city) {
          return DropdownMenuItem(
            value: city["id"],
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Text(city["name"]),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) => setState(() => selectedCityId = value),
      ),
    );
  }

  // DATE ROW
  Widget _buildDateBox() {
    return Row(
      children: [
        Expanded(
          child: _dateField("Pickup Date", pickupDate, () async {
            pickupDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
            );
            setState(() {});
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _dateField("Dropoff Date", dropoffDate, () async {
            dropoffDate = await showDatePicker(
              context: context,
              initialDate: pickupDate ?? DateTime.now(),
              firstDate: pickupDate ?? DateTime.now(),
              lastDate: DateTime(2030),
            );
            setState(() {});
          }),
        ),
      ],
    );
  }

  Widget _dateField(String label, DateTime? value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue, size: 18),
            const SizedBox(width: 8),
            Text(value == null ? label : value.toString().split(" ")[0]),
          ],
        ),
      ),
    );
  }

 // TIME ROW
  Widget _buildTimeBox() {
    return Row(
      children: [
        Expanded(
          child: _timeField("Pickup Time", pickupTime, () async {
            pickupTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            setState(() {});
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _timeField("Dropoff Time", dropoffTime, () async {
            dropoffTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            setState(() {});
          }),
        ),
      ],
    );
  }

  Widget _timeField(String label, TimeOfDay? time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.blue, size: 18),
            const SizedBox(width: 8),
            Text(time == null ? label : time.format(context)),
          ],
        ),
      ),
    );
  }

  // SEARCH BUTTON
  Widget _buildSearchButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () async {
          if (selectedCityId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a city")),
            );
            return;
          }

          setState(() {
            loadingCars = true;
            showResults = true;
          });

          var response = await ApiService.getCarsByCity(selectedCityId!);

          carResults = response;
          loadingCars = false;

          _applySorting();

          setState(() {});
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search),
              SizedBox(width: 6),
              Text("Search"),
            ],
          ),
        ),
      ),
    );
  }

  // RESULTS
  Widget _buildCarResults() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Sorting Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _sortTab("Recommended", 0),
              const SizedBox(width: 12),
              _sortTab("Cheapest", 1),
            ],
          ),

          const SizedBox(height: 10),

          Text("${carResults.length} cars found",
              style: const TextStyle(fontWeight: FontWeight.bold)),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: carResults.length,
            itemBuilder: (context, i) {
              return _carCard(carResults[i]);
            },
          ),
        ],
      ),
    );
  }

  // SORT TABS
  Widget _sortTab(String title, int index) {
    bool active = selectedSort == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSort = index;
          _applySorting();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? Colors.blue : Colors.grey.shade300),
        ),
        child: Text(
          title,
          style: TextStyle(color: active ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  void _applySorting() {
    if (selectedSort == 1) {
      carResults.sort((a, b) =>
          (a["price_per_day"] ?? 0).compareTo(b["price_per_day"] ?? 0));
    } else {
      carResults.sort((a, b) =>
          a["name"].toString().compareTo(b["name"].toString()));
    }
  }

  // ------------------------ CAR CARD WITH NAVIGATION ------------------------
  Widget _carCard(dynamic car) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingDetailsScreen(
              car: car,
              pickupDate: pickupDate,
              dropoffDate: dropoffDate,
              pickupTime: pickupTime,
              dropoffTime: dropoffTime,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            // IMAGE
            Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(car['image_url'] ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car["name"],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("${car["brand"]} - ${car["model_year"]}",
                      style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text("4"),
                      const SizedBox(width: 10),

                      const Icon(Icons.luggage, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text("2"),
                      const SizedBox(width: 10),

                      const Icon(Icons.settings, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(car['automatic'] == true ? "Auto" : "Manual"),
                    ],
                  ),
                ],
              ),
            ),

            // PRICE
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${car["price_per_day"]} SAR",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

