import '../../utils/shared_import.dart';

class BaseLanguage {
  static BaseLanguage? of(BuildContext context) {
    try {
      return Localizations.of<BaseLanguage>(context, BaseLanguage);
    } catch (e) {
      rethrow;
    }
  }

   String chattingImageScreen = "ChattingImageScreen";
   String communityScreen = "CommunityScreen";
   String dashboardScreen = "DashboardScreen";
   String dietScreen = "DietScreen";
   String editProfileScreen = "EditProfileScreen";
   String exerciseDetailScreen = "ExerciseDetailScreen";
   String filterWorkoutScreen = "FilterWorkoutScreen";
   String homeScreen = "HomeScreen";
   String notificationScreen = "NotificationScreen";
   String otpScreen = "OTPScreen";
   String paymentScreen = "PaymentScreen";
   String productScreen = "ProductScreen";
   String profileScreen = "ProfileScreen";
   String progressScreen = "ProgressScreen";
   String scheduleScreen = "ScheduleScreen";
   String searchScreen = "SearchScreen";
   String settingScreen = "SettingScreen";
   String signInScreen = "SignInScreen";
   String signUpStep1Component = "SignUpStep1Component";
   String signUpStep2Component = "SignUpStep2Component";
   String signUpStep3Component = "SignUpStep3Component";
   String signUpStep4Component = "SignUpStep4Component";
   String subscribeScreen = "SubscribeScreen";
   String walkThroughScreen = "WalkThroughScreen";
   String dailyPlanScreen = "DailyPlanScreen";
   String signUpStep5Component = "SignUpStep5Component";
   String signUpStep6Component = "SignUpStep6Component";

