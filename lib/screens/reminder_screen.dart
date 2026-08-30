import '../utils/shared_import.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  bool? isSet = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {}

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      languages.lblDailyReminders,
      context: context,
      actions: [
        IconButton(
          onPressed: () async {
            final bool? res = await const SetReminderScreen().launch(context);
            if (res == true) {
              setState(() {});
            }
          },
          icon: const Icon(Icons.add, color: primaryColor),
        ),
      ],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Container(
            decoration: appStore.isDarkMode
                ? boxDecorationWithRoundedCorners(borderRadius: radius(12))
                : boxDecorationRoundedWithShadow(
                    12,
                    spreadRadius: 0,
                    blurRadius: 6,
                    shadowColor: Colors.grey.shade200,
                  ),
            child: ListTile(
              title: Text(languages.lblMealswater, style: primaryTextStyle()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const MealsWaterReminderScreen(),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: notificationStore.mRemindList.isNotEmpty
              ? AnimatedListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  itemCount: notificationStore.mRemindList.length,
                  itemBuilder: (context, index) {
                    final DateTime duration = DateTime.parse(
                      notificationStore.mRemindList[index].duration.validate(),
                    );
                    final String formattedTime = DateFormat.jm().format(
                      duration,
                    );
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: appStore.isDarkMode
                          ? boxDecorationWithRoundedCorners(
                              borderRadius: radius(12),
                            )
                          : boxDecorationRoundedWithShadow(
                              12,
                              spreadRadius: 0,
                              blurRadius: 6,
                              shadowColor: Colors.grey.shade200,
                            ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notificationStore.mRemindList[index].title
                                    .validate(),
                                style: boldTextStyle(size: 18),
                              ),
                              const Icon(
                                MaterialCommunityIcons.delete_outline,
                              ).paddingAll(4).onTap(() {
                                AwesomeNotifications().cancel(
                                  notificationStore.mRemindList[index].id
                                      .validate(),
                                );
                                notificationStore.removeToReminder(
                                  notificationStore.mRemindList[index],
                                );
                                setState(() {});
                              }),
                            ],
                          ),
                          6.height,
                          Text(
                            "${weekdays[notificationStore.mRemindList[index].week.toInt() - 1]} ${formattedTime.validate()} | ${notificationStore.mRemindList[index].subTitle.validate()}",
                            style: secondaryTextStyle(),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      no_data_found,
                      height: context.height() * 0.2,
                      width: context.width() * 0.4,
                    ),
                    16.height,
                    Text(
                      languages.lblNotificationEmpty,
                      style: boldTextStyle(),
                    ),
                  ],
                ).center(),
        ),
      ],
    ),
  );
}
