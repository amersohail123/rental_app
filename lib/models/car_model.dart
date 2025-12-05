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

  /// -----------------------------
  /// FACTORY FROM JSON (SAFE)
  /// -----------------------------
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      modelYear: _toInt(json['model_year'] ?? json['modelYear']),
      pricePerDay: _safeDouble(json['price_per_day'] ?? json['pricePerDay']),
      cityId: _toInt(json['city_id'] ?? json['cityId']),
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      automatic: json['automatic'] == 1 || json['automatic'] == true,
    );
  }

  /// -----------------------------
  /// JSON EXPORT
  /// -----------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'modelYear': modelYear,
      'pricePerDay': pricePerDay,
      'cityId': cityId,
      'imageUrl': imageUrl,
      'automatic': automatic,
    };
  }

  /// -----------------------------
  /// SAFE PARSERS
  /// -----------------------------

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static double _safeDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) {
      // Remove commas like "45,000.00"
      return double.tryParse(v.replaceAll(",", "")) ?? 0.0;
    }
    return 0.0;
  }
}
