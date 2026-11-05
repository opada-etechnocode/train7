import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';

import '../service/reminder_notification_service.dart';
import 'shared_import.dart';

void setTheme() {
  final int mode = getIntAsync(THEME_MODE_INDEX, defaultValue: ThemeModeLight);
  if (mode == ThemeModeDark) {
    appStore.setDarkMode(true);
  } else if (mode == ThemeModeSystem) {
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    appStore.setDarkMode(brightness == Brightness.dark);
  } else {
    appStore.setDarkMode(false);
  }
}

Widget cachedImage(
  String? url, {
  double? height,
  Color? color,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
      radius: radius,
    );
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      progressIndicatorBuilder: (context, url, progress) => placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius,
      ),
      errorWidget: (_, s, d) => placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius,
      ),
    );
  } else {
    return Image.asset(
      ic_placeholder,
      height: height,
      width: width,
      fit: BoxFit.cover,
      alignment: alignment ?? Alignment.center,
    ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  double? radius,
}) => Image.asset(
  ic_placeholder,
  height: height,
  width: width,
  fit: BoxFit.cover,
  alignment: alignment ?? Alignment.center,
).cornerRadiusWithClipRRect(radius ?? defaultRadius);

void toast(
  String? value, {
  ToastGravity? gravity,
  Toast length = Toast.LENGTH_SHORT,
  Color? bgColor,
  Color? textColor,
}) {
  Fluttertoast.showToast(
    msg: value.validate(),
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}

void setLogInValue() {
  log(getBoolAsync(IS_LOGIN).toString());
  userStore.setLogin(getBoolAsync(IS_LOGIN));
  if (userStore.isLoggedIn) {
    userStore.setToken(getStringAsync(TOKEN));
    userStore.setUserID(getIntAsync(USER_ID));
    userStore.setUserEmail(getStringAsync(EMAIL));
    userStore.setFirstName(getStringAsync(FIRSTNAME));
    userStore.setLastName(getStringAsync(LASTNAME));
    userStore.setUserPassword(getStringAsync(PASSWORD));
    userStore.setUserImage(getStringAsync(USER_PROFILE_IMG));
    userStore.setPhoneNo(getStringAsync(PHONE_NUMBER));
    userStore.setDisplayName(getStringAsync(DISPLAY_NAME));
    userStore.setGender(getStringAsync(GENDER));
    userStore.setAge(getStringAsync(AGE));
    userStore.setHeight(getStringAsync(HEIGHT));
    userStore.setHeightUnit(getStringAsync(HEIGHT_UNIT));
    userStore.setWeight(getStringAsync(WEIGHT));
    userStore.setWeightUnit(getStringAsync(WEIGHT_UNIT));

    if (!getStringAsync(SUBSCRIPTION_DETAIL).isEmptyOrNull) {
      final SubscriptionDetail subscriptionDetail = SubscriptionDetail.fromJson(
        jsonDecode(getStringAsync(SUBSCRIPTION_DETAIL)),
      );
      userStore.setSubscribe(getIntAsync(IS_SUBSCRIBE));
      userStore.setSubscriptionDetail(subscriptionDetail);
    }
    final String notificationData = getStringAsync(NOTIFICATION_DETAIL);
    if (notificationData.isNotEmpty) {
      final Iterable<dynamic> mList = jsonDecode(getStringAsync(NOTIFICATION_DETAIL));
      notificationStore.mRemindList = mList
          .map((model) => ReminderModel.fromJson(model))
          .toList();
    }
  }
}

String parseDocumentDate(DateTime dateTime, [bool includeTime = false]) {
  if (includeTime) {
    return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
  } else {
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }
}

Duration parseDuration(String durationString) {
  final List<String> components = durationString.split(':');

  final int hours = int.parse(components[0]);
  final int minutes = int.parse(components[1]);
  final int seconds = int.parse(components[2]);

  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

String progressDateStringWidget(String date) {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateTime dateTime = DateTime.parse(date);
  final dateValue = dateFormat.format(dateTime);
  return dateValue;
}

Future<void> launchUrls(String url, {bool forceWebView = false}) async {
  await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  ).catchError((Object e) {
    log(e.toString());
    toast('Invalid URL: $url');
    return false;
  });
}

Widget mBlackEffect(
  double? width,
  double? height, {
  double? radiusValue = 16,
}) => Container(
  width: width,
  height: height,
  decoration: BoxDecoration(
    borderRadius: radius(radiusValue),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withValues(alpha: 0.2),
        Colors.black.withValues(alpha: 0.2),
        Colors.black.withValues(alpha: 0.4),
        Colors.black.withValues(alpha: 0.4),
      ],
    ),
  ),
  alignment: Alignment.bottomLeft,
);

