class CarModel {
  final int id;
  final String name;
  final String model;
  final String brand;
  final int modelYear;
  final double pricePerDay;
  final int cityId;
  final String imageUrl;
  final bool automatic;

  CarModel({
    required this.id,
    required this.name,
    required this.model,
    required this.brand,
    required this.modelYear,
    required this.pricePerDay,
    required this.cityId,
    required this.imageUrl,
    required this.automatic,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
      modelYear: json['model_year'] ?? 0,
      pricePerDay: (json['price_per_day'] ?? 0).toDouble(),
      cityId: json['city_id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      automatic: json['automatic'] == 1 || json['automatic'] == true,
    );
  }
}
