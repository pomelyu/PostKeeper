import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';

import './postcard_repository.dart';

const _home = Location(id: '_mock_home', name: '家', countryCode: 'TW');
const _kaohsiung = Location(id: '_mock_home', name: '高雄', countryCode: 'TW');
const _kyoto = Location(id: '_mock_kyoto', name: '京都', countryCode: 'JP');
const _porto = Location(id: '_mock_porto', name: '波多', countryCode: 'PT');
const _vancouver = Location(id: '_mock_vancouver', name: '溫哥華', countryCode: 'CA');

const _me = Person(id: '_mock_me', name: '我', locations: [_home]);
const _friend1 = Person(id: '_mock_friend-000', name: '朋友1', locations: [_kyoto, _kaohsiung]);
const _friend2 = Person(id: '_mock_friend-001', name: '朋友2', locations: [_kaohsiung]);
const _friend3 = Person(id: '_mock_friend-002', name: '朋友3', locations: [_vancouver]);

final Postcard _sent1 = Postcard(
  id: '_mock_postcard_sent-001',
  isFavorite: false,
  orientation: PostcardOrientation.landscape,
  createdAt: DateTime(2026, 09, 25),
  updatedAt: DateTime(2026, 09, 30),
  frontImagePath: 'assets/postcard/landscape_front.jp2',
  backImagePath: 'assets/postcard/landscape_back.jp2',
  sender: _me,
  sendFrom: _vancouver,
  recipient: _friend2,
  sendTo: _kaohsiung,
  sentAt: DateTime(2026, 09, 20),
  receivedAt: DateTime(2026, 09, 25),
);

final Postcard _sent2 = Postcard(
  id: '_mock_postcard_sent-002',
  isFavorite: true,
  orientation: PostcardOrientation.portrait,
  createdAt: DateTime(2025, 05, 25),
  updatedAt: DateTime(2025, 05, 30),
  frontImagePath: 'assets/postcard/landscape_front.jp2',
  backImagePath: 'assets/postcard/landscape_back.jp2',
  title: '波多夕陽',
  sender: _me,
  sendFrom: _porto,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2025, 05, 20),
  receivedAt: DateTime(2025, 05, 25),
);

final Postcard _received1 = Postcard(
  id: '_mock_postcard_received-001',
  isFavorite: true,
  orientation: PostcardOrientation.portrait,
  createdAt: DateTime(2026, 10, 05),
  updatedAt: DateTime(2026, 10, 18),
  frontImagePath: 'assets/postcard/portrait_front.jp2',
  backImagePath: 'assets/postcard/portrait_back.jp2',
  title: '京都賞楓',
  sender: _friend1,
  sendFrom: _kyoto,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2026, 10, 01),
  receivedAt: DateTime(2026, 10, 05),
);

final Postcard _received2 = Postcard(
  id: '_mock_postcard_received-002',
  isFavorite: false,
  orientation: PostcardOrientation.landscape,
  createdAt: DateTime(2024, 12, 05),
  updatedAt: DateTime(2024, 12, 18),
  frontImagePath: 'assets/postcard/portrait_front.jp2',
  backImagePath: 'assets/postcard/portrait_back.jp2',
  title: '北美滑雪',
  sender: _friend3,
  sendFrom: _vancouver,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2024, 12, 01),
  receivedAt: DateTime(2024, 12, 05),
);

final List<Postcard> all_cards = [_sent1, _sent2, _received1, _received2];

class MockPostcardRepository implements PostcardRepository {

  @override
  Future<Postcard?> getLatestSentPostcard() async => _sent1;

  @override
  Future<Postcard?> getLatestReceivedPostcard() async => _received1;
}
