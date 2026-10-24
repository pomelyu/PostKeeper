import 'package:flutter/material.dart';
import 'package:postkeeper/ui/style.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel();
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
    return const Column(
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
          child: MainPostcardTab(),
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
  const MainPostcardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
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
                ),
                Placeholder(
                  key: ValueKey('main-sent-content'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

