import '../utils/shared_import.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(languages.lblSelectLanguage, context: context),
    body: AnimatedListView(
      itemCount: localLanguages.length,
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final LanguageJsonData data = localLanguages[index];
        final bool isSelected =
            getStringAsync(
              SELECTED_LANGUAGE_CODE,
              defaultValue: DEFAULT_LANGUAGE,
            ) ==
            data.languageCode.validate();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: isSelected
                ? primaryColor
                : appStore.isDarkMode
                    ? context.scaffoldBackgroundColor
                    : cardLightColor,
            border: Border.all(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.80)
                  : GreyLightColor,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    data.languageCode == 'ar' ? '🇦🇪' : '🇺🇸',
                    style: const TextStyle(fontSize: 28),
                  ),
                  16.width,
                  Text(
                    data.languageName.validate(),
                    style: boldTextStyle(
                      color: isSelected
                          ? Colors.white
                          : appStore.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ).expand(),
                  isSelected
                      ? Image.asset(
                          ic_radio_fill,
                          height: 20,
                          width: 20,
                          color: Colors.white,
                        )
                      : Image.asset(
                          ic_radio,
                          color: primaryColor,
                          height: 20,
                          width: 20,
                        ),
                ],
              ),
              4.height,
            ],
          ).paddingSymmetric(vertical: 4).onTap(() async {
            await setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
            await setValue(
              SELECTED_LANGUAGE_COUNTRY_CODE,
              data.countryCode,
            );
            selectedServerLanguageData = data;
            setValue(IS_SELECTED_LANGUAGE_CHANGE, true);
            setState(() {});
            LiveStream().emit(CHANGE_LANGUAGE);
            if (!context.mounted) return;
            await appStore.setLanguage(
              data.languageCode ?? 'en',
              context: context,
            );
            if (!context.mounted) return;
            finish(context, true);
          }),
        );
      },
    ),
  );
}