Widget mOption(
  String img,
  String title,
  Function? onCall,
  BuildContext context, {
  bool requireLogin = false,
  bool goToLogin = false,
}) {
  if (requireLogin && !userStore.isLoggedIn) {
    return const SizedBox(); // hidden
  }
  return SettingItemWidget(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    title: title,
    leading: Image.asset(
      img,
      width: 20,
      height: 20,
      color: textPrimaryColorGlobal,
    ),
    trailing:
         const Icon(Icons.chevron_right, color: grayColor)
,
    onTap: () async {
      if (goToLogin && !userStore.isLoggedIn) {
        const SignInScreen().launch<void>(context);
      } else {
        onCall!.call();
      }
    },
  );
}

/// Apple App Store review mode (`is_apple` == 1 from get-appsetting).
bool get isAppleMode =>
    userStore.isApple || getBoolAsync(IS_APPLE_MODE);

/// Subscription / IAP UI and paywalls (disabled in Apple mode).
bool get isSubscriptionEnabled =>
    !isAppleMode && userStore.subscription == '1';

/// Any purchase flow (subscription, programs, shop, classes).
bool get isPurchaseEnabled => !isAppleMode;

Future<void> applyAppleModeFromSettings(AppSettingResponse value) async {
  final bool apple = (value.isApple ?? 0) == 1;
  await userStore.setIsApple(apple);
  if (apple) {
    // Hide subscription UI / paywalls while keeping content usable.
    await userStore.setSubscription('0');
  } else {
    await userStore.setSubscription(value.subscription.validate());
  }
}

Future<void> getSettingData() async {
  await getAppSettingApi().then((value) async {
    log('------------------238------------>>-${value.toJson()}');

    appUpdateCheck = value.appVersion;
    log("fkfjkjfjfdfj:${value.appVersion}");
    log("fasdfkjfeueir:$appUpdateCheck");
    setValue(SITE_NAME, value.siteName.validate());
    setValue(SITE_DESCRIPTION, value.siteDescription.validate());
    setValue(SITE_COPYRIGHT, value.siteCopyright.validate());
    setValue(FACEBOOK_URL, value.facebookUrl.validate());
    setValue(INSTAGRAM_URL, value.instagramUrl.validate());
    setValue(TWITTER_URL, value.twitterUrl.validate());
    setValue(LINKED_URL, value.linkedinUrl.validate());
    setValue(CONTACT_EMAIL, value.contactEmail.validate());
    setValue(CONTACT_NUMBER, value.contactNumber.validate());
    setValue(HELP_SUPPORT, value.helpSupportUrl.validate());
    setValue(PRIVACY_POLICY, value.helpSupportUrl.validate());
    setValue(TERMS_SERVICE, value.helpSupportUrl.validate());
    setValue(
      CRISP_CHAT_ENABLED,
      value.crispChat?.isCrispChatEnabled.validate(),
    );
    setValue(
      MOBILE_GAME_ENABLED,
      value.mobileGame?.mobileGameEnabled.validate(),
    );
    setValue(
      CRISP_CHAT_WEB_SITE_ID,
      value.crispChat?.crispChatWebsiteId.validate(),
    );
    await applyAppleModeFromSettings(value);
    await userStore.setLoginRequired(value.loginEnable.validate() == "1");
  });
}

