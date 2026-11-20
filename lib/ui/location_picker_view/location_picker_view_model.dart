import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/repositories/location_repository.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/place_suggestion.dart';
class LocationPickerViewModel extends ChangeNotifier {
  LocationPickerViewModel({required this.repository}) {
    searchController.addListener(_onSearchChanged);
  }
  final TextEditingController searchController = TextEditingController();
  String _lastInput = '';
  bool _wasComposing = false;

  void _onSearchChanged() {
    final value = searchController.value;
    final composing = value.composing.isValid && !value.composing.isCollapsed;
    if (_lastInput == value.text && _wasComposing == composing) return;
    _lastInput = value.text;
    _wasComposing = composing;
    changeQuery(value.text, composing: composing);
  }

  final LocationRepository repository;
  Timer? _debounce;
  int _revision = 0;
  bool _disposed = false;
  String? _sessionId;
  String _query = '';
  List<PlaceSuggestion> _suggestions = const [];
  Location? _selected;
  bool _loading = false;
  bool _failed = false;
  bool _searched = false;

  List<PlaceSuggestion> get suggestions => _suggestions;
  Location? get selected => _selected;
  bool get loading => _loading;
  bool get failed => _failed;
  bool get noResults =>
      _searched &&
      !_loading &&
      !_failed &&
      _suggestions.isEmpty &&
      _selected == null;
  bool get canConfirm => _selected != null && !_loading;

  String _session() =>
      _sessionId ??= DateTime.now().microsecondsSinceEpoch.toString();

  void changeQuery(String text, {bool composing = false}) {
    _debounce?.cancel();
    final revision = ++_revision;
    _query = text.trim();
    _suggestions = const [];
    _selected = null;
    _loading = false;
    _failed = false;
    _searched = false;
    if (!composing && _query.runes.length >= 2) {
      _loading = true;
      _debounce = Timer(
        const Duration(milliseconds: locationAutocompletePeriod),
        () => _search(revision),
      );
    } else if (_query.isEmpty) {
      _endSession();
    }
    notifyListeners();
  }

  Future<void> _search(int revision) async {
    try {
      final found = await repository.search(_query, _session());
      if (_disposed || revision != _revision) return;
      _suggestions = List.unmodifiable(found);
      _searched = true;
    } catch (_) {
      if (_disposed || revision != _revision) return;
      _failed = true;
    } finally {
      if (!_disposed && revision == _revision) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> select(PlaceSuggestion suggestion) async {
    _debounce?.cancel();
    final revision = ++_revision;
    final session = _session();
    _sessionId = null;
    _loading = true;
    _failed = false;
    _selected = null;
    notifyListeners();
    try {
      final location = await repository.select(suggestion, session);
      if (_disposed || revision != _revision) return;
      _selected = location;
      _suggestions = const [];
      _searched = false;
    } catch (_) {
      if (_disposed || revision != _revision) return;
      _failed = true;
    } finally {
      unawaited(repository.endSession(session).catchError((Object _) {}));
      if (!_disposed && revision == _revision) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  void _endSession() {
    final session = _sessionId;
    _sessionId = null;
    if (session != null) {
      unawaited(repository.endSession(session).catchError((Object _) {}));
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    searchController.dispose();
    _endSession();
    super.dispose();
  }
}
