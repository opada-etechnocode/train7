import '../utils/shared_import.dart';

class SignUpStep2Component extends StatefulWidget {
  final bool? isNewTask;

  const SignUpStep2Component({super.key, this.isNewTask = false});

  @override
  State<SignUpStep2Component> createState() => _SignUpStep2ComponentState();
}

class _SignUpStep2ComponentState extends State<SignUpStep2Component> {
  int mCurrentValue = 0;

  @override
  void didChangeDependencies() {
    if (widget.isNewTask != true) {
      mCurrentValue = userStore.gender == MALE ? 0 : 1;
    }
    super.didChangeDependencies();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget mGender(String? image, String? title, int i, void Function()? onnCall) =>
      Bounce(
        duration: const Duration(milliseconds: 110),
        onPressed: () {
          onnCall!.call();
        },
        child: Column(
          children: [
            16.height,
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  decoration: boxDecorationWithRoundedCorners(
                    border: Border.all(color: context.dividerColor),
                    backgroundColor: mCurrentValue == i
                        ? primaryColor
                        : context.scaffoldBackgroundColor,
                  ),
                  height: context.height() * 0.3,
                  width: context.width() * 0.4,
                ),
                Image.asset(
                  image!,
                  width: context.width() / 3,
                  height: context.height() * 0.4,
                  fit: BoxFit.fill,
                ),
              ],
            ),
            8.height,
            Text(
              title!,
              style: boldTextStyle(
                color: mCurrentValue == i
                    ? textPrimaryColorGlobal
                    : textSecondaryColorGlobal,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(languages.lblWhtGender, style: boldTextStyle(size: 22)),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            mGender(
              mCurrentValue == 0 ? ic_male_selected : ic_male_unselected,
              languages.lblMale,
              0,
              () {
                mCurrentValue = 0;
                setState(() {});
              },
            ),
            16.width,
            mGender(
              mCurrentValue == 0 ? ic_female_unselected : ic_female_selected,
              languages.lblFemale,
              1,
              () {
                mCurrentValue = 1;
                setState(() {});
              },
            ),
          ],
        ),
        52.height,
        AppButton(
          text: languages.lblNext,
          width: context.width(),
          color: primaryColor,
          onTap: () {
            userStore.setGender(mCurrentValue == 0 ? MALE : FEMALE);
            appStore.signUpIndex = 2;
            setState(() {});
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 16),
  );
}
