class Car {
  final int id;
  final String name;
  final String brand;
  final String modelYear;
  final double pricePerDay;
  final String imageUrl;
  final int cityId;
  final bool isAutomatic;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.modelYear,
    required this.pricePerDay,
    required this.imageUrl,
    required this.cityId,
    required this.isAutomatic,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Car',
      brand: json['brand'] ?? 'Unknown Brand',
      // API returns model_year as int, converting to String for your model
      modelYear: json['model_year']?.toString() ?? 'N/A',
      // FIX: API sends "45.00" as String. tryParse handles String/int/double safely.
      pricePerDay: double.tryParse(json['price_per_day']?.toString() ?? '0.0') ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      cityId: json['city_id'] ?? 0,
      isAutomatic: json['automatic'] ?? false,
    );
  }
}
