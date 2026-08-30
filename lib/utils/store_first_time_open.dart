import 'shared_import.dart';

Future<void> setFirstTimeOpen(bool? isFirstTime) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('firstTimeOpen${userStore.userId}', isFirstTime ?? false);
}

Future<bool?> getFirstTimeOpen() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('firstTimeOpen${userStore.userId}');
}
