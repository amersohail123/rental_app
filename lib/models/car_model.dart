// lib/models/car_model.dart
class CarModel {
  final int id;
  final String name;
  final String brand;
  final int modelYear;
  final double pricePerDay;
  final String imageUrl;
  final bool automatic;

  CarModel({
    required this.id, required this.name, required this.brand,
    required this.modelYear, required this.pricePerDay,
    required this.imageUrl, required this.automatic,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      modelYear: _toInt(json['model_year']),
      pricePerDay: _toDouble(json['price_per_day']), // Fixes toDouble error
      imageUrl: json['image_url'] ?? '',
      automatic: _toBool(json['automatic']),
    );
  }

  static double _toDouble(dynamic value) => double.tryParse(value.toString()) ?? 0.0;
  static int _toInt(dynamic value) => int.tryParse(value.toString()) ?? 0;
  static bool _toBool(dynamic value) => value.toString().toLowerCase() == 'true' || value == 1;
}
