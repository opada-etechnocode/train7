import '../../utils/shared_import.dart';

/// Enum for Dialog Type
enum DialogType { CONFIRMATION, ACCEPT, DELETE, UPDATE, ADD, RETRY }

/// Enum for Dialog Animation
enum DialogAnimation {
  DEFAULT,
  ROTATE,
  SLIDE_TOP_BOTTOM,
  SLIDE_BOTTOM_TOP,
  SLIDE_LEFT_RIGHT,
  SLIDE_RIGHT_LEFT,
  SCALE,
}

/// dialog primary color
Color getDialogPrimaryColor(
  BuildContext context,
  DialogType dialogType,
  Color? primaryColor,
) {
  if (primaryColor != null) return primaryColor;
  Color color;

  switch (dialogType) {
    case DialogType.DELETE:
      color = Colors.red;
      break;
    case DialogType.UPDATE:
      color = Colors.amber;
      break;
    case DialogType.CONFIRMATION:
    case DialogType.ADD:
    case DialogType.RETRY:
      color = Colors.blue;
      break;
    case DialogType.ACCEPT:
      color = Colors.green;
      break;
  }
  return color;
}

/// build positive text for dialog
String getPositiveText(DialogType dialogType) {
  String positiveText = "";

  switch (dialogType) {
    case DialogType.CONFIRMATION:
      positiveText = "Yes";
      break;
    case DialogType.DELETE:
      positiveText = languages.lblDelete;
      break;
    case DialogType.UPDATE:
      positiveText = "Update";
      break;
    case DialogType.ADD:
      positiveText = "Add";
      break;
    case DialogType.ACCEPT:
      positiveText = "Accept";
      break;
    case DialogType.RETRY:
      positiveText = "Retry";
      break;
  }
  return positiveText;
}

/// Build title
String getTitle(DialogType dialogType) {
  String titleText = "";

  switch (dialogType) {
    case DialogType.CONFIRMATION:
      titleText = "Are you sure want to perform this action?";
      break;
    case DialogType.DELETE:
      titleText = "Do you want to delete?";
      break;
    case DialogType.UPDATE:
      titleText = "Do you want to update?";
      break;
    case DialogType.ADD:
      titleText = "Do you want to add?";
      break;
    case DialogType.ACCEPT:
      titleText = "Do you want to accept?";
      break;
    case DialogType.RETRY:
      titleText = "Click to retry";
      break;
  }
  return titleText;
}

/// get icon for dialog
Widget getIcon(DialogType dialogType, {double? size}) {
  Icon icon;

  switch (dialogType) {
    case DialogType.CONFIRMATION:
    case DialogType.RETRY:
    case DialogType.ACCEPT:
      icon = Icon(Icons.done, size: size ?? 20, color: Colors.white);
      break;
    case DialogType.DELETE:
      icon = Icon(
        Icons.delete_forever_outlined,
        size: size ?? 20,
        color: Colors.white,
      );
      break;
    case DialogType.UPDATE:
      icon = Icon(Icons.edit, size: size ?? 20, color: Colors.white);
      break;
    case DialogType.ADD:
      icon = Icon(Icons.add, size: size ?? 20, color: Colors.white);
      break;
  }
  return icon;
}

/// Build center image for dialog
Widget? getCenteredImage(
  BuildContext context,
  DialogType dialogType,
  Color? primaryColor,
) {
  Widget? widget;

  switch (dialogType) {
    case DialogType.CONFIRMATION:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.warning_amber_rounded,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case DialogType.DELETE:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.close,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case DialogType.UPDATE:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.edit_outlined,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case DialogType.ADD:
    case DialogType.ACCEPT:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.done_outline,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
    case DialogType.RETRY:
      widget = Container(
        decoration: BoxDecoration(
          color: getDialogPrimaryColor(
            context,
            dialogType,
            primaryColor,
          ).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.refresh_rounded,
          color: getDialogPrimaryColor(context, dialogType, primaryColor),
          size: 40,
        ),
      );
      break;
  }
  return widget;
}

/// placeholder for dialog
Widget defaultPlaceHolder(
  BuildContext context,
  DialogType dialogType,
  double? height,
  double? width,
  Color? primaryColor, {
  Widget? child,
  ShapeBorder? shape,
}) => Container(
  height: height,
  width: width,
  decoration: BoxDecoration(
    color: getDialogPrimaryColor(
      context,
      dialogType,
      primaryColor,
    ).withValues(alpha: 0.2),
  ),
  alignment: Alignment.center,
  child: child ?? getCenteredImage(context, dialogType, primaryColor),
);