Future<void> getUSerDetail(BuildContext context, int? id) async {
  await getUserDataApi(id: id.validate())
      .then((value) async {
        userStore.setFirstName(value.data!.firstName.validate());
        userStore.setUserEmail(value.data!.email.validate());
        userStore.setLastName(value.data!.lastName.validate());
        userStore.setGender(value.data!.gender.validate());
        userStore.setUserID(value.data!.id.validate());
        log("------265>>>${value.data!.phoneNumber}");
        userStore.setPhoneNo(value.data!.phoneNumber.validate());
        userStore.setUsername(value.data!.username.validate());
        userStore.setDisplayName(value.data!.displayName.validate());
        userStore.setUserImage(value.data!.profileImage.validate());
        userStore.setAge(value.data!.userProfile!.age.validate());
        userStore.setHeight(value.data!.userProfile!.height.validate());
        userStore.setWeight(value.data!.userProfile!.weight.validate());
        userStore.setWeightUnit(value.data!.userProfile!.weightUnit.validate());
        userStore.setHeightUnit(value.data!.userProfile!.heightUnit.validate());
        userStore.setSubscribe(
          value.subscriptionDetail!.isSubscribe.validate(),
        );
        userStore.setSubscriptionDetail(value.subscriptionDetail!);

        // Set full user profile (includes water/meal reminder settings) so reminder screens and notifications can use it
        if (value.data!.userProfile != null) {
          userStore.setUserProfile(value.data!.userProfile);
          userStore.setGoal(value.data!.userProfile!.goal.validate());
          userStore.setActivityLevel(
            value.data!.userProfile!.activity.validate(),
          );
          userStore.setMacroType(value.data!.userProfile!.macroType.validate());
          await ReminderNotificationService.syncRemindersFromProfile(
            value.data!.userProfile,
          );
        }

        log("user data->${value.toJson()}");
        appStore.setLoading(false);
      })
      .catchError((Object e) {
        log("error-${e.toString()}");
        appStore.setLoading(false);
      });
}

void oneSignalData() {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.consentRequired(false);

  OneSignal.initialize(mOneSignalID);

  OneSignal.User.pushSubscription.addObserver((state) async {
    log(OneSignal.User.pushSubscription.optedIn.toString());
    log(OneSignal.User.pushSubscription.id.validate());
    log(OneSignal.User.pushSubscription.token.validate());
    await setValue(PLAYER_ID, OneSignal.User.pushSubscription.id);
  });
  if (userStore.isLoggedIn) {
    updatePlayerId(getStringAsync(EMAIL));
  }

  OneSignal.Notifications.addClickListener((event) {
    final data = event.notification.additionalData;
    if (data == null) return;
    final String? type = data['type'];
    final int? id = data['posting_id'];
    if (type != null && id != null) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppRuntime.isUiReady) {
        getPostDetailApi(postId: id).then((res) {
          PostDetailsScreen(
            postData: res.data,
            isFromLink: true,
          ).launch<void>(getContext);
        });
      }
      // });
      else {
        NotificationIntent.postingId = id;
        NotificationIntent.type = type;
      }
    }
    log(
      "Notification === $type = $id = ${event.notification.rawPayload.toString()}",
    );
  });
}

Widget mSuffixTextFieldIconWidget(String? img) => Image.asset(
  img.validate(),
  height: 20,
  width: 20,
  color: Colors.grey,
).paddingAll(14);

List<ProgressSettingModel> progressSettingList() => [
  ProgressSettingModel(id: 1, name: 'Weight', isEnable: true),
  ProgressSettingModel(id: 2, name: 'Heart Rate', isEnable: true),
  ProgressSettingModel(id: 3, name: 'Push ups in 1 minutes', isEnable: true),
];

Widget mPro() => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: boxDecorationWithRoundedCorners(
    backgroundColor: primaryColor,
    borderRadius: radius(6),
  ),
  child: Text(
    languages.lblPro,
    style: primaryTextStyle(color: Colors.white, size: 12),
  ),
);

Widget noProfileImageFound({
  double? height,
  double? width,
  bool isNoRadius = true,
}) => Image.asset(
  ic_profile,
  height: height,
  width: width,
  fit: BoxFit.cover,
  // color: iconColor,
).cornerRadiusWithClipRRect(isNoRadius ? 0 : height! / 2);

UserModel sender = UserModel(
  firstName: getStringAsync(FIRSTNAME),
  profileImage: getStringAsync(USER_PROFILE_IMG),
  uid: getStringAsync(UID),
  playerId: getStringAsync(PLAYER_ID),
);

Widget dividerCommon(BuildContext context) =>
    const Divider(color: viewLineColor, height: 8, thickness: 1);

