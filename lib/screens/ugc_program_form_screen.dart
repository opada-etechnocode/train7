import '../service/ugc_plan_sync_service.dart';
import '../utils/shared_import.dart';

class UgcProgramFormScreen extends StatefulWidget {
  final UgcProgramModel? program;

  const UgcProgramFormScreen({super.key, this.program});

  @override
  State<UgcProgramFormScreen> createState() => _UgcProgramFormScreenState();
}

class _UgcProgramFormScreenState extends State<UgcProgramFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCont;
  late TextEditingController objectiveCont;
  late TextEditingController weeksCont;
  bool isRecurring = true;
  bool loadingLists = true;
  final List<_DayDraft> days = [];

  List<WorkoutDetailModel> workouts = [];
  List<DietModel> diets = [];

  bool get isEdit => widget.program?.id != null;

  static const List<String> _dayNamesEn = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const List<String> _dayNamesAr = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  @override
  void initState() {
    super.initState();
    final UgcProgramModel? p = widget.program;
    nameCont = TextEditingController(text: p?.name);
    objectiveCont = TextEditingController(text: p?.objective);
    weeksCont = TextEditingController(text: '${p?.durationWeeks ?? 4}');
    isRecurring = p?.isRecurring ?? true;
    if (p?.days != null) {
      for (final d in p!.days!) {
        days.add(_DayDraft.fromModel(d));
      }
    }
    if (days.isEmpty) {
      days.add(_DayDraft(type: 'workout', weekNumber: 1, dayOfWeek: 1));
    }
    _loadPickers();
  }

  Future<void> _loadPickers() async {
    setState(() => loadingLists = true);
    try {
      final results = await Future.wait([
        getWorkoutListApi(false, false, page: 1),
        getSearchDietApi(mSearch: '', page: 1),
      ]);
      workouts = (results[0] as WorkoutResponse).data ?? [];
      diets = (results[1] as DietResponse).data ?? [];
    } on Exception catch (e) {
      toast(e.toString());
    }
    if (mounted) setState(() => loadingLists = false);
  }

  @override
  void dispose() {
    nameCont.dispose();
    objectiveCont.dispose();
    weeksCont.dispose();
    for (final d in days) {
      d.dispose();
    }
    super.dispose();
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'rest':
        return languages.lblUgcRestDay;
      case 'cardio':
        return languages.lblUgcCardio;
      default:
        return languages.lblUgcWorkouts;
    }
  }

  String _dayLabel(int day) {
    final int i = (day.clamp(1, 7)) - 1;
    return appStore.selectedLanguageCode == 'ar'
        ? _dayNamesAr[i]
        : _dayNamesEn[i];
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (days.isEmpty) {
      toast(languages.lblUgcAddDay);
      return;
    }

    final Map<String, dynamic> req = {
      if (isEdit) 'id': widget.program!.id,
      'name': nameCont.text.trim(),
      'objective': objectiveCont.text.trim(),
      'duration_weeks': int.tryParse(weeksCont.text.trim()) ?? 1,
      'is_recurring': isRecurring,
      'frequency': isRecurring ? 'weekly' : 'custom',
      'days': days.map((e) => e.toJson(isRecurring: isRecurring)).toList(),
    };

    appStore.setLoading(true);
    try {
      final FitnessBaseResponse res = isEdit
          ? await updateUgcProgramApi(req)
          : await saveUgcProgramApi(req);
      toast(res.message.validate(value: languages.lblDone));

      // Link plan to schedule + water/steps when editing, or auto-activate new save
      UgcProgramModel? toActivate;
      if (isEdit && widget.program?.id != null) {
        toActivate = UgcProgramModel(
          id: widget.program!.id,
          name: nameCont.text.trim(),
          objective: objectiveCont.text.trim(),
          durationWeeks: int.tryParse(weeksCont.text.trim()),
          isRecurring: isRecurring,
          frequency: isRecurring ? 'weekly' : 'custom',
          days: days
              .map(
                (e) => UgcProgramDay.fromJson(
                  e.toJson(isRecurring: isRecurring),
                ),
              )
              .toList(),
        );
      } else {
        try {
          final list = await getUgcProgramList(page: 1, perPage: 20);
          final String name = nameCont.text.trim();
          for (final UgcProgramModel p in list.data ?? []) {
            if (p.name == name) {
              toActivate = p;
              break;
            }
          }
          toActivate ??=
              (list.data?.isNotEmpty ?? false) ? list.data!.first : null;
        } on Exception catch (_) {}
      }
      if (toActivate?.id != null) {
        await UgcPlanSyncService.activateProgram(toActivate!);
      }

      if (mounted) finish(context, true);
    } on Exception catch (e) {
      toast(e.toString());
    }
    appStore.setLoading(false);
  }

  Widget _fieldLabel(String text) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(text, style: boldTextStyle(size: 13)),
        ),
      );

  Widget _sectionCard({required String title, required List<Widget> children}) {
    final bool isDark = appStore.isDarkMode;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : lightDividerColor,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: boldTextStyle(size: 15)),
          14.height,
          ...children,
        ],
      ),
    );
  }

  Widget _pickerField<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    IconData icon = Icons.list_alt_rounded,
  }) {
    final T? safeValue =
        value != null && items.any((e) => e.value == value) ? value : null;
    return DropdownButtonFormField<T>(
      value: safeValue,
      isExpanded: true,
      hint: Text(hint, style: secondaryTextStyle()),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
      decoration: defaultInputDecoration(context, hint: hint).copyWith(
        prefixIcon: Icon(icon, color: primaryColor, size: 20),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = appStore.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? darkScaffoldBg : lightScaffoldColor,
      appBar: appBarWidget(
        isEdit ? languages.lblEdit : languages.lblUgcCreateProgram,
        context: context,
        color: isDark ? darkScaffoldBg : lightScaffoldColor,
      ),
      body: Stack(
        children: [
          if (loadingLists)
            const Loader().center()
          else
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                child: Column(
                  children: [
                    _sectionCard(
                      title: languages.lblUgcProgramInfo,
                      children: [
                        _fieldLabel(languages.lblName),
                        AppTextField(
                          controller: nameCont,
                          textFieldType: TextFieldType.NAME,
                          decoration: defaultInputDecoration(
                            context,
                            hint: languages.lblName,
                          ),
                        ),
                        12.height,
                        _fieldLabel(languages.lblUgcObjective),
                        AppTextField(
                          controller: objectiveCont,
                          textFieldType: TextFieldType.MULTILINE,
                          minLines: 2,
                          maxLines: 4,
                          decoration: defaultInputDecoration(
                            context,
                            hint: languages.lblUgcObjective,
                          ),
                        ),
                        12.height,
                        _fieldLabel(languages.lblUgcWeeks),
                        AppTextField(
                          controller: weeksCont,
                          textFieldType: TextFieldType.PHONE,
                          keyboardType: TextInputType.number,
                          decoration: defaultInputDecoration(
                            context,
                            hint: languages.lblUgcWeeks,
                          ),
                        ),
                        8.height,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              languages.lblUgcRecurring,
                              style: boldTextStyle(size: 14),
                            ),
                            subtitle: Text(
                              languages.lblUgcRecurringHint,
                              style: secondaryTextStyle(size: 11),
                            ),
                            value: isRecurring,
                            activeThumbColor: primaryColor,
                            onChanged: (v) => setState(() => isRecurring = v),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          languages.lblUgcDays,
                          style: boldTextStyle(size: 16),
                        ).expand(),
                        Material(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                days.add(
                                  _DayDraft(
                                    type: 'workout',
                                    weekNumber: 1,
                                    dayOfWeek: (days.length % 7) + 1,
                                  ),
                                );
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  4.width,
                                  Text(
                                    languages.lblAdd,
                                    style: boldTextStyle(
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.height,
                    ...List.generate(days.length, (i) {
                      final d = days[i];
                      final bool needsWorkout =
                          d.type == 'workout' || d.type == 'cardio';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: isDark ? darkCardColor : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : lightDividerColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.08),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${i + 1}',
                                      style: boldTextStyle(
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  10.width,
                                  Text(
                                    '${languages.lblUgcDay} ${i + 1}',
                                    style: boldTextStyle(size: 15),
                                  ).expand(),
                                  if (days.length > 1)
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.red.shade400,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          days.removeAt(i).dispose();
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  _fieldLabel(languages.lblType),
                                  _pickerField<String>(
                                    hint: languages.lblType,
                                    value: d.type,
                                    icon: Icons.category_outlined,
                                    items: ['workout', 'rest', 'cardio']
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(_typeLabel(e)),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) => setState(
                                      () => d.type = v ?? 'workout',
                                    ),
                                  ),
                                  12.height,
                                  if (isRecurring) ...[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              _fieldLabel(
                                                languages.lblUgcWeekNumber,
                                              ),
                                              AppTextField(
                                                controller: d.weekCont,
                                                textFieldType:
                                                    TextFieldType.PHONE,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    defaultInputDecoration(
                                                  context,
                                                  hint:
                                                      languages.lblUgcWeekNumber,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        10.width,
                                        Expanded(
                                          child: Column(
                                            children: [
                                              _fieldLabel(
                                                languages.lblUgcDayOfWeek,
                                              ),
                                              _pickerField<int>(
                                                hint: languages.lblUgcDayOfWeek,
                                                value: d.dayOfWeek,
                                                icon: Icons
                                                    .calendar_today_outlined,
                                                items: List.generate(
                                                  7,
                                                  (idx) => DropdownMenuItem(
                                                    value: idx + 1,
                                                    child: Text(
                                                      _dayLabel(idx + 1),
                                                    ),
                                                  ),
                                                ),
                                                onChanged: (v) => setState(
                                                  () => d.dayOfWeek = v ?? 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    _fieldLabel(languages.lblUgcSpecificDate),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () async {
                                        DateTime initial = DateTime.now();
                                        if (d.dateCont.text.trim().isNotEmpty) {
                                          initial = DateTime.tryParse(
                                                d.dateCont.text.trim(),
                                              ) ??
                                              DateTime.now();
                                        }
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: initial,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2101),
                                          builder: (ctx, child) => Theme(
                                            data: Theme.of(ctx).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: primaryColor,
                                                onPrimary: Colors.white,
                                                surface: appStore.isDarkMode
                                                    ? darkCardColor
                                                    : Colors.white,
                                              ),
                                            ),
                                            child: child!,
                                          ),
                                        );
                                        if (picked == null) return;
                                        setState(() {
                                          d.dateCont.text = DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(picked);
                                        });
                                      },
                                      child: InputDecorator(
                                        decoration: defaultInputDecoration(
                                          context,
                                          hint: languages.lblUgcSpecificDate,
                                        ).copyWith(
                                          prefixIcon: const Icon(
                                            Icons.calendar_month_rounded,
                                            color: primaryColor,
                                            size: 20,
                                          ),
                                          suffixIcon: const Icon(
                                            Icons.arrow_drop_down_rounded,
                                            color: primaryColor,
                                          ),
                                        ),
                                        child: Text(
                                          d.dateCont.text.trim().isEmpty
                                              ? languages.lblUgcPickDate
                                              : d.dateCont.text.trim(),
                                          style: d.dateCont.text
                                                  .trim()
                                                  .isEmpty
                                              ? secondaryTextStyle()
                                              : primaryTextStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (needsWorkout) ...[
                                    12.height,
                                    _fieldLabel(languages.lblUgcSelectWorkout),
                                    _pickerField<int>(
                                      hint: languages.lblUgcSelectWorkout,
                                      value: d.workoutId,
                                      icon: Icons.fitness_center_rounded,
                                      items: workouts
                                          .where((w) => w.id != null)
                                          .map(
                                            (w) => DropdownMenuItem(
                                              value: w.id!,
                                              child: Text(
                                                w.title.validate(
                                                  value: '#${w.id}',
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) =>
                                          setState(() => d.workoutId = v),
                                    ),
                                  ],
                                  12.height,
                                  _fieldLabel(languages.lblUgcSelectDiet),
                                  _pickerField<int>(
                                    hint: languages.lblUgcSelectDiet,
                                    value: d.dietId,
                                    icon: Icons.restaurant_menu_rounded,
                                    items: diets
                                        .where((x) => x.id != null)
                                        .map(
                                          (x) => DropdownMenuItem(
                                            value: x.id!,
                                            child: Text(
                                              x.title.validate(
                                                value: '#${x.id}',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => d.dietId = v),
                                  ),
                                  12.height,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            _fieldLabel(
                                              languages.lblUgcWaterMl,
                                            ),
                                            AppTextField(
                                              controller: d.waterCont,
                                              textFieldType:
                                                  TextFieldType.PHONE,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration:
                                                  defaultInputDecoration(
                                                context,
                                                hint: languages.lblUgcWaterMl,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Column(
                                          children: [
                                            _fieldLabel(languages.lblUgcSteps),
                                            AppTextField(
                                              controller: d.stepsCont,
                                              textFieldType:
                                                  TextFieldType.PHONE,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration:
                                                  defaultInputDecoration(
                                                context,
                                                hint: languages.lblUgcSteps,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: AppButton(
                text: languages.lblSave,
                color: primaryColor,
                width: context.width(),
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: loadingLists ? null : _save,
              ),
            ),
          ),
          Observer(
            builder: (_) =>
                const Loader().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}

class _DayDraft {
  String type;
  int dayOfWeek;
  int? workoutId;
  int? dietId;
  late TextEditingController weekCont;
  late TextEditingController dateCont;
  late TextEditingController waterCont;
  late TextEditingController stepsCont;

  _DayDraft({
    required this.type,
    int? weekNumber,
    this.dayOfWeek = 1,
    String? specificDate,
    this.workoutId,
    this.dietId,
    int? water,
    int? steps,
  }) {
    weekCont = TextEditingController(text: '${weekNumber ?? 1}');
    dateCont = TextEditingController(text: specificDate ?? '');
    waterCont = TextEditingController(text: '${water ?? 3000}');
    stepsCont = TextEditingController(text: '${steps ?? 10000}');
  }

  factory _DayDraft.fromModel(UgcProgramDay d) => _DayDraft(
        type: d.type ?? 'workout',
        weekNumber: d.weekNumber,
        dayOfWeek: d.dayOfWeek ?? 1,
        specificDate: d.specificDate,
        workoutId: d.workoutId,
        dietId: d.dietId,
        water: d.waterGoalMl,
        steps: d.stepsGoal,
      );

  Map<String, dynamic> toJson({required bool isRecurring}) {
    final Map<String, dynamic> data = {
      'type': type,
      'workout_id': type == 'rest' ? null : workoutId,
      'diet_id': dietId,
      'water_goal_ml': int.tryParse(waterCont.text.trim()),
      'steps_goal': int.tryParse(stepsCont.text.trim()),
    };
    if (isRecurring) {
      data['week_number'] = int.tryParse(weekCont.text.trim()) ?? 1;
      data['day_of_week'] = dayOfWeek;
    } else {
      data['specific_date'] = dateCont.text.trim();
    }
    return data;
  }

  void dispose() {
    weekCont.dispose();
    dateCont.dispose();
    waterCont.dispose();
    stepsCont.dispose();
  }
}
