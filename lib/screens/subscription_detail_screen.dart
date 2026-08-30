import '../utils/shared_import.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  final SubscriptionPlan? mList;

  const SubscriptionDetailScreen({super.key, this.mList});

  @override
  State<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  List<ProgramModel> mProgramList = [];
  List<SubscriptionPlan> mSubscriptionHistoryList = [];

  /// true = Programs tab, false = History tab
  bool select = true;
  bool isLoadingPrograms = false;
  bool isLoadingHistory = false;

  final ScrollController programScrollController = ScrollController();
  final ScrollController historyScrollController = ScrollController();

  int historyPage = 1;
  int? historyNumPage;

  @override
  void initState() {
    super.initState();
    getProgramsList();
    getSubscriptionHistory();
    LiveStream().on(PAYMENT, (p0) {
      historyPage = 1;
      getSubscriptionHistory();
    });
    historyScrollController.addListener(() {
      if (historyScrollController.position.pixels >=
              historyScrollController.position.maxScrollExtent - 40 &&
          !isLoadingHistory) {
        if (historyNumPage != null && historyPage < historyNumPage!) {
          historyPage++;
          getSubscriptionHistory();
        }
      }
    });
  }

  @override
  void dispose() {
    programScrollController.dispose();
    historyScrollController.dispose();
    LiveStream().dispose(PAYMENT);
    super.dispose();
  }

  Future<void> getProgramsList() async {
    setState(() => isLoadingPrograms = true);
    try {
      final ProgramResponse value = await getPrograms();
      mProgramList = value.data ?? [];
      log('Programs loaded: ${mProgramList.length}');
      if (mounted) {
        setState(() => isLoadingPrograms = false);
      }
    } catch (e) {
      log('Programs error: $e');
      if (mounted) {
        setState(() => isLoadingPrograms = false);
      }
    }
  }

  Future<void> getSubscriptionHistory() async {
    setState(() => isLoadingHistory = true);
    try {
      final SubscriptionPlanResponse value =
          await getSubScriptionPlanList(page: historyPage);
      historyNumPage = value.pagination?.totalPages;
      if (historyPage == 1) {
        mSubscriptionHistoryList.clear();
      }
      if (value.data != null) {
        mSubscriptionHistoryList.addAll(value.data!);
      }
      if (mounted) {
        setState(() => isLoadingHistory = false);
      }
    } catch (e) {
      log('History error: $e');
      if (mounted) {
        setState(() => isLoadingHistory = false);
      }
    }
  }

  Color getTextColor(String? state) {
    switch (state) {
      case ACTIVE:
        return GreenColor;
      case INACTIVE:
        return Colors.grey;
      case CANCELLED:
        return RedColor;
      case EXPIRED:
        return YellowColor;
      default:
        return textPrimaryColorGlobal;
    }
  }

  Color getBgColor(String? state) {
    switch (state) {
      case ACTIVE:
        return GreenColor.withValues(alpha: 0.15);
      case INACTIVE:
        return Colors.grey.withValues(alpha: 0.10);
      case CANCELLED:
        return RedColor.withValues(alpha: 0.10);
      case EXPIRED:
        return YellowColor.withValues(alpha: 0.5);
      default:
        return context.cardColor;
    }
  }

  Widget _buildProgramsTab() {
    if (isLoadingPrograms && mProgramList.isEmpty) {
      return const Loader().center();
    }

    if (mProgramList.isEmpty) {
      return SizedBox(
        height: context.height() * 0.65,
        child: const NoDataScreen().center(),
      );
    }

    return RefreshIndicator(
      onRefresh: getProgramsList,
      child: ListView.builder(
        controller: programScrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: mProgramList.length,
        itemBuilder: (context, index) =>
            ProgramCardComponent(program: mProgramList[index]),
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (isLoadingHistory && mSubscriptionHistoryList.isEmpty) {
      return const Loader().center();
    }

    if (mSubscriptionHistoryList.isEmpty) {
      return SizedBox(
        height: context.height() * 0.65,
        child: const NoDataScreen().center(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        historyPage = 1;
        await getSubscriptionHistory();
      },
      child: ListView.builder(
        controller: historyScrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: mSubscriptionHistoryList.length,
        itemBuilder: (context, index) => SubscriptionHistoryItem(
          plan: mSubscriptionHistoryList[index],
          getTextColor: getTextColor,
          getBgColor: getBgColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBarWidget(
          languages.lblSubscriptionPlans,
          context: context,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: SubscriptionTabHeader(
              select: select,
              onTap: () {
                setState(() {
                  select = !select;
                });
              },
            ),
          ),
        ),
        body: select ? _buildProgramsTab() : _buildHistoryTab(),
      );
}
