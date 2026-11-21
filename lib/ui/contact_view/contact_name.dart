import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/style.dart';

class ContactName extends StatelessWidget {
  const ContactName({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.editing,
    required this.saving,
    required this.onEdit,
    required this.onSave,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool editing;
  final bool saving;
  final VoidCallback onEdit;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(l10n.contactName, style: sectionTextStyle),
        Card(
          color: surfaceMutedColor,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const ValueKey('contact-name-input'),
                    controller: controller,
                    focusNode: focusNode,
                    decoration: null,
                    readOnly: !editing || saving,
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) => IconButton(
                    key: ValueKey(
                      editing ? 'contact-name-save' : 'contact-edit-button',
                    ),
                    onPressed: saving || (editing && value.text.trim().isEmpty)
                        ? null
                        : () {
                            if (!editing) {
                              onEdit();
                            } else {
                              onSave();
                            }
                          },
                    icon: Icon(
                      editing ? Icons.save_outlined : Icons.edit_outlined,
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ]
    );
  }
}
