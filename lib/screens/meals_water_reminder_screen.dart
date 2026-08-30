import '../utils/shared_import.dart';

class MealsWaterReminderScreen extends StatelessWidget {
  const MealsWaterReminderScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget('Meals & Water', context: context),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(12),
          backgroundColor: context.cardColor,
          boxShadow: defaultBoxShadow(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.amber.shade700),
              title: Text(languages.lblMeals, style: primaryTextStyle()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const MealsRemindersScreen(),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.opacity, color: Colors.amber.shade700),
              title: Text(languages.lblWater, style: primaryTextStyle()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const WaterRemindersScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
