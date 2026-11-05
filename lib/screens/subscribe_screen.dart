import '../utils/shared_import.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  List<ProgramModel> mProgramList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (!isPurchaseEnabled) {
      afterBuildCreated(() {
        toast(languages.lblPurchasesDisabled);
        finish(context);
      });
      return;
    }
    getProgramData();
  }

  Future<void> getProgramData() async {
    setState(() => isLoading = true);
    try {
      final ProgramResponse value = await getPrograms();
      mProgramList = value.data ?? [];
      log('SubscribeScreen programs: ${mProgramList.length}');
    } catch (e) {
      log('SubscribeScreen programs error: $e');
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(languages.lblSubscriptionPlans, context: context),
    body: isLoading && mProgramList.isEmpty
        ? const Loader().center()
        : mProgramList.isNotEmpty
            ? RefreshIndicator(
                onRefresh: getProgramData,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: mProgramList.length,
                  itemBuilder: (context, index) => ProgramCardComponent(
                    program: mProgramList[index],
                    popOnSuccess: true,
                  ),
                ),
              )
            : SizedBox(
                height: context.height() * 0.65,
                child: const NoDataScreen().center(),
              ),
  );
}
