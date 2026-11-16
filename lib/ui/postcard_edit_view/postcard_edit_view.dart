
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postkeeper/data/repositories/person_repository.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';
import 'package:postkeeper/ui/style.dart';

import 'postcard_edit_details.dart';
import 'postcard_edit_images.dart';
import 'postcard_edit_steps.dart';

class PostcardEditViewModel extends ChangeNotifier {
  PostcardEditViewModel({
    required this._repository,
    required PersonRepository personRepository,
    Postcard? postcard,
    Future<XFile?> Function(ImageSource)? pickImage,
  }) : pickImage =
           pickImage ??
           ((source) => ImagePicker().pickImage(
             source: source,
             requestFullMetadata: false,
           )),
       _postcard = postcard,
       people = personRepository.getAllUsers(),
       titleController = TextEditingController(text: postcard?.title ?? ''),
       notesController = TextEditingController(text: postcard?.notes ?? ''),
       senderController = TextEditingController(
         text: postcard?.sender.name ?? '',
       ),
       recipientController = TextEditingController(
         text: postcard?.recipient.name ?? '',
       ),
       sender = postcard?.sender,
       recipient = postcard?.recipient,
       sentAt = postcard?.sentAt,
       receivedAt = postcard?.receivedAt,
       sendFrom = postcard?.sendFrom,
       sendTo = postcard?.sendTo;

  final Future<XFile?> Function(ImageSource) pickImage;
  Uint8List? frontImage;
  Uint8List? backImage;
  bool importingImage = false;

  bool hasImage(bool back) =>
      (back ? backImage : frontImage) != null ||
      (back ? postcard?.backImagePath : postcard?.frontImagePath)?.isNotEmpty ==
          true;

  void setImportingImage(bool value) {
    importingImage = value;
    notifyListeners();
  }

  void replaceImage(Uint8List bytes, {required bool back}) {
    if (back) {
      backImage = bytes;
    } else {
      frontImage = bytes;
    }
    notifyListeners();
  }

  final Future<List<Person>> people;
  final TextEditingController titleController;
  final TextEditingController notesController;
  final TextEditingController senderController;
  final TextEditingController recipientController;
  Person? sender;
  Person? recipient;
  DateTime? sentAt;
  DateTime? receivedAt;
  Location? sendFrom;
  Location? sendTo;

  void selectPerson(Person person, {required bool sending}) {
    if (sending) {
      sender = person;
      senderController.text = person.name;
    } else {
      recipient = person;
      recipientController.text = person.name;
    }
    notifyListeners();
  }

  void editPersonName(String name, {required bool sending}) {
    if (sending) {
      if (sender?.name == name) return;
      sender = null;
    } else {
      if (recipient?.name == name) return;
      recipient = null;
    }
    notifyListeners();
  }

  void selectDate(DateTime date, {required bool sending}) {
    if (sending) {
      sentAt = date;
    } else {
      receivedAt = date;
    }
    notifyListeners();
  }

  void selectLocation(Location location, {required bool sending}) {
    if (sending) {
      sendFrom = location;
    } else {
      sendTo = location;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    senderController.dispose();
    recipientController.dispose();
    super.dispose();
  }

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

  void selectStep(int step) {
    if (step < 0 || step > 1 || _currentStep == step) return;
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() => selectStep(1);
}

class PostcardEditView extends StatelessWidget {
  const PostcardEditView({super.key, required this.viewModel});

  final PostcardEditViewModel viewModel;

  Future<void> _importImage(BuildContext context, ImageSource source) async {
    if (viewModel.importingImage) return;
    final back = viewModel.showBack;
    viewModel.setImportingImage(true);
    try {
      final file = await viewModel.pickImage(source);
      if (file == null || !context.mounted) return;
      final bytes = await file.readAsBytes();
      if (!context.mounted) return;
      if (viewModel.hasImage(back)) {
        final l10n = AppLocalizations.of(context);
        final replace = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            key: const ValueKey('postcard-edit-replace-dialog'),
            title: Text(l10n.postcardEditReplaceImage),
            content: Text(l10n.postcardEditReplaceImageMessage),
            actions: [
              TextButton(
                key: const ValueKey('postcard-edit-replace-cancel'),
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                ),
              ),
              TextButton(
                key: const ValueKey('postcard-edit-replace-confirm'),
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.postcardEditReplaceImage),
              ),
            ],
          ),
        );
        if (replace != true || !context.mounted) return;
      }
      viewModel.replaceImage(bytes, back: back);
    } on PlatformException catch (_) {
      if (context.mounted) _showImportError(context);
    } on MissingPluginException catch (_) {
      if (context.mounted) _showImportError(context);
    } catch (_) {
      if (context.mounted) _showImportError(context);
    } finally {
      if (context.mounted) viewModel.setImportingImage(false);
    }
  }

  void _showImportError(BuildContext context) => ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).postcardEditImageError),
        ),
      );

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
              PostcardEditSteps(
                currentStep: viewModel.currentStep,
                onStepSelected: (step) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  viewModel.selectStep(step);
                },
              ),
              const SizedBox(height: sectionSpacing),
              Expanded(
                child: viewModel.isDetailsStep
                    ? PostcardEditDetails(viewModel: viewModel)
                    : PostcardEditImages(
                        postcard: viewModel.postcard,
                        showBack: viewModel.showBack,
                        onSideSelected: viewModel.selectSide,
                        image: viewModel.showBack
                            ? viewModel.backImage
                            : viewModel.frontImage,
                        importing: viewModel.importingImage,
                        onCamera: () =>
                            _importImage(context, ImageSource.camera),
                        onGallery: () =>
                            _importImage(context, ImageSource.gallery),
                      ),
              ),
              const SizedBox(height: sectionSpacing),
              SizedBox(
                height: 52,
                child: TextButton(
                  key: const ValueKey('postcard-edit-action'),
                  style: primaryActionStyle,
                  onPressed: viewModel.isDetailsStep
                      ? null
                      : viewModel.nextStep,
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
