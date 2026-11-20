import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:postkeeper/data/repositories/location_repository.dart';
import 'package:postkeeper/data/services/google_places_service.dart';

// flutter test integration_test/google_places_test.dart -d <iOS-device-id>
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Places SDK searches and selects a location', (tester) async {
    const repository = GoogleLocationRepository(service: GooglePlacesService());
    final session = DateTime.now().microsecondsSinceEpoch.toString();
    try {
      final suggestions = await repository.search('台北車站', session);
      expect(suggestions, isNotEmpty);
      final location = await repository.select(suggestions.first, session);
      expect(location.name, isNotEmpty);
      expect(location.address, isNotEmpty);
      expect(location.countryCode, matches(RegExp(r'^[A-Z]{2}$')));
      expect(location.latitude, isNotNull);
      expect(location.longitude, isNotNull);
    } finally {
      await repository.endSession(session);
    }
  }, skip: kIsWeb || defaultTargetPlatform != TargetPlatform.iOS);
}
