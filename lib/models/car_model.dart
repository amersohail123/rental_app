class CarModel {
  final int id;
  final String name;
  final String brand;
  final int modelYear;
  final double pricePerDay;
  final int cityId;
  final String imageUrl;
  final bool automatic;

  CarModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.modelYear,
    required this.pricePerDay,
    required this.cityId,
    required this.imageUrl,
    required this.automatic,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    print("🔥 Car JSON -> $json");

    return CarModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      modelYear: _toInt(json['model_year'] ?? json['modelYear']),
      pricePerDay: _toDouble(json['price_per_day'] ?? json['pricePerDay']),
      cityId: _toInt(json['city_id'] ?? json['cityId']),
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      automatic: _toBool(json['automatic']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model_year': modelYear,
      'price_per_day': pricePerDay,
      'city_id': cityId,
      'image_url': imageUrl,
      'automatic': automatic,
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}
