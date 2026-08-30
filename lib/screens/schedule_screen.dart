import '../utils/shared_import.dart';

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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    //  final timezoneOffset = now.timeZoneOffset;
    final timezoneName = now.timeZoneName;
    // log('Timezone Name: $timezoneOffset');
    log('Timezone Name: $timezoneName');

    callScheduleApi();
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
    //  commaSeparatedValues.isNotEmpty?commaSeparatedValues:DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    await getClassSchedule(selectedDate: dataSet, page: page)
        .then((value) {
          final Iterable<ScheduledModelData> it = value.data ?? [];
          numPage = value.pagination?.totalPages;
          isLastPage = false;

          if (page == 1) {
            scheduledWorkoutList.clear();
          }

          it.map((e) => scheduledWorkoutList.add(e)).toList();
          log("-----------85>>>>${scheduledWorkoutList.length}");
          appStore.setLoading(false);
          setState(() {});
        })
        .catchError((Object e, StackTrace s) {
          log("-------------89>>${e.toString()}");
          log("-------------90>>${s.toString()}");
          isLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        })
        .whenComplete(() {
          appStore.setLoading(false);
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBarWidget(
        // languages.scheduledWorkoutList,
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
                  initialDisplayDate: height == 300
                      ? DateTime.now()
                      : DateTime.now(),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    numberOfWeeksInView: numberOfWeeksInView ?? 6,
                    //  firstDayOfWeek: 1
                  ),
                  initialSelectedDates: _selectedDays,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is List<DateTime>) {
                          _selectedDays = List<DateTime>.from(args.value);
                        }
                        callScheduleApi();
                        setState(() {});
                      },
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3)),
                  ),
                ),
              ),
              Expanded(
                child: AnimatedListView(
                  controller: scrollController,
                  itemCount: scheduledWorkoutList.length,
                  itemBuilder: (context, index) => ScheduledComponent(
                    scheduledWorkoutList: scheduledWorkoutList[index],
                    myCallback: (String price, String id) async {
                      debugPrint('---id----$id-------');
                      debugPrint('---price----$price-------');
                      final String? refresh = await PaymentScheduledScreen(
                        price: price,
                        sceduledId: id,
                      ).launch(context);
                      if (refresh == 'refresh') {
                        callScheduleApi();
                      }
                    },
                  ),
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
}
