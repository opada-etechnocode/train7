import '../utils/shared_import.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController mFNameCont = TextEditingController();
  TextEditingController mLNameCont = TextEditingController();
  TextEditingController mEmailCont = TextEditingController();
  TextEditingController mAgeCont = TextEditingController();
  TextEditingController mMobileNumberCont = TextEditingController();
  TextEditingController mWeightCont = TextEditingController();
  TextEditingController mHeightCont = TextEditingController();

  FocusNode mEmailFocus = FocusNode();
  FocusNode mFNameFocus = FocusNode();
  FocusNode mLNameFocus = FocusNode();
  FocusNode mMobileNumberFocus = FocusNode();
  FocusNode mAgeFocus = FocusNode();
  FocusNode mWeightFocus = FocusNode();
  FocusNode mHeightFocus = FocusNode();

  List<String> item = [languages.lblFemale, languages.lblMale];
  List<GenderModel> genderList = [];

  String mGender = languages.lblFemale;
  String? profileImg = '';
  String? countryCode = '';

  int? mHeight;
  int? mWeight;

  XFile? image;

  double inputValue = 0.0;
  int selectGender = 0;

  bool isKGClicked = false;
  bool isLBSClicked = false;
  bool isFeetClicked = false;
  bool isCMClicked = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getGender();
    //
    mFNameCont.text = userStore.fName;
    mLNameCont.text = userStore.lName;
    mEmailCont.text = userStore.email;
    mAgeCont.text = userStore.age;
    mMobileNumberCont.text = userStore.phoneNo;
    mWeightCont.text = '${userStore.weight} ${userStore.weightUnit}';
    profileImg = userStore.profileImage;
    if (!userStore.height.isEmptyOrNull) {
      mHeightCont.text = '${userStore.height} ${userStore.heightUnit}';
    }
    //userStore.heightUnit == FEET ? mHeight = 0 : mHeight = 1;
    //userStore.weightUnit == LBS ? mWeight = 0 : mWeight = 1;
    mGender = userStore.gender.isEmptyOrNull
        ? "female"
        : userStore.gender.capitalizeFirstLetter();
    userStore.displayName = userStore.fName + userStore.lName;
  }

  void getGender() {
    genderList.add(GenderModel(0, languages.lblMale, MALE));
    genderList.add(GenderModel(1, languages.lblFemale, FEMALE));
    for (var element in genderList) {
      log('userStore.gender${userStore.gender}');
      if (element.key == userStore.gender) {
        selectGender = element.id.validate();
      }
    }
  }

  Future<void> save() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    log("type ==> ${userStore.weightUnit}");

    final MultipartRequest multiPartRequest = await getMultiPartRequest(
      'update-profile',
    );
    multiPartRequest.fields['id'] = userStore.userId.toString();
    multiPartRequest.fields['first_name'] = mFNameCont.text;
    multiPartRequest.fields['last_name'] = mLNameCont.text;
    multiPartRequest.fields['email'] = mEmailCont.text;
    multiPartRequest.fields['username'] = mEmailCont.text;
    multiPartRequest.fields['phone_number'] = mMobileNumberCont.text;
    multiPartRequest.fields['gender'] = mGender.toLowerCase();
    multiPartRequest.fields['user_profile[age]'] = mAgeCont.text;
    multiPartRequest.fields['user_profile[weight]'] = mWeightCont.text
        .validate()
        .split(' ')[0];
    multiPartRequest.fields['user_profile[height]'] = mHeightCont.text
        .validate()
        .split(' ')[0];
    multiPartRequest.fields['user_profile[height_unit]'] = userStore.heightUnit;
    multiPartRequest.fields['user_profile[weight_unit]'] = userStore.weightUnit;

    if (image != null) {
      multiPartRequest.files.add(
        await MultipartFile.fromPath('profile_image', image!.path.toString()),
      );
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        if ((data as String).isJson()) {
          final UserResponse res = UserResponse.fromJson(jsonDecode(data));
          log(res.toJson().toString());
          setValue(COUNTRY_CODE, countryCode);
          userStore.weight.isEmpty;
          userStore.weightUnit.isEmpty;
          userStore.height.isEmpty;
          userStore.heightUnit.isEmpty;
          await userStore.setUserEmail(res.data!.email.validate());
          await userStore.setFirstName(res.data!.firstName.validate());
          await userStore.setLastName(res.data!.lastName.validate());
          await userStore.setUsername(res.data!.username.validate());
          await userStore.setGender(res.data!.gender.validate());
          await userStore.setUserImage(res.data!.profileImage.validate());
          await userStore.setDisplayName(res.data!.displayName.validate());
          await userStore.setPhoneNo(res.data!.phoneNumber.validate());

          if (res.data?.userProfile != null) {
            await userStore.setAge(res.data?.userProfile?.age ?? '');
            await userStore.setHeight(res.data?.userProfile?.height ?? '');
            await userStore.setHeightUnit(
              res.data?.userProfile?.heightUnit ?? '',
            );
            await userStore.setWeight(res.data?.userProfile?.weight ?? '');
            await userStore.setWeightUnit(
              res.data?.userProfile?.weightUnit ?? '',
            );
          } else {
            await userStore.setAge(mAgeCont.text.validate());
            await userStore.setHeight(mHeightCont.text.validate());
            await userStore.setHeightUnit(mHeight == 0 ? FEET : METRICS_CM);
            await userStore.setWeight(weight.toString());
            await userStore.setWeightUnit(weightType.name);
          }

          if (!mounted) return;
          await getUSerDetail(context, userStore.userId).whenComplete(() {
            if (!mounted) return;
            appStore.setLoading(false);
            LiveStream().emit(PROGRESS);
            finish(context, true);
            setState(() {});
          });
        }
      },
      onError: (error) {
        log(multiPartRequest.toString());
        toast(error.toString());
        appStore.setLoading(false);
      },
    ).catchError((dynamic e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget mHeightOption(String? value, int? index) =>
      Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(6),
          backgroundColor: mHeight == index
              ? primaryColor
              : appStore.isDarkMode
              ? context.cardColor
              : GreyLightColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          value.toString(),
          style: secondaryTextStyle(
            color: mHeight == index ? Colors.white : textColor,
          ),
        ),
      ).onTap(() {
        mHeight = index;
        hideKeyboard(context);
        if (index == 1) {
          if (!isFeetClicked) {
            convertFeetToCm();
            isFeetClicked = true;
            isCMClicked = false;
          }
        } else {
          if (!isCMClicked) {
            convertCMToFeet();
            isCMClicked = true;
            isFeetClicked = false;
          }
        }
        setState(() {});
      });

  WeightType weightType = userStore.weightUnit == 'kg'
      ? WeightType.lb
      : WeightType.kg;

  double weight = 0;

  //Convert Feet to Cm
  void convertFeetToCm() {
    final double a =
        double.parse(
          mHeightCont.text.isEmptyOrNull ? "0.0" : mHeightCont.text.validate(),
        ) *
        30.48;
    if (!mHeightCont.text.isEmptyOrNull) {
      mHeightCont.text = a.toStringAsFixed(2).toString();
    }
    mHeightCont.selection = TextSelection.fromPosition(
      TextPosition(offset: mHeightCont.text.length),
    );
    log(a.toStringAsFixed(2).toString());
  }

  //Convert CM to Feet
  void convertCMToFeet() {
    final double a =
        double.parse(
          mHeightCont.text.isEmptyOrNull ? "0.0" : mHeightCont.text.validate(),
        ) *
        0.0328;
    if (!mHeightCont.text.isEmptyOrNull) {
      mHeightCont.text = a.toStringAsFixed(2).toString();
    }
    mHeightCont.selection = TextSelection.fromPosition(
      TextPosition(offset: mHeightCont.text.length),
    );
    log(a.toStringAsFixed(2).toString());
  }

  Widget mWeightOption(String? value, int? index) =>
      Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(6),
          backgroundColor: mWeight == index
              ? primaryColor
              : appStore.isDarkMode
              ? Colors.black
              : const Color(0xffD9D9D9),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          value!,
          style: secondaryTextStyle(
            color: mWeight == index ? Colors.white : textColor,
          ),
        ),
      ).onTap(() {
        mWeight = index;
        hideKeyboard(context);
        if (index == 0) {
          if (!isLBSClicked) {
            convertKgToLbs();
            isLBSClicked = true;
            isKGClicked = false;
          }
        } else {
          if (!isKGClicked) {
            convertLbsToKg();
            isKGClicked = true;
            isLBSClicked = false;
          }
        }
        setState(() {});
      });

  //Convert lbs to kg
  void convertLbsToKg() {
    final double a =
        double.parse(
          mWeightCont.text.isEmptyOrNull ? "0.0" : mWeightCont.text.validate(),
        ) *
        0.45359237;
    if (!mWeightCont.text.isEmptyOrNull) {
      mWeightCont.text = a.toStringAsFixed(2).toString();
    }
    mWeightCont.selection = TextSelection.fromPosition(
      TextPosition(offset: mWeightCont.text.length),
    );
  }

  void convertKgToLbs() {
    final double a =
        double.parse(
          mWeightCont.text.isEmptyOrNull ? "0.0" : mWeightCont.text.validate(),
        ) *
        2.2046;
    if (!mWeightCont.text.isEmptyOrNull) {
      mWeightCont.text = a.toStringAsFixed(2).toString();
    }
    mWeightCont.selection = TextSelection.fromPosition(
      TextPosition(offset: mWeightCont.text.length),
    );
  }

  Future<void> getImage() async {
    image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (mounted) {
      setState(() {});
    }
  }

  Widget profileImage() {
    if (image != null) {
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(
          boxShape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: primaryColor.withValues(alpha: 0.5),
          ),
        ),
        child: Image.file(
          File(image!.path),
          height: 90,
          width: 90,
          fit: BoxFit.cover,
        ).cornerRadiusWithClipRRect(65),
      );
    } else if (!profileImg.isEmptyOrNull) {
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(
          boxShape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: primaryColor.withValues(alpha: 0.5),
          ),
        ),
        child: cachedImage(
          profileImg,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        ).cornerRadiusWithClipRRect(65),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(
          boxShape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: primaryColor.withValues(alpha: 0.5),
          ),
        ),
        child: const CircleAvatar(
          maxRadius: 60,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(ic_logo),
        ),
      );
    }
  }

  int mSelectedIndex = 0;

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.light,
      systemNavigationBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.light,
    ),
    child: Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Container(height: context.height() * 0.4, color: primaryColor),
                EditProfileHeader(onBack: () => Navigator.pop(context)),
                Container(
                  margin: EdgeInsets.only(top: context.height() * 0.2),
                  height: context.height() * 0.4,
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radiusOnly(topRight: 16, topLeft: 16),
                    backgroundColor: appStore.isDarkMode
                        ? context.scaffoldBackgroundColor
                        : Colors.white,
                  ),
                ),
                Column(
                  children: [
                    16.height,
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        profileImage(),
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            backgroundColor: primaryOpacity,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            ic_camera,
                            color: primaryColor,
                            height: 20,
                            width: 20,
                          ),
                        ).onTap(
                          getImage,
                        ) /*.visible(!getBoolAsync(IS_SOCIAL))*/,
                      ],
                    ).paddingOnly(top: context.height() * 0.11).center(),
                    EditProfileFormFields(
                      fNameCont: mFNameCont,
                      lNameCont: mLNameCont,
                      emailCont: mEmailCont,
                      phoneNumberCont: mMobileNumberCont,
                      ageCont: mAgeCont,
                      weightCont: mWeightCont,
                      heightCont: mHeightCont,
                      fNameFocus: mFNameFocus,
                      lNameFocus: mLNameFocus,
                      emailFocus: mEmailFocus,
                      phoneNumberFocus: mMobileNumberFocus,
                      ageFocus: mAgeFocus,
                      weightFocus: mWeightFocus,
                      heightFocus: mHeightFocus,
                      formKey: _formKey,
                      genderList: genderList,
                      selectGender: selectGender,
                      onAgeTap: () => _openAgePickerBottomSheet(context),
                      onWeightTap: () => _openWightPickerBottomSheet(context),
                      onHeightTap: () {
                        CustomHeightPicker(
                          heightSelected: (val) {
                            mHeightCont.text =
                                "$val ${userStore.heightUnit.validate()}";
                          },
                        ).launch<void>(context);
                      },
                      onGenderChanged: (GenderModel? value) {
                        setState(() {
                          mGender = value!.key.toString();
                        });
                      },
                      onSave: () {
                        if (_formKey.currentState!.validate()) {
                          save();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Observer(
            builder: (context) =>
                const Loader().center().visible(appStore.isLoading),
          ),
        ],
      ),
    ),
  );

  Future<void> _openWightPickerBottomSheet(BuildContext context) async {
    final res = await showModalBottomSheet<Tuple2<WeightType, double>>(
      context: context,
      isDismissible: false,
      elevation: 0,
      enableDrag: false,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => WeightPickerBottomSheet(
        initialWeightType: weightType,
        initialWeight: weight,
      ),
    );
    if (res != null) {
      setState(() {
        mWeightCont.text =
            "${res.item2.toString()}  ${res.item1.name.toString().toLowerCase()}";
        userStore.setWeightUnit(res.item1.name.toString().toLowerCase());
        weightType = res.item1;
        weight = res.item2;
      });
    }
  }

  Future<void> _openAgePickerBottomSheet(BuildContext context) async {
    final int? selectedAge = await showModalBottomSheet<int>(
      context: context,
      isDismissible: false,
      elevation: 0,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => AgePickerBottomSheet(
        initialAge: userStore.age.validate().toInt(),
      ),
    );

    if (selectedAge != null) {
      setState(() {
        mAgeCont.text = selectedAge.toString();
      });
    }
  }
}
