import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/postcard.dart';

abstract interface class PostcardRepository {
  Future<Collection> getAllPostcards();
  Future<List<Collection>> getCollectionsByRegion();
  Future<List<Collection>> getCollectionsByYear();
  Future<List<Collection>> getCustomCollections();

  Future<Postcard?> getLatestSent();
  Future<Postcard?> getLatestReceived();

  Future<Collection> getAllMySent();
  Future<Collection> getAllMyReceived();
  Future<Collection> getAllFavorite();

  Future<Postcard?> getPostcardById(String id);
  Future<Collection?> getCustomCollectionById(String id);
  Future<List<Postcard>> searchPostcards(String query);
}
