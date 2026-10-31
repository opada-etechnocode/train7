import 'shared_import.dart';

const APP_NAME = "Train7";
//endregion
var initialSteps = 0;

//region baseurl
final mBackendURL = AppServerConfig.baseUrl; //live url

//endregion
//region Default Language Code
const DEFAULT_LANGUAGE = 'ar';
//endregion

//region Change Walk Through Text
String walk1Title = languages.lblWalkTitle1;
String walk2Title = languages.lblWalkTitle2;
String walk3Title = languages.lblWalkTitle3;
//endregion

//region onesignal
const mOneSignalID = 'f0fb5c67-798d-4332-a97c-307982146d18';
//endregion

//region country

String? countryCode = "IN";
String? countryDail = "91";
//endregion

//region logins
const ENABLE_SOCIAL_LOGIN = true;
const ENABLE_GOOGLE_SIGN_IN = true;
const ENABLE_OTP = true;
const ENABLE_APPLE_SIGN_IN = true;
//endregion

//region perPage value
const EQUIPMENT_PER_PAGE = 10;
const LEVEL_PER_PAGE = 10;
const WORKOUT_TYPE_PAGE = 10;
//endregion

//region payment description and identifier
const mRazorDescription = '<YOUR_APP_NAME>';
const mStripeIdentifier = 'IN';
//endregion

//region urls
final mBaseUrl = '$mBackendURL/api/';
//endregion

//region Manage Ads
// const showAdOnDietDetail = false;
// const showAdOnBlogDetail = false;
// const showAdOnExerciseDetail = false;
// const showAdOnProductDetail = false;
// const showAdOnWorkoutDetail = false;
// const showAdOnProgressDetail = false;

// const showBannerAdOnDiet = false;
// const showBannerOnProduct = false;
// const showBannerOnBodyPart = false;
// const showBannerOnEquipment = false;
// const showBannerOnLevel = false;
// const showBannerOnWorkouts = false;
//endregion

List<String> firstTitles = [
  languages.lblBuildMuscle,
  languages.lblKeepFit,
  languages.lblLoseWeight,
];
List<String> firstDescriptions = [
  languages.lblFirstDescriptions1,
  languages.lblFirstDescriptions2,
  languages.lblFirstDescriptions3,
];
final List<String> firstIcons = [ic_build, ic_keep, ic_lose];

List<String> secondTitles = [
  languages.lblTotallyNewbie,
  languages.lblBeginner,
  languages.lblIntermediate,
  languages.lblAdvanced,
];
List<String> secondDescriptions = [
  languages.lblSecDesc1,
  languages.lblSecDesc2,
  languages.lblSecDesc3,
  languages.lblSecDesc4,
];
final List<String> secondIcons = [
  empty_graph,
  one_graph,
  two_graph,
  full_graph,
];

List<String> thirdTitles = [
  languages.lblNoEquipment,
  languages.lblDumbbells,
  languages.lblGarageGym,
  languages.lblFullGym,
  languages.lblCustom,
];
List<String> thirdDescriptions = [
  languages.lblThirdDescriptions1,
  languages.lblThirdDescriptions2,
  languages.lblThirdDescriptions3,
  languages.lblThirdDescriptions4,
  languages.lblThirdDescriptions5,
];
final List<String> thirdIcons = [
  ic_noequpment,
  ic_dumbbell,
  garage_gym,
  full_gym,
  custom,
];