  String get lblGetStarted =>
      getContentValueFromKey("$walkThroughScreen.lblGetStarted");
  String get lblNext => getContentValueFromKey("$walkThroughScreen.lblNext");
  String get lblWelcomeBack =>
      getContentValueFromKey("$signInScreen.lblWelcomeBack");
  String get lblWelcomeBackDesc =>
      getContentValueFromKey("$signInScreen.lblWelcomeBackDesc");
  String get lblLogin => getContentValueFromKey("$signInScreen.lblLogin");
  String get lblEmail => getContentValueFromKey("$signInScreen.lblEmail");
  String get lblEnterEmail =>
      getContentValueFromKey("$signInScreen.lblEnterEmail");
  String get lblPassword => getContentValueFromKey("$signInScreen.lblPassword");
  String get lblEnterPassword =>
      getContentValueFromKey("$signInScreen.lblEnterPassword");
  String get lblRememberMe =>
      getContentValueFromKey("$signInScreen.lblRememberMe");
  String get lblForgotPassword =>
      getContentValueFromKey("$signInScreen.lblForgotPassword");
  String get lblNewUser => getContentValueFromKey("$signInScreen.lblNewUser");
  String get lblHome => getContentValueFromKey("$dashboardScreen.lblHome");
  String get lblDiet => getContentValueFromKey("$dashboardScreen.lblDiet");
  String get lblReport => getContentValueFromKey("$dashboardScreen.lblReport");
  String get lblProfile => getContentValueFromKey("$dashboardScreen.lblProfile");
  String get lblAboutUs => getContentValueFromKey("$profileScreen.lblAboutUs");
  String get lblRecipe => getContentValueFromKey("$dietScreen.lblRecipe");
  String get lblBlog => getContentValueFromKey("$profileScreen.lblBlog");
  String get lblChangePassword =>
      getContentValueFromKey("$settingScreen.lblChangePassword");
  String get lblEnterCurrentPwd =>
      getContentValueFromKey("$settingScreen.lblEnterCurrentPwd");
  String get lblEnterNewPwd =>
      getContentValueFromKey("$settingScreen.lblEnterNewPwd");
  String get lblCurrentPassword =>
      getContentValueFromKey("$settingScreen.lblCurrentPassword");
  String get lblNewPassword =>
      getContentValueFromKey("$settingScreen.lblNewPassword");
  String get lblConfirmPassword =>
      getContentValueFromKey("$signUpStep1Component.lblConfirmPassword");
  String get lblEnterConfirmPwd =>
      getContentValueFromKey("$signUpStep1Component.lblEnterConfirmPwd");
  String get errorPwdLength =>
      getContentValueFromKey("$signUpStep1Component.errorPwdLength");
  String get errorPwdMatch =>
      getContentValueFromKey("$signUpStep1Component.errorPwdMatch");
  String get lblSubmit => getContentValueFromKey("$settingScreen.lblSubmit");
  String get lblEditProfile =>
      getContentValueFromKey("$editProfileScreen.lblEditProfile");
  String get lblFirstName =>
      getContentValueFromKey("$signUpStep1Component.lblFirstName");
  String get lblEnterFirstName =>
      getContentValueFromKey("$signUpStep1Component.lblEnterFirstName");
  String get lblEnterLastName =>
      getContentValueFromKey("$signUpStep1Component.lblEnterLastName");
  String get lblLastName =>
      getContentValueFromKey("$signUpStep1Component.lblLastName");
  String get lblPhoneNumber =>
      getContentValueFromKey("$signUpStep1Component.lblPhoneNumber");
  String get lblEnterPhoneNumber =>
      getContentValueFromKey("$signUpStep1Component.lblEnterPhoneNumber");
  String get lblEnterAge =>
      getContentValueFromKey("$editProfileScreen.lblEnterAge");
  String get lblAge => getContentValueFromKey("$editProfileScreen.lblAge");
  String get lblWeight =>
      getContentValueFromKey("$signUpStep4Component.lblWeight");
  String get lblLbs => getContentValueFromKey("$signUpStep4Component.lblLbs");
  String get lblKg => getContentValueFromKey("$signUpStep4Component.lblKg");
  String get lblEnterWeight =>
      getContentValueFromKey("$signUpStep4Component.lblEnterWeight");
  String get lblHeight =>
      getContentValueFromKey("$signUpStep4Component.lblHeight");
  String get lblFeet => getContentValueFromKey("$signUpStep4Component.lblFeet");
  String get lblCm => getContentValueFromKey("$signUpStep4Component.lblCm");
  String get lblEnterHeight =>
      getContentValueFromKey("$signUpStep4Component.lblEnterHeight");
  String get lblGender => getContentValueFromKey("$editProfileScreen.lblGender");
  String get lblSave => getContentValueFromKey("$editProfileScreen.lblSave");
  String get lblForgotPwdMsg =>
      getContentValueFromKey("$settingScreen.lblForgotPwdMsg");
  String get lblContinue => getContentValueFromKey("$otpScreen.lblContinue");
  String get lblSelectLanguage =>
      getContentValueFromKey("$settingScreen.lblSelectLanguage");
  String get lblNoInternet =>
      getContentValueFromKey("$chattingImageScreen.lblNoInternet");
  String get lblContinueWithPhone =>
      getContentValueFromKey("$otpScreen.lblContinueWithPhone");
  String get lblRcvCode => getContentValueFromKey("$otpScreen.lblRcvCode");
  String get lblYear => getContentValueFromKey("$subscribeScreen.lblYear");
  String get lblFavourite =>
      getContentValueFromKey("$chattingImageScreen.lblFavourite");
  String get lblSelectTheme =>
      getContentValueFromKey("$settingScreen.lblSelectTheme");
  String get lblDeleteAccount =>
      getContentValueFromKey("$progressScreen.lblDeleteAccount");
  String get lblPrivacyPolicy =>
      getContentValueFromKey("$profileScreen.lblPrivacyPolicy");
  String get lblLogout => getContentValueFromKey("$profileScreen.lblLogout");
  String get lblLogoutMsg =>
      getContentValueFromKey("$profileScreen.lblLogoutMsg");
  String get lblVerifyOTP => getContentValueFromKey("$otpScreen.lblVerifyOTP");
  String get lblVerifyProceed =>
      getContentValueFromKey("$otpScreen.lblVerifyProceed");
  String get lblCode => getContentValueFromKey("$otpScreen.lblCode");
  String get lblTellUsAboutYourself =>
      getContentValueFromKey("$signUpStep1Component.lblTellUsAboutYourself");
  String get lblAlreadyAccount =>
      getContentValueFromKey("$signUpStep1Component.lblAlreadyAccount");
  String get lblWhtGender =>
      getContentValueFromKey("$signUpStep2Component.lblWhtGender");
  String get lblMale => getContentValueFromKey("$signUpStep2Component.lblMale");
  String get lblFemale =>
      getContentValueFromKey("$signUpStep2Component.lblFemale");
  String get lblHowOld =>
      getContentValueFromKey("$signUpStep3Component.lblHowOld");
  String get lblLetUsKnowBetter =>
      getContentValueFromKey("$signUpStep4Component.lblLetUsKnowBetter");
  String get lblLight => getContentValueFromKey("$settingScreen.lblLight");
  String get lblDark => getContentValueFromKey("$settingScreen.lblDark");
  String get lblSystemDefault =>
      getContentValueFromKey("$settingScreen.lblSystemDefault");
  String get lblStore => getContentValueFromKey("$chattingImageScreen.lblStore");
  String get lblPlan => getContentValueFromKey("$profileScreen.lblPlan");
  String get plan => getContentValueFromKey("$dailyPlanScreen.plan");
  String get lblAboutApp => getContentValueFromKey("$profileScreen.lblAboutApp");
  String get lblPasswordMsg =>
      getContentValueFromKey("$settingScreen.lblPasswordMsg");
  String get lblDelete => getContentValueFromKey("$progressScreen.lblDelete");
  String get lblCancel => getContentValueFromKey("$settingScreen.lblCancel");
  String get lblSettings => getContentValueFromKey("$profileScreen.lblSettings");
  String get lblHeartRate =>
      getContentValueFromKey("$progressScreen.lblHeartRate");
  String get lblMonthly => getContentValueFromKey("$otpScreen.lblMonthly");
  String get lblNoFoundData =>
      getContentValueFromKey("$searchScreen.lblNoFoundData");
  String get lblTermsOfServices =>
      getContentValueFromKey("$profileScreen.lblTermsOfServices");
  String get lblFollowUs => getContentValueFromKey("$profileScreen.lblFollowUs");
  String get lblWorkouts => getContentValueFromKey("$homeScreen.lblWorkouts");
  String get lblChatConfirmMsg =>
      getContentValueFromKey("$chattingImageScreen.lblChatConfirmMsg");
  String get lblYes => getContentValueFromKey("$chattingImageScreen.lblYes");
  String get lblNo => getContentValueFromKey("$chattingImageScreen.lblNo");
  String get lblClearConversion =>
      getContentValueFromKey("$chattingImageScreen.lblClearConversion");
  String get lblChatHintText =>
      getContentValueFromKey("$chattingImageScreen.lblChatHintText");
  String get lblTapBackAgainToLeave =>
      getContentValueFromKey("$dashboardScreen.lblTapBackAgainToLeave");
  String get lblPro => getContentValueFromKey("$chattingImageScreen.lblPro");
  String get lblCalories =>
      getContentValueFromKey("$chattingImageScreen.lblCalories");
  String get lblCarbs => getContentValueFromKey("$chattingImageScreen.lblCarbs");
  String get lblFat => getContentValueFromKey("$chattingImageScreen.lblFat");
  String get lblProtein =>
      getContentValueFromKey("$chattingImageScreen.lblProtein");
  String get lblKcal => getContentValueFromKey("$chattingImageScreen.lblKcal");
  String get lblIngredients =>
      getContentValueFromKey("$chattingImageScreen.lblIngredients");
  String get lblInstruction =>
      getContentValueFromKey("$chattingImageScreen.lblInstruction");
  String get lblStartExercise =>
      getContentValueFromKey("$exerciseDetailScreen.lblStartExercise");
  String get lblDuration => getContentValueFromKey("$searchScreen.lblDuration");
  String get lblBodyParts =>
      getContentValueFromKey("$exerciseDetailScreen.lblBodyParts");
  String get lblEquipments =>
      getContentValueFromKey("$exerciseDetailScreen.lblEquipments");
  String get lblHomeWelMsg =>
      getContentValueFromKey("$homeScreen.lblHomeWelMsg");
  String get lblBodyPartExercise =>
      getContentValueFromKey("$homeScreen.lblBodyPartExercise");
  String get lblEquipmentsExercise =>
      getContentValueFromKey("$homeScreen.lblEquipmentsExercise");
  String get lblLevels => getContentValueFromKey("$homeScreen.lblLevels");
  String get lblBuyNow => getContentValueFromKey("$subscribeScreen.lblBuyNow");
  String get lblSearchExercise =>
      getContentValueFromKey("$searchScreen.lblSearchExercise");
  String get lblAll => getContentValueFromKey("$searchScreen.lblAll");
  String get lblTips => getContentValueFromKey("$homeScreen.lblTips");
  String get lblDietCategories =>
      getContentValueFromKey("$dietScreen.lblDietCategories");
  String get lblSkip => getContentValueFromKey("$walkThroughScreen.lblSkip");
  String get lblWorkoutType =>
      getContentValueFromKey("$filterWorkoutScreen.lblWorkoutType");
  String get lblLevel => getContentValueFromKey("$homeScreen.lblLevel");
  String get lblBmi => getContentValueFromKey("$subscribeScreen.lblBmi");
  String get lblCopiedToClipboard =>
      getContentValueFromKey("$chattingImageScreen.lblCopiedToClipboard");
  String get lblFullBodyWorkout =>
      getContentValueFromKey("$filterWorkoutScreen.lblFullBodyWorkout");
  String get lblTypes => getContentValueFromKey("$filterWorkoutScreen.lblTypes");
  String get lblClearAll =>
      getContentValueFromKey("$filterWorkoutScreen.lblClearAll");
  String get lblSelectAll =>
      getContentValueFromKey("$filterWorkoutScreen.lblSelectAll");
  String get lblShowResult =>
      getContentValueFromKey("$filterWorkoutScreen.lblShowResult");
  String get lblSelectLevels =>
      getContentValueFromKey("$filterWorkoutScreen.lblSelectLevels");
  String get lblUpdate => getContentValueFromKey("$progressScreen.lblupdate");
  String get lblSteps => getContentValueFromKey("$progressScreen.lblSteps");
  String get lblProgramTitle =>
      getContentValueFromKey("$subscribeScreen.lblProgramTitle");
  String get lblProgramTitle1 =>
      getContentValueFromKey("$subscribeScreen.lblProgramTitle1");
  String get lblSubscriptionPlans =>
      getContentValueFromKey("$subscribeScreen.lblSubscriptionPlans");
  String get lblSubscribe =>
      getContentValueFromKey("$subscribeScreen.lblSubscribe");
  String get lblActive => getContentValueFromKey("$subscribeScreen.lblActive");
  String get lblHistory => getContentValueFromKey("$subscribeScreen.lblHistory");
  String get lblSubscriptionMsg =>
      getContentValueFromKey("$subscribeScreen.lblSubscriptionMsg");
  String get lblCancelSubscription =>
      getContentValueFromKey("$subscribeScreen.lblCancelSubscription");
  String get lblViewPlans =>
      getContentValueFromKey("$subscribeScreen.lblViewPlans");
  String get lblFollowUp =>
      getContentValueFromKey("$subscribeScreen.lblFollowUp");
  String get lblFollowUpTooltip =>
      getContentValueFromKey("$subscribeScreen.lblFollowUpTooltip");
  String get lblConfirm =>
      getContentValueFromKey("$subscribeScreen.lblConfirm");
  String get lblFoodRecognitionLimit =>
      getContentValueFromKey("$subscribeScreen.lblFoodRecognitionLimit");
  String get lblTotal => getContentValueFromKey("$subscribeScreen.lblTotal");
  String get lblProgramPrice =>
      getContentValueFromKey("$subscribeScreen.lblProgramPrice");
  String get lblName => getContentValueFromKey("$subscribeScreen.lblName");
  String get lblPrice => getContentValueFromKey("$subscribeScreen.lblPrice");
  String get lblDurationUnit =>
      getContentValueFromKey("$subscribeScreen.lblDurationUnit");
  String get lblAdvice => getContentValueFromKey("$subscribeScreen.lblAdvice");
  String get lblEnterProgram =>
      getContentValueFromKey("$subscribeScreen.lblEnterProgram");
  String get lblExercises =>
      getContentValueFromKey("$subscribeScreen.lblExercises");
  String get lblHey => getContentValueFromKey("$homeScreen.lblHey");
  String get lblRepeat =>
      getContentValueFromKey("$notificationScreen.lblRepeat");
  String get lblEveryday => getContentValueFromKey("$profileScreen.lblEveryday");
  String get lblReminderName =>
      getContentValueFromKey("$profileScreen.lblReminderName");
  String get lblDescription =>
      getContentValueFromKey("$profileScreen.lblDescription");
  String get lblSearch => getContentValueFromKey("$homeScreen.lblSearch");
  String get lblTopFitnessReads =>
      getContentValueFromKey("$profileScreen.lblTopFitnessReads");
  String get lblTrendingBlogs =>
      getContentValueFromKey("$profileScreen.lblTrendingBlogs");
  String get lblBestDietDiscoveries =>
      getContentValueFromKey("$dietScreen.lblBestDietDiscoveries");
  String get lblDietaryOptions =>
      getContentValueFromKey("$dietScreen.lblDietaryOptions");
  String get lblFav => getContentValueFromKey("$otpScreen.lblFav");

