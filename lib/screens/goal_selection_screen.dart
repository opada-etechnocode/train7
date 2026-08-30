import '../utils/shared_import.dart';

class GoalSelectionScreen extends StatefulWidget {
  final int step;

  const GoalSelectionScreen({super.key, required this.step});

  @override
  _GoalSelectionScreenState createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    String title = '';
    if (widget.step == 5) {
      title = languages.lblGoal;
    }
    if (widget.step == 6) {
      title = languages.lblActivityLevel;
    }
    if (widget.step == 7) {
      title = languages.lblMacrosDietType;
    }

    return Scaffold(
      appBar: appBarWidget(title, context: context),
      body: _buildComponent(),
    );
  }

  Widget _buildComponent() {
    if (widget.step == 5) {
      return SignUpStep5Component(
        isEdit: true,
        onSelect: (val) {
          _confirmAndUpdate({'goal': val});
        },
      );
    } else if (widget.step == 6) {
      return SignUpStep6Component(
        isEdit: true,
        onSelect: (val) {
          _confirmAndUpdate({'activity': val});
        },
      );
    } else {
      return SignUpStep7Component(
        isEdit: true,
        onSelect: (type, customMacros) {
          final Map<String, dynamic> data = {'macro_type': type};
          if (type == 'custom') {
            data['carbs_pct'] = customMacros['carbs_pct'];
            data['protein_pct'] = customMacros['protein_pct'];
            data['fat_pct'] = customMacros['fat_pct'];
          }
          _confirmAndUpdate(data);
        },
      );
    }
  }

  Future<void> _confirmAndUpdate(Map<String, dynamic> data) async {
    final bool? res = await showConfirmDialogCustom(
      context,
      title:
          "Do you want us to recalculate your calories and macros according to your new information?",
      positiveText: languages.lblYes,
      negativeText: languages.lblNo,
      onAccept: (c) => true,
      onCancel: (c) => false,
    );

    if (res == true) {
      appStore.setLoading(true);

      final Map<String, dynamic> req = {
        'first_name': userStore.fName.validate(),
        'last_name': userStore.lName.validate(),
        'email': userStore.email.validate(),
        'gender': userStore.gender.validate().toLowerCase(),
        'username': userStore.username.validate(),
        'user_profile': {
          'activity': data.containsKey('activity')
              ? data['activity']
              : userStore.activityLevel,
          'goal': data.containsKey('goal') ? data['goal'] : userStore.goal,
          'macro_type': data.containsKey('macro_type')
              ? data['macro_type']
              : userStore.macroType,
          'carbs_pct': data.containsKey('carbs_pct')
              ? data['carbs_pct']
              : userStore.customCarbs,
          'protein_pct': data.containsKey('protein_pct')
              ? data['protein_pct']
              : userStore.customProtein,
          'fat_pct': data.containsKey('fat_pct')
              ? data['fat_pct']
              : userStore.customFat,
        },
      };

      await updateProfileApi(req)
          .then((value) async {
            if (!mounted) return;
            await getUSerDetail(context, userStore.userId);
            appStore.setLoading(false);
            toast(languages.lblUpdatedSuccessfully);
            if (!mounted) return;
            finish(context);
          })
          .catchError((Object e) {
            appStore.setLoading(false);
            toast(e.toString());
          });
    }
  }
}
