import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';

class Collection {
  Collection({
    required this.name,
    required this.type,
    required this.postcards,
    required this.id,
  });

  final String id;
  final String name;
  final CollectionType type;
  final List<Postcard> postcards;
}
