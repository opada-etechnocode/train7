import '../../utils/shared_import.dart';

const LanguageJsonDataRes = 'LanguageJsonDataRes'; // DO NOT CHANGE
const CURRENT_LAN_VERSION = 'LanguageData'; // DO NOT CHANGE
const LanguageVersion = '0'; // DO NOT CHANGE
//const SELECTED_LANGUAGE_CODE = 'selected_language_code'; // DO NOT CHANGE
const SELECTED_LANGUAGE_COUNTRY_CODE =
    'selected_language_country_code'; // DO NOT CHANGE
const IS_SELECTED_LANGUAGE_CHANGE = 'isSelectedLanguageChange';

Locale defaultLanguageLocale = Locale(defaultLanguageCode, defaultCountryCode);

Locale setDefaultLocate() {
  final String getJsonData = getStringAsync(LanguageJsonDataRes);
  if (getJsonData.isNotEmpty) {
    final ServerLanguageResponse languageSettings =
        ServerLanguageResponse.fromJson(json.decode(getJsonData.trim()));
    if (languageSettings.data!.isNotEmpty) {
      defaultServerLanguageData = languageSettings.data;
      performLanguageOperation(defaultServerLanguageData);
    }
  }
  if (defaultServerLanguageData != null &&
      defaultServerLanguageData!.isNotEmpty) {
    performLanguageOperation(defaultServerLanguageData);
  }

  return defaultLanguageLocale;
}

void performLanguageOperation(List<LanguageJsonData>? defaultServerLanguageData) {
  final String selectedLanguageCode = getStringAsync(SELECTED_LANGUAGE_CODE);
  bool isFoundLocalSelectedLanguage = false;
  bool isFoundSelectedLanguageFromServer = false;

  for (int index = 0; index < defaultServerLanguageData!.length; index++) {
    if (selectedLanguageCode.isNotEmpty) {
      if (defaultServerLanguageData[index].languageCode ==
          selectedLanguageCode) {
        isFoundLocalSelectedLanguage = true;
        defaultLanguageLocale = Locale(
          defaultServerLanguageData[index].languageCode!,
          defaultServerLanguageData[index].countryCode!,
        );
        selectedServerLanguageData = defaultServerLanguageData[index];
        break;
      }
    }
    if (defaultServerLanguageData[index].isDefaultLanguage == 1) {
      isFoundSelectedLanguageFromServer = true;
      defaultLanguageLocale = Locale(
        defaultServerLanguageData[index].languageCode!,
        defaultServerLanguageData[index].countryCode!,
      );
      selectedServerLanguageData = defaultServerLanguageData[index];
    }
  }

  if (!isFoundLocalSelectedLanguage && !isFoundSelectedLanguageFromServer) {
    selectedServerLanguageData = null;
  }
}

List<Locale> getSupportedLocales() {
  log("get supported called");
  final List<Locale> list = [];
  if (defaultServerLanguageData != null &&
      defaultServerLanguageData!.isNotEmpty) {
    for (int index = 0; index < defaultServerLanguageData!.length; index++) {
      list.add(
        Locale(
          defaultServerLanguageData![index].languageCode!,
          defaultServerLanguageData![index].countryCode!,
        ),
      );
    }
  } else {
    list.add(defaultLanguageLocale);
  }
  return list;
}

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

  // 1. Try finding in selected server language data (Cached data)
  if (selectedServerLanguageData != null) {
    for (
      int index = 0;
      index < selectedServerLanguageData!.contentData!.length;
      index++
    ) {
      final ContentData content =
          selectedServerLanguageData!.contentData![index];
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

    // 2. Fallback: If not found by name in cached data, try to find the keywordId from local assets and then search again in cached data.
    // This handles old cached data that lacks 'keywordName' but has 'keywordId'.
    int? fallbackId;
    for (var content in defaultLanguageDataKeys) {
      if (searchScreenName != null) {
        if (content.screenName == searchScreenName &&
            content.keywordName == searchKeywordName) {
          fallbackId = content.keywordId;
          break;
        }
      } else if (content.keywordName == searchKeywordName) {
        fallbackId = content.keywordId;
        break;
      }
    }

    if (fallbackId != null) {
      for (var content in selectedServerLanguageData!.contentData!) {
        if (content.keywordId == fallbackId) {
          return content.keywordValue.validate();
        }
      }
    }
  }

  // 3. Finally try finding in local assets (defaultLanguageDataKeys)
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

Future<void> initJsonFile() async {
  log("init josn");
  final String jsonString = await rootBundle.loadString(
    'assets/fitness_language.json',
  );
  final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
  log("list==========================$list");
  final List<LocalLanguageResponse> finalList =
      list.map((e) => LocalLanguageResponse.fromJson(e)).toList();
  defaultLanguageDataKeys.clear();
  log("final list length finallist${finalList.length}");

  for (int index = 0; index < finalList.length; index++) {
    final String? currentScreenName = finalList[index].screenName;
    for (int i = 0; i < finalList[index].keywordData!.length; i++) {
      defaultLanguageDataKeys.add(
        ContentData(
          keywordId: finalList[index].keywordData![i].keywordId,
          screenName: currentScreenName,
          keywordName: finalList[index].keywordData![i].keywordName,
          keywordValue: finalList[index].keywordData![i].keywordValue,
        ),
      );
    }
  }
}

// DO NOT CHANGE

String getCountryCode() {
  String defaultCode = countryCode!;
  final String selectedLang = getStringAsync(
    SELECTED_LANGUAGE_CODE,
    defaultValue: defaultLanguageCode,
  );
  if (defaultServerLanguageData != null &&
      defaultServerLanguageData!.isNotEmpty) {
    for (int index = 0; index < defaultServerLanguageData!.length; index++) {
      if (selectedLang == defaultServerLanguageData![index].languageCode) {
        final List<String> selectedCoutry = defaultServerLanguageData![index]
            .countryCode!
            .split("-");
        if (selectedCoutry.isNotEmpty) {
          defaultCode = selectedCoutry[1];
        }
      }
    }
  }

  return defaultCode;
}
