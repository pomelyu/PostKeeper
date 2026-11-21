import 'package:postkeeper/data/constants.dart';
import 'package:postkeeper/data/country_code.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';

import './person_repository.dart';
import './postcard_repository.dart';
import './utils.dart';

const _home = Location(id: '_mock_home', name: '家', countryCode: 'TW', latitude: 22.6273, longitude: 120.3014);
const _kaohsiung = Location(id: '_mock_kaohsiung', name: '高雄', countryCode: 'TW', latitude: 22.6273, longitude: 120.3014);
const _taipei = Location(id: '_mock_taipei', name: '台北', countryCode: 'TW', latitude: 25.0330, longitude: 121.5654);
const _tokyo = Location(id: '_mock_tokyo', name: '東京', countryCode: 'JP', latitude: 35.6762, longitude: 139.6503);
const _lisbon = Location(id: '_mock_lisbon', name: '里斯本', countryCode: 'PT', latitude: 38.7223, longitude: -9.1393);
const _kyoto = Location(id: '_mock_kyoto', name: '京都', countryCode: 'JP', latitude: 35.0116, longitude: 135.7681);
const _porto = Location(id: '_mock_porto', name: '波多', countryCode: 'PT', latitude: 41.1579, longitude: -8.6291);
const _vancouver = Location(id: '_mock_vancouver', name: '溫哥華', countryCode: 'CA', latitude: 49.2827, longitude: -123.1207);

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
  id: '_mock_postcard_sent-003',
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
  notes: "秋天的京都，是一年之中最令人著迷的季節。漫步在清水寺與嵐山之間，"
  "楓葉染紅了古老的寺院與街道，陽光穿過枝葉，灑落一地金黃。沿著石板小徑緩緩前行，偶爾停下腳步，欣賞紅葉與古寺交織的風景。"
  "傍晚坐進街角的茶屋，品嚐一杯溫熱的抹茶，感受京都獨有的寧靜與浪漫。希望能將這份秋日的美好，永遠收藏在回憶裡。"
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

final Postcard _received3 = Postcard(
  id: '_mock_postcard_received-003',
  isFavorite: false,
  orientation: PostcardOrientation.landscape,
  createdAt: DateTime(2026, 11, 04),
  updatedAt: DateTime(2026, 11, 04),
  frontImagePath: dummyCardLandscapeFront,
  backImagePath: dummyCardLandscapeBack,
  title: '里斯本電車',
  sender: _friend1,
  sendFrom: _lisbon,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2026, 11, 03),
  receivedAt: DateTime(2026, 11, 04),
);

final Postcard _received4 = Postcard(
  id: '_mock_postcard_received-004',
  isFavorite: false,
  orientation: PostcardOrientation.landscape,
  createdAt: DateTime(2026, 11, 05),
  updatedAt: DateTime(2026, 11, 05),
  frontImagePath: dummyCardLandscapeFront,
  backImagePath: dummyCardLandscapeBack,
  title: '東京散步',
  sender: _friend1,
  sendFrom: _tokyo,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2026, 11, 04),
  receivedAt: DateTime(2026, 11, 05),
);

final Postcard _received5 = Postcard(
  id: '_mock_postcard_received-005',
  isFavorite: false,
  orientation: PostcardOrientation.landscape,
  createdAt: DateTime(2026, 11, 06),
  updatedAt: DateTime(2026, 11, 06),
  frontImagePath: dummyCardLandscapeFront,
  backImagePath: dummyCardLandscapeBack,
  title: '台北街景',
  sender: _friend2,
  sendFrom: _taipei,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2026, 11, 05),
  receivedAt: DateTime(2026, 11, 06),
);

final Postcard _received6 = Postcard(
  id: '_mock_postcard_received-006',
  isFavorite: false,
  orientation: PostcardOrientation.landscape,
  createdAt: DateTime(2026, 11, 07),
  updatedAt: DateTime(2026, 11, 07),
  frontImagePath: dummyCardLandscapeFront,
  backImagePath: dummyCardLandscapeBack,
  title: '高雄港灣',
  sender: _friend2,
  sendFrom: _kaohsiung,
  recipient: _me,
  sendTo: _home,
  sentAt: DateTime(2026, 11, 06),
  receivedAt: DateTime(2026, 11, 07),
);

final List<Postcard> allCards = [_sent1, _sent2, _sent3, _received1, _received2, _received3, _received4, _received5, _received6]
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

class MockPersonRepository implements PersonRepository {
  final Map<String, Person> _updates = {};

  @override
  Future<void> removeLocation(String id, String locationId) async {
    final person = (await getPersonById(id))!;
    _updates[id] = Person(
      id: id,
      name: person.name,
      locations: person.locations
          .where((item) => item.id != locationId)
          .toList(),
    );
  }

  @override
  Future<void> updateName(String id, String name) async {
    if (name.trim().isEmpty) throw ArgumentError.value(name, 'name');
    final person = (await getPersonById(id))!;
    _updates[id] = Person(
      id: id,
      name: name.trim(),
      locations: person.locations,
    );
  }

  @override
  Future<void> addLocation(String id, Location location) async {
    final person = (await getPersonById(id))!;
    _updates[id] = Person(
      id: id,
      name: person.name,
      locations: [
        ...person.locations,
        if (!person.locations.any((item) => item.id == location.id)) location,
      ],
    );
  }

  @override
  Future<List<Person>> getAllUsers() async => [
    for (final person in [_me, _friend1, _friend2, _friend3])
      _updates[person.id] ?? person,
  ];

  @override
  Future<Person> getMyInfo() async => _updates[_me.id] ?? _me;

  @override
  Future<Person?> getPersonById(String id) async {
    for (final person in await getAllUsers()) {
      if (person.id == id) return person;
    }
    return null;
  }
}

class MockPostcardRepository implements PostcardRepository {

  @override
  Future<Postcard?> getPostcardById(String id) async {
    for (final card in allCards) {
      if (card.id == id) return card;
    }
    return null;
  }

  @override
  Future<Collection?> getCustomCollectionById(String id) async {
    for (final collection in mockCustomCollections) {
      if (collection.id == id) return collection;
    }
    return null;
  }

  @override
  Future<List<Postcard>> searchPostcards(String query) async {
    final term = query.trim().toLowerCase();
    return allCards.where((card) => [
      card.title, card.notes, card.sender.name, card.recipient.name,
      card.sendFrom.name, card.sendFrom.address, card.sendTo.name, card.sendTo.address,
    ].any((value) => value?.toLowerCase().contains(term) ?? false)).toList();
  }

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
