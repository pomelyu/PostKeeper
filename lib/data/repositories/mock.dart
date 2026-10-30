import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/country_code.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';

import './postcard_repository.dart';
import './utils.dart';

const _home = Location(id: '_mock_home', name: '家', countryCode: 'TW');
const _kaohsiung = Location(id: '_mock_home', name: '高雄', countryCode: 'TW');
const _kyoto = Location(id: '_mock_kyoto', name: '京都', countryCode: 'JP');
const _porto = Location(id: '_mock_porto', name: '波多', countryCode: 'PT');
const _vancouver = Location(id: '_mock_vancouver', name: '溫哥華', countryCode: 'CA');

const _me = Person(id: myId, name: '我', locations: [_home]);
const _friend1 = Person(id: '_mock_friend-000', name: '朋友1', locations: [_kyoto, _kaohsiung]);
const _friend2 = Person(id: '_mock_friend-001', name: '朋友2', locations: [_kaohsiung]);
const _friend3 = Person(id: '_mock_friend-002', name: '朋友3', locations: [_vancouver]);

final Postcard _sent1 = Postcard(
  id: '_mock_postcard_sent-001',
  isFavorite: false,
  orientation: PostcardOrientation.landscape,
  createdAt: DateTime(2026, 09, 25),
  updatedAt: DateTime(2026, 09, 30),
  frontImagePath: dummyCardLandscapeFront,
  backImagePath: dummyCardLandscapeBack,
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
  frontImagePath: dummyCardPortraitFront,
  backImagePath: dummyCardPortraitBack,
  title: '波多夕陽',
  sender: _me,
  sendFrom: _porto,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2025, 05, 20),
  receivedAt: DateTime(2025, 05, 25),
);

final Postcard _sent3 = Postcard(
  id: '_mock_postcard_sent-002',
  isFavorite: true,
  orientation: PostcardOrientation.landscape,
  createdAt: DateTime(2025, 07, 25),
  updatedAt: DateTime(2025, 07, 30),
  frontImagePath: dummyCardLandscapeFront,
  backImagePath: dummyCardLandscapeBack,
  title: '日本祭典',
  sender: _me,
  sendFrom: _kyoto,
  recipient: dummyPerson,
  sendTo: dummyLocation,
  sentAt: DateTime(2025, 07, 20),
  receivedAt: DateTime(2025, 07, 25),
);

final Postcard _received1 = Postcard(
  id: '_mock_postcard_received-001',
  isFavorite: true,
  orientation: PostcardOrientation.portrait,
  createdAt: DateTime(2026, 10, 05),
  updatedAt: DateTime(2026, 10, 18),
  frontImagePath: dummyCardPortraitFront,
  backImagePath: dummyCardPortraitBack,
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
  frontImagePath: dummyCardLandscapeFront,
  backImagePath: dummyCardLandscapeBack,
  title: '北美滑雪',
  sender: _friend3,
  sendFrom: _vancouver,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2024, 12, 01),
  receivedAt: DateTime(2024, 12, 05),
);

final List<Postcard> allCards = [_sent1, _sent2, _sent3, _received1, _received2]
  ..sort((a, b) {
    final aDate = a.sentAt;
    final bDate = b.sentAt;

    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return -1;
    if (bDate == null) return 1;

    return aDate.compareTo(bDate);
  });

final List<Collection> mockCustomCollections = [
  Collection(id: 'custom-travel', type: CollectionType.custom, name: '旅行回憶', postcards: [_sent1, _received2]),
  Collection(id: 'custom-japan', type: CollectionType.custom, name: '日本風景', postcards: [_sent3, _received1]),
];

class MockPostcardRepository implements PostcardRepository {

  @override
  Future<List<Collection>> getCollectionsByRegion() async {
    final groups = groupCardsBy(allCards, (card) => CountryCode.getRegion(card.sendFrom.countryCode));
    final keys = groups.keys.toList()..sort();
    return [for (final key in keys) Collection(id: key, type: CollectionType.region, name: key, postcards: groups[key]!)];
  }

  @override
  Future<List<Collection>> getCollectionsByYear() async {
    final groups = groupCardsBy(allCards, (card) => card.sentAt?.year.toString() ?? '000');
    final keys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return [for (final key in keys) Collection(id: key, type: CollectionType.year, name: key, postcards: groups[key]!)];
  }

  @override
  Future<List<Collection>> getCustomCollections() async => List.of(mockCustomCollections);

  @override
  Future<Collection> getAllPostcards() async {
    return Collection(id: allCollectionId, type: CollectionType.system, name: "All", postcards: allCards);
  }

  @override
  Future<Postcard?> getLatestSent() async {
    final collection = await getAllMySent();
    return collection.postcards.isEmpty ? null : collection.postcards.last;
  }

  @override
  Future<Postcard?> getLatestReceived() async {
    final collection = await getAllMyReceived();
    return collection.postcards.isEmpty ? null : collection.postcards.last;
  }

  @override
  Future<Collection> getAllMySent() async {
    final filtered = allCards
      .where((card) => card.sender.id == _me.id)
      .toList();
    return Collection(id: sentCollectionId, type: CollectionType.system, name: 'My Sent', postcards: filtered);
  }

  @override
  Future<Collection> getAllMyReceived() async {
    final filtered = allCards
      .where((card) => card.recipient.id == _me.id)
      .toList();
    return Collection(id: receiveCollectionId, type: CollectionType.system, name: 'My Received', postcards: filtered);
  }

  @override
  Future<Collection> getAllFavorite() async {
    final filtered = allCards
      .where((card) => card.isFavorite)
      .toList();
    return Collection(id: favoriteCollectionId, type: CollectionType.system, name: 'Favorite', postcards: filtered);
  }
}