  String get lblBreak => getContentValueFromKey("$productScreen.lblBreak");

  String get lblProductCategory =>
      getContentValueFromKey("$productScreen.lblProductCategory");

  String get lblProductList =>
      getContentValueFromKey("$productScreen.lblProductList");

  String get lblTipsInst =>
      getContentValueFromKey("$editProfileScreen.lblTipsInst");

  String get lblContactAdmin =>
      getContentValueFromKey("$signInScreen.lblContactAdmin");

  String get lblOr => getContentValueFromKey("$signInScreen.lblOr");

  String get lblRegisterNow =>
      getContentValueFromKey("$signInScreen.lblRegisterNow");

  String get lblDailyReminders =>
      getContentValueFromKey("$profileScreen.lblDailyReminders");

  String get lblPayments => getContentValueFromKey("$paymentScreen.lblPayments");

  String get lblPay =>
      getContentValueFromKey("$filterWorkoutScreen.lblWorkoutType");

  String get lblAppThemes =>
      getContentValueFromKey("$settingScreen.lblAppThemes");

  String get lblTotalSteps =>
      getContentValueFromKey("$settingScreen.lblTotalSteps");

  String get lblDate => getContentValueFromKey("$progressScreen.lblDate");

  String get lblDeleteAccountMSg =>
      getContentValueFromKey("$progressScreen.lblDeleteAccountMSg");

  String get lblHint => getContentValueFromKey("$progressScreen.lblHint");

  String get lblAdd => getContentValueFromKey("$progressScreen.lblAdd");

  String get lblNotifications =>
      getContentValueFromKey("$notificationScreen.lblNotifications");

  String get lblNotificationEmpty =>
      getContentValueFromKey("$notificationScreen.lblNotificationEmpty");

  String get lblQue1 => getContentValueFromKey("$chattingImageScreen.lblQue1");

  String get lblQue2 => getContentValueFromKey("$chattingImageScreen.lblQue2");

  String get lblQue3 => getContentValueFromKey("$chattingImageScreen.lblQue3");

  String get lblFitBot =>
      getContentValueFromKey("$chattingImageScreen.lblFitBot");

  String get lblG => getContentValueFromKey("$chattingImageScreen.lblG");

  String get lblEnterText => getContentValueFromKey("$otpScreen.lblEnterText");

  String get lblYourPlanValid =>
      getContentValueFromKey("$subscribeScreen.lblYourPlanValid");

  String get lblTo => getContentValueFromKey("$subscribeScreen.lblTo");

  String get lblSets => getContentValueFromKey("$exerciseDetailScreen.lblSets");

  String get lblSuccessMsg =>
      getContentValueFromKey("$paymentScreen.lblSuccessMsg");

  String get lblPaymentFailed =>
      getContentValueFromKey("$paymentScreen.lblPaymentFailed");

  String get lblSuccess => getContentValueFromKey("$paymentScreen.lblSuccess");

  String get lblDone => getContentValueFromKey("$signUpStep4Component.lblDone");

  String get lblWorkoutLevel =>
      getContentValueFromKey("$filterWorkoutScreen.lblWorkoutLevel");

  String get lblReps => getContentValueFromKey("$exerciseDetailScreen.lblReps");

  String get lblSecond =>
      getContentValueFromKey("$exerciseDetailScreen.lblSecond");

  String get lblFavoriteWorkoutAndNutristions =>
      getContentValueFromKey("$profileScreen.lblFavoriteWorkoutAndNutristions");

  String get lblShop => getContentValueFromKey("$dashboardScreen.lblShop");

  String get lblDeleteMsg =>
      getContentValueFromKey("$progressScreen.lblDeleteMsg");

  String get lblSelectPlanToContinue =>
      getContentValueFromKey("$subscribeScreen.lblSelectPlanToContinue");

  String get lblResultNoFound =>
      getContentValueFromKey("$dietScreen.lblResultNoFound");

  String get lblExerciseNoFound =>
      getContentValueFromKey("$searchScreen.lblExerciseNoFound");

  String get lblBlogNoFound =>
      getContentValueFromKey("$profileScreen.lblBlogNoFound");

  String get lblWorkoutNoFound =>
      getContentValueFromKey("$filterWorkoutScreen.lblWorkoutNoFound");

  String get lblTenSecondRemaining =>
      getContentValueFromKey("$exerciseDetailScreen.lblTenSecondRemaining");

  String get lblThree =>
      getContentValueFromKey("$exerciseDetailScreen.lblThree");

  String get lblTwo => getContentValueFromKey("$exerciseDetailScreen.lblTwo");

  String get lblOne => getContentValueFromKey("$exerciseDetailScreen.lblOne");

  String get lblExerciseDone =>
      getContentValueFromKey("$exerciseDetailScreen.lblExerciseDone");

  String get lblMonth => getContentValueFromKey("$subscribeScreen.lblMonth");

  String get lblDay => getContentValueFromKey("$homeScreen.lblDay");

  String get lblPushUp => getContentValueFromKey("$progressScreen.lblPushUp");

  String get lblEnterReminderName =>
      getContentValueFromKey("$exerciseDetailScreen.lblEnterReminderName");

  String get lblEnterDescription =>
      getContentValueFromKey("$exerciseDetailScreen.lblEnterDescription");

  String get lblMetricsSettings =>
      getContentValueFromKey("$settingScreen.lblMetricsSettings");

  String get lblIdealWeight =>
      getContentValueFromKey("$settingScreen.lblIdealWeight");

  String get lblBmr => getContentValueFromKey("$settingScreen.lblBmr");

  String get lblErrorThisFiledIsRequired =>
      getContentValueFromKey("$otpScreen.lblErrorThisFiledIsRequired");

  String get lblSomethingWentWrong =>
      getContentValueFromKey("$otpScreen.lblSomethingWentWrong");

  String get lblErrorInternetNotAvailable =>
      getContentValueFromKey("$otpScreen.lblErrorInternetNotAvailable");

  String get lblErrorNotAllow =>
      getContentValueFromKey("$chattingImageScreen.lblErrorNotAllow");

  String get lblPleaseTryAgain =>
      getContentValueFromKey("$chattingImageScreen.lblPleaseTryAgain");

  String get lblInvalidUrl =>
      getContentValueFromKey("$chattingImageScreen.lblInvalidUrl");

  String get lblUsernameShouldNotContainSpace => getContentValueFromKey(
    "$chattingImageScreen.lblUsernameShouldNotContainSpace",
  );

