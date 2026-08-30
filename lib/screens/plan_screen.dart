import '../extensions/date_time_extensions.dart';
import '../utils/registration_data.dart';
import '../utils/shared_import.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final ScrollController _scrollController = ScrollController();
  static const double _graphCardHeight = 260;

  int _kcalTarget = 1331;
  num _kcalFrom = 0;
  num _kcalTo = 0;
  int _proteinTarget = 74;
  int _carbsTarget = 159;
  int _fatsTarget = 44;

  int _kcalCurrent = 0;
  int _proteinCurrent = 0;
  int _carbsCurrent = 0;
  int _fatsCurrent = 0;

  final Map<String, MealTotal> _mealTotals = {};
  final Map<String, List<DailyPlanRecipeItem>> _mealRecipes = {};

  DateTime _selectedDay = DateTime.now();
  bool _showCompactSummary = false;
  bool _isLoading = true;
  DailyPlanData? _dailyPlanData;
  List<String> _plannedDays = [];

  final PageController _pageController = PageController(initialPage: 500);
  static const int _initialPage = 500;

  @override
  void initState() {
    super.initState();
    _fetchDailyPlan();
    _scrollController.addListener(_onScroll);

    afterBuildCreated(() {
      if (userStore.goal.isEmptyOrNull ||
          userStore.activityLevel.isEmptyOrNull) {
        _showMissingDetailsBottomSheet();
      }
    });
  }

  Future<void> _fetchDailyPlan() async {
    appStore.setLoading(true);
    await getDailyPlanDetailApi(date: getDateTimeString(_selectedDay))
        .then((value) {
          _dailyPlanData = value.data;
          if (_dailyPlanData != null) {
            if (_dailyPlanData!.dailyPlan != null) {
              _kcalTarget = _dailyPlanData!.dailyPlan!.kCal ?? _kcalTarget;
              _kcalFrom = _dailyPlanData!.dailyPlan!.kCalFrom ?? _kcalTarget;
              _kcalTo = _dailyPlanData!.dailyPlan!.kCalTo ?? _kcalTarget;
              _proteinTarget =
                  _dailyPlanData!.dailyPlan!.protein?.target?.toInt() ??
                  _proteinTarget;
              _carbsTarget =
                  _dailyPlanData!.dailyPlan!.carbs?.target?.toInt() ??
                  _carbsTarget;
              _fatsTarget =
                  _dailyPlanData!.dailyPlan!.fat?.target?.toInt() ??
                  _fatsTarget;

              _kcalCurrent = _dailyPlanData!.eaten.validate().toInt();
              _proteinCurrent = _dailyPlanData!.protein.validate();
              _carbsCurrent = _dailyPlanData!.carbs.validate();
              _fatsCurrent = _dailyPlanData!.fats.validate();
            }

            if (_dailyPlanData!.mealType != null) {
              _mealTotals.clear();
              for (var element in _dailyPlanData!.mealType!) {
                if (element.key != null) {
                  _mealTotals[element.key!] = element.total ?? MealTotal();
                }
              }
            }
          }

          _mealRecipes.clear();
          if (value.dailyPlanRecipe != null &&
              value.dailyPlanRecipe!.mealRecipes != null) {
            _mealRecipes.addAll(value.dailyPlanRecipe!.mealRecipes!);
          }

          _plannedDays.clear();
          if (value.dayHasDailyPlan != null) {
            _plannedDays.addAll(value.dayHasDailyPlan!);
          }

          setState(() {});
        })
        .catchError((Object e, Object s) {
          log("Error ===> ${e.toString()} == ${s.toString()}");
          // toast(e.toString());
        })
        .whenComplete(() {
          appStore.setLoading(false);
          setState(() => _isLoading = false);
        });
  }



  void _showMissingDetailsBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          MissingDetailsBottomSheet(onComplete: _fetchDailyPlan),
    ).then((value) {
      if (userStore.goal.isEmptyOrNull ||
          userStore.activityLevel.isEmptyOrNull) {}
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _onScroll() {
    final show =
        _scrollController.hasClients &&
        _scrollController.offset > _graphCardHeight * 0.6;
    if (show != _showCompactSummary) {
      setState(() => _showCompactSummary = show);
    }
  }

  void _onPageChanged(int page) {
    final newOffset = page - _initialPage;
    final startOfCurrentWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    final startOfNewWeek = startOfCurrentWeek.add(Duration(days: newOffset * 7));
    final newDate = startOfNewWeek.add(Duration(days: _selectedDay.weekday - 1));

    if (!_isSameDay(newDate, _selectedDay)) {
      setState(() {
        _selectedDay = newDate;
      });
      _fetchDailyPlan();
    }
  }

  List<DateTime> _getWeekDays(int weekOffset) {
    final now = DateTime.now();
    final startOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = startOfCurrentWeek.add(Duration(days: weekOffset * 7));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }



  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  double get _proteinProgress => _proteinTarget > 0
      ? (_proteinCurrent / _proteinTarget).clamp(0.0, 1.0)
      : 0.0;
  double get _carbsProgress =>
      _carbsTarget > 0 ? (_carbsCurrent / _carbsTarget).clamp(0.0, 1.0) : 0.0;
  double get _fatsProgress =>
      _fatsTarget > 0 ? (_fatsCurrent / _fatsTarget).clamp(0.0, 1.0) : 0.0;

  Future<void> _toggleRecipeCompletion(
    DailyPlanRecipeItem item,
    String mealType,
  ) async {
    if (item.id == null || item.dailyPlanId == null || item.recipeId == null) {
      toast(languages.lblMissingrequiredinformation);
      return;
    }

    // Toggle the completion status
    final newCompletionStatus = !(item.isComplete ?? false);

    // Prepare the request
    final Map<String, dynamic> request = {
      'id': item.id,
      'daily_plan_id': item.dailyPlanId,
      'recipe_id': item.recipeId,
      'meal_type': mealType,
      'is_complete': newCompletionStatus,
    };

    try {
      // Show loading
      appStore.setLoading(true);

      // Call the API
      final response = await saveDailyPlanRecipeApi(request);

      // Update all data from the API response
      _updateDataFromResponse(response);

      toast(languages.lblStatusupdatedsuccessfully);
    } on Exception catch (e) {
      toast(e.toString());
    } finally {
      appStore.setLoading(false);
    }
  }

  void _updateDataFromResponse(DailyPlanResponse response) {
    _mealRecipes.clear();
    _mealTotals.clear();

    setState(() {
      _dailyPlanData = response.data;

      if (_dailyPlanData != null) {
        // Update targets and current values
        if (_dailyPlanData!.dailyPlan != null) {
          _kcalTarget = _dailyPlanData!.dailyPlan!.kCal ?? _kcalTarget;
          _kcalFrom = _dailyPlanData!.dailyPlan!.kCalFrom ?? _kcalTarget;
          _kcalTo = _dailyPlanData!.dailyPlan!.kCalTo ?? _kcalTarget;
          _proteinTarget =
              _dailyPlanData!.dailyPlan!.protein?.target?.toInt() ??
              _proteinTarget;
          _carbsTarget =
              _dailyPlanData!.dailyPlan!.carbs?.target?.toInt() ?? _carbsTarget;
          _fatsTarget =
              _dailyPlanData!.dailyPlan!.fat?.target?.toInt() ?? _fatsTarget;

          _kcalCurrent = _dailyPlanData!.eaten.validate().toInt();
          _proteinCurrent = _dailyPlanData!.protein.validate();
          _carbsCurrent = _dailyPlanData!.carbs.validate();
          _fatsCurrent = _dailyPlanData!.fats.validate();
        }

        // Update meal type totals
        if (_dailyPlanData!.mealType != null) {
          for (var element in _dailyPlanData!.mealType!) {
            if (element.key != null) {
              _mealTotals[element.key!] = element.total ?? MealTotal();
            }
          }
        }
      }

      if (response.dailyPlanRecipe != null &&
          response.dailyPlanRecipe!.mealRecipes != null) {
        _mealRecipes.addAll(response.dailyPlanRecipe!.mealRecipes!);
      }

      _plannedDays.clear();
      if (response.dayHasDailyPlan != null) {
        _plannedDays.addAll(response.dayHasDailyPlan!);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.scaffoldBackgroundColor,
    body: Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              PlanHeader(
                selectedDay: _selectedDay,
                dailyPlanId: _dailyPlanData?.id,
                hasRecipes: _mealRecipes.values.any((list) => list.isNotEmpty),
                onClearDay: _clearDailyPlan,
              ),
              SizedBox(
                height: 100,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final weekDays = _getWeekDays(index - _initialPage);
                    return PlanWeekStrip(
                      weekDays: weekDays,
                      selectedDay: _selectedDay,
                      plannedDays: _plannedDays,
                      onDaySelected: (date) {
                        setState(() {
                          _selectedDay = date;
                        });
                        _fetchDailyPlan();
                      },
                    );
                  },
                ),
              ),
              if (_showCompactSummary) _buildCompactSummaryBar(),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 6, right: 6, bottom: 24),
                  children: [
                    8.height,
                    PlanNutrientGraph(
                      currentKcal: _kcalCurrent,
                      targetKcal: _kcalTarget,
                      fromKcal: _kcalFrom,
                      toKcal: _kcalTo,
                      currentProtein: _proteinCurrent,
                      targetProtein: _proteinTarget,
                      proteinProgress: _proteinProgress,
                      currentCarbs: _carbsCurrent,
                      targetCarbs: _carbsTarget,
                      carbsProgress: _carbsProgress,
                      currentFats: _fatsCurrent,
                      targetFats: _fatsTarget,
                      fatsProgress: _fatsProgress,
                    ),
                    ...RegistrationData.getAvailableMealEntries().entries.map((
                      entry,
                    ) {
                      final key = entry.key;
                      final displayName = entry.value;
                      final total = _mealTotals[key] ?? MealTotal();
                      final recipes = _mealRecipes[key] ?? [];
                      return PlanMealSection(
                        mealType: key,
                        title: displayName,
                        kcal: total.totalCalories ?? 0,
                        p: total.totalProtein ?? 0,
                        c: total.totalCarbs ?? 0,
                        f: total.totalFats ?? 0,
                        recipes: recipes,
                        onAddMeal: () => _navigateToRecipeList(key),
                        onMoveRecipe: _moveRecipe,
                        onDeleteAll: _deleteAllRecipes,
                        onToggleCompletion: _toggleRecipeCompletion,
                        onShowRecipeDetail: _showRecipeDetailBottomSheet,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLoading) const Loader(),
      ],
    ),
  );

  void _navigateToRecipeList(String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => DailyPlanRecipeListScreen(
          mealType: mealType,
          dailyPlanId: _dailyPlanData?.id,
          date: getDateTimeString(_selectedDay),
        ),
      ),
    ).then((result) {
      if (result == true) {
        _fetchDailyPlan();
      }
    });
  }

  void _showRecipeDetailBottomSheet(DailyPlanRecipeItem item, String mealType) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeDetailBottomSheet(
        recipeItem: item,
        mealType: mealType,
        onDelete: () {
          Navigator.pop(context);
          _deleteRecipe(item, mealType);
        },
        onUpdate: () {
          Navigator.pop(context);
          _updateRecipe(item, mealType);
        },
      ),
    );
  }

  void _deleteRecipe(DailyPlanRecipeItem item, String mealType) {
    appStore.setLoading(true);
    deleteDailyPlanRecipeApi({'id': item.id})
        .then((value) {
          _updateDataFromResponse(value);
          toast(languages.lblRecipedeletedsuccessfully);
        })
        .catchError((Object e) {
          toast(e.toString());
        })
        .whenComplete(() {
          appStore.setLoading(false);
        });
  }

  void _deleteAllRecipes(String mealType) {
    if (_dailyPlanData?.id == null) {
      return;
    }

    appStore.setLoading(true);
    final Map<String, dynamic> req = {
      "daily_plan_id": _dailyPlanData!.id,
      "meal_type": mealType,
    };

    deleteAllDailyPlanRecipeApi(req)
        .then((value) {
          _updateDataFromResponse(value);
          toast('All $mealType recipes deleted successfully');
        })
        .catchError((Object e) {
          toast(e.toString());
        })
        .whenComplete(() {
          appStore.setLoading(false);
        });
  }

  void _updateRecipe(DailyPlanRecipeItem item, String mealType) {
    // TODO: Implement update functionality
    toast('Update recipe functionality to be implemented');
  }

  Future<void> _moveRecipe(DailyPlanRecipeItem item, String toMealType) async {
    if (item.mealType == toMealType) {
      return;
    }

    if (item.id == null || item.dailyPlanId == null || item.recipeId == null) {
      toast(languages.lblMissingrequiredinformation);
      return;
    }

    // Prepare the request with the new meal type
    final Map<String, dynamic> request = {
      'id': item.id,
      'daily_plan_id': item.dailyPlanId,
      'recipe_id': item.recipeId,
      'meal_type': toMealType,
      'is_complete': item.isComplete ?? false,
    };

    try {
      appStore.setLoading(true);
      final response = await saveDailyPlanRecipeApi(request);
      _updateDataFromResponse(response);
      toast('Recipe moved to $toMealType');
    } on Exception catch (e) {
      toast(e.toString());
    } finally {
      appStore.setLoading(false);
    }
  }

  void _clearDailyPlan() {
    if (_dailyPlanData?.id == null) {
      return;
    }

    appStore.setLoading(true);
    final Map<String, dynamic> req = {"daily_plan_id": _dailyPlanData!.id};

    deleteAllDailyPlanRecipeApi(req)
        .then((value) {
          _updateDataFromResponse(value);
          toast(languages.lblDailyplanclearedsuccessfully);
        })
        .catchError((Object e) {
          toast(e.toString());
        })
        .whenComplete(() {
          appStore.setLoading(false);
        });
  }

  Widget _buildCompactSummaryBar() => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.cardColor,
        borderRadius: radius(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _compactStat(
            languages.lblKcal.validate(),
            '$_kcalCurrent/$_kcalTarget',
            _kcalTarget > 0 ? (_kcalCurrent / _kcalTarget).toDouble().clamp(0, 1) : 0,
          ),
          _compactStat(
            languages.lblProtein.validate(),
            '$_proteinCurrent / $_proteinTarget g',
            _proteinProgress,
          ),
          _compactStat(
            languages.lblCarbs.validate(),
            '$_carbsCurrent / $_carbsTarget g',
            _carbsProgress,
          ),
          _compactStat(
            languages.lblFat.validate(),
            '$_fatsCurrent / $_fatsTarget g',
            _fatsProgress,
          ),
        ],
      ),
    );

  Widget _compactStat(String label, String value, double progress) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: secondaryTextStyle(size: 10)),
      Text(value, style: boldTextStyle(size: 11)),
      6.height,
      Container(
        height: 3,
        width: 45,
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: appStore.isDarkMode ? Colors.white12 : Colors.black12,
          borderRadius: radius(2),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: primaryColor,
              borderRadius: radius(2),
            ),
          ),
        ),
      ),
    ],
  );
}
