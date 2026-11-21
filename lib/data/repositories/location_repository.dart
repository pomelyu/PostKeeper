import 'package:postkeeper/data/services/google_places_service.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/place_suggestion.dart';

abstract interface class LocationRepository {
  Future<List<PlaceSuggestion>> search(String query, String sessionId);
  Future<Location> select(PlaceSuggestion suggestion, String sessionId);
  Future<void> endSession(String sessionId);
}

class GoogleLocationRepository implements LocationRepository {
  const GoogleLocationRepository({required this.service});
  final GooglePlacesService service;

  @override
  Future<List<PlaceSuggestion>> search(String query, String sessionId) async =>
      [
        for (final item in await service.search(query, sessionId))
          PlaceSuggestion(
            id: item['placeId'] as String,
            name: (item['primaryText'] ?? item['text']) as String,
            address: item['text'] as String,
          ),
      ];

  @override
  Future<Location> select(PlaceSuggestion suggestion, String sessionId) async {
    final data = await service.details(suggestion.id, sessionId);
    final latitude = (data['latitude'] as num?)?.toDouble();
    final longitude = (data['longitude'] as num?)?.toDouble();
    final country = (data['countryCode'] as String? ?? '').toUpperCase();
    final address = data['address'] as String? ?? '';
    if (latitude == null ||
        longitude == null ||
        !latitude.isFinite ||
        !longitude.isFinite ||
        latitude.abs() > 90 ||
        longitude.abs() > 180 ||
        !RegExp(r'^[A-Z]{2}$').hasMatch(country) ||
        address.isEmpty) {
      throw const FormatException('Incomplete place details');
    }
    return Location(
      id: 'google:${suggestion.id}',
      googlePlaceId: suggestion.id,
      name: suggestion.name,
      countryCode: country,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> endSession(String sessionId) => service.endSession(sessionId);
}
