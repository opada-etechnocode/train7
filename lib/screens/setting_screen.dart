import '../utils/shared_import.dart';

class SettingScreen extends StatefulWidget {
  static String tag = '/SettingScreen';

  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    LiveStream().on(CHANGE_LANGUAGE, (p0) {
      setState(() {});
    });
  }

  Future<void> deleteAccount(BuildContext context) async {
    appStore.setLoading(true);
    await deleteUserAccountApi()
        .then((value) async {
          await deleteUserFirebase()
              .then((value) async {
                if (!context.mounted) return;
                await logout(context).then((value) async {
                  appStore.setLoading(false);
                  await removeKey(EMAIL);
                  await removeKey(PASSWORD);
                  await removeKey(IS_REMEMBER);
                  isFirstTimeGraph = false;
                  AwesomeNotifications().dispose();
                  if (!context.mounted) return;
                  finish(context);
                  const DashboardScreen().launch<void>(context, isNewTask: true);
                });
              })
              .catchError((Object error) {
                appStore.setLoading(false);
                toast(error.toString());
              });
        })
        .catchError((Object error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) => Scaffold(
      appBar: appBarWidget(languages.lblSettings, context: context),
      body: Column(
        children: [
          mOption(
            ic_setting,
            languages.lblMetricsSettings,
            () async {
              const ProgressSettingScreen().launch<void>(context);
            },
            context,
            requireLogin: true,
          ),
          const Divider(height: 0).visible(userStore.isLoggedIn),
          mOption(
            ic_calories,
            languages.lblGoalCaloriesMacros,
            () async {
              const GoalCaloriesMacrosScreen().launch<void>(context);
            },
            context,
            requireLogin: true,
          ),
          const Divider(height: 0).visible(userStore.isLoggedIn),
          mOption(ic_language, languages.lblSelectLanguage, () async {
            final bool? res = await const LanguageScreen().launch(
              context,
              pageRouteAnimation: PageRouteAnimation.Fade,
            );
            if (res == true) {
              setState(() {});
            }
          }, context),
          const Divider(height: 0),
          mOption(ic_theme, languages.lblAppThemes, () async {
            await showInDialog<void>(
              context,
              shape: RoundedRectangleBorder(borderRadius: radius()),
              builder: (_) => const ThemeSelectionDialog(),
              contentPadding: EdgeInsets.zero,
            );
          }, context),
          const Divider(height: 0),
          mOption(ic_change_password, languages.lblChangePassword, () {
            const ChangePwdScreen().launch<void>(
              context,
              pageRouteAnimation: PageRouteAnimation.Fade,
            );
          }, context).visible(!getBoolAsync(IS_SOCIAL) && userStore.isLoggedIn),
          const Divider(
            height: 0,
          ).visible(!getBoolAsync(IS_SOCIAL) && userStore.isLoggedIn),
          mOption(
            ic_delete,
            languages.lblDeleteAccount,
            () async {
              await showConfirmDialogCustom(
                context,
                title: languages.lblDeleteMsg,
                dialogType: DialogType.DELETE,
                positiveText: languages.lblDelete,
                negativeText: languages.lblCancel,
                image: ic_delete,
                iconColor: primaryColor,
                onAccept: (c) async {
                  await deleteAccount(context);
                },
              );
            },
            context,
            requireLogin: true,
          ),
        ],
      ),
    ),
  );
}
