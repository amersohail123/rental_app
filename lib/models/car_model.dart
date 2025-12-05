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

  // -----------------------------
  // JSON FACTORY
  // -----------------------------
  factory CarModel.fromJson(Map<String, dynamic> json) {
    // Debug print to console
    print("🔥 Car JSON -> $json");

    return CarModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',

      // Support BOTH: model_year & modelYear
      modelYear: _toInt(json['model_year'] ?? json['modelYear']),

      // Support BOTH: price_per_day & pricePerDay
      pricePerDay: _toDouble(json['price_per_day'] ?? json['pricePerDay']),

      // Support both: city_id & cityId
      cityId: _toInt(json['cit]()_
