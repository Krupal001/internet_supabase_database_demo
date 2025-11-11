import '../../domain/entities/geolocation_entity.dart';

/// Geolocation model - Data layer representation with JSON serialization
class GeolocationModel extends GeolocationEntity {
  const GeolocationModel({
    required super.query,
    required super.status,
    required super.country,
    required super.countryCode,
    required super.region,
    required super.regionName,
    required super.city,
    required super.zip,
    required super.lat,
    required super.lon,
    required super.timezone,
    required super.isp,
    required super.org,
    required super.as,
  });

  /// Create model from JSON (from API)
  factory GeolocationModel.fromJson(Map<String, dynamic> json) {
    return GeolocationModel(
      query: json['query'] as String,
      status: json['status'] as String,
      country: json['country'] as String,
      countryCode: json['countryCode'] as String,
      region: json['region'] as String,
      regionName: json['regionName'] as String,
      city: json['city'] as String,
      zip: json['zip'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      timezone: json['timezone'] as String,
      isp: json['isp'] as String,
      org: json['org'] as String,
      as: json['as'] as String,
    );
  }

  /// Convert model to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'status': status,
      'country': country,
      'countryCode': countryCode,
      'region': region,
      'regionName': regionName,
      'city': city,
      'zip': zip,
      'lat': lat,
      'lon': lon,
      'timezone': timezone,
      'isp': isp,
      'org': org,
      'as': as,
    };
  }

  /// Create model from entity
  factory GeolocationModel.fromEntity(GeolocationEntity entity) {
    return GeolocationModel(
      query: entity.query,
      status: entity.status,
      country: entity.country,
      countryCode: entity.countryCode,
      region: entity.region,
      regionName: entity.regionName,
      city: entity.city,
      zip: entity.zip,
      lat: entity.lat,
      lon: entity.lon,
      timezone: entity.timezone,
      isp: entity.isp,
      org: entity.org,
      as: entity.as,
    );
  }
}
