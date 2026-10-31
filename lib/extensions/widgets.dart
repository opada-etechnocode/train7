import '../../utils/shared_import.dart';

/// show confirm dialog box
Future<bool?> showConfirmDialog<bool>(
  BuildContext context,
  String title, {
  String positiveText = 'Yes',
  String negativeText = 'No',
  Color? buttonColor,
  Color? barrierColor,
  bool? barrierDismissible,
  Function? onAccept,
}) async => showDialog(
  context: context,
  // barrierDismissible: barrierDismissible ?? false,
  builder: (dialogContext) => AlertDialog(
    title: Text(title.validate(), style: primaryTextStyle()),
    actions: <Widget>[
      SimpleDialogOption(
        child: Text(negativeText.validate(), style: secondaryTextStyle()),
        onPressed: () {
          finish(dialogContext, false);
        },
      ),
      SimpleDialogOption(
        onPressed: () {
          finish(dialogContext, true);

          onAccept?.call();
        },
        child: Text(
          positiveText.validate(),
          style: primaryTextStyle(
            color: buttonColor ?? Theme.of(dialogContext).primaryColor,
          ),
        ),
      ),
    ],
  ),
);

/// show child widget in dialog
Future<T?> showInDialog<T>(
  BuildContext context, {
  Widget? title,
  @Deprecated('Use builder instead') Widget? child,
  Widget? Function(BuildContext)? builder,
  ShapeBorder? shape,
  TextStyle? titleTextStyle,
  EdgeInsetsGeometry? contentPadding,
  //bool scrollable = false,
  Color? backgroundColor,
  DialogAnimation dialogAnimation = DialogAnimation.DEFAULT,
  double? elevation,
  Color? barrierColor,
  //EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  List<Widget>? actions,
  bool barrierDismissible = true,
  bool hideSoftKeyboard = true,
  Duration? transitionDuration,
  Curve curve = Curves.easeInBack,
}) async {
  if (hideSoftKeyboard) hideKeyboard(context);

  return await showGeneralDialog<T>(
    context: context,
    barrierColor: barrierColor ?? Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    barrierLabel: '',
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration ?? 400.milliseconds,
    transitionBuilder: (dialogContext, animation, secondaryAnimation, c) =>
        dialogAnimatedWrapperWidget(
          animation: animation,
          dialogAnimation: dialogAnimation,
          curve: curve,
          child: AlertDialog(
            content: builder != null ? builder.call(dialogContext) : child,
            shape: shape ?? defaultDialogShape,
            title: title,
            titleTextStyle: titleTextStyle,
            contentPadding:
                contentPadding ??
                const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
            //scrollable: scrollable,
            backgroundColor: backgroundColor,
            elevation: elevation ?? defaultElevation.toDouble(),
            //insetPadding: insetPadding,
            actions: actions,
          ),
        ),
  );
}

/// Default AppBar
AppBar appBarWidget(
  String title, {
  @Deprecated('Use titleWidget instead') Widget? child,
  Widget? titleWidget,
  List<Widget>? actions,
  Color? color,
  bool center = false,
  Color? textColor,
  int textSize = 18,
  double titleSpacing = 2,
  bool showBack = true,
  bool isBottom = true,
  Color? shadowColor,
  double? elevation,
  Widget? backWidget,
  @Deprecated('Use systemOverlayStyle instead') Brightness? brightness,
  SystemUiOverlayStyle? systemUiOverlayStyle,
  TextStyle? titleTextStyle,
  PreferredSizeWidget? bottom,
  Widget? flexibleSpace,
  required BuildContext context,
}) => AppBar(
  centerTitle: center,
  title:
      titleWidget ??
      Text(
        title,
        style:
            titleTextStyle ??
            (boldTextStyle(
              color: appStore.isDarkMode ? Colors.white : Colors.black,
              size: textSize,
            )),
      ),
  actions: actions ?? [],
  automaticallyImplyLeading: showBack,
  backgroundColor: color ??
      (appStore.isDarkMode ? scaffoldColorDark : Colors.white),
  leading: showBack ? (backWidget ?? backIcon(context)) : null,
  shadowColor: shadowColor,
  elevation: elevation ?? defaultAppBarElevation,
  systemOverlayStyle:
      systemUiOverlayStyle ??
      SystemUiOverlayStyle(
        statusBarColor:
            appStore.isDarkMode ? scaffoldColorDark : Colors.white,
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
      ),
  bottom: bottom,
  titleSpacing: titleSpacing,
  flexibleSpace: flexibleSpace,
);