  String get lblMinimumPasswordLengthShouldBe => getContentValueFromKey(
    "$chattingImageScreen.lblMinimumPasswordLengthShouldBe",
  );

  String get lblInternetIsConnected =>
      getContentValueFromKey("$chattingImageScreen.lblInternetIsConnected");

  String get lblNoSetsMsg =>
      getContentValueFromKey("$exerciseDetailScreen.lblNoSetsMsg");

  String get lblNoDurationMsg =>
      getContentValueFromKey("$chattingImageScreen.lblNoDurationMsg");

  String get lblWalkTitle1 =>
      getContentValueFromKey("$walkThroughScreen.lblWalkTitle1");

  String get lblWalkTitle2 =>
      getContentValueFromKey("$walkThroughScreen.lblWalkTitle2");

  String get lblWalkTitle3 =>
      getContentValueFromKey("$walkThroughScreen.lblWalkTitle3");

  String get lblEmailIsInvalid =>
      getContentValueFromKey("$walkThroughScreen.lblEmailIsInvalid");

  String get lblMainGoal =>
      getContentValueFromKey("$chattingImageScreen.lblMainGoal");

  String get lblHowExperienced =>
      getContentValueFromKey("$chattingImageScreen.lblHowExperienced");

  String get lblHoweEquipment =>
      getContentValueFromKey("$chattingImageScreen.lblHoweEquipment");

  String get lblHoweOftenWorkout =>
      getContentValueFromKey("$chattingImageScreen.lblHoweOftenWorkout");

  String get lblFinish =>
      getContentValueFromKey("$chattingImageScreen.lblFinish");

  String get lblProgression =>
      getContentValueFromKey("$chattingImageScreen.lblProgression");

  String get lblEasyHabit =>
      getContentValueFromKey("$chattingImageScreen.lblEasyHabit");

  String get lblRecommend =>
      getContentValueFromKey("$chattingImageScreen.lblRecommend");

  String get lblTimesWeek =>
      getContentValueFromKey("$chattingImageScreen.lblTimesWeek");

  String get lblOnlyTimesWeek =>
      getContentValueFromKey("$chattingImageScreen.lblOnlyTimesWeek");

  String get lblSchedule =>
      getContentValueFromKey("$scheduleScreen.lblSchedule");
  String get lblChangeView =>
      getContentValueFromKey("$scheduleScreen.lblChangeView");
  String get lblJoin => getContentValueFromKey("$scheduleScreen.lblJoin");
  String get lblUpdateNow => getContentValueFromKey("$homeScreen.lblUpdateNow");
  String get lblUpdateAvailable =>
      getContentValueFromKey("$homeScreen.lblUpdateAvailable");
  String get lblUpdateNote =>
      getContentValueFromKey("$homeScreen.lblUpdateNote");
  String get lblGameOver => getContentValueFromKey("$homeScreen.lblGameOver");

  String get lblMainMenu => getContentValueFromKey("$homeScreen.lblMainMenu");
  String get lblBetterLuckNextTime =>
      getContentValueFromKey("$homeScreen.lblBetterLuckNextTime");
  String get lblExit => getContentValueFromKey("$homeScreen.lblExit");
  String get lblMightyBrainWorkout =>
      getContentValueFromKey("$homeScreen.lblMightyBrainWorkout");
  String get lblGameTitle => getContentValueFromKey("$homeScreen.lblGameTitle");
  String get lblStart => getContentValueFromKey("$homeScreen.lblStart");
  String get lblPleaseWait =>
      getContentValueFromKey("$homeScreen.lblPleaseWait");
  String get lblHoursAfterPlayAgain =>
      getContentValueFromKey("$homeScreen.lblHoursAfterPlayAgain");
  String get lblBuildMuscle =>
      getContentValueFromKey("$homeScreen.lblBuildMuscle");
  String get lblKeepFit => getContentValueFromKey("$homeScreen.lblKeepFit");
  String get lblLoseWeight =>
      getContentValueFromKey("$homeScreen.lblLoseWeight");

  String get lblFirstDescriptions1 =>
      getContentValueFromKey("$homeScreen.lblFirstDescriptions1");
  String get lblFirstDescriptions2 =>
      getContentValueFromKey("$homeScreen.lblFirstDescriptions2");
  String get lblFirstDescriptions3 =>
      getContentValueFromKey("$homeScreen.lblFirstDescriptions3");

  String get lblTotallyNewbie =>
      getContentValueFromKey("$homeScreen.lblTotallyNewbie");
  String get lblBeginner => getContentValueFromKey("$homeScreen.lblBeginner");
  String get lblIntermediate =>
      getContentValueFromKey("$homeScreen.lblIntermediate");
  String get lblAdvanced => getContentValueFromKey("$homeScreen.lblAdvanced");

  String get lblSecDesc1 => getContentValueFromKey("$homeScreen.LblSecDesc1");
  String get lblSecDesc2 => getContentValueFromKey("$homeScreen.LblSecDesc2");
  String get lblSecDesc3 => getContentValueFromKey("$homeScreen.LblSecDesc3");
  String get lblSecDesc4 => getContentValueFromKey("$homeScreen.LblSecDesc4");

  String get lblNoEquipment =>
      getContentValueFromKey("$homeScreen.lblNoEquipment");
  String get lblDumbbells => getContentValueFromKey("$homeScreen.lblDumbbells");
  String get lblGarageGym => getContentValueFromKey("$homeScreen.lblGarageGym");
  String get lblFullGym => getContentValueFromKey("$homeScreen.lblFullGym");
  String get lblCustom => getContentValueFromKey("$homeScreen.lblCustom");
  String get lblThirdDescriptions1 =>
      getContentValueFromKey("$homeScreen.lblThirdDescriptions1");
  String get lblThirdDescriptions2 =>
      getContentValueFromKey("$homeScreen.lblThirdDescriptions2");
  String get lblThirdDescriptions3 =>
      getContentValueFromKey("$homeScreen.lblThirdDescriptions3");
  String get lblThirdDescriptions4 =>
      getContentValueFromKey("$homeScreen.lblThirdDescriptions4");
  String get lblThirdDescriptions5 =>
      getContentValueFromKey("$homeScreen.lblThirdDescriptions5");

  String get lblHomeScreenTitle =>
      getContentValueFromKey("$homeScreen.lblHomeScreenTitle");

  String get lblNoConversationFound =>
      getContentValueFromKey("$chattingImageScreen.lblNoConversationFound");

  String get lblViewContact =>
      getContentValueFromKey("$chattingImageScreen.lblViewContact");
  String get lblUnblock =>
      getContentValueFromKey("$chattingImageScreen.lblUnblock");
  String get lblBlock => getContentValueFromKey("$chattingImageScreen.lblBlock");
  String get lblClearChat =>
      getContentValueFromKey("$chattingImageScreen.lblClearChat");
  String get lblChatCleared =>
      getContentValueFromKey("$chattingImageScreen.lblChatCleared");
  String get lblBlockMsg =>
      getContentValueFromKey("$chattingImageScreen.lblBlockMsg");
  String get lblOnline =>
      getContentValueFromKey("$chattingImageScreen.lblOnline");
  String get lblLastSeen =>
      getContentValueFromKey("$chattingImageScreen.lblLastSeen");
  String get lblSearchHere =>
      getContentValueFromKey("$chattingImageScreen.lblSearchHere");
  String get lblNewChat =>
      getContentValueFromKey("$chattingImageScreen.lblNewChat");

  String get lblFailed => getContentValueFromKey("$paymentScreen.lblFailed");
  String get lblPaymentSuccessful =>
      getContentValueFromKey("$paymentScreen.lblPaymentSuccessful");
  String get lblPaymentCancelled =>
      getContentValueFromKey("$paymentScreen.lblPaymentCancelled");

