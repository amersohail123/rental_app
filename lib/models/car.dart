class Car {
  final int id;
  final String name;
  final String model;
  final String type;

  Car({
    required this.id,
    required this.name,
    required this.model,
    required this.type,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      type: json['type'],
    );
  }
}
