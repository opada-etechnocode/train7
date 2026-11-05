import '../utils/shared_import.dart';

class ProgramDayDetailScreen extends StatefulWidget {
  final int programId;
  final DateTime date;
  final String? programName;

  const ProgramDayDetailScreen({
    super.key,
    required this.programId,
    required this.date,
    this.programName,
  });

  @override
  State<ProgramDayDetailScreen> createState() => _ProgramDayDetailScreenState();
}

class _ProgramDayDetailScreenState extends State<ProgramDayDetailScreen> {
  bool _loading = true;
  String? _error;
  ProgramDayDetail? _detail;

  String get _dateStr => DateFormat('yyyy-MM-dd').format(widget.date);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ProgramDayDetailResponse res = await getProgramDayDetailApi(
        programId: widget.programId,
        date: _dateStr,
      );
      if (!mounted) return;
      setState(() {
        _detail = res.data;
        _loading = false;
        if (res.data == null) {
          _error = languages.lblUgcNoPlanDay;
        }
      });
    } on Exception catch (e) {
      log('program-day-detail: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = languages.lblUgcNoPlanDay;
        _detail = null;
      });
    }
  }

  String _typeLabel(String? type) {
    switch (type) {
      case 'rest':
        return languages.lblUgcRestDay;
      case 'cardio':
        return languages.lblUgcCardio;
      default:
        return languages.lblUgcWorkouts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = appStore.isDarkMode;
    final ProgramDayDetail? d = _detail;
    final List<ProgramDayExerciseItem> exercises = d?.allExercises ?? [];

    return Scaffold(
      appBar: appBarWidget(
        languages.lblUgcDayDetail,
        context: context,
      ),
      body: _loading
          ? const Loader().center()
          : _error != null && d == null
              ? NoDataScreen(mTitle: _error!).center()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      Text(
                        DateFormat('EEEE, d MMM yyyy').format(widget.date),
                        style: boldTextStyle(size: 18),
                      ),
                      if (widget.programName.validate().isNotEmpty) ...[
                        4.height,
                        Text(
                          widget.programName!,
                          style: secondaryTextStyle(),
                        ),
                      ],
                      14.height,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip(
                            Icons.fitness_center_rounded,
                            _typeLabel(d?.type),
                          ),
                          if (d?.waterGoalMl != null)
                            _chip(
                              Icons.water_drop_outlined,
                              '${d!.waterGoalMl} ml',
                            ),
                          if (d?.stepsGoal != null)
                            _chip(
                              Icons.directions_walk_rounded,
                              '${d!.stepsGoal} ${languages.lblSteps}',
                            ),
                        ],
                      ),
                      if (d?.workout != null) ...[
                        20.height,
                        Text(
                          languages.lblUgcWorkouts,
                          style: boldTextStyle(size: 16),
                        ),
                        8.height,
                        _card(
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d!.workout!.title.validate(),
                                style: boldTextStyle(size: 15),
                              ),
                              if (d.workout!.description
                                  .validate()
                                  .isNotEmpty) ...[
                                6.height,
                                Text(
                                  d.workout!.description!,
                                  style: secondaryTextStyle(),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (exercises.isNotEmpty) ...[
                          14.height,
                          Text(
                            languages.lblExercises,
                            style: boldTextStyle(size: 16),
                          ),
                          8.height,
                          ...exercises.map((ex) => _exerciseTile(ex, isDark)),
                        ],
                      ],
                      if (d?.diet != null) ...[
                        20.height,
                        Text(
                          languages.lblDiet,
                          style: boldTextStyle(size: 16),
                        ),
                        8.height,
                        _card(
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d!.diet!.title.validate(),
                                style: boldTextStyle(size: 15),
                              ),
                              10.height,
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  if (d.diet!.calories.validate().isNotEmpty)
                                    _chip(
                                      Icons.local_fire_department_outlined,
                                      '${languages.lblCalories}: ${d.diet!.calories}',
                                    ),
                                  if (d.diet!.protein.validate().isNotEmpty)
                                    _chip(
                                      Icons.egg_outlined,
                                      '${languages.lblProtein}: ${d.diet!.protein}',
                                    ),
                                  if (d.diet!.carbs.validate().isNotEmpty)
                                    _chip(
                                      Icons.breakfast_dining_outlined,
                                      '${languages.lblCarbs}: ${d.diet!.carbs}',
                                    ),
                                  if (d.diet!.fat.validate().isNotEmpty)
                                    _chip(
                                      Icons.opacity_outlined,
                                      '${languages.lblFat}: ${d.diet!.fat}',
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _exerciseTile(ProgramDayExerciseItem ex, bool isDark) {
    final String title =
        ex.exerciseTitle.validate(value: ex.exercise?.title.validate() ?? '-');
    final String image =
        ex.exerciseImage.validate(value: ex.exercise?.exerciseImage ?? '');
    final List<ProgramDayExerciseSet> sets = ex.exercise?.sets ?? [];
    final String setsLine = sets.isEmpty
        ? ''
        : sets
            .map((s) {
              final List<String> parts = [];
              if (s.reps.validate().isNotEmpty) {
                parts.add('${s.reps} ${languages.lblUgcReps}');
              }
              if (s.weight.validate().isNotEmpty) {
                parts.add('${s.weight} ${languages.lblUgcWeight}');
              }
              if (s.time.validate().isNotEmpty) parts.add('${s.time}s');
              if (s.rest.validate().isNotEmpty) {
                parts.add('rest ${s.rest}s');
              }
              return parts.join(' · ');
            })
            .where((e) => e.isNotEmpty)
            .join('\n');

    return InkWell(
      onTap: () {
        final int? id = ex.exerciseId ?? ex.exercise?.id;
        if (id == null) return;
        ExerciseDetailScreen(
          mExerciseId: id,
          mExerciseName: title,
        ).launch<void>(context);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : lightDividerColor,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: cachedImage(
                image,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: boldTextStyle(size: 14), maxLines: 2),
                  if (setsLine.isNotEmpty) ...[
                    4.height,
                    Text(setsLine, style: secondaryTextStyle(size: 12)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _card({required bool isDark, required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : lightDividerColor,
          ),
        ),
        child: child,
      );

  Widget _chip(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: primaryColor),
            4.width,
            Text(text, style: secondaryTextStyle(size: 11, color: primaryColor)),
          ],
        ),
      );
}
