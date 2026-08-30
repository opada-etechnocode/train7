import '../utils/shared_import.dart';

class ThemeSelectionDialog extends StatefulWidget {
  static String tag = '/ThemeSelectionDialog';

  const ThemeSelectionDialog({super.key});

  @override
  ThemeSelectionDialogState createState() => ThemeSelectionDialogState();
}

class ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  List<String> themeModeList = [
    languages.lblLight,
    languages.lblDark,
    languages.lblSystemDefault,
  ];

  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: context.width(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.topLeft,
          decoration: boxDecorationWithShadow(
            backgroundColor: primaryColor,
            borderRadius: radiusOnly(
              topRight: defaultRadius,
              topLeft: defaultRadius,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                languages.lblSelectTheme,
                style: boldTextStyle(size: 20, color: Colors.white),
              ).paddingLeft(12),
              const CloseButton(color: Colors.white),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 8),
          itemCount: themeModeList.length,
          itemBuilder: (BuildContext context, int index) => RadioListTile(
            value: index,
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            groupValue: currentIndex,
            activeColor: primaryColor,
            title: Text(themeModeList[index], style: primaryTextStyle()),
            onChanged: (dynamic val) {
              currentIndex = val;
              setValue(THEME_MODE_INDEX, val);
              if (val == ThemeModeSystem) {
                appStore.setDarkMode(
                  MediaQuery.of(context).platformBrightness == Brightness.dark,
                );
              } else if (val == ThemeModeLight) {
                appStore.setDarkMode(false);
              } else if (val == ThemeModeDark) {
                appStore.setDarkMode(true);
              }
              setState(() {});
              afterBuildCreated(() {
                finish(context);
              });
            },
          ),
        ),
      ],
    ),
  );
}
