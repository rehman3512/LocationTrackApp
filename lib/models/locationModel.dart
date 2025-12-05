class LocationModel{
  final double latitude;
  final double longitude;
  final String city;
  final String state;
  final String postalCode;
  final DateTime timestamp;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.timestamp
});

  Map<String,dynamic> tojson ()=> {
    "latitude" : latitude,
    "longitude" : longitude,
    "city" : city,
    "state" : state,
    "postalCode" : postalCode,
    "timestamp" : timestamp.toIso8601String(),
  };

  factory LocationModel.fromJson(Map<String,dynamic> json) => LocationModel(
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      city: (json["city"] ?? "N/A"),
      state: (json["state"] ?? "N/A"),
      postalCode: (json["postalCode"] ?? "N/A"),
      timestamp: DateTime.parse(json["timestamp"]),
  );

}