import '../extensions/date_time_extensions.dart';
import '../utils/shared_import.dart';

class PlanWeekStrip extends StatelessWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDay;
  final List<String> plannedDays;
  final void Function(DateTime) onDaySelected;

  const PlanWeekStrip({
    super.key,
    required this.weekDays,
    required this.selectedDay,
    required this.plannedDays,
    required this.onDaySelected,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: context.cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (i) {
          final date = weekDays.isNotEmpty
              ? weekDays[i]
              : DateTime.now().add(Duration(days: i));
          final isSelected =
              weekDays.isNotEmpty && _isSameDay(date, selectedDay);
          return Expanded(
            child: GestureDetector(
              onTap: () => onDaySelected(date),
              child: Column(
                children: [
                  Text(
                    days[i],
                    style: secondaryTextStyle(
                      size: 12,
                      color: isSelected
                          ? Colors.white
                          : textSecondaryColorGlobal,
                    ),
                  ),
                  4.height,
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: boldTextStyle(
                        size: 14,
                        color: isSelected
                            ? Colors.white
                            : textPrimaryColorGlobal,
                      ),
                    ),
                  ),
                  6.height,
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: plannedDays.contains(getDateTimeString(date))
                          ? primaryColor
                          : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
