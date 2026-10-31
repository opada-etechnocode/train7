import '../../utils/shared_import.dart';

/// returns default InputDecoration for AppTextField widget
InputDecoration defaultInputDecoration(
  BuildContext context, {
  String? hint,
  String? label,
  TextStyle? textStyle,
  bool? isFocusTExtField = false,
  Widget? mPrefix,
}) {
  final bool isDark = appStore.isDarkMode;
  final Color borderColor = context.dividerColor.withValues(alpha: 0.7);

  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    prefixIcon: mPrefix,
    // Fill only in light theme — dark theme input look unchanged
    filled: !isDark,
    fillColor: isDark ? null : const Color(0xFFF0F1F3),
    hintText: hint,
    hintStyle: secondaryTextStyle(),
    border: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(
        color: isFocusTExtField == true ? borderColor : primaryColor,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(
        color: isFocusTExtField == true ? borderColor : primaryColor,
        width: 1.2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(color: borderColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(
        color: isFocusTExtField == true ? borderColor : Colors.red,
      ),
    ),
    alignLabelWithHint: true,
    isDense: true,
    labelText: label,
    labelStyle: secondaryTextStyle(),
  );
}

/// returns Radius
BorderRadius radius([double? radius]) =>
    BorderRadius.all(radiusCircular(radius ?? defaultRadius));

/// returns Radius
Radius radiusCircular([double? radius]) =>
    Radius.circular(radius ?? defaultRadius);

ShapeBorder dialogShape([double? borderRadius]) =>
    RoundedRectangleBorder(borderRadius: radius(borderRadius ?? defaultRadius));

/// returns custom Radius on each side
BorderRadius radiusOnly({
  double? topRight,
  double? topLeft,
  double? bottomRight,
  double? bottomLeft,
}) => BorderRadius.only(
  topRight: radiusCircular(topRight ?? 0),
  topLeft: radiusCircular(topLeft ?? 0),
  bottomRight: radiusCircular(bottomRight ?? 0),
  bottomLeft: radiusCircular(bottomLeft ?? 0),
);

Decoration boxDecorationDefault({
  BorderRadiusGeometry? borderRadius,
  Color? color,
  Gradient? gradient,
  BoxBorder? border,
  BoxShape? shape,
  BlendMode? backgroundBlendMode,
  List<BoxShadow>? boxShadow,
  DecorationImage? image,
}) => BoxDecoration(
  borderRadius: (shape != null && shape == BoxShape.circle)
      ? null
      : (borderRadius ?? radius()),
  boxShadow: boxShadow ?? defaultBoxShadow(),
  color: color ?? Colors.white,
  gradient: gradient,
  border: border,
  shape: shape ?? BoxShape.rectangle,
  backgroundBlendMode: backgroundBlendMode,
  image: image,
);

/// rounded box decoration
Decoration boxDecorationWithRoundedCorners({
  Color? backgroundColor,
  BorderRadius? borderRadius,
  LinearGradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  DecorationImage? decorationImage,
  BoxShape boxShape = BoxShape.rectangle,
}) => BoxDecoration(
  color:
      backgroundColor ??
          (appStore.isDarkMode ? const Color(0xFF151A22) : cardLightColor),
  borderRadius: boxShape == BoxShape.circle ? null : (borderRadius ?? radius()),
  gradient: gradient,
  border: border,
  boxShadow: boxShadow,
  image: decorationImage,
  shape: boxShape,
);

/// box decoration with shadow
Decoration boxDecorationWithShadow({
  Color? backgroundColor,
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
  LinearGradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  DecorationImage? decorationImage,
  BoxShape boxShape = BoxShape.rectangle,
  BorderRadius? borderRadius,
}) {
  log(backgroundColor.toString());
  return BoxDecoration(
    boxShadow:
        boxShadow ??
        defaultBoxShadow(
          shadowColor: shadowColor,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
          offset: offset,
        ),
    color:
        backgroundColor ??
        (appStore.isDarkMode ? const Color(0xFF151A22) : cardLightColor),
    gradient: gradient,
    border: border,
    image: decorationImage,
    shape: boxShape,
    borderRadius: borderRadius,
  );
}

/// rounded box decoration with shadow
Decoration boxDecorationRoundedWithShadow(
  int radiusAll, {
  Color? backgroundColor,
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0, 0),
  LinearGradient? gradient,
}) => BoxDecoration(
  boxShadow: defaultBoxShadow(
    shadowColor: shadowColor ?? Colors.grey.withValues(alpha: 0.065),
    blurRadius: blurRadius ?? defaultBlurRadius,
    spreadRadius: spreadRadius ?? defaultSpreadRadius,
    offset: offset,
  ),
  color:
      backgroundColor ??
          (appStore.isDarkMode ? const Color(0xFF151A22) : cardLightColor),
  gradient: gradient,
  borderRadius: radius(radiusAll.toDouble()),
);

/// default box shadow
List<BoxShadow> defaultBoxShadow({
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
}) => [
  BoxShadow(
    color: shadowColor ?? Colors.grey.withValues(alpha: 0.065),
    blurRadius: blurRadius ?? defaultBlurRadius,
    spreadRadius: spreadRadius ?? defaultSpreadRadius,
    offset: offset,
  ),
];
