import '../service/ugc_plan_sync_service.dart';
import '../utils/shared_import.dart';
import 'program_day_detail_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  CalendarFormat calendarFormat = CalendarFormat.week;
  DateTime focusedDay = DateTime.now();
  List<ScheduledModelData> scheduledWorkoutList = [];
  List<DateTime> _selectedDays = [];
  ScrollController scrollController = ScrollController();
  int page = 1;
  int? numPage;
  bool isLastPage = false;
  double? height = 300;
  int? numberOfWeeksInView = 6;

  UgcProgramModel? _activeProgram;
  bool _openingDay = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    callScheduleApi();
    _loadActivePlan();
    _selectedDays.add(DateTime.now());
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          callScheduleApi();
        }
      }
    });
  }

  Future<void> _loadActivePlan() async {
    final UgcProgramModel? program =
        await UgcPlanSyncService.loadActiveProgram();
    if (!mounted) return;
    setState(() => _activeProgram = program);
  }

  Future<void> callScheduleApi() async {
    final String commaSeparatedValues = _selectedDays
        .map((date) => DateFormat('yyyy-MM-dd').format(date))
        .join(',');
    appStore.setLoading(true);
    final dataSet = commaSeparatedValues.isNotEmpty
        ? commaSeparatedValues
        : _selectedDays.isEmpty
            ? ''
            : DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    await getClassSchedule(selectedDate: dataSet, page: page)
        .then((value) {
          final Iterable<ScheduledModelData> it = value.data ?? [];
          numPage = value.pagination?.totalPages;
          isLastPage = false;

          if (page == 1) {
            scheduledWorkoutList.clear();
          }

          it.map((e) => scheduledWorkoutList.add(e)).toList();
          appStore.setLoading(false);
          setState(() {});
        })
        .catchError((Object e, StackTrace s) {
          log(e.toString());
          isLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        })
        .whenComplete(() {
          appStore.setLoading(false);
        });
  }

  Future<void> _openProgramDay(DateTime date) async {
    final int? programId =
        _activeProgram?.id ?? UgcPlanSyncService.activeProgramId;
    if (programId == null) {
      toast(languages.lblUgcNoPlanDay);
      return;
    }
    if (_openingDay) return;
    _openingDay = true;
    try {
      await ProgramDayDetailScreen(
        programId: programId,
        date: date,
        programName: _activeProgram?.name ?? UgcPlanSyncService.activeProgramName,
      ).launch<void>(context);
    } finally {
      _openingDay = false;
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
    super.build(context);
    final bool isDark = appStore.isDarkMode;

    return Scaffold(
      appBar: appBarWidget(
        languages.lblSchedule,
        context: context,
        showBack: false,
        titleSpacing: 16,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(languages.lblChangeView, style: primaryTextStyle()),
                  IconButton(
                    icon: Icon(
                      height == 300
                          ? Icons.calendar_view_month
                          : Icons.calendar_view_week,
                    ),
                    onPressed: () {
                      setState(() {
                        height = height == 300 ? 100 : 300;
                        numberOfWeeksInView = numberOfWeeksInView == 6 ? 1 : 6;
                      });
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
              SizedBox(
                height: height,
                child: SfDateRangePicker(
                  initialDisplayDate: DateTime.now(),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    numberOfWeeksInView: numberOfWeeksInView ?? 6,
                  ),
                  initialSelectedDates: _selectedDays,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    List<DateTime> next = _selectedDays;
                    DateTime? tapped;
                    if (args.value is List<DateTime>) {
                      next = List<DateTime>.from(args.value);
                      if (next.length > _selectedDays.length) {
                        tapped = next.firstWhere(
                          (d) => !_selectedDays.any(
                            (s) =>
                                s.year == d.year &&
                                s.month == d.month &&
                                s.day == d.day,
                          ),
                          orElse: () => next.last,
                        );
                      } else if (next.isNotEmpty) {
                        tapped = next.last;
                      }
                    } else if (args.value is DateTime) {
                      tapped = args.value as DateTime;
                      next = [tapped];
                    }
                    _selectedDays = next;
                    page = 1;
                    callScheduleApi();
                    setState(() {});

                    // Open plan day detail when user taps a day and a plan is active
                    if (tapped != null &&
                        (_activeProgram != null ||
                            UgcPlanSyncService.activeProgramId != null)) {
                      _openProgramDay(tapped);
                    }
                  },
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3)),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                  children: [
                    if (_activeProgram != null ||
                        UgcPlanSyncService.activeProgramId != null) ...[
                      Text(
                        '${languages.lblUgcPlanForDay}: ${(_activeProgram?.name ?? UgcPlanSyncService.activeProgramName).validate()}',
                        style: boldTextStyle(size: 15),
                      ),
                      6.height,
                      Text(
                        languages.lblUgcTapDayHint,
                        style: secondaryTextStyle(size: 12),
                      ),
                      10.height,
                      ...(_selectedDays.isEmpty
                              ? [DateTime.now()]
                              : _selectedDays)
                          .map((date) {
                        final UgcProgramDay? localDay = _activeProgram == null
                            ? null
                            : UgcPlanSyncService.dayForDate(
                                _activeProgram!,
                                date,
                              );
                        return InkWell(
                          onTap: () => _openProgramDay(date),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? darkCardColor : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: primaryColor.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('EEE d MMM').format(date),
                                        style: boldTextStyle(
                                          size: 13,
                                          color: primaryColor,
                                        ),
                                      ),
                                      6.height,
                                      Text(
                                        localDay == null
                                            ? languages.lblUgcTapDayHint
                                            : _typeLabel(localDay.type),
                                        style: secondaryTextStyle(),
                                      ),
                                      if (localDay != null) ...[
                                        8.height,
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            if (localDay.waterGoalMl != null)
                                              _chip(
                                                Icons.water_drop_outlined,
                                                '${localDay.waterGoalMl} ml',
                                              ),
                                            if (localDay.stepsGoal != null)
                                              _chip(
                                                Icons.directions_walk_rounded,
                                                '${localDay.stepsGoal} ${languages.lblSteps}',
                                              ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      8.height,
                      Divider(color: context.dividerColor),
                      8.height,
                    ],
                    if (scheduledWorkoutList.isEmpty &&
                        _activeProgram == null &&
                        UgcPlanSyncService.activeProgramId == null)
                      NoDataScreen(mTitle: languages.lblNoFoundData)
                          .paddingTop(40)
                    else
                      ...List.generate(
                        scheduledWorkoutList.length,
                        (index) => ScheduledComponent(
                          scheduledWorkoutList: scheduledWorkoutList[index],
                          myCallback: (String price, String id) async {
                            final String? refresh =
                                await PaymentScheduledScreen(
                              price: price,
                              sceduledId: id,
                            ).launch(context);
                            if (refresh == 'refresh') {
                              callScheduleApi();
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Observer(
            builder: (context) => Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
              child: const Loader().center(),
            ).visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }

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