Widget noteCommon() => Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  decoration: boxDecorationWithRoundedCorners(
    backgroundColor: Colors.grey.shade200,
    borderRadius: radius(defaultRadius),
  ),
  child: Text(
    "NOTE: we don't collect, process, or store any of the data that you enter while using this tool. "
    "All calculation are done exclusively in your locally, and we don't have access to the results. "
    "All data will be permanently erased after leaving or close the screen.",
    style: boldTextStyle(size: 8, color: Colors.grey),
  ),
).paddingSymmetric(horizontal: 16);

List<String> setSearchParam(String caseNumber) {
  final List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < caseNumber.length; i++) {
    temp = temp + caseNumber[i];
    caseSearchList.add(temp.toLowerCase());
  }
  return caseSearchList;
}

double poundsToKilograms(double pounds) => pounds * 0.453592;

Future<void> unblockDialog(
  BuildContext context, {
  required UserModel receiver,
}) async {
  await showConfirmDialogCustom(
    context,
    imageShow: Container(
      width: 50,
      height: 50,
      decoration: boxDecorationDefault(
        color: primaryLightColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(Icons.block, size: 28, color: primaryColor),
    ),
    title:
        '${languages.lblUnblock} ${receiver.firstName} ${languages.lblToSendMsg}',
    dialogAnimation: DialogAnimation.SCALE,
    positiveText: languages.lblUnblock.capitalizeFirstLetter(),
    negativeText: languages.lblCancel.capitalizeFirstLetter(),
    onAccept: (v) async {
      List<DocumentReference> temp = [];

      temp = await userService
          .userByEmail(getStringAsync(EMAIL))
          .then((value) => value.blockedTo!);

      if (temp.contains(
        userService.getUserReference(uid: receiver.uid.validate()),
      )) {
        temp.removeWhere(
          (element) =>
              element ==
              userService.getUserReference(uid: receiver.uid.validate()),
        );
      }

      userService
          .unBlockUser({KEY_BLOCKED_TO: temp})
          .then((value) {
            if (!context.mounted) return;
            finish(context);
          })
          .catchError((Object e) {
            //
          });
    },
  );
}

String timeAgoSinceDate(Timestamp dateString) {
  final Duration difference = DateTime.now().difference(dateString.toDate());

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if ((difference.inDays / 7).floor() < 4) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if ((difference.inDays / 30).floor() < 12) {
    return '${(difference.inDays / 30).floor()} months ago';
  } else {
    return '${(difference.inDays / 365).floor()} years ago';
  }
}

String generateNonceData([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(
    length,
    (_) => charset[random.nextInt(charset.length)],
  ).join();
}

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class AppRuntime {
  static bool isUiReady = false;
}

Future<void> handleColdStartNotification() async {
  if (NotificationIntent.postingId == null) return;
  getPostDetailApi(postId: NotificationIntent.postingId.validate()).then((res) {
    PostDetailsScreen(postData: res.data, isFromLink: true).launch<void>(getContext);
  });

  NotificationIntent.postingId = null;
  NotificationIntent.type = null;
}

class NotificationIntent {
  static int? postingId;
  static String? type;
}

Future<void> showRecipeDetailBottomSheetCustom(
  BuildContext context, {
  required RecipeItem recipeItem,
  String mealType = 'breakfast',
  int? dailyPlanId,
  String? date,
  VoidCallback? onUpdate,
}) async {
  final dailyPlanRecipeItem = DailyPlanRecipeItem(
    dailyPlanId: dailyPlanId,
    recipeId: recipeItem.id,
    calories: recipeItem.calories ?? recipeItem.kcal,
    protein: recipeItem.protein?.toInt(),
    carbs: recipeItem.carbs?.toInt(),
    fats: recipeItem.fats?.toInt(),
    mealType: mealType,
    recipe: Recipe(
      id: recipeItem.id,
      title: recipeItem.title,
      recipeImage: recipeItem.recipeImage,
      calories: recipeItem.calories ?? recipeItem.kcal,
      protein: recipeItem.protein?.toInt(),
      carbs: recipeItem.carbs?.toInt(),
      fats: recipeItem.fats?.toInt(),
    ),
  );

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => RecipeDetailBottomSheet(
      recipeItem: dailyPlanRecipeItem,
      mealType: mealType,
      date: date,
      onUpdate: onUpdate,
    ),
  );
}
