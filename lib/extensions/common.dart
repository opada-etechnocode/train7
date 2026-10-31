import '../../utils/shared_import.dart';

/// Make any variable nullable
T? makeNullable<T>(T? value) => value;

/// Enum for page route
enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }

/// has match return bool for pattern matching
bool hasMatch(String? s, String p) =>
    (s == null) ? false : RegExp(p).hasMatch(s);

/// Show SnackBar
void snackBar(
  BuildContext context, {
  String title = '',
  Widget? content,
  SnackBarAction? snackBarAction,
  Function? onVisible,
  Color? textColor,
  Color? backgroundColor,
  EdgeInsets? margin,
  EdgeInsets? padding,
  Animation<double>? animation,
  double? width,
  ShapeBorder? shape,
  Duration? duration,
  SnackBarBehavior? behavior,
  double? elevation,
}) {
  if (title.isEmpty && content == null) {
    log('SnackBar message is empty');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        action: snackBarAction,
        margin: margin,
        animation: animation,
        width: width,
        shape: shape,
        duration: duration ?? 4.seconds,
        behavior: margin != null ? SnackBarBehavior.floating : behavior,
        elevation: elevation,
        onVisible: onVisible?.call(),
        content:
            content ??
            Padding(
              padding: padding ?? const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                title,
                style: primaryTextStyle(color: textColor ?? Colors.white),
              ),
            ),
      ),
    );
  }
}

/// Hide soft keyboard
void hideKeyboard(BuildContext context) => FocusScope.of(context).requestFocus(FocusNode());

/// Returns a string from Clipboard
Future<String> paste() async {
  final ClipboardData? data = await Clipboard.getData('text/plain');
  return data?.text?.toString() ?? "";
}

/// Returns a string from Clipboard
Future<dynamic> pasteObject() async {
  final ClipboardData? data = await Clipboard.getData('text/plain');
  return data;
}

/// Enum for Link Provider
enum LinkProvider {
  PLAY_STORE,
  APPSTORE,
  FACEBOOK,
  INSTAGRAM,
  LINKEDIN,
  TWITTER,
  YOUTUBE,
  REDDIT,
  TELEGRAM,
  WHATSAPP,
  FB_MESSENGER,
  GOOGLE_DRIVE,
}

/// Use getSocialMediaLink function to build social media links
String getSocialMediaLink(LinkProvider linkProvider, {String url = ''}) {
  switch (linkProvider) {
    case LinkProvider.PLAY_STORE:
      return "$playStoreBaseURL$url";
    case LinkProvider.APPSTORE:
      return "$appStoreBaseURL$url";
    case LinkProvider.FACEBOOK:
      return "$facebookBaseURL$url";
    case LinkProvider.INSTAGRAM:
      return "$instagramBaseURL$url";
    case LinkProvider.LINKEDIN:
      return "$linkedinBaseURL$url";
    case LinkProvider.TWITTER:
      return "$twitterBaseURL$url";
    case LinkProvider.YOUTUBE:
      return "$youtubeBaseURL$url";
    case LinkProvider.REDDIT:
      return "$redditBaseURL$url";
    case LinkProvider.TELEGRAM:
      return "$telegramBaseURL$url";
    case LinkProvider.FB_MESSENGER:
      return "$facebookMessengerURL$url";
    case LinkProvider.WHATSAPP:
      return "$whatsappURL$url";
    case LinkProvider.GOOGLE_DRIVE:
      return "$googleDriveURL$url";
  }
}

const double degrees2Radians = pi / 180.0;

double radians(double degrees) => degrees * degrees2Radians;

void afterBuildCreated(void Function()? onCreated) {
  makeNullable(
    SchedulerBinding.instance,
  )!.addPostFrameCallback((_) => onCreated?.call());
}

Widget dialogAnimatedWrapperWidget({
  required Animation<double> animation,
  required Widget child,
  required DialogAnimation dialogAnimation,
  required Curve curve,
}) {
  switch (dialogAnimation) {
    case DialogAnimation.ROTATE:
      return Transform.rotate(
        angle: radians(animation.value * 360),
        child: Opacity(
          opacity: animation.value,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );

    case DialogAnimation.SLIDE_TOP_BOTTOM:
      final curvedValue = curve.transform(animation.value) - 1.0;

      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 300, 0.0),
        child: Opacity(
          opacity: animation.value,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );

    case DialogAnimation.SCALE:
      return Transform.scale(
        scale: animation.value,
        child: FadeTransition(opacity: animation, child: child),
      );

    case DialogAnimation.SLIDE_BOTTOM_TOP:
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve)).animate(animation),
        child: Opacity(
          opacity: animation.value,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );

    case DialogAnimation.SLIDE_LEFT_RIGHT:
      return SlideTransition(
        position: Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve)).animate(animation),
        child: Opacity(
          opacity: animation.value,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );

    case DialogAnimation.SLIDE_RIGHT_LEFT:
      return SlideTransition(
        position: Tween(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve)).animate(animation),
        child: Opacity(
          opacity: animation.value,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );

    case DialogAnimation.DEFAULT:
      return FadeTransition(opacity: animation, child: child);
  }
}

