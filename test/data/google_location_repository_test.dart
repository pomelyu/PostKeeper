import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/data/repositories/location_repository.dart';
import 'package:postkeeper/data/services/google_places_service.dart';
import 'package:postkeeper/domain/models/place_suggestion.dart';

class _PlacesService extends GooglePlacesService {
  @override
  Future<Map<String, dynamic>> details(
    String placeId,
    String sessionId,
  ) async => {
    'latitude': 25.033,
    'longitude': 121.5654,
    'countryCode': 'tw',
    'address': 'Test address',
  };
}

void main() {
  test('Google 選取結果保留獨立的 Place ID 欄位', () async {
    final repository = GoogleLocationRepository(service: _PlacesService());
    final location = await repository.select(
      const PlaceSuggestion(
        id: 'place-123',
        name: 'Test place',
        address: 'Test address',
      ),
      'test-session',
    );
    expect(location.googlePlaceId, 'place-123');
    expect(location.countryCode, 'TW');
  });
}