Widget backIcon(BuildContext context) =>
    Icon(
      appStore.selectedLanguageCode == 'ar'
          ? MaterialIcons.arrow_forward_ios
          : Octicons.chevron_left,
      color: primaryColor,
      size: 28,
    ).onTap(() {
      Navigator.pop(context);
    });

/// Handle error and loading widget when using FutureBuilder or StreamBuilder
Widget snapWidgetHelper<T>(
  AsyncSnapshot<T> snap, {
  Widget? errorWidget,
  Widget? loadingWidget,
  String? defaultErrorMessage,
  @Deprecated('Do not use this') bool checkHasData = false,
  Widget Function(String)? errorBuilder,
}) {
  if (snap.hasError) {
    log(snap.error.toString());
    if (errorBuilder != null) {
      return errorBuilder.call(defaultErrorMessage ?? snap.error.toString());
    }
    return errorWidget ??
        Text(
          defaultErrorMessage ?? snap.error.toString(),
          style: primaryTextStyle(),
        ).center();
  } else if (!snap.hasData) {
    return loadingWidget ?? const Loader();
  } else {
    return const SizedBox();
  }
}

class PriceWidget extends StatefulWidget {
  static String tag = '/PriceWidget';
  final String? price;
  final double? size;
  final Color? color;
  final TextStyle? textStyle;

  const PriceWidget({
    super.key,
    this.price,
    this.color,
    this.size = 22.0,
    this.textStyle,
  });

  @override
  PriceWidgetState createState() => PriceWidgetState();
}

class PriceWidgetState extends State<PriceWidget> {
  var currency = '₹';

  @override
  void initState() {
    super.initState();
    get();
  }

  Future<void> get() async {
    setState(() {
      currency = getStringAsync(CurrencySymbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userStore.currencyPosition == "left") {
      return Text(
        '$currency ${widget.price.toString().replaceAll(".00", "")}',
        style:
            widget.textStyle ??
                TextStyle(
              fontSize: widget.size,
              color: widget.color ?? primaryColor,
              fontWeight: FontWeight.w600,
            ),
      );
    } else {
      return Text(
        '${widget.price.toString().replaceAll(".00", "")} $currency',
        style:
            widget.textStyle ??
            TextStyle(
              fontSize: widget.size,
              color: widget.color ?? primaryColor,
              fontWeight: FontWeight.w600,
            ),
      );
    }
  }
}

void openPhotoViewer(BuildContext context, ImageProvider imageProvider) {
  Scaffold(
    body: Stack(
      children: <Widget>[
        PhotoView(
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: 1.0,
        ),
        const Positioned(
          top: 35,
          left: 16,
          child: BackButton(color: Colors.white),
        ),
      ],
    ),
  ).launch<void>(context);
}

class SnapHelperWidget<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(T data) onSuccess;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String? defaultErrorMessage;
  final bool checkHasData;

  const SnapHelperWidget({
    super.key,
    this.future,
    required this.onSuccess,
    this.loadingWidget,
    this.errorWidget,
    this.defaultErrorMessage,
    this.checkHasData = false,
  });

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return onSuccess(snapshot.data as T);
      }
      return snapWidgetHelper(
        snapshot,
        errorWidget: errorWidget,
        loadingWidget: loadingWidget,
        defaultErrorMessage: defaultErrorMessage,
      );
    },
  );
}