Route<T> buildPageRoute<T>(
  Widget child,
  PageRouteAnimation? pageRouteAnimation,
  Duration? duration,
) {
  if (pageRouteAnimation != null) {
    if (pageRouteAnimation == PageRouteAnimation.Fade) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) =>
            RotationTransition(turns: ReverseAnimation(anim), child: child),
        transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) =>
            ScaleTransition(scale: anim, child: child),
        transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          position: Tween(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(anim),
          child: child,
        ),
        transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 1.0),
            end: const Offset(0.0, 0.0),
          ).animate(anim),
          child: child,
        ),
        transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
      );
    }
  }
  return CupertinoPageRoute<T>(builder: (_) => child);
}

EdgeInsets dynamicAppButtonPadding(BuildContext context) {
  if (context.isDesktop()) {
    return const EdgeInsets.symmetric(vertical: 20, horizontal: 20);
  } else if (context.isTablet()) {
    return const EdgeInsets.symmetric(vertical: 16, horizontal: 16);
  } else {
    return const EdgeInsets.symmetric(vertical: 16, horizontal: 16);
  }
}

enum BottomSheetDialog { Dialog, BottomSheet }

Future<dynamic> showBottomSheetOrDialog({
  required BuildContext context,
  required Widget child,
  BottomSheetDialog bottomSheetDialog = BottomSheetDialog.Dialog,
}) {
  if (bottomSheetDialog == BottomSheetDialog.BottomSheet) {
    return showModalBottomSheet(context: context, builder: (_) => child);
  } else {
    return showInDialog(context, builder: (_) => child);
  }
}

/// mailto: function to open native email app
Uri mailTo({
  required List<String> to,
  String subject = '',
  String body = '',
  List<String> cc = const [],
  List<String> bcc = const [],
}) {
  String subject0 = '';
  if (subject.isNotEmpty) subject0 = '&subject=$subject';

  String body0 = '';
  if (body.isNotEmpty) body0 = '&body=$body';

  String cc0 = '';
  if (cc.isNotEmpty) cc0 = '&cc=${cc.join(',')}';

  String bcc0 = '';
  if (bcc.isNotEmpty) bcc0 = '&bcc=${bcc.join(',')}';

  return Uri(
    scheme: 'mailto',
    query: 'to=${to.join(',')}$subject0$body0$cc0$bcc0',
  );
}

Widget dotIndicator(List<dynamic> list, int i, {bool isPersonal = false}) => SizedBox(
  height: 16,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      list.length,
      (ind) => Container(
        height: 4,
        width: i == ind ? 30 : 12,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: i == ind
              ? appStore.isDarkMode == true
                    ? Colors.white
                    : primaryLightColor
              : Colors.grey.withValues(alpha: 0.5),
          borderRadius: radius(4),
        ),
      ),
    ),
  ),
);

/// returns true if network is available
Future<bool> isNetworkAvailable() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return !connectivityResult.contains(ConnectivityResult.none);
}

BuildContext get getContext => navigatorKey.currentState!.overlay!.context;

Future<T?> push<T>(
  Widget widget, {
  bool isNewTask = false,
  PageRouteAnimation? pageRouteAnimation,
  Duration? duration,
}) async {
  if (isNewTask) {
    return await Navigator.of(getContext).pushAndRemoveUntil(
      buildPageRoute(widget, pageRouteAnimation, duration),
      (route) => false,
    );
  } else {
    return await Navigator.of(
      getContext,
    ).push(buildPageRoute(widget, pageRouteAnimation, duration));
  }
}

/// Dispose current screen or close current dialog
void pop([Object? object]) {
  if (Navigator.canPop(getContext)) Navigator.pop(getContext, object);
}

class AppServerConfig {
  static String get baseUrl {
    if (kReleaseMode) {
      return 'https://dashboard.train7.com';
    } else if (kProfileMode) {
      return 'https://dashboard.train7.com';
    } else {
      return 'https://dashboard.train7.com';
    }
  }
}
