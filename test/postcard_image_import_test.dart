import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/postcard_edit_view/postcard_edit_view.dart';

void main() {
  testWidgets('圖片選取、取消取代與確認取代只更新選中的面', (tester) async {
    final repository = MockPostcardRepository();
    final postcard = (await repository.getAllPostcards()).postcards.first;
    final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );
    final sources = <ImageSource>[];
    XFile? selection = XFile.fromData(bytes);
    final model = PostcardEditViewModel(
      repository: repository,
      personRepository: MockPersonRepository(),
      postcard: postcard,
      pickImage: (source) async {
        sources.add(source);
        return selection;
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PostcardEditView(viewModel: model),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('postcard-edit-gallery')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('postcard-edit-replace-dialog')),
      findsOneWidget,
    );
    await tester.tap(
      find.byKey(const ValueKey('postcard-edit-replace-cancel')),
    );
    await tester.pumpAndSettle();
    expect(model.frontImage, isNull);
    await tester.tap(find.byKey(const ValueKey('postcard-edit-back-tab')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('postcard-edit-camera')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('postcard-edit-replace-confirm')),
    );
    await tester.pumpAndSettle();
    expect(model.backImage, bytes);
    expect(model.frontImage, isNull);
    expect(sources, [ImageSource.gallery, ImageSource.camera]);
    selection = null;
    await tester.tap(find.byKey(const ValueKey('postcard-edit-gallery')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('postcard-edit-replace-dialog')),
      findsNothing,
    );
    expect(model.backImage, bytes);
    expect(model.importingImage, isFalse);
    await tester.pumpWidget(const SizedBox());
    model.dispose();
  });
}
