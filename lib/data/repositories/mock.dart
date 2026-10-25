import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';

import './postcard_repository.dart';

const _home = Location(id: '_mock_home-000', name: '家', countryCode: 'TW');
const _kyoto = Location(id: '_mock_kyoto-000', name: '京都', countryCode: 'JP');

const _me = Person(id: '_mock_me-000', name: '我', locations: [_home]);
const _friend = Person(id: '_mock_friend-000', name: '朋友', locations: [_kyoto]);

final Postcard _sent = Postcard(
  id: '_mock_postcard_sent-000',
  orientation: Orientation.landscape,
  createdAt: DateTime(2026, 09, 25),
  updatedAt: DateTime(2026, 09, 30),
  frontImagePath: 'assets/postcard/landscape_front.jp2',
  backImagePath: 'assets/postcard/landscape_back.jp2',
  sender: _me,
  recipient: _friend,
);

final _received = Postcard(
  id: '_mock_postcard_received-000',
  orientation: Orientation.portrait,
  createdAt: DateTime(2026, 10, 05),
  updatedAt: DateTime(2026, 10, 18),
  frontImagePath: 'assets/postcard/portrait_front.jp2',
  backImagePath: 'assets/postcard/portrait_back.jp2',
  sender: _friend,
  recipient: _me,
);

class MockPostcardRepository implements PostcardRepository {

  @override
  Future<Postcard?> getLatestSentPostcard() async => _sent;

  @override
  Future<Postcard?> getLatestReceivedPostcard() async => _received;
}
