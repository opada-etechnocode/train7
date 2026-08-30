import '../utils/shared_import.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({super.key});

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController mPageController = PageController();

  List<WalkThroughModel> mWalkList = [];
  int mCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
    mWalkList.add(WalkThroughModel(image: ic_walk1, title: walk1Title));
    mWalkList.add(WalkThroughModel(image: ic_walk2, title: walk2Title));
    mWalkList.add(WalkThroughModel(image: ic_walk3, title: walk3Title));
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    mPageController.dispose();
    super.dispose();
  }

  /// Splits the raw title text manually (no model changes) into:
  /// - a bold headline (first line), with its LAST word highlighted in white
  ///   while the rest stays bold gold (primaryLightColor)
  /// - a lighter, non-bold subtitle (second line, if present)
  ///
  /// Expected format for the title string (use "\n" to separate the two lines):
  ///   "Train Smarter With AI\nPersonalized workouts powered by intelligence"
  Widget buildWalkTitle(String rawTitle) {
    final List<String> lines = rawTitle.split('\n');
    final String headline = lines.isNotEmpty ? lines.first.trim() : '';
    final String subtitle = lines.length > 1
        ? lines.sublist(1).join(' ').trim()
        : '';

    final List<String> headlineWords = headline
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    return Column(
      children: [
        if (headline.isNotEmpty)
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: List.generate(headlineWords.length, (index) {
                final bool isLastWord = index == headlineWords.length - 1;
                final String word = headlineWords[index];
                final String spacer = index == headlineWords.length - 1
                    ? ''
                    : ' ';

                return TextSpan(
                  text: '$word$spacer',
                  style: boldTextStyle(
                    size: 22,
                    color: isLastWord ? Colors.white : primaryLightColor,
                  ),
                );
              }),
            ),
          ),
        if (subtitle.isNotEmpty) ...[
          SizedBox(height: mq.height * 0.008),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            // Not bold, and not fully white — a softer/lighter tone.
            style: secondaryTextStyle(
              size: 20,
              color: primaryLightColor,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : Brightness.dark,
    ),
    child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView(
            controller: mPageController,
            children: mWalkList
                .map(
                  (e) => Image.asset(
                mWalkList[mCurrentIndex].image!,
                height: context.height(),
                width: context.width(),
                fit: BoxFit.fill,
              ),
            )
                .toList(),
            onPageChanged: (i) {
              mCurrentIndex = i;
              setState(() {});
            },
          ),
          Positioned(
            top: context.statusBarHeight,
            right: mq.width * 0.010,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                setValue(IS_FIRST_TIME, true);
                if (userStore.loginRequired) {
                  const SignInScreen(showBack: false).launch<void>(context);
                } else {
                  const DashboardScreen().launch<void>(context);
                }
              },
              child: Text(
                languages.lblSkip,
                style: boldTextStyle(size: 18, color: primaryLightColor),
              ),
            ),
          ).visible(mCurrentIndex != 2),
          Positioned(
            right: 24,
            left: 24,
            bottom: 50,
            child: Column(
              children: [
                buildWalkTitle(mWalkList[mCurrentIndex].title.toString()),
                SizedBox(height: mq.height * 0.020),
                // 16.height,
                dotIndicator(mWalkList, mCurrentIndex),
                //30.height,
                SizedBox(height: mq.height * 0.038),

                AppButton(
                  useGradient: true,
                  textColor: Colors.black,
                  text: mCurrentIndex == 2
                      ? languages.lblGetStarted
                      : languages.lblNext,
                  width: context.width(),
                  // color: primaryColor,
                  onTap: () {
                    if (mCurrentIndex.toInt() >= 2) {
                      setValue(IS_FIRST_TIME, true);
                      if (userStore.loginRequired) {
                        const SignInScreen(
                          showBack: false,
                        ).launch<void>(context);
                      } else {
                        const DashboardScreen().launch<void>(context);
                      }
                    } else {
                      mPageController.nextPage(
                        duration: const Duration(seconds: 1),
                        curve: Curves.linearToEaseOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}