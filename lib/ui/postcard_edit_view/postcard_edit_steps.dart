import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardEditSteps extends StatelessWidget {
  const PostcardEditSteps({
    super.key,
    required this.currentStep,
    required this.onStepSelected,
  });
  final int currentStep;
  final ValueChanged<int> onStepSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        _buildStep(0, l10n.postcardEditImagesStep),
        const Icon(Icons.arrow_forward),
        _buildStep(1, l10n.postcardEditDetailsStep),
        const Icon(Icons.arrow_forward),
        _buildStep(2, l10n.postcardEditSave),
      ],
    );
  }

  Widget _buildStep(int index, String label) {
    final selected = currentStep == index;

    return Expanded(
      child: InkWell(
        key: ValueKey('postcard-edit-step-${index + 1}'),
        onTap: index < 2 ? () => onStepSelected(index) : null,
        borderRadius: BorderRadius.circular(16),
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
      ),
    );
  }
}
