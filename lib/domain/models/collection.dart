import 'package:postkeeper/domain/models/postcard.dart';

class Collection {
  Collection({
    required this.name,
    required this.postcards,
    this.id,
  });

  final String? id;
  final String name;
  final List<Postcard> postcards;
}
