import '../utils/shared_import.dart';

class AboutAppScreen extends StatefulWidget {
  static String tag = '/AboutAppScreen';

  const AboutAppScreen({super.key});

  @override
  AboutAppScreenState createState() => AboutAppScreenState();
}

class AboutAppScreenState extends State<AboutAppScreen> {
  List<dynamic> aboutPages = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAppSettings();
  }

  Future<void> loadAppSettings() async {
    try {
      final AppSettingResponse response = await getAppSettingApi();

      // Save only pages list
      aboutPages = response.pages ?? [];

      // Sort alphabetically by title
      aboutPages.sort(
        (a, b) => a.title.toString().compareTo(b.title.toString()),
      );

      setState(() {
        loading = false;
      });
    } on Exception catch (e) {
      log("Error loading settings: $e");
      loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(languages.lblAboutApp, context: context),
    body: SingleChildScrollView(
      child: Column(
        children: [
          mOption(ic_rate_us, languages.lblPrivacyPolicy, () {
            const PrivacyPolicyScreen().launch<void>(
              context,
              pageRouteAnimation: PageRouteAnimation.Fade,
            );
          }, context).visible(getStringAsync(PRIVACY_POLICY).isNotEmpty),
          const Divider(
            height: 0,
          ).visible(getStringAsync(PRIVACY_POLICY).isNotEmpty),
          mOption(ic_terms, languages.lblTermsOfServices, () {
            const TermsAndConditionScreen().launch<void>(
              context,
              pageRouteAnimation: PageRouteAnimation.Fade,
            );
          }, context).visible(getStringAsync(TERMS_SERVICE).isNotEmpty),
          const Divider(
            height: 0,
          ).visible(getStringAsync(TERMS_SERVICE).isNotEmpty),
          mOption(ic_info, languages.lblAboutUs, () {
            const AboutUsScreen().launch<void>(
              context,
              pageRouteAnimation: PageRouteAnimation.Fade,
            );
          }, context),
          const Divider(height: 0),
          ...aboutPages.map(
            (page) => Column(
              children: [
                mOption(ic_info, page.title ?? "", () {
                  InAppWebPage(
                    url: page.url ?? "",
                    title: page.title ?? "",
                  ).launch<void>(context);
                }, context),
                const Divider(height: 0),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
