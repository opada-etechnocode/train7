import '../../utils/shared_import.dart';

/// Default App Button
class AppButton extends StatefulWidget {
  final Function? onTap;
  final String? text;
  final double? width;
  final Color? color;
  final Color? textColor;
  final Color? disabledColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final ShapeBorder? shapeBorder;
  final Widget? child;
  final double? elevation;
  final double? height;
  final bool? enabled;
  final bool? enableScaleAnimation;

  /// If true, the button background is painted with a gradient
  /// instead of a flat [color].
  final bool useGradient;

  /// Colors used for the gradient when [useGradient] is true.
  /// Defaults to a gold/orange gradient (left -> right).
  final List<Color>? gradientColors;

  /// Begin/end alignment for the gradient.
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;

  const AppButton({
    this.onTap,
    this.text,
    this.width,
    this.color,
    this.textColor,
    this.padding,
    this.margin,
    this.textStyle,
    this.shapeBorder,
    this.child,
    this.elevation,
    this.enabled,
    this.height,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.enableScaleAnimation,
    this.useGradient = false,
    this.gradientColors,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    super.key,
  });

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  AnimationController? _controller;

  static List<Color> get _defaultGradientColors => [
    primaryLightColor,
    primaryColor,
    // fades out at the end
  ];

  @override
  void initState() {
    if (widget.enableScaleAnimation.validate(
      value: enableAppButtonScaleAnimationGlobal,
    )) {
      _controller =
      AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: appButtonScaleAnimationDurationGlobal ?? 50,
        ),
        upperBound: 0.1,
      )..addListener(() {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && widget.enabled.validate(value: true)) {
      _scale = 1 - _controller!.value;
    }

    if (widget.enableScaleAnimation.validate(
      value: enableAppButtonScaleAnimationGlobal,
    )) {
      return Listener(
        onPointerDown: (details) {
          _controller?.forward();
        },
        onPointerUp: (details) {
          _controller?.reverse();
        },
        child: Transform.scale(scale: _scale, child: buildButton()),
      );
    } else {
      return buildButton();
    }
  }

  Widget buildButton() {
    final ShapeBorder? shape =
        widget.shapeBorder ?? defaultAppButtonShapeBorder;

    final Widget button = MaterialButton(
      minWidth: widget.width,
      padding: widget.padding ?? dynamicAppButtonPadding(context),
      onPressed: widget.enabled.validate(value: true)
          ? widget.onTap != null
          ? widget.onTap as void Function()?
          : null
          : null,
      // When using a gradient, the MaterialButton itself stays transparent;
      // the gradient is painted by the Ink/Container behind it.
      color: widget.useGradient
          ? Colors.transparent
          : (widget.color ?? appButtonBackgroundColorGlobal),
      shape: shape,
      elevation: widget.useGradient ? 0 : (widget.elevation ?? defaultAppButtonElevation),
      highlightElevation: widget.useGradient ? 0 : null,
      animationDuration: const Duration(milliseconds: 300),
      height: widget.height,
      disabledColor: widget.disabledColor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      splashColor: widget.splashColor,
      child:
      widget.child ??
          Text(
            widget.text.validate(),
            style:
            widget.textStyle ??
                boldTextStyle(
                  color: widget.textColor ?? defaultAppButtonTextColorGlobal,
                ),
          ),
    );

    if (!widget.useGradient) {
      return Padding(padding: widget.margin ?? EdgeInsets.zero, child: button);
    }

    // Wrap with a gradient-filled Container. Using Container (not Ink) avoids
    // relying on an ancestor Material to paint the decoration — Ink can end up
    // rendering nothing (looking fully transparent) if that lookup fails.
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Container(
        decoration: ShapeDecoration(
          shape: shape!,
          gradient: LinearGradient(
            begin: widget.gradientBegin,
            end: widget.gradientEnd,
            colors: widget.gradientColors ?? _defaultGradientColors,
          ),
        ),
        // Material(transparency) preserves ripple/splash on top of the gradient.
        child: Material(
          type: MaterialType.transparency,
          shape: shape,
          child: button,
        ),
      ),
    );
  }
}