  String get lblDeleteChat =>
      getContentValueFromKey("$chattingImageScreen.lblDeleteChat");
  String get lblDeleteDialogTitle =>
      getContentValueFromKey("$chattingImageScreen.lblDeleteDialogTitle");
  String get lblChatDeleted =>
      getContentValueFromKey("$chattingImageScreen.lblChatDeleted");
  String get lblDeleteMessage =>
      getContentValueFromKey("$chattingImageScreen.lblDeleteMessage");

  String get lblChat => getContentValueFromKey("$chattingImageScreen.lblChat");
  String get lblMinRead =>
      getContentValueFromKey("$chattingImageScreen.lblMinRead");

  String get lblFree => getContentValueFromKey("$scheduleScreen.lblFree");
  String get lblPurchases =>
      getContentValueFromKey("$scheduleScreen.lblPurchases");
  String get lblToSendMsg =>
      getContentValueFromKey("$chattingImageScreen.lblToSendMsg");
  String get lblMsg => getContentValueFromKey("$chattingImageScreen.lblMsg");
  String get lblRepsWeight =>
      getContentValueFromKey("$homeScreen.lblRepsWeight");
  String get lblRest => getContentValueFromKey("$homeScreen.lblRest");

  String get lblLeaderboard =>
      getContentValueFromKey("$homeScreen.lblLeaderboard");

  String get lblCommunity =>
      getContentValueFromKey("$communityScreen.lblCommunity");
  String get lblReportPost =>
      getContentValueFromKey("$communityScreen.lblReportPost");
  String get lblEditPost =>
      getContentValueFromKey("$communityScreen.lblEditPost");
  String get lblDeletePost =>
      getContentValueFromKey("$communityScreen.lblDeletePost");
  String get lblDelPost => getContentValueFromKey("$communityScreen.lblDelPost");
  String get gotoProfile =>
      getContentValueFromKey("$communityScreen.gotoProfile");
  String get lblNoPost => getContentValueFromKey("$communityScreen.lblNoPost");
  String get lblComments =>
      getContentValueFromKey("$communityScreen.lblComments");
  String get lblupdate => getContentValueFromKey("$progressScreen.lblUpdate");
  String get lblReply => getContentValueFromKey("$communityScreen.lblReply");
  String get lblViewR => getContentValueFromKey("$communityScreen.lblViewR");
  String get lblHideR => getContentValueFromKey("$communityScreen.lblHideR");
  String get lblUpComments =>
      getContentValueFromKey("$communityScreen.lblUpComments");
  String get lblAddComments =>
      getContentValueFromKey("$communityScreen.lblAddComments");
  String get lblReports => getContentValueFromKey("$communityScreen.lblReports");
  String get lblRepoDes => getContentValueFromKey("$communityScreen.lblRepoDes");
  String get lblRepo => getContentValueFromKey("$communityScreen.lblRepo");
  String get finishProfileSetting =>
      getContentValueFromKey("$communityScreen.finishProfileSetting");
  String get lblChoseVideo =>
      getContentValueFromKey("$communityScreen.lblChoseVideo");
  String get lblMaxVideoMsg =>
      getContentValueFromKey("$communityScreen.lblMaxVideoMsg");
  String get lblNewPost => getContentValueFromKey("$communityScreen.lblNewPost");
  String get writeSomeThing =>
      getContentValueFromKey("$communityScreen.WriteSomeThing");
  String get lblEditImg => getContentValueFromKey("$communityScreen.lblEditImg");
  String get lblEditVid => getContentValueFromKey("$communityScreen.lblEditVid");
  String get lblSelectImg =>
      getContentValueFromKey("$communityScreen.lblSelectImg");
  String get lblSelectVid =>
      getContentValueFromKey("$communityScreen.lblSelectVid");
  String get lblEmptyMsg =>
      getContentValueFromKey("$communityScreen.lblEmptyMsg");
  String get lblAddImg => getContentValueFromKey("$communityScreen.lblAddImg");
  String get lblAddVid => getContentValueFromKey("$communityScreen.lblAddVid");
  String get lblSharePost =>
      getContentValueFromKey("$communityScreen.lblSharePost");
  String get lblCamera => getContentValueFromKey("$communityScreen.lblCamera");
  String get lblChoseImg =>
      getContentValueFromKey("$communityScreen.lblChoseImg");
  String get lblRecord => getContentValueFromKey("$communityScreen.lblRecord");
  String get lblPost => getContentValueFromKey("$communityScreen.lblPost");
  String get edtCmt => getContentValueFromKey("$communityScreen.edtCmt");
  String get edtRpl => getContentValueFromKey("$communityScreen.edtRpl");
  String get dltRpl => getContentValueFromKey("$communityScreen.dltRpl");
  String get dltCmt => getContentValueFromKey("$communityScreen.dltCmt");
  String get share => getContentValueFromKey("$communityScreen.share");
  String get posted => getContentValueFromKey("$communityScreen.posted");
  String get lblCmt => getContentValueFromKey("$communityScreen.lblCmt");
  String get lblLike => getContentValueFromKey("$communityScreen.lblLike");
  String get lblLikes => getContentValueFromKey("$communityScreen.lblLikes");
  String get lblUMedia => getContentValueFromKey("$communityScreen.lblUMedia");
  String get lblPostBmk => getContentValueFromKey("$profileScreen.lblPostBmk");
  String get lblWOHtr => getContentValueFromKey("$profileScreen.lblWOHtr");
  String get lblOpen => getContentValueFromKey("$communityScreen.lblOpen");
  String get lblPermissionDescription =>
      getContentValueFromKey("$communityScreen.lblPermissionDescription");
  String get confirmDeleteComment =>
      getContentValueFromKey("$communityScreen.confirmDeleteComment");
  String get confirmDeleteCommentReply =>
      getContentValueFromKey("$communityScreen.confirmDeleteCommentReply");
  String get checkOutPost =>
      getContentValueFromKey("$communityScreen.checkOutPost");
  String get readMore => getContentValueFromKey("$communityScreen.readMore");
  String get readLess => getContentValueFromKey("$communityScreen.readLess");
  String get disclaimer => getContentValueFromKey("$dietScreen.disclaimer");
  String get viewSourceReference =>
      getContentValueFromKey("$dietScreen.viewSourceReference");
  String get sourceReference =>
      getContentValueFromKey("$dietScreen.sourceReference");
  String get close => getContentValueFromKey("$dietScreen.close");
  String get dietDisclaimerNote =>
      getContentValueFromKey("$dietScreen.dietDisclaimerNote");
  String get dietDisclaimerNote2 =>
      getContentValueFromKey("$dietScreen.dietDisclaimerNote2");
  String get dietDisclaimerNote3 =>
      getContentValueFromKey("$dietScreen.dietDisclaimerNote3");

  String get lblDailyTracking =>
      getContentValueFromKey("$homeScreen.lblDailyTracking");
  String get lblStpCnt => getContentValueFromKey("$homeScreen.lblStpCnt");
  String get lblWtrInt => getContentValueFromKey("$homeScreen.lblWtrInt");
  String get lblGlass => getContentValueFromKey("$homeScreen.lblGlass");
  String get lblStpTrack => getContentValueFromKey("$homeScreen.lblStpTrack");
  String get lblStpC1 => getContentValueFromKey("$homeScreen.lblStpC1");
  String get lblOnly => getContentValueFromKey("$homeScreen.lblOnly");
  String get lblStpC2 => getContentValueFromKey("$homeScreen.lblStpC2");
  String get lblStpC3 => getContentValueFromKey("$homeScreen.lblStpC3");
  String get lblStpC4 => getContentValueFromKey("$homeScreen.lblStpC4");
  String get lblDG => getContentValueFromKey("$homeScreen.lblDG");
  String get lblWtrTrack => getContentValueFromKey("$homeScreen.lblWtrTrack");
  String get lblGoalC1 => getContentValueFromKey("$homeScreen.lblGoalC1");
  String get lblGlasses => getContentValueFromKey("$homeScreen.lblGlasses");
  String get lblLogNw => getContentValueFromKey("$homeScreen.lblLogNw");
  String get lblEnrGls => getContentValueFromKey("$homeScreen.lblEnrGls");
  String get lblWtrConsDaily =>
      getContentValueFromKey("$homeScreen.lblWtrConsDaily");
  String get assignedWorkouts =>
      getContentValueFromKey("$homeScreen.assignedWorkouts");
  String get assignedDiet => getContentValueFromKey("$homeScreen.assignedDiet");

