import 'package:postkeeper/domain/models/location.dart';

/// Reads saved local locations; separate from Google Places autocomplete.
abstract interface class SavedLocationRepository {
  Future<List<Location>> getAllLocations();
  Future<Location?> getLocationById(String id);
  Future<List<Location>> getLocationsByGooglePlaceId(String googlePlaceId);
}
