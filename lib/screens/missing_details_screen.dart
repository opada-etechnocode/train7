import '../utils/shared_import.dart';

class MissingDetailsScreen extends StatefulWidget {
  const MissingDetailsScreen({super.key});

  @override
  _MissingDetailsScreenState createState() => _MissingDetailsScreenState();
}

class _MissingDetailsScreenState extends State<MissingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    appStore.signUpIndex = 4;
  }

  Future<void> _updateProfile() async {
    hideKeyboard(context);

    final Map<String, dynamic> req = {
      'email': userStore.email,
      'username': userStore.username,
      'user_profile': {
        'activity': userStore.activityLevel.validate(),
        'goal': userStore.goal.validate(),
        'macro_type': userStore.macroType.validate(),
      },
    };
    appStore.setLoading(true);
    await updateProfileApi(req)
        .then((value) async {
          if (!mounted) return;
          appStore.setLoading(false);
          finish(context, true);
        })
        .catchError((Object e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Scaffold(
      appBar: appBarWidget(
        "Add Details",
        color: whiteColor,
        elevation: 0,
        textColor: textPrimaryColorGlobal,
        context: context,
        showBack: false,
      ),
      body: Observer(
        builder: (context) => Column(
          children: [
            16.height,
            if (appStore.signUpIndex == 4)
              const SignUpStep5Component().expand(),
            if (appStore.signUpIndex == 5)
              const SignUpStep6Component().expand(),
            if (appStore.signUpIndex == 6)
              SignUpStep7Component(onSave: _updateProfile).expand(),
          ],
        ),
      ),
    ),
  );
}
