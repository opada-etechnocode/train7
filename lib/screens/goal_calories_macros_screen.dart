import '../utils/shared_import.dart';

class GoalCaloriesMacrosScreen extends StatefulWidget {
  const GoalCaloriesMacrosScreen({super.key});

  @override
  _GoalCaloriesMacrosScreenState createState() =>
      _GoalCaloriesMacrosScreenState();
}

class _GoalCaloriesMacrosScreenState extends State<GoalCaloriesMacrosScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(languages.lblGoalCaloriesMacros, context: context),
    body: Column(
      children: [
        mOption(ic_bmr1, languages.lblGoal, () {
          const GoalSelectionScreen(step: 5).launch<void>(context);
        }, context),
        const Divider(height: 0),
        mOption(ic_level, languages.lblActivityLevel, () {
          const GoalSelectionScreen(step: 6).launch<void>(context);
        }, context),
        const Divider(height: 0),
        mOption(ic_calories, languages.lblMacrosDietType, () {
          const GoalSelectionScreen(step: 7).launch<void>(context);
        }, context),
        const Divider(height: 0),
      ],
    ),
  );
}
