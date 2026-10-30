import 'package:postkeeper/domain/models/postcard.dart';

Map<String, List<Postcard>> groupCardsBy(
  Iterable<Postcard> cards,
  String Function(Postcard) keyFor,
) {
  final groups = <String, List<Postcard>>{};
  for (final postcard in cards) {
    groups.putIfAbsent(keyFor(postcard), () => []).add(postcard);
  }
  return groups;
}
