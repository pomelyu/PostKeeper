import 'package:postkeeper/constant.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/enums.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/geography_names.dart';

/// Resolves a collection's display name without changing its data.
String decodeCollectionName(Collection collection, AppLocalizations l10n) =>
  switch (collection.type) {
    CollectionType.custom => collection.name,
    CollectionType.region => getRegionName(collection.name, l10n),
    CollectionType.year =>
      collection.name == '000' ? l10n.geoUnknown : collection.name,
    CollectionType.system => switch (collection.id) {
      favoriteCollectionId => l10n.keeperFavorite,
      receiveCollectionId => l10n.keeperReceived,
      sentCollectionId => l10n.keeperSent,
      _ => collection.name,
    },
  };
