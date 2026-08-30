import '../utils/shared_import.dart';

class ProgramDetailScreen extends StatefulWidget {
  final ProgramModel program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _emptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: textSecondaryColorGlobal),
          12.height,
          Text(message, style: secondaryTextStyle()),
        ],
      ),
    );
  }

  Widget _buildExercisesTab() {
    final ExerciseModel? exercise = widget.program.exercise;
    if (exercise == null) {
      return _emptyState(languages.lblExerciseNoFound);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        ExerciseComponent(mExerciseModel: exercise),
      ],
    );
  }

  Widget _buildDietTab() {
    final DietModel? diet = widget.program.diet;
    final int? limit = widget.program.foodRecognitionLimit;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        if (diet != null) ...[
          FeaturedDietComponent(mDietModel: diet, isList: true),
          12.height,
        ] else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: _emptyState(languages.lblNoFoundData),
          ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: appStore.isDarkMode
              ? boxDecorationWithRoundedCorners(borderRadius: radius(14))
              : boxDecorationRoundedWithShadow(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: radius(12),
                ),
                child: const Icon(Icons.restaurant_menu, color: primaryColor),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languages.lblCalorieCalculator,
                      style: boldTextStyle(size: 15),
                    ),
                    4.height,
                    Text(
                      limit != null
                          ? '${languages.lblFoodRecognitionLimit}: $limit'
                          : languages.lblCalorieCalculatorDesc,
                      style: secondaryTextStyle(size: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: primaryColor),
            ],
          ),
        ).onTap(() {
          if (!userStore.isLoggedIn) {
            const SignInScreen().launch<void>(context);
            return;
          }
          CalorieCalculatorScreen(
            foodRecognitionLimit: limit,
          ).launch<void>(context);
        }),
      ],
    );
  }

  Widget _buildAdviceTab() {
    final ProgramAdvice? advice = widget.program.advice;
    if (advice == null) {
      return _emptyState(languages.lblNoFoundData);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: radius(16),
            color: primaryColor.withValues(alpha: 0.1),
            border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                advice.name.validate(),
                style: boldTextStyle(size: 18, color: primaryColor),
              ),
              if (advice.seedText.validate().isNotEmpty) ...[
                10.height,
                Text(
                  advice.seedText.validate(),
                  style: primaryTextStyle(size: 14),
                ),
              ],
            ],
          ),
        ),
        if (advice.options.validate().isNotEmpty) ...[
          16.height,
          Text(languages.lblTips, style: boldTextStyle(size: 16)),
          10.height,
          ...advice.options!.map((option) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: appStore.isDarkMode
                  ? boxDecorationWithRoundedCorners(borderRadius: radius(12))
                  : boxDecorationRoundedWithShadow(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      8.width,
                      Expanded(
                        child: Text(
                          option.label.validate(value: option.key.validate()),
                          style: boldTextStyle(size: 15),
                        ),
                      ),
                    ],
                  ),
                  if (option.description.validate().isNotEmpty) ...[
                    8.height,
                    Text(
                      option.description.validate(),
                      style: secondaryTextStyle(size: 13),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: textPrimaryColorGlobal,
          ),
          onPressed: () => finish(context),
        ),
        title: Text(
          widget.program.name.validate(),
          style: boldTextStyle(size: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: appStore.isDarkMode
                  ? Colors.white.withValues(alpha: 0.06)
                  : primaryColor.withValues(alpha: 0.08),
              borderRadius: radius(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: primaryColor,
                borderRadius: radius(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: textSecondaryColorGlobal,
              labelStyle: boldTextStyle(size: 13, color: Colors.white),
              unselectedLabelStyle: primaryTextStyle(size: 13),
              tabs: [
                Tab(text: languages.lblExercises),
                Tab(text: languages.lblDiet),
                Tab(text: languages.lblAdvice),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExercisesTab(),
          _buildDietTab(),
          _buildAdviceTab(),
        ],
      ),
    );
  }
}
