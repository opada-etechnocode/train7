import '../../utils/shared_import.dart';

// Color Extensions
extension Hex on Color {
  /// return hex String
  String toHex({bool leadingHashSign = true, bool includeAlpha = false}) =>
      '${leadingHashSign ? '#' : ''}'
      // ignore: deprecated_member_use
      '${includeAlpha ? alpha.toRadixString(16).padLeft(2, '0') : ''}'
      // ignore: deprecated_member_use
      '${red.toRadixString(16).padLeft(2, '0')}'
      // ignore: deprecated_member_use
      '${green.toRadixString(16).padLeft(2, '0')}'
      // ignore: deprecated_member_use
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Return true if given Color is dark
  bool isDark() => getBrightness() < 128.0;

  /// Return true if given Color is light
  bool isLight() => !isDark();

  /// Returns Brightness of give Color
  double getBrightness() =>
      // ignore: deprecated_member_use
      (red * 299 + green * 587 + blue * 114) / 1000;

  /// Returns Luminance of give Color
  double getLuminance() => computeLuminance();
}
