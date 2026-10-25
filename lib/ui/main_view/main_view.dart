import 'package:flutter/material.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/ui/main_view/postcard_tab.dart';
import 'package:postkeeper/ui/style.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel({required this._repository});

  final PostcardRepository _repository;

  Postcard? _latestSent;
  Postcard? _latestReceived;
  bool _disposed = false;

  Postcard? get latestSent => _latestSent;
  Postcard? get latestReceived => _latestReceived;

  Future<void> loadLatestPostcards() async {
    if (_disposed) return;

    final sent = await _repository.getLatestSentPostcard();
    final received = await _repository.getLatestReceivedPostcard();

    if (_disposed) return;

    _latestSent = sent;
    _latestReceived = received;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key, required this.viewModel});

  final MainViewModel viewModel;

  // 固定區域高度，單位為 logical pixels；釘選區域使用剩餘高度。
  static const double _titleHeight = 80;
  static const double _tabHeight = 400;
  static const double _quickAddHeight = 80;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          key: ValueKey('main-title-section'),
          height: _titleHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('我的明信片', style: styleDisplayTitle),
                Text('把收到的風景，好好收藏', style: styleBody),
              ],
            ),
          ),
        ),
        SizedBox(
          key: ValueKey('main-tab-section'),
          height: _tabHeight,
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return PostcardTab(
                latestReceived: viewModel.latestReceived,
                latestSent: viewModel.latestSent,
              );
            },
          ),
        ),
        Divider(),
        Expanded(
          child: Placeholder(
            key: ValueKey('main-pinned-section'),
          ),
        ),
        SizedBox(
          key: ValueKey('main-quick-add-section'),
          height: _quickAddHeight,
          child: TextButton(
            onPressed: null,
            child: Text('新增明信片', style: styleSectionTitle),
          )
        ),
      ],
    );
  }
}
