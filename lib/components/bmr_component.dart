import '../utils/shared_import.dart';

class BMRComponent extends StatefulWidget {
  static String tag = '/BMRComponent';

  const BMRComponent({super.key});

  @override
  BMRComponentState createState() => BMRComponentState();
}

class BMRComponentState extends State<BMRComponent> {
  double? mBMR;
  double? mKg;
  double? mCm;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
    convertLbsToKg();
    convertFeetToCm();

    if (userStore.gender == "male") {
      mBMR = (10 * mKg!) + (6.25 * mCm!) - (5 * userStore.age.toDouble()) + 5;
    } else {
      mBMR = (10 * mKg!) + (6.25 * mCm!) - (5 * userStore.age.toDouble()) - 161;
    }
  }

  //Convert lbs to kg
  void convertLbsToKg() {
    log("user weight->${userStore.weight}");
    final double a = double.parse(userStore.weight.toString()) * 2.2046;
    mKg = userStore.weightUnit == LBS
        ? a
        : double.parse(userStore.weight.validate());
  }

  // convert Feet to cm
  void convertFeetToCm() {
    mCm = userStore.heightUnit == FEET
        ? double.parse(userStore.height.validate()) * 30.48
        : double.parse(userStore.height.validate());
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    decoration: appStore.isDarkMode
        ? boxDecorationWithRoundedCorners(
            borderRadius: radius(16),
            backgroundColor: context.cardColor,
          )
        : boxDecorationRoundedWithShadow(
            16,
            backgroundColor: context.cardColor,
          ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(8),
                backgroundColor: appStore.isDarkMode
                    ? Colors.black
                    : Colors.white,
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                ic_bmr,
                width: 22,
                height: 22,
                color: primaryColor,
              ),
            ),
            Text(
              languages.lblBmr,
              style: boldTextStyle(
                color: appStore.isDarkMode ? primaryColor : black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
        12.height,
        Image.asset(ic_bmr1, width: 50, height: 50, color: primaryColor),
        Text(
          mBMR.toString().isEmptyOrNull
              ? "0"
              : mBMR!.toStringAsFixed(2).validate(),
          style: boldTextStyle(size: 19),
        ).center(),
        Text(languages.lblCalories, style: secondaryTextStyle()),
        8.height,
      ],
    ),
  );
}
