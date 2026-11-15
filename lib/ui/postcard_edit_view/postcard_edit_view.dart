import 'package:flutter/material.dart';

import 'postcard_edit_images.dart';
import 'postcard_edit_steps.dart';

import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardEditViewModel extends ChangeNotifier {
  PostcardEditViewModel({required this._repository, this._postcard});

  final PostcardRepository _repository;
  final Postcard? _postcard;

  PostcardRepository get repository => _repository;
  Postcard? get postcard => _postcard;

  bool _showBack = false;
  bool get showBack => _showBack;

  void selectSide(bool showBack) {
    if (_showBack == showBack) return;
    _showBack = showBack;
    notifyListeners();
  }

  int _currentStep = 0;

  int get currentStep => _currentStep;
  bool get isDetailsStep => _currentStep == 1;

  void nextStep() {
    if (isDetailsStep) return;

    _currentStep = 1;
    notifyListeners();
  }
}

class PostcardEditView extends StatelessWidget {
  const PostcardEditView({super.key, required this.viewModel});

  final PostcardEditViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final String title = viewModel.isDetailsStep
            ? l10n.postcardEditDetailsTitle
            : l10n.postcardEditImagesTitle;

        return SecondaryViewLayout(
          title: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PostcardEditSteps(currentStep: viewModel.currentStep),
              const SizedBox(height: sectionSpacing),
              Expanded(
                child: viewModel.isDetailsStep
                    ? Center(child: Text(l10n.textCommingSoon))
                    : PostcardEditImages(
                        postcard: viewModel.postcard,
                        showBack: viewModel.showBack,
                        onSideSelected: viewModel.selectSide,
                      ),
              ),
              const SizedBox(height: sectionSpacing),
              SizedBox(
                height: 52,
                child: TextButton(
                  key: const ValueKey('postcard-edit-action'),
                  style: primaryActionStyle,
                  onPressed: () {
                    if (viewModel.isDetailsStep) {
                      context.pop();
                    } else {
                      viewModel.nextStep();
                    }
                  },
                  child: Text(
                    viewModel.isDetailsStep
                        ? l10n.postcardEditSave
                        : l10n.postcardEditNext,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
