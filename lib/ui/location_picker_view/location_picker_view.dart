import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/app_map.dart';
import 'package:postkeeper/ui/core/layout.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';
import 'package:postkeeper/ui/style.dart';

import 'location_picker_view_model.dart';

class LocationPickerView extends StatelessWidget {
  const LocationPickerView({
    super.key,
    required this.viewModel,
  });
  final LocationPickerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SecondaryViewLayout(
      title: l10n.locationPickerTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LocationSearchField(controller: viewModel.searchController),
          sectionVerticalSpace,
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Stack(
                        fit: StackFit.expand,
                        children: [
                          AppMap(selected: viewModel.selected),
                          if (viewModel.suggestions.isNotEmpty)
                            Align(
                              alignment: Alignment.topCenter,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: constraints.maxHeight * .6,
                                ),
                                child: LocationSearchResults(
                                  viewModel: viewModel,
                                ),
                              ),
                            ),
                          if (viewModel.loading)
                            const Align(
                              alignment: Alignment.topCenter,
                              child: LinearProgressIndicator(),
                            ),
                          if (viewModel.failed || viewModel.noResults)
                            Align(
                              alignment: Alignment.topCenter,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    viewModel.failed
                                        ? l10n.locationPickerError
                                        : l10n.locationPickerNoResults,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (viewModel.selected case final location?) ...[
                    sectionVerticalSpace,
                    LocationSelectionSummary(location: location),
                  ],
                  sectionVerticalSpace,
                  TextButton(
                    key: const ValueKey('location-picker-confirm'),
                    style: primaryActionStyle,
                    onPressed: viewModel.canConfirm
                        ? () => context.pop(viewModel.selected)
                        : null,
                    child: Text(l10n.locationPickerConfirm),
                  ),
                  sectionVerticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationSearchField extends StatelessWidget {
  const LocationSearchField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextFormField(
    key: const ValueKey('location-picker-search'),
    controller: controller,
    decoration: InputDecoration(
      hintText: AppLocalizations.of(context).locationPickerSearch,
      prefixIcon: const Icon(Icons.search),
    ),
    textInputAction: TextInputAction.search,
    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
  );
}

class LocationSearchResults extends StatelessWidget {
  const LocationSearchResults({super.key, required this.viewModel});
  final LocationPickerViewModel viewModel;

  @override
  Widget build(BuildContext context) => Material(
    color: backgroundColor,
    elevation: 2,
    borderRadius: BorderRadius.circular(cardRadius),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView.builder(
            key: const ValueKey('location-picker-results'),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: viewModel.suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = viewModel.suggestions[index];
              return ListTile(
                key: ValueKey('location-result-${suggestion.id}'),
                title: Text(suggestion.name),
                subtitle: Text(suggestion.address),
                onTap: viewModel.loading
                    ? null
                    : () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        viewModel.select(suggestion);
                      },
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Google Maps',
            style: TextStyle(fontSize: 12, color: Color(0xFF5E5E5E)),
          ),
        ),
      ],
    ),
  );
}

class LocationSelectionSummary extends StatelessWidget {
  const LocationSelectionSummary({super.key, required this.location});
  final Location location;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('location-picker-selection'),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: surfaceMutedColor,
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(color: borderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(location.name, style: sectionTextStyle),
        Text(
          location.address ?? '',
          style: labelTextStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
