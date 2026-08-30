import '../utils/shared_import.dart';

class ScheduledComponent extends StatefulWidget {
  const ScheduledComponent({
    super.key,
    required this.scheduledWorkoutList,
    required this.myCallback,
  });

  final ScheduledModelData scheduledWorkoutList;
  final void Function(String price, String id) myCallback;

  @override
  State<ScheduledComponent> createState() => _ScheduledComponentState();
}

class _ScheduledComponentState extends State<ScheduledComponent> {
  @override
  void initState() {
    super.initState();
    getDays();
  }

  String formatTime(String startTime, String endTime) {
    final DateTime start = DateTime.parse('1970-01-01 $startTime');
    final DateTime end = DateTime.parse('1970-01-01 $endTime');

    final DateFormat formatter = DateFormat.jm();

    final String formattedStart = formatter.format(start);
    final String formattedEnd = formatter.format(end);

    return '$formattedStart - $formattedEnd';
  }

  String getDays() {
    final DateTime startDate = DateTime.parse(
      widget.scheduledWorkoutList.startDate ?? '',
    );
    final DateTime endDate = DateTime.parse(
      widget.scheduledWorkoutList.endDate ?? '',
    );

    final Duration difference = endDate.difference(startDate);

    final int days = difference.inDays;

    return days.toString();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 90,
            // width: 60,
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                (widget.scheduledWorkoutList.price != null &&
                        widget.scheduledWorkoutList.isClassSchedulePlan == 0)
                    ? '${userStore.currencySymbol} ${widget.scheduledWorkoutList.price} '
                    : widget.scheduledWorkoutList.price != null &&
                          widget.scheduledWorkoutList.isClassSchedulePlan == 1
                    ? languages.lblPurchases
                    : languages.lblFree,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  widget.scheduledWorkoutList.className ?? '',
                  style: primaryTextStyle(
                    color: appStore.isDarkMode ? Colors.white : Colors.black,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.scheduledWorkoutList.startDate}  TO  ${widget.scheduledWorkoutList.endDate}',
                  style: primaryTextStyle(
                    color: appStore.isDarkMode ? Colors.white : Colors.black,
                    size: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatTime(
                    widget.scheduledWorkoutList.startTime ?? '',
                    widget.scheduledWorkoutList.endTime ?? '',
                  ),
                  style: primaryTextStyle(
                    color: appStore.isDarkMode ? Colors.white : Colors.black,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: GestureDetector(
              onTap: () async {
                if (widget.scheduledWorkoutList.isPaid == '0') {
                  if (widget.scheduledWorkoutList.link != null) {
                    launchUrlString(widget.scheduledWorkoutList.link ?? '');
                  }
                } else {
                  if (widget.scheduledWorkoutList.isClassSchedulePlan == 1) {
                    if (widget.scheduledWorkoutList.link != null) {
                      launchUrlString(widget.scheduledWorkoutList.link ?? '');
                    }
                  } else {
                    widget.myCallback(
                      widget.scheduledWorkoutList.price.toString(),
                      widget.scheduledWorkoutList.id.toString(),
                    );
                  }
                }
              },
              child: Text(
                languages.lblJoin,
                style: boldTextStyle(color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
