import '../utils/shared_import.dart';

class MissingDetailsBottomSheet extends StatefulWidget {
  final VoidCallback onComplete;

  const MissingDetailsBottomSheet({super.key, required this.onComplete});

  @override
  State<MissingDetailsBottomSheet> createState() =>
      _MissingDetailsBottomSheetState();
}

class _MissingDetailsBottomSheetState extends State<MissingDetailsBottomSheet> {
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
          appStore.setLoading(false);
          widget.onComplete();
          if (!mounted) return;
          Navigator.pop(context);
        })
        .catchError((Object e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
  }

  void _handleBackPress() {
    // Navigate to home screen (DashboardScreen with index 0)
    // We use pushAndRemoveUntil to ensure we navigate to a fresh DashboardScreen
    // which will default to the home tab (index 0)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (BuildContext context) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      _handleBackPress();
    },
    child: Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languages.lblCompleteyourprofile, style: boldTextStyle(size: 18)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _handleBackPress,
                  color: textPrimaryColorGlobal,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Observer(
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
        ],
      ),
    ),
  );
}
