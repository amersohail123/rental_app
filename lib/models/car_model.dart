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
    return CarModel(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? "",
      brand: json['brand']?.toString() ?? "",
      modelYear: _toInt(json['model_year']),
      pricePerDay: _toDouble(json['price_per_day']),
      cityId: _toInt(json['city_id']),
      imageUrl: json['image_url']?.toString() ?? "",
      automatic: json['automatic'] == true,
    );
  }

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
