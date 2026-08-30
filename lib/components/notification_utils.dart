import '../utils/shared_import.dart';

int createUniqueId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final DateTime timeOfDay;
  final String title;
  final String subTitle;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
    required this.title,
    required this.subTitle,
  });
}

class NotificationDaily {
  final int hour;
  final int min;

  NotificationDaily({required this.hour, required this.min});
}

Future<NotificationWeekAndTime?> pickSchedule(BuildContext context) async {
  final List<String> weekdays = [
    'Every Monday',
    'Every Tuesday',
    'Every Wednesday',
    'Every Thursday',
    'Every Friday',
    'Every Saturday',
    'Every Sunday',
  ];
  TimeOfDay? timeOfDay;
  final DateTime now = DateTime.now();
  int? selectedDay;
  int? currentIndex = -1;
  await showInDialog<void>(
    context,
    shape: RoundedRectangleBorder(borderRadius: radius()),
    builder: (_) => SizedBox(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.topLeft,
            decoration: boxDecorationWithShadow(
              backgroundColor: primaryColor,
              borderRadius: radiusOnly(
                topRight: defaultRadius,
                topLeft: defaultRadius,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languages.lblRepeat,
                  style: boldTextStyle(size: 20, color: Colors.white),
                ).paddingLeft(12),
                const CloseButton(color: Colors.white),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: weekdays.length,
            itemBuilder: (BuildContext context, int index) => RadioListTile(
              value: index,
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              groupValue: currentIndex,
              activeColor: primaryColor,
              title: Text(weekdays[index], style: primaryTextStyle()),
              onChanged: (dynamic val) {
                currentIndex = val;

                selectedDay = index + 1;
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.zero,
  );

  if (selectedDay != null) {
    if (!context.mounted) return null;
    timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 1))),
      builder: (BuildContext context, Widget? child) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(primary: primaryColor),
        ),
        child: child!,
      ),
    );

    if (timeOfDay != null) {
      if (!context.mounted) return null;
      final String mTime = timeOfDay.format(context);
      final ReminderModel reminderModel = ReminderModel();
      reminderModel.id = notificationStore.mRemindList.length + 1;
      reminderModel.status = 0;
      reminderModel.duration = mTime;
      reminderModel.week = weekdays[currentIndex!];
      reminderModel.title = "<YOUR_APP_NAME>";
      reminderModel.subTitle = "Testing";
      notificationStore.addToReminder(reminderModel);
    }
  }
  return null;
}
