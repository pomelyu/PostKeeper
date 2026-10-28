import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/postcard.dart';

abstract interface class PostcardRepository {
  Future<Collection> getAllPostcards();

  Future<Postcard?> getLatestSent();
  Future<Postcard?> getLatestReceived();

  Future<Collection> getAllMySent();
  Future<Collection> getAllMyReceived();
  Future<Collection> getAllFavorite();
}