  String get resetExercise =>
      getContentValueFromKey("$exerciseDetailScreen.resetExercise");
  String get lblComplete =>
      getContentValueFromKey("$exerciseDetailScreen.lblComplete");
  String get lblUpNext =>
      getContentValueFromKey("$exerciseDetailScreen.lblUpNext");
  String get confirmCompleteExercise =>
      getContentValueFromKey("$exerciseDetailScreen.confirmCompleteExercise");
  String get lblExerHtr => getContentValueFromKey("$profileScreen.lblExerHtr");
  String get lblPosts => getContentValueFromKey("$communityScreen.lblPosts");
  String get lblGoal => getContentValueFromKey("$progressScreen.lblGoal");
  String get lblAchived => getContentValueFromKey("$progressScreen.lblAchived");
  String get lblConsumed =>
      getContentValueFromKey("$progressScreen.lblConsumed");
  String get valueGreaterZero =>
      getContentValueFromKey("$progressScreen.valueGreaterZero");

  String get lblSetGoalInsights => getContentValueFromKey("$homeScreen.lblSetGoalInsights");
  String get lblSetWaterGoal => getContentValueFromKey("$homeScreen.lblSetWaterGoal");
  String get lblSetStepGoal => getContentValueFromKey("$homeScreen.lblSetStepGoal");
  String get lblQuantity => getContentValueFromKey("$dailyPlanScreen.lblQuantity");
  String get lblServing => getContentValueFromKey("$dailyPlanScreen.lblServing");
  String get lblRecipesteps => getContentValueFromKey("$dailyPlanScreen.lblRecipesteps");
  String get lblNorecipesfound => getContentValueFromKey("$dailyPlanScreen.lblNorecipesfound");
  String get lblMeals => getContentValueFromKey("$dailyPlanScreen.lblMeals");
  String get lblWater => getContentValueFromKey("$dailyPlanScreen.lblWater");
  String get lblDoyouwantustorecalculateyourcaloriesandmacrosaccordingtoyournewinformation => getContentValueFromKey("$dailyPlanScreen.lblDoyouwantustorecalculateyourcaloriesandmacrosaccordingtoyournewinformation");
  String get lblNodatafound => getContentValueFromKey("$dailyPlanScreen.lblNodatafound");
  String get lblTitle => getContentValueFromKey("$dailyPlanScreen.lblTitle");
  String get lblReminders => getContentValueFromKey("$dailyPlanScreen.lblReminders");
  String get lblTime => getContentValueFromKey("$dailyPlanScreen.lblTime");
  String get lblBreakfast => getContentValueFromKey("$dailyPlanScreen.lblBreakfast");
  String get lblSnacks => getContentValueFromKey("$dailyPlanScreen.lblSnacks");
  String get lblLunch => getContentValueFromKey("$dailyPlanScreen.lblLunch");
  String get lblDinner => getContentValueFromKey("$dailyPlanScreen.lblDinner");
  String get lblStopcasting => getContentValueFromKey("$dailyPlanScreen.lblStopcasting");
  String get lblEditlist => getContentValueFromKey("$dailyPlanScreen.lblEditlist");
  String get lblDeletelist => getContentValueFromKey("$dailyPlanScreen.lblDeletelist");
  String get lblAdditem => getContentValueFromKey("$dailyPlanScreen.lblAdditem");
  String get lblItem => getContentValueFromKey("$dailyPlanScreen.lblItem");
  String get lblUnit => getContentValueFromKey("$dailyPlanScreen.lblUnit");
  String get lblNone => getContentValueFromKey("$dailyPlanScreen.lblNone");
  String get lblDeleteshoppinglist => getContentValueFromKey("$dailyPlanScreen.lblDeleteshoppinglist");
  String get lblSpecificdate => getContentValueFromKey("$dailyPlanScreen.lblSpecificdate");
  String get lblDaterange => getContentValueFromKey("$dailyPlanScreen.lblDaterange");
  String get lblMealtypes => getContentValueFromKey("$dailyPlanScreen.lblMealtypes");
  String get lblServings => getContentValueFromKey("$dailyPlanScreen.lblServings");
  String get lblIscompleteonly => getContentValueFromKey("$dailyPlanScreen.lblIscompleteonly");
  String get lblEvery => getContentValueFromKey("$dailyPlanScreen.lblEvery");
  String get lblFrom => getContentValueFromKey("$dailyPlanScreen.lblFrom");
  String get lblUntil => getContentValueFromKey("$dailyPlanScreen.lblUntil");
  String get lblAt => getContentValueFromKey("$dailyPlanScreen.lblAt");
  String get lblMealswater => getContentValueFromKey("$dailyPlanScreen.lblMealswater");
  String get lblGenerateshoppinglist => getContentValueFromKey("$dailyPlanScreen.lblGenerateshoppinglist");
  String get lblChoosewhichplannedmealstoinclude => getContentValueFromKey("$dailyPlanScreen.lblChoosewhichplannedmealstoinclude");
  String get lblSelectaspecificdate => getContentValueFromKey("$dailyPlanScreen.lblSelectaspecificdate");
  String get lblPickstartenddates => getContentValueFromKey("$dailyPlanScreen.lblPickstartenddates");
  String get lblTags => getContentValueFromKey("$dailyPlanScreen.lblTags");
  String get lblCategories => getContentValueFromKey("$dailyPlanScreen.lblCategories");
  String get lblRecipes => getContentValueFromKey("$dailyPlanScreen.lblRecipes");
  String get lblViewmore => getContentValueFromKey("$dailyPlanScreen.lblViewmore");
  String get lblWaterreminder => getContentValueFromKey("$dailyPlanScreen.lblWaterreminder");
  String get lblDataaccessed => getContentValueFromKey("$dailyPlanScreen.lblDataaccessed");
  String get lblStepcount => getContentValueFromKey("$dailyPlanScreen.lblStepcount");
  String get lblCompleteyourprofile => getContentValueFromKey("$dailyPlanScreen.lblCompleteyourprofile");
  String get lblMightyfitness => getContentValueFromKey("$dailyPlanScreen.lblMightyfitness");
  String get lblAdloading => getContentValueFromKey("$dailyPlanScreen.lblAdloading");
  String get lblDatafromapplehealth => getContentValueFromKey("$dailyPlanScreen.lblDatafromapplehealth");
  String get lblFilters => getContentValueFromKey("$dailyPlanScreen.lblFilters");
  String get lblClearday => getContentValueFromKey("$dailyPlanScreen.lblClearday");
  String get lblAreyousureyouwanttocleartheentiredayplan => getContentValueFromKey("$dailyPlanScreen.lblAreyousureyouwanttocleartheentiredayplan");
  String get lblWhichtypeofdietdoyouwant => getContentValueFromKey("$dailyPlanScreen.lblWhichtypeofdietdoyouwant");
  String get lblDeleteall => getContentValueFromKey("$dailyPlanScreen.lblDeleteall");
  String get lblNihroleofdietinautoimmunediseases => getContentValueFromKey("$dailyPlanScreen.lblNihroleofdietinautoimmunediseases");
  String get lblHarvardinflammatoryfoodsimpact => getContentValueFromKey("$dailyPlanScreen.lblHarvardinflammatoryfoodsimpact");
  String get lblWhonutritionalguidelinesforillness => getContentValueFromKey("$dailyPlanScreen.lblWhonutritionalguidelinesforillness");
  String get lblFindadifferentcolortocheckbrainworkout => getContentValueFromKey("$dailyPlanScreen.lblFindadifferentcolortocheckbrainworkout");
  String get lblConfirmDeleteShoppingList => getContentValueFromKey("$dailyPlanScreen.lblConfirmDeleteShoppingList");
  String get lblWhatsYourGoal => getContentValueFromKey("$signUpStep5Component.lblWhatsYourGoal");
  String get lblGoalSubtitle => getContentValueFromKey("$signUpStep5Component.lblGoalSubtitle");
  String get lblSelectGoal => getContentValueFromKey("$signUpStep5Component.lblSelectGoal");
  String get lblWhatsYourActivityLevel => getContentValueFromKey("$signUpStep6Component.lblWhatsYourActivityLevel");
  String get lblSelectActivityLevel => getContentValueFromKey("$signUpStep6Component.lblSelectActivityLevel");
  String get lblProteins => getContentValueFromKey("$dailyPlanScreen.lblProteins");
  String get lblFats => getContentValueFromKey("$dailyPlanScreen.lblFats");
  String get lblPleaseselectadiettype => getContentValueFromKey("$dailyPlanScreen.lblPleaseselectadiettype");
  String get lblRetry => getContentValueFromKey("$dailyPlanScreen.lblRetry");
  String get lblPleaseenteryourageweightandhei => getContentValueFromKey("$dailyPlanScreen.lblPleaseenteryourageweightandhei");
  String get lblCastingnotsupported => getContentValueFromKey("$dailyPlanScreen.lblCastingnotsupported");
  String get lblDatasaved => getContentValueFromKey("$dailyPlanScreen.lblDatasaved");
  String get lblPleaseenteratitle => getContentValueFromKey("$dailyPlanScreen.lblPleaseenteratitle");
  String get lblNodailyplanfoundforthisdate => getContentValueFromKey("$dailyPlanScreen.lblNodailyplanfoundforthisdate");
  String get lblPleasewaitfordailyplantoload => getContentValueFromKey("$dailyPlanScreen.lblPleasewaitfordailyplantoload");
  String get lblPleaseselectatleastonemealtype => getContentValueFromKey("$dailyPlanScreen.lblPleaseselectatleastonemealtype");
  String get lblPleaseselectadaterange => getContentValueFromKey("$dailyPlanScreen.lblPleaseselectadaterange");
  String get lblSelectday => getContentValueFromKey("$dailyPlanScreen.lblSelectday");
  String get lblMissingrequiredinformation => getContentValueFromKey("$dailyPlanScreen.lblMissingrequiredinformation");
  String get lblStatusupdatedsuccessfully => getContentValueFromKey("$dailyPlanScreen.lblStatusupdatedsuccessfully");
  String get lblRecipedeletedsuccessfully => getContentValueFromKey("$dailyPlanScreen.lblRecipedeletedsuccessfully");
  String get lblDailyplanclearedsuccessfully => getContentValueFromKey("$dailyPlanScreen.lblDailyplanclearedsuccessfully");
  String get lblInvalidrecipedata => getContentValueFromKey("$dailyPlanScreen.lblInvalidrecipedata");
  String get lblRecipeaddedsuccessfully => getContentValueFromKey("$dailyPlanScreen.lblRecipeaddedsuccessfully");
  String get lblEditShoppingList => getContentValueFromKey("$dailyPlanScreen.lblEditShoppingList");
  String get lblAddShoppingList => getContentValueFromKey("$dailyPlanScreen.lblAddShoppingList");
  String get lblAddNewItemToYourShoppingList => getContentValueFromKey("$dailyPlanScreen.lblAddNewItemToYourShoppingList");
  String get lblFailedToLoadVideo => getContentValueFromKey("$dailyPlanScreen.lblFailedToLoadVideo");
  String get lblFailedToLoadImage => getContentValueFromKey("$dailyPlanScreen.lblFailedToLoadImage");
  String get lblReadLess => getContentValueFromKey("$dailyPlanScreen.lblReadLess");
  String get lblReadMore => getContentValueFromKey("$dailyPlanScreen.lblReadMore");
  String get lblReplyTo => getContentValueFromKey("$dailyPlanScreen.lblReplyTo");
  String get lblApplyFilters => getContentValueFromKey("$dailyPlanScreen.lblApplyFilters");
  String get lblAppleHealthIntegration => getContentValueFromKey("$dailyPlanScreen.lblAppleHealthIntegration");
  String get lblConnectAppleHealth => getContentValueFromKey("$dailyPlanScreen.lblConnectAppleHealth");
  String get lblStepDataFromAppleHealth => getContentValueFromKey("$dailyPlanScreen.lblStepDataFromAppleHealth");
  String get lblThreeSecondRemainingForRest => getContentValueFromKey("$dailyPlanScreen.lblThreeSecondRemainingForRest");
  String get lblThreeSecondRemaining => getContentValueFromKey("$dailyPlanScreen.lblThreeSecondRemaining");
  String get lblExerciseComplete => getContentValueFromKey("$dailyPlanScreen.lblExerciseComplete");
  String get lblPayWithCard => getContentValueFromKey("$dailyPlanScreen.lblPayWithCard");
  String get lblShoppingLists => getContentValueFromKey("$dailyPlanScreen.lblShoppingLists");
  String get lblNoShoppingListsFound => getContentValueFromKey("$dailyPlanScreen.lblNoShoppingListsFound");
  String get lblSimpleList => getContentValueFromKey("$dailyPlanScreen.lblSimpleList");
  String get lblCategorized => getContentValueFromKey("$dailyPlanScreen.lblCategorized");
  String get lblEnterItemName => getContentValueFromKey("$dailyPlanScreen.lblEnterItemName");
  String get lblItemNameIsRequired => getContentValueFromKey("$dailyPlanScreen.lblItemNameIsRequired");
  String get lblGoalCaloriesMacros => getContentValueFromKey("$dailyPlanScreen.lblGoalCaloriesMacros");
  String get lblActivityLevel => getContentValueFromKey("$dailyPlanScreen.lblActivityLevel");
  String get lblMacrosDietType => getContentValueFromKey("$dailyPlanScreen.lblMacrosDietType");
  String get lblUpdatedSuccessfully => getContentValueFromKey("$dailyPlanScreen.lblUpdatedSuccessfully");
  String get lblGeneric => getContentValueFromKey("$dailyPlanScreen.lblGeneric");
  String get lblMarkThisRecipeAsCompleted => getContentValueFromKey("$dailyPlanScreen.lblMarkThisRecipeAsCompleted");

