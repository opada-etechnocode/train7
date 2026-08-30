import '../utils/shared_import.dart';

class PlanHeader extends StatelessWidget {
  final DateTime selectedDay;
  final int? dailyPlanId;
  final bool hasRecipes;
  final VoidCallback onClearDay;

  const PlanHeader({
    super.key,
    required this.selectedDay,
    this.dailyPlanId,
    this.hasRecipes = false,
    required this.onClearDay,
  });

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 20, color: textPrimaryColorGlobal),
              8.width,
              Text(
                selectedDay.isToday ? 'Today' : selectedDay.getDateTimeString,
                style: boldTextStyle(size: 18),
              ),
            ],
          ),
          const Spacer(),
          if (dailyPlanId != null)
            IconButton(
              icon: Icon(Icons.post_add, color: textPrimaryColorGlobal),
              onPressed: () {
                const ShoppingListScreen().launch(context);
              },
            ),
          if (hasRecipes)
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.more_horiz, size: 28, color: textPrimaryColorGlobal),
              onSelected: (value) {
                if (value == 'clear_day') {
                  showConfirmDialogCustom(
                    context,
                    dialogType: DialogType.DELETE,
                    title: languages.lblAreyousureyouwanttocleartheentiredayplan,
                    positiveText: 'Clear', // todo
                    negativeText: 'Cancel', // todo
                    onAccept: (c) {
                      onClearDay();
                    },
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'clear_day',
                  child: Text(languages.lblClearday, style: primaryTextStyle()),
                ),
              ],
            ),
        ],
      ),
    );
}
