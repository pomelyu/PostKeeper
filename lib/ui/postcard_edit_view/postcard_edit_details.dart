import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/style.dart';

import 'postcard_edit_detail_fields.dart';
import 'postcard_edit_view.dart';

class PostcardEditDetails extends StatelessWidget {
  const PostcardEditDetails({super.key, required this.viewModel});
  final PostcardEditViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<List<Person>>(
      future: viewModel.people,
      builder: (context, snapshot) {
        final people = snapshot.data ?? const <Person>[];
        return LayoutBuilder(
          builder: (context, constraints) {
            final keyboard = MediaQuery.viewInsetsOf(context).bottom;
            final content = Column(
              key: const ValueKey('postcard-edit-details'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostcardEditPureTextField(
                  fieldKey: 'title',
                  label: l10n.postcardEditTitleLabel,
                  controller: viewModel.titleController,
                ),
                const SizedBox(height: 12),
                PostcardEditPartySection(
                  title: l10n.postcardEditSending,
                  peopleField: PostcardEditPeopleField(
                    fieldKey: 'sender',
                    controller: viewModel.senderController,
                    people: people,
                    onSelected: (person) =>
                        viewModel.selectPerson(person, sending: true),
                    onChanged: (name) =>
                        viewModel.editPersonName(name, sending: true),
                  ),
                  dateField: PostcardEditDateField(
                    fieldKey: 'sent-date',
                    value: viewModel.sentAt,
                    onSelected: (date) =>
                        viewModel.selectDate(date, sending: true),
                  ),
                  locationField: PostcardEditLocationField(
                    fieldKey: 'send-from',
                    value: viewModel.sendFrom,
                    locations: viewModel.sender?.locations ?? const [],
                    onSelected: (location) =>
                        viewModel.selectLocation(location, sending: true),
                  ),
                ),
                const SizedBox(height: 12),
                PostcardEditPartySection(
                  title: l10n.postcardEditReceiving,
                  peopleField: PostcardEditPeopleField(
                    fieldKey: 'recipient',
                    controller: viewModel.recipientController,
                    people: people,
                    onSelected: (person) =>
                        viewModel.selectPerson(person, sending: false),
                    onChanged: (name) =>
                        viewModel.editPersonName(name, sending: false),
                  ),
                  dateField: PostcardEditDateField(
                    fieldKey: 'received-date',
                    value: viewModel.receivedAt,
                    onSelected: (date) =>
                        viewModel.selectDate(date, sending: false),
                  ),
                  locationField: PostcardEditLocationField(
                    fieldKey: 'send-to',
                    value: viewModel.sendTo,
                    locations: viewModel.recipient?.locations ?? const [],
                    onSelected: (location) =>
                        viewModel.selectLocation(location, sending: false),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  flex: 2,
                  child: PostcardEditNotesSection(
                    controller: viewModel.notesController,
                  ),
                ),
              ],
            );
            if (keyboard == 0) return content;
            return SingleChildScrollView(
              child: SizedBox(
                height: constraints.maxHeight + keyboard,
                child: content,
              ),
            );
          },
        );
      },
    );
  }
}

class PostcardEditPartySection extends StatelessWidget {
  const PostcardEditPartySection({
    super.key,
    required this.title,
    required this.peopleField,
    required this.dateField,
    required this.locationField,
  });
  final String title;
  final Widget peopleField;
  final Widget dateField;
  final Widget locationField;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: surfaceMutedColor,
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(color: borderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          child: Text(title, style: styleSectionTitle),
        ),
        peopleField,
        const Divider(height: 1, indent: 12, endIndent: 12),
        dateField,
        const Divider(height: 1, indent: 12, endIndent: 12),
        locationField,
      ],
    ),
  );
}

class PostcardEditNotesSection extends StatelessWidget {
  const PostcardEditNotesSection({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(color: borderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).postcardEditNotes,
          style: styleSectionTitle,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TextFormField(
            key: const ValueKey('postcard-edit-notes'),
            controller: controller,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            expands: true,
            maxLines: null,
            textAlignVertical: TextAlignVertical.top,
            style: styleLabel,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ),
      ],
    ),
  );
}
