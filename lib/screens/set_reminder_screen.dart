import '../utils/shared_import.dart';

class SetReminderScreen extends StatefulWidget {
  static String tag = '/SetReminderScreen';

  final bool? isDaily;

  const SetReminderScreen({super.key, this.isDaily = false});

  @override
  SetReminderScreenState createState() => SetReminderScreenState();
}

class SetReminderScreenState extends State<SetReminderScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();
  bool? isSet = false;
  DateTime _dateTime = DateTime.now();

  DateTime now = DateTime.now();
  Set<int> selectedDays = {}; // <-- Changed to Set for multi-selection
  int? currentIndex = -1;

  TextEditingController mReminderNameCount = TextEditingController();
  TextEditingController mDescriptionCont = TextEditingController();

  FocusNode mNameFocus = FocusNode();
  FocusNode mDescriptionFocus = FocusNode();

  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget("", context: context),
    body: SingleChildScrollView(
      child: Form(
        key: mFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hourMinute12H(),
            const Divider(),
            8.height,
            if (widget.isDaily != true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages.lblRepeat, style: boldTextStyle(size: 20)),
                  8.height,
                  Text(
                    languages.lblEveryday,
                    style: primaryTextStyle(color: primaryColor, size: 14),
                  ).onTap(() {
                    setState(() {
                      if (selectedDays.length == 7) {
                        selectedDays.clear(); // Deselect all
                      } else {
                        selectedDays = {0, 1, 2, 3, 4, 5, 6}; // Select all
                      }
                    });
                  }),
                  16.height,
                  HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: weekdays.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bool isSelected = selectedDays.contains(index);
                      return Container(
                        width: 40,
                        padding: const EdgeInsets.all(12),
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          backgroundColor: isSelected
                              ? primaryColor
                              : primaryOpacity,
                        ),
                        child: Text(
                          weekdays[index].substring(0, 1).toUpperCase(),
                          style: boldTextStyle(
                            color: isSelected ? white : primaryColor,
                          ),
                        ).center(),
                      ).onTap(() {
                        setState(() {
                          if (isSelected) {
                            selectedDays.remove(index);
                          } else {
                            selectedDays.add(index);
                          }
                        });
                      });
                    },
                  ),
                  24.height,
                ],
              ),
            Text(
              languages.lblReminderName,
              style: secondaryTextStyle(color: textPrimaryColorGlobal),
            ),
            8.height,
            AppTextField(
              controller: mReminderNameCount,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              focus: mNameFocus,
              nextFocus: mDescriptionFocus,
              decoration: defaultInputDecoration(
                context,
                label: languages.lblEnterReminderName,
              ),
            ),
            24.height,
            Text(
              languages.lblDescription,
              style: secondaryTextStyle(color: textPrimaryColorGlobal),
            ),
            8.height,
            AppTextField(
              controller: mDescriptionCont,
              textFieldType: TextFieldType.OTHER,
              isValidationRequired: true,
              focus: mDescriptionFocus,
              decoration: defaultInputDecoration(
                context,
                label: languages.lblEnterDescription,
              ),
            ),
            24.height,
            AppButton(
              text: languages.lblSave,
              width: context.width(),
              color: primaryColor,
              onTap: () async {
                if (mFormKey.currentState!.validate()) {
                  if (widget.isDaily == true) {
                    for (int i = 1; i <= 7; i++) {
                      await AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: i,
                          channelKey: 'basic_channel',
                          title: mReminderNameCount.text.validate(),
                          body: mDescriptionCont.text.validate(),
                        ),
                        schedule: NotificationCalendar(
                          weekday: i,
                          hour: _dateTime.hour,
                          minute: _dateTime.minute,
                          second: 0,
                          allowWhileIdle: true,
                          repeats: true,
                        ),
                      );
                    }
                  } else {
                    if (selectedDays.isEmpty) {
                      toast(languages.lblSelectday);
                    } else {
                      for (int dayIndex in selectedDays) {
                        final int day = dayIndex + 1;

                        final ReminderModel reminderModel = ReminderModel();
                        reminderModel.id =
                            notificationStore.mRemindList.length + 1;
                        reminderModel.status = 0;
                        reminderModel.duration = _dateTime.toString();
                        reminderModel.week = day.toString();
                        reminderModel.title = mReminderNameCount.text
                            .validate();
                        reminderModel.subTitle = mDescriptionCont.text
                            .validate();

                        notificationStore.addToReminder(reminderModel);

                        NotificationWeekAndTime(
                          dayOfTheWeek: day,
                          timeOfDay: _dateTime,
                          title: mReminderNameCount.text.validate(),
                          subTitle: mDescriptionCont.text.validate(),
                        );

                        await AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            id: notificationStore.mRemindList.length + 1,
                            channelKey: 'scheduled_channel',
                            title: mReminderNameCount.text.validate(),
                            body: mDescriptionCont.text.validate(),
                          ),
                          schedule: NotificationCalendar(
                            weekday: day,
                            hour: _dateTime.hour,
                            minute: _dateTime.minute,
                            second: 0,
                            allowWhileIdle: true,
                            repeats: true,
                          ),
                        );
                      }
                      if (!context.mounted) return;
                      finish(context, true);
                      if (!mounted) return;
                      setState(() {});
                    }
                  }
                  // finish(context, true);
                  // setState(() {});
                }
              },
            ),
            16.height,
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    ),
  );

  Widget hourMinute12H() => TimePickerSpinner(
    spacing: 50,
    normalTextStyle: boldTextStyle(size: 24, color: textColor),
    highlightedTextStyle: boldTextStyle(size: 28),
    alignment: Alignment.center,
    is24HourMode: false,
    isForce2Digits: true,
    onTimeChange: (time) {
      setState(() {
        _dateTime = time;
      });
    },
  );
}