/// title for dialog
Widget buildTitleWidget(
  BuildContext context,
  DialogType dialogType,
  Color? primaryColor,
  Widget? customCenterWidget,
  double height,
  double width,
  String? centerImage,
  ShapeBorder? shape,
) {
  if (customCenterWidget != null) {
    return Container(
      constraints: BoxConstraints(maxHeight: height, maxWidth: width),
      child: customCenterWidget,
    );
  } else {
    if (centerImage != null) {
      return Image.network(
        centerImage,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (_, object, stack) {
          log(object.toString());
          return defaultPlaceHolder(
            context,
            dialogType,
            height,
            width,
            primaryColor,
            shape: shape,
          );
        },
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return defaultPlaceHolder(
            context,
            dialogType,
            height,
            width,
            primaryColor,
            shape: shape,
            child: Loader(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      return defaultPlaceHolder(
        context,
        dialogType,
        height,
        width,
        primaryColor,
        shape: shape,
      );
    }
  }
}

/// show confirm dialog box
Future<bool?> showConfirmDialogCustom(
  BuildContext context, {
  required void Function(BuildContext) onAccept,
  String? title,
  Widget? imageShow,
  String? subTitle,
  String? positiveText,
  String? negativeText,
  String? centerImage,
  Widget? customCenterWidget,
  Color? primaryColor = primaryColor,
  Color? positiveTextColor,
  Color? negativeTextColor,
  Color? iconColor,
  ShapeBorder? shape,
  String? image,
  void Function(BuildContext)? onCancel,
  bool barrierDismissible = true,
  double? height,
  double? width,
  bool cancelable = true,
  Color? barrierColor,
  DialogType dialogType = DialogType.CONFIRMATION,
  DialogAnimation dialogAnimation = DialogAnimation.DEFAULT,
  Duration? transitionDuration,
  Curve curve = Curves.easeInBack,
}) async {
  hideKeyboard(context);

  return await showGeneralDialog(
    context: context,
    barrierColor: barrierColor ?? Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    transitionDuration: transitionDuration ?? 400.milliseconds,
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) =>
        dialogAnimatedWrapperWidget(
          animation: animation,
          dialogAnimation: dialogAnimation,
          curve: curve,
          child: AlertDialog(
            shape: shape ?? dialogShape(),
            titlePadding: EdgeInsets.zero,
            //backgroundColor: _.cardColor,
            elevation: defaultElevation.toDouble(),
            title:
                buildTitleWidget(
                  dialogContext,
                  dialogType,
                  primaryColor,
                  customCenterWidget,
                  height ?? customDialogHeight,
                  width ?? customDialogWidth,
                  centerImage,
                  shape,
                ).cornerRadiusWithClipRRectOnly(
                  topLeft: defaultRadius.toInt(),
                  topRight: defaultRadius.toInt(),
                ),
            content: Container(
              width: width ?? customDialogWidth,
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  imageShow ??
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(150),
                          border: Border.all(color: primaryColor!),
                          backgroundColor: BackgroundColorImageColor,
                        ),
                        child: Image.asset(
                          image.isEmptyOrNull ? ic_logo : image!,
                          color: iconColor ?? primaryColor,
                          height: 28,
                          width: 28,
                        ),
                      ).center(),
                  14.height,
                  Text(
                    title ?? getTitle(dialogType),
                    style: boldTextStyle(size: 16),
                    textAlign: TextAlign.center,
                  ),
                  8.height.visible(subTitle.validate().isNotEmpty),
                  Text(
                    subTitle.validate(),
                    style: secondaryTextStyle(size: 16),
                    textAlign: TextAlign.center,
                  ).visible(subTitle.validate().isNotEmpty),
                  20.height,
                  Row(
                    children: [
                      AppButton(
                        elevation: 0,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: radius(defaultAppButtonRadius),
                          side: BorderSide(color: primaryColor!),
                        ),
                        color: dialogContext.cardColor,
                        child: Text(
                          negativeText ?? languages.lblCancel,
                          style: boldTextStyle(color: primaryColor),
                          // style: boldTextStyle(color: negativeTextColor ?? textPrimaryColorGlobal),
                        ).fit(),
                        onTap: () {
                          if (cancelable) finish(dialogContext, false);

                          onCancel?.call(dialogContext);
                        },
                      ).expand(),
                      16.width,
                      AppButton(
                        elevation: 0,
                        color: getDialogPrimaryColor(
                          dialogContext,
                          dialogType,
                          primaryColor,
                        ),
                        child: Text(
                          positiveText ?? getPositiveText(dialogType),
                          style: boldTextStyle(
                            color: positiveTextColor ?? Colors.white,
                          ),
                        ).fit(),
                        onTap: () {
                          onAccept.call(dialogContext);

                          if (cancelable) finish(dialogContext, true);
                        },
                      ).expand(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
