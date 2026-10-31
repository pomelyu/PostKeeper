import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';

class PostcardViewModel extends ChangeNotifier {
  PostcardViewModel({required this._postcard});

  final Postcard _postcard;

  Postcard get postcard => _postcard;
}

class PostcardView extends StatelessWidget {
  const PostcardView({super.key, required this.viewModel});

  final PostcardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final Postcard postcard = viewModel.postcard;

    return SecondaryViewLayout(
      title: l10n.postcardTitle,
      titleActions: [
        IconButton(
          key: const ValueKey('postcard-edit-button'),
          tooltip: '編輯',
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            context.push(postcardEditViewURI, extra: viewModel.postcard);
          },
        ),
      ],
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final isLandscape =
              postcard.orientation == PostcardOrientation.landscape;

          return Flex(
            direction: isLandscape ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(
                  postcard.frontImagePath,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Image.asset(postcard.backImagePath, fit: BoxFit.contain),
              ),
            ],
          );
        },
      ),
    );
  }
}
