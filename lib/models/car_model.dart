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

  // ----------------------------------------------------------
  // FIX #2 — Safe imageUrl handling (null, missing, wrong key)
  // ----------------------------------------------------------
  static String _safeImage(dynamic value) {
    if (value == null) return _default;
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return _default;
  }

  // Default placeholder image
  static const String _default =
      "https://cdn-icons-png.flaticon.com/512/3202/3202926.png";

  // ----------------------------------------------------------
  // JSON → MODEL
  // ----------------------------------------------------------
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',

      // Support both model_year & modelYear
      modelYear: _toInt(json['model_year'] ?? json['modelYear']),

      // Support both price_per_day & pricePerDay
      pricePerDay: _toDouble(json['price_per_day'] ?? json['pricePerDay']),

      // Support both city_id & cityId
      cityId: _toInt(json['city_id'] ?? json['cityId']),

      // FIX #2 applied here — SAFE image URL
      imageUrl: _safeImage(json['image_url'] ?? json['imageUrl']),

      // Support 0/1 or true/false
      automatic: json['automatic'] == 1 || json['automatic'] == true,
    );
  }

  // ----------------------------------------------------------
  // MODEL → JSON
  // ----------------------------------------------------------
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

  // ----------------------------------------------------------
  // SAFE PARSERS
  // ----------------------------------------------------------
  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }
}