  String get lblCalorieCalculator {
    final String value =
        getContentValueFromKey("$dietScreen.lblCalorieCalculator");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'حساب السعرات الحرارية'
          : 'Calorie Calculator';
    }
    return value;
  }

  String get lblCalculateCalories {
    final String value =
        getContentValueFromKey("$dietScreen.lblCalculateCalories");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'حساب السعرات الحرارية'
          : 'Calculate Calories';
    }
    return value;
  }

  String get lblFoodRecognitionHistory {
    final String value =
        getContentValueFromKey("$dietScreen.lblFoodRecognitionHistory");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'سجل حساب السعرات'
          : 'Calorie Scan History';
    }
    return value;
  }

  String get lblSelectImageSource {
    final String value =
        getContentValueFromKey("$dietScreen.lblSelectImageSource");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'اختر مصدر الصورة'
          : 'Select Image Source';
    }
    return value;
  }

  String get lblGallery {
    final String value = getContentValueFromKey("$dietScreen.lblGallery");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar' ? 'الاستوديو' : 'Gallery';
    }
    return value;
  }

  String get lblNoFoodHistory {
    final String value =
        getContentValueFromKey("$dietScreen.lblNoFoodHistory");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'لا يوجد سجل بعد. اضغط على الزر لبدء المسح'
          : 'No history yet. Tap the button to start scanning';
    }
    return value;
  }

  String get lblFoodRecognitionResult {
    final String value =
        getContentValueFromKey("$dietScreen.lblFoodRecognitionResult");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'نتيجة التعرف على الطعام'
          : 'Food Recognition Result';
    }
    return value;
  }

  String get lblFoodNotRecognized {
    final String value =
        getContentValueFromKey("$dietScreen.lblFoodNotRecognized");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'لم يتم التعرف على الطعام'
          : 'Food was not recognized';
    }
    return value;
  }

  String get lblOtherSuggestions {
    final String value =
        getContentValueFromKey("$dietScreen.lblOtherSuggestions");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'اقتراحات أخرى'
          : 'Other Suggestions';
    }
    return value;
  }

  String get lblConfidence {
    final String value = getContentValueFromKey("$dietScreen.lblConfidence");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar' ? 'الثقة' : 'Confidence';
    }
    return value;
  }

  String get lblRemainingRequests {
    final String value =
        getContentValueFromKey("$dietScreen.lblRemainingRequests");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'الطلبات المتبقية'
          : 'Remaining Requests';
    }
    return value;
  }

  String get lblCalorieCalculatorDesc {
    final String value =
        getContentValueFromKey("$dietScreen.lblCalorieCalculatorDesc");
    if (value.contains(defaultKeyNotFoundValue)) {
      return appStore.selectedLanguageCode == 'ar'
          ? 'صوّر طعامك واحسب السعرات الحرارية'
          : 'Snap your food and calculate calories';
    }
    return value;
  }

  // -------------------- UGC hub --------------------
  String _ugc(String ar, String en) =>
      appStore.selectedLanguageCode == 'ar' ? ar : en;

  String get lblUgcHubTitle => _ugc('بلان', 'Plan');
  String get lblUgcHubSubtitle => _ugc(
        'أنشئ خططك وتمارينك وحمياتك الخاصة',
        'Build your custom programs, workouts and diets',
      );
  String get lblUgcProgramInfo => _ugc('معلومات الخطة', 'Plan details');
  String get lblUgcSelectWorkout => _ugc('اختر التمرين', 'Select workout');
  String get lblUgcSelectDiet => _ugc('اختر الحمية', 'Select diet');
  String get lblUgcCardio => _ugc('كارديو', 'Cardio');
  String get lblUgcSpecificDate => _ugc('التاريخ', 'Date');
  String get lblUgcPickDate => _ugc('اختر من التقويم', 'Pick from calendar');
  String get lblUgcActivate => _ugc('تفعيل الخطة', 'Activate plan');
  String get lblUgcActivated => _ugc('مفعّلة', 'Active');
  String get lblUgcActivateSuccess => _ugc(
        'تم تفعيل الخطة وربطها بالجدولة والماء والخطوات',
        'Plan activated and linked to schedule, water and steps',
      );
  String get lblUgcTodayPlan => _ugc('خطة اليوم', 'Today\'s plan');
  String get lblUgcPlanForDay => _ugc('خطة هذا اليوم', 'Plan for this day');
  String get lblUgcNoPlanDay =>
      _ugc('لا يوجد يوم خطة لهذا التاريخ', 'No plan day for this date');
  String get lblUgcDayDetail => _ugc('تفاصيل اليوم', 'Day details');
  String get lblUgcTapDayHint =>
      _ugc('اضغط على يوم في التقويم لعرض التفاصيل', 'Tap a day to view details');
  String get lblPurchasesDisabled =>
      _ugc('الشراء غير متاح حالياً', 'Purchases are currently unavailable');
  String get lblUgcPrograms => _ugc('البرامج', 'Programs');
  String get lblUgcWorkouts => _ugc('التمارين', 'Workouts');
  String get lblUgcDiets => _ugc('الحميات', 'Diets');
  String get lblUgcSetup => _ugc('الإعدادات', 'Setup');
  String get lblUgcNoPrograms =>
      _ugc('لا توجد برامج بعد', 'No programs yet');
  String get lblUgcWeeks => _ugc('أسابيع', 'Weeks');
  String get lblUgcRecurring => _ugc('متكرر أسبوعياً', 'Weekly recurring');
  String get lblUgcCustom => _ugc('مخصص', 'Custom');
  String get lblUgcDays => _ugc('أيام', 'Days');
  String get lblUgcDay => _ugc('يوم', 'Day');
  String get lblUgcCreateProgram => _ugc('إنشاء برنامج', 'Create Program');
  String get lblUgcCreateWorkout => _ugc('إنشاء تمرين', 'Create Workout');
  String get lblUgcCreateDiet => _ugc('إنشاء حمية', 'Create Diet');
  String get lblUgcCreateWorkoutDesc => _ugc(
        'أنشئ تمريناً مخصصاً لاستخدامه داخل برامجك',
        'Create a custom workout to use inside your programs',
      );
  String get lblUgcCreateDietDesc => _ugc(
        'أنشئ حمية مخصصة وربطها بأيام البرنامج',
        'Create a custom diet and link it to program days',
      );
  String get lblUgcObjective => _ugc('الهدف', 'Objective');
  String get lblUgcRecurringHint => _ugc(
        'عند التفعيل تُعاد الأيام أسبوعياً',
        'When enabled, days repeat weekly',
      );
  String get lblUgcAddDay => _ugc('أضف يوماً واحداً على الأقل', 'Add at least one day');
  String get lblUgcWeekNumber => _ugc('رقم الأسبوع', 'Week number');
  String get lblUgcDayOfWeek => _ugc('يوم الأسبوع (1-7)', 'Day of week (1-7)');
  String get lblUgcWorkoutId => _ugc('معرّف التمرين', 'Workout ID');
  String get lblUgcDietId => _ugc('معرّف الحمية', 'Diet ID');
  String get lblUgcWaterMl => _ugc('هدف الماء (مل)', 'Water goal (ml)');
  String get lblUgcSteps => _ugc('هدف الخطوات', 'Steps goal');
  String get lblUgcNeedLevelType =>
      _ugc('اختر المستوى ونوع التمرين', 'Select level and workout type');
  String get lblUgcRestDay => _ugc('يوم راحة', 'Rest day');
  String get lblUgcExerciseId => _ugc('معرّف التمرين', 'Exercise ID');
  String get lblUgcReps => _ugc('تكرارات', 'Reps');
  String get lblUgcWeight => _ugc('الوزن', 'Weight');
  String get lblUgcNeedCategory =>
      _ugc('اختر تصنيف الحمية', 'Select diet category');
  String get lblUgcDietCategory => _ugc('تصنيف الحمية', 'Diet category');
  String get lblUgcIngredients => _ugc('المكونات', 'Ingredients');
  String get lblUgcCreateLevel => _ugc('إنشاء مستوى', 'Create Level');
  String get lblUgcCreateWorkoutType =>
      _ugc('إنشاء نوع تمرين', 'Create Workout Type');
  String get lblUgcCreateCategory =>
      _ugc('إنشاء تصنيف حمية', 'Create Diet Category');
  String get lblUgcTitleRequired =>
      _ugc('العنوان مطلوب', 'Title is required');
  String get lblUgcRate => _ugc('التقييم', 'Rate');
  String get lblEdit => _ugc('تعديل', 'Edit');
  String get lblType => _ugc('النوع', 'Type');
  String get lblCategory => _ugc('التصنيفات', 'Categories');

  // AI Workout Coach
  String get lblAiCoach => _ugc('مدرب الذكاء الاصطناعي', 'AI Coach');
  String get lblAiStart => _ugc('ابدأ مع AI', 'Start with AI');
  String get lblAiFinish => _ugc('إنهاء التمرين', 'Finish workout');
  String get lblAiReset => _ugc('تصفير العدّات', 'Reset reps');
  String get lblAiReps => _ugc('العدّات', 'Reps');
  String get lblAiStage => _ugc('المرحلة', 'Stage');
  String get lblAiScore => _ugc('الدقة', 'Score');
  String get lblAiWorkoutSummary =>
      _ugc('ملخص تمرين AI', 'AI Workout Summary');
  String get lblAiCameraDenied =>
      _ugc('يلزم إذن الكاميرا لمدرب AI', 'Camera permission is required for AI coach');
  String get lblAiStartFailed =>
      _ugc('تعذر بدء جلسة AI', 'Failed to start AI session');
  String get lblAiSelectExercise =>
      _ugc('اختر نوع التمرين', 'Select exercise type');
}
