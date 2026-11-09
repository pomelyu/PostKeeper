import 'package:flutter/material.dart';

const backgroundColor = Color(0xFFFDFBF1);
const surfacePrimaryColor = Color(0xFF758A66);
const surfaceMutedColor = Color(0xFFF7F0DD);
const textPrimaryColor = Color(0xFF293422);
const textSecondaryColor = Color(0xFF5D6656);
const borderColor = Color(0xFFCFDAC4);
const selectionColor = Color(0xFFC4D7BC);
const pagePadding = 20.0;
const sectionSpacing = 16.0;
const cardRadius = 16.0;
const controlHeight = 52.0;
const styleDisplayTitle = TextStyle(
  color: textPrimaryColor,
  fontSize: 28,
  fontWeight: FontWeight.w700,
  height: 1.3,
);
const styleSectionTitle = TextStyle(
  color: textPrimaryColor,
  fontSize: 18,
  fontWeight: FontWeight.w700,
  height: 1.4,
);
const styleBody = TextStyle(color: textPrimaryColor, fontSize: 16, height: 1.5);
const styleLabel = TextStyle(
  color: textSecondaryColor,
  fontSize: 14,
  height: 1.4,
);

final primaryActionStyle = TextButton.styleFrom(
  backgroundColor: surfacePrimaryColor,
  foregroundColor: Colors.white,
  minimumSize: const Size(0, controlHeight),
  textStyle: styleSectionTitle,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(cardRadius),
  ),
);
ButtonStyle collectionTabStyle(bool selected) => TextButton.styleFrom(
  backgroundColor: selected ? surfacePrimaryColor : surfaceMutedColor,
  foregroundColor: selected ? Colors.white : textPrimaryColor,
  shape: const StadiumBorder(),
);

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: surfacePrimaryColor).copyWith(
    primary: surfacePrimaryColor,
    onPrimary: Colors.white,
    surface: backgroundColor,
    onSurface: textPrimaryColor,
    onSurfaceVariant: textSecondaryColor,
    outline: borderColor,
    secondaryContainer: selectionColor,
  );
  final outline = OutlineInputBorder(
    borderRadius: BorderRadius.circular(cardRadius),
    borderSide: const BorderSide(color: borderColor),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      headlineLarge: styleDisplayTitle,
      titleLarge: styleSectionTitle,
      titleMedium: styleBody,
      bodyLarge: styleBody,
      bodyMedium: styleLabel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textPrimaryColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: backgroundColor,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: const BorderSide(color: borderColor),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: textSecondaryColor,
    ),
    dividerTheme: const DividerThemeData(
      color: borderColor,
      thickness: 1,
      space: 24,
    ),
    iconTheme: const IconThemeData(color: textPrimaryColor, size: 24),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: backgroundColor,
      indicatorColor: selectionColor,
      surfaceTintColor: Colors.transparent,
      height: 72,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundColor,
      border: outline,
      enabledBorder: outline,
      focusedBorder: outline.copyWith(
        borderSide: const BorderSide(color: surfacePrimaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: surfacePrimaryColor,
        borderRadius: BorderRadius.circular(28),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: textPrimaryColor,
      labelStyle: styleSectionTitle,
      unselectedLabelStyle: styleBody,
    ),
  );
}
