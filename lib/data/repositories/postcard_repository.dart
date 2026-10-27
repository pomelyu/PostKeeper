import 'package:postkeeper/domain/models/postcard.dart';

abstract interface class PostcardRepository {
  Future<List<Postcard>> getAllPostcards();

  Future<Postcard?> getLatestSent();
  Future<Postcard?> getLatestReceived();

  Future<List<Postcard>> getAllMySent();
  Future<List<Postcard>> getAllMyReceived();
  Future<List<Postcard>> getAllFavorite();
}
