import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/core/layout.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';

import 'postcard_actions.dart';
import 'postcard_image.dart';
import 'postcard_info.dart';

class PostcardViewModel extends ChangeNotifier {
  PostcardViewModel({required this._postcard});
  final Postcard _postcard;
  Postcard get postcard => _postcard;
  bool _showBack = false;
  bool get showBack => _showBack;
  void selectSide(bool back) {
    if (_showBack == back) return;
    _showBack = back;
    notifyListeners();
  }
}

class PostcardView extends StatelessWidget {
  const PostcardView({super.key, required this.viewModel});
  final PostcardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final postcard = viewModel.postcard;
    return SecondaryViewLayout(
      title: postcard.title?.trim().isNotEmpty == true
          ? postcard.title!
          : l10n.postcardTitle,
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => Column(
          children: [
            PostcardActions(
              postcard: postcard,
              onEdit: () => context.push(postcardEditViewURI, extra: postcard),
            ),
            PostcardImage(postcard: postcard, showBack: viewModel.showBack),
            sectionVerticalSpace,
            PostcardSideSelector(
              showBack: viewModel.showBack,
              onSideSelected: viewModel.selectSide,
            ),
            Expanded(child: PostcardInfoScroll(postcard: postcard)),
          ],
        ),
      ),
    );
  }
}
