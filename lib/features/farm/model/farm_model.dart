class FarmModel {
  final String? name;
  final String? location;

  FarmModel({this.name, this.location});

  factory FarmModel.fromMap(Map<String, dynamic> map) {
    return FarmModel(
      name: map['name'] as String?,
      location: map['location'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
    };
  }
}