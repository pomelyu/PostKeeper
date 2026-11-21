import 'package:postkeeper/data/repositories/location_repository.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/place_suggestion.dart';
import 'package:postkeeper/main.dart';

PostKeeperApp createTestApp() => PostKeeperApp(
  postcardRepository: MockPostcardRepository(),
  personRepository: MockPersonRepository(),
  locationRepository: TestLocationRepository(),
);

class TestLocationRepository implements LocationRepository {
  @override
  Future<List<PlaceSuggestion>> search(String query, String sessionId) async =>
      [];

  @override
  Future<Location> select(PlaceSuggestion suggestion, String sessionId) async =>
      throw StateError('No test place selected');

  @override
  Future<void> endSession(String sessionId) async {}
}
