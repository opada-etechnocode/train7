import '../../utils/shared_import.dart';

const LanguageJsonDataRes = 'LanguageJsonDataRes'; // DO NOT CHANGE
const CURRENT_LAN_VERSION = 'LanguageData'; // DO NOT CHANGE
const LanguageVersion = '0'; // DO NOT CHANGE
const SELECTED_LANGUAGE_COUNTRY_CODE =
    'selected_language_country_code'; // DO NOT CHANGE
const IS_SELECTED_LANGUAGE_CHANGE = 'isSelectedLanguageChange';

Locale defaultLanguageLocale = Locale(defaultLanguageCode, defaultCountryCode);

/// Local languages only (no backend).
final List<LanguageJsonData> localLanguages = [
  LanguageJsonData(
    id: 1,
    languageName: 'English',
    languageCode: 'en',
    countryCode: 'US',
    languageImage: '',
    isRtl: 0,
    isDefaultLanguage: 1,
    contentData: [],
  ),
  LanguageJsonData(
    id: 2,
    languageName: 'العربية',
    languageCode: 'ar',
    countryCode: 'AE',
    languageImage: '',
    isRtl: 1,
    isDefaultLanguage: 0,
    contentData: [],
  ),
];

Locale setDefaultLocate() {
  defaultServerLanguageData = localLanguages;
  performLanguageOperation(defaultServerLanguageData);
  return defaultLanguageLocale;
}

void performLanguageOperation(List<LanguageJsonData>? languageList) {
  final String selectedLanguageCode = getStringAsync(
    SELECTED_LANGUAGE_CODE,
    defaultValue: defaultLanguageCode,
  );
  bool isFoundLocalSelectedLanguage = false;
  bool isFoundSelectedLanguageFromServer = false;

  final List<LanguageJsonData> list =
      (languageList != null && languageList.isNotEmpty)
          ? languageList
          : localLanguages;

  for (int index = 0; index < list.length; index++) {
    if (selectedLanguageCode.isNotEmpty) {
      if (list[index].languageCode == selectedLanguageCode) {
        isFoundLocalSelectedLanguage = true;
        defaultLanguageLocale = Locale(
          list[index].languageCode!,
          list[index].countryCode!,
        );
        selectedServerLanguageData = list[index];
        break;
      }
    }
    if (list[index].isDefaultLanguage == 1) {
      isFoundSelectedLanguageFromServer = true;
      defaultLanguageLocale = Locale(
        list[index].languageCode!,
        list[index].countryCode!,
      );
      selectedServerLanguageData = list[index];
    }
  }

  if (!isFoundLocalSelectedLanguage && !isFoundSelectedLanguageFromServer) {
    selectedServerLanguageData = localLanguages.first;
    defaultLanguageLocale = Locale(
      localLanguages.first.languageCode!,
      localLanguages.first.countryCode!,
    );
  }
}

List<Locale> getSupportedLocales() => [
      const Locale('en', 'US'),
      const Locale('ar', 'AE'),
    ];

/// Resolve UI text from local language files only.
String getContentValueFromKey(Object key) {
  final String defaultKeyValue = defaultKeyNotFoundValue;

  String? searchScreenName;
  String searchKeywordName;

  if (key is String && key.contains('.')) {
    final List<String> parts = key.split('.');
    searchScreenName = parts[0];
    searchKeywordName = parts[1];
  } else {
    searchKeywordName = key.toString();
  }

  for (int index = 0; index < defaultLanguageDataKeys.length; index++) {
    final ContentData content = defaultLanguageDataKeys[index];
    bool match = false;
    if (searchScreenName != null) {
      match =
          content.screenName == searchScreenName &&
          content.keywordName == searchKeywordName;
    } else {
      match =
          content.keywordName == searchKeywordName ||
          content.keywordId.toString() == searchKeywordName;
    }

    if (match) {
      return content.keywordValue.validate();
    }
  }

  return "$defaultKeyValue($key)";
}

Future<String> _loadLanguageAsset(String code) async {
  final List<String> candidates = code == 'ar'
      ? <String>[
          'assets/lang/ar.json',
          'assets/lang/en.json',
          'assets/fitness_language.json',
        ]
      : <String>[
          'assets/lang/en.json',
          'assets/fitness_language.json',
        ];

  Object? lastError;
  for (final String path in candidates) {
    try {
      final String data = await rootBundle.loadString(path);
      log('initJsonFile loaded → $path');
      return data;
    } catch (e) {
      lastError = e;
      log('initJsonFile missing → $path');
    }
  }
  throw Exception('No language asset found: $lastError');
}

Future<void> initJsonFile({String? languageCode}) async {
  final String code = (languageCode ??
          getStringAsync(
            SELECTED_LANGUAGE_CODE,
            defaultValue: defaultLanguageCode,
          ))
      .toLowerCase();

  final String jsonString = await _loadLanguageAsset(code);
  final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
  final List<LocalLanguageResponse> finalList =
      list.map((e) => LocalLanguageResponse.fromJson(e)).toList();

  defaultLanguageDataKeys
    ..clear()
    ..addAll(
      finalList.expand((LocalLanguageResponse screen) {
        final String? screenName = screen.screenName;
        final List<ContentData> keywords = screen.keywordData ?? <ContentData>[];
        return keywords.map(
          (ContentData item) => ContentData(
            keywordId: item.keywordId,
            screenName: screenName,
            keywordName: item.keywordName,
            keywordValue: item.keywordValue,
          ),
        );
      }),
    );

  defaultServerLanguageData = localLanguages;
  performLanguageOperation(defaultServerLanguageData);
  log('Local language keys loaded: ${defaultLanguageDataKeys.length}');
}

String getCountryCode() {
  final String selectedLang = getStringAsync(
    SELECTED_LANGUAGE_CODE,
    defaultValue: defaultLanguageCode,
  );
  if (selectedLang == 'ar') return 'AE';
  return 'US';
}
