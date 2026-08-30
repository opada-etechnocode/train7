import '../utils/shared_import.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;

  const SignUpScreen({super.key, this.phoneNumber});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool? isNewTask = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    appStore.signUpIndex = 0;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (appStore.signUpIndex == 0) {
          appStore.setLoading(false);
          finish(context);
        } else {
          isNewTask = false;
          appStore.signUpIndex--;
          setState(() {});
        }
      },
      child: Observer(
        builder: (context) => Scaffold(
          appBar: appBarWidget(
            "",
            backWidget:
                const Icon(
                  Octicons.chevron_left,
                  color: primaryColor,
                  size: 28,
                ).onTap(() {
                  if (appStore.signUpIndex == 0) {
                    finish(context);
                  } else {
                    isNewTask = false;
                    appStore.signUpIndex--;
                    setState(() {});
                  }
                }),
            color: whiteColor,
            elevation: 0,
            textColor: textPrimaryColorGlobal,
            context: context,
          ),
          body: Column(
            children: [
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  7,
                  (index) => Container(
                    alignment: Alignment.center,
                    height: 6,
                    width: context.width() / 8,
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: appStore.signUpIndex >= index
                          ? primaryColor
                          : GreyLightColor,
                    ),
                  ),
                ).toList(),
              ).paddingSymmetric(horizontal: 12),
              16.height,
              if (appStore.signUpIndex == 0)
                SignUpStep1Component(isNewTask: isNewTask).expand(),
              if (appStore.signUpIndex == 1)
                SignUpStep2Component(isNewTask: isNewTask).expand(),
              if (appStore.signUpIndex == 2)
                SignUpStep3Component(isNewTask: isNewTask).expand(),
              if (appStore.signUpIndex == 3)
                const SignUpStep4Component().expand(),

              if (appStore.signUpIndex == 4)
                const SignUpStep5Component().expand(),
              if (appStore.signUpIndex == 5)
                const SignUpStep6Component().expand(),
              if (appStore.signUpIndex == 6)
                const SignUpStep7Component().expand(),
            ],
          ),
        ),
      ),
    );
}
