import 'package:flutter/material.dart';
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
              Row(
                children: [
                  _buildStep(0, l10n.postcardEditImagesStep),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: textPrimaryColor,
                  ),
                  _buildStep(1, l10n.postcardEditDetailsStep),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: textPrimaryColor,
                  ),
                  _buildStep(2, l10n.postcardEditSave),
                ],
              ),
              Expanded(child: Center(child: Text(l10n.textCommingSoon))),
              SizedBox(
                height: 52,
                child: TextButton(
                  key: const ValueKey('postcard-edit-action'),
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
                    style: styleSectionTitle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep(int index, String label) {
    final selected = viewModel.currentStep == index;

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? surfacePrimaryColor : surfaceMutedColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: selected ? Colors.white : textPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: textPrimaryColor,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
