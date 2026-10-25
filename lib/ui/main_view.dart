import 'package:flutter/material.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/ui/style.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel({required PostcardRepository repository})
    : _repository = repository;

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
              return MainPostcardTab(
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


class MainPostcardTab extends StatelessWidget {
  const MainPostcardTab({
    super.key,
    required this.latestReceived,
    required this.latestSent,
  });

  final Postcard? latestReceived;
  final Postcard? latestSent;

  @override
  Widget build(BuildContext context) {
    final sentImagePath = latestSent?.frontImagePath;
    final receivedImagePath = latestReceived?.frontImagePath;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                key: ValueKey('main-received-tab'),
                text: '最近收到',
              ),
              Tab(
                key: ValueKey('main-sent-tab'),
                text: '最近寄出',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Placeholder(
                  key: ValueKey('main-received-content'),
                  child: receivedImagePath != null && receivedImagePath.isNotEmpty
                    ? Image.asset(receivedImagePath)
                    : const Text('尚無資料'),
                ),
                Placeholder(
                  key: ValueKey('main-sent-content'),
                  child: sentImagePath != null && sentImagePath.isNotEmpty
                    ? Image.asset(sentImagePath)
                    : const Text('尚無資料'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

