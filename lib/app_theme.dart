import '../utils/shared_import.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightScaffold = Color(0xFFF5F6F8);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightDivider = Color(0xFFE6E8EC);
  static const Color _lightInput = Color(0xFFF0F1F3);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: _lightScaffold,
    primaryColor: primaryColor,
    canvasColor: _lightScaffold,
    cardColor: _lightCard,
    dividerColor: _lightDivider,
    hintColor: const Color(0xFF8A8A8A),
    disabledColor: const Color(0xFFB0B3B8),
    iconTheme: const IconThemeData(color: Color(0xFF1C1C1E)),
    primaryIconTheme: const IconThemeData(color: primaryColor),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: _lightCard,
      foregroundColor: Color(0xFF1C1C1E),
      iconTheme: IconThemeData(color: Color(0xFF1C1C1E)),
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1C1C1E),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _lightCard,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF8A8A8A),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      modalBackgroundColor: _lightCard,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    cardTheme: CardThemeData(
      color: _lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightInput,
      hintStyle: const TextStyle(
        fontFamily: 'Cairo',
        color: Color(0xFF8A8A8A),
        fontSize: 14,
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Cairo',
        color: Color(0xFF5C5F66),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _lightDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryColor, width: 1.2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor,
      surface: _lightCard,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1C1C1E),
      onError: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: radius(20),
        side: const BorderSide(color: primaryColor),
      ),
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(primaryColor),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    ),
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Cairo',
      bodyColor: const Color(0xFF1C1C1E),
      displayColor: const Color(0xFF1C1C1E),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  /// Dark theme — kept as original (do not alter colors).
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    fontFamily: 'Cairo',
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: scaffoldColorDark,
    iconTheme: const IconThemeData(color: Colors.white),
    cardColor: const Color(0xFF151A22),
    colorScheme: const ColorScheme(
      primary: primaryColor,
      secondary: primaryColor,
      surface: Colors.black,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.redAccent,
      brightness: Brightness.dark,
    ),
    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: primaryColor,
      headerForegroundColor: Colors.white,
      backgroundColor: scaffoldColorDark,
      dayForegroundColor: WidgetStateProperty.all(Colors.white),
      yearForegroundColor: WidgetStateProperty.all(Colors.white),
      rangePickerHeaderBackgroundColor: primaryColor,
      rangePickerHeaderForegroundColor: Colors.white,
      dayStyle: primaryTextStyle(color: Colors.white),
    ),
    dividerColor: Colors.white24,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Cairo',
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: radius(20),
        side: const BorderSide(color: primaryColor),
      ),
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(primaryColor),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
