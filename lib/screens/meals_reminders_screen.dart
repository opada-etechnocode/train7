import '../service/reminder_notification_service.dart';
import '../utils/shared_import.dart';

class MealsRemindersScreen extends StatefulWidget {
  const MealsRemindersScreen({super.key});

  @override
  State<MealsRemindersScreen> createState() => _MealsRemindersScreenState();
}

class _MealsRemindersScreenState extends State<MealsRemindersScreen> {
  bool breakfastEnabled = true;
  bool snacksEnabled = true;
  bool lunchEnabled = true;
  bool dinnerEnabled = true;

  TimeOfDay breakfastTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay snacksTime = const TimeOfDay(hour: 10, minute: 30);
  TimeOfDay lunchTime = const TimeOfDay(hour: 13, minute: 0);
  TimeOfDay dinnerTime = const TimeOfDay(hour: 20, minute: 0);

  bool _isSaving = false;

  Future<void> _pickTime({
    required TimeOfDay current,
    required ValueChanged<TimeOfDay> onSelected,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(primary: primaryColor),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

  Widget _mealSection({
    required String title,
    required bool enabled,
    required ValueChanged<bool> onToggle,
    required TimeOfDay time,
    required VoidCallback onPickTime,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: boldTextStyle(size: 16)),
      8.height,
      Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(12),
          backgroundColor: context.cardColor,
          boxShadow: defaultBoxShadow(),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(languages.lblReminders, style: primaryTextStyle()),
              trailing: Switch(
                value: enabled,
                activeThumbColor: Colors.amber.shade700,
                onChanged: onToggle,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              title: Text(languages.lblTime, style: primaryTextStyle()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time.format(context), style: secondaryTextStyle()),
                  8.width,
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: enabled ? onPickTime : null,
            ),
          ],
        ),
      ),
      16.height,
    ],
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (userStore.userProfile?.mealReminderSettings != null) {
      final MealReminderSettings settings =
          userStore.userProfile!.mealReminderSettings!;
      if (settings.breakfast != null) {
        breakfastEnabled = settings.breakfast!.enabled ?? true;
        if (settings.breakfast!.time != null) {
          breakfastTime = TimeOfDay(
            hour: int.parse(settings.breakfast!.time!.split(":")[0]),
            minute: int.parse(settings.breakfast!.time!.split(":")[1]),
          );
        }
      }
      if (settings.lunch != null) {
        lunchEnabled = settings.lunch!.enabled ?? true;
        if (settings.lunch!.time != null) {
          lunchTime = TimeOfDay(
            hour: int.parse(settings.lunch!.time!.split(":")[0]),
            minute: int.parse(settings.lunch!.time!.split(":")[1]),
          );
        }
      }
      if (settings.snacks != null) {
        snacksEnabled = settings.snacks!.enabled ?? true;
        if (settings.snacks!.time != null) {
          snacksTime = TimeOfDay(
            hour: int.parse(settings.snacks!.time!.split(":")[0]),
            minute: int.parse(settings.snacks!.time!.split(":")[1]),
          );
        }
      }
      if (settings.dinner != null) {
        dinnerEnabled = settings.dinner!.enabled ?? true;
        if (settings.dinner!.time != null) {
          dinnerTime = TimeOfDay(
            hour: int.parse(settings.dinner!.time!.split(":")[0]),
            minute: int.parse(settings.dinner!.time!.split(":")[1]),
          );
        }
      }
      setState(() {});
    }
  }

  Future<void> _saveSettings() async {
    if (_isSaving) {
      return;
    }
    final Map<String, dynamic> request = {
      "meal_reminder_settings": {
        "breakfast": {
          "enabled": breakfastEnabled,
          "time":
              "${breakfastTime.hour.toString().padLeft(2, '0')}:${breakfastTime.minute.toString().padLeft(2, '0')}",
        },
        "lunch": {
          "enabled": lunchEnabled,
          "time":
              "${lunchTime.hour.toString().padLeft(2, '0')}:${lunchTime.minute.toString().padLeft(2, '0')}",
        },
        "snacks": {
          "enabled": snacksEnabled,
          "time":
              "${snacksTime.hour.toString().padLeft(2, '0')}:${snacksTime.minute.toString().padLeft(2, '0')}",
        },
        "dinner": {
          "enabled": dinnerEnabled,
          "time":
              "${dinnerTime.hour.toString().padLeft(2, '0')}:${dinnerTime.minute.toString().padLeft(2, '0')}",
        },
      },
    };

    setState(() => _isSaving = true);
    appStore.setLoading(true);
    try {
      await setReminderSettingsApi(request);

      // Build meal settings from current screen state so store is up to date even if API doesn't return updated user_profile
      final newMealSettings = MealReminderSettings(
        breakfast: MealSetting(
          enabled: breakfastEnabled,
          time:
              "${breakfastTime.hour.toString().padLeft(2, '0')}:${breakfastTime.minute.toString().padLeft(2, '0')}",
        ),
        lunch: MealSetting(
          enabled: lunchEnabled,
          time:
              "${lunchTime.hour.toString().padLeft(2, '0')}:${lunchTime.minute.toString().padLeft(2, '0')}",
        ),
        snacks: MealSetting(
          enabled: snacksEnabled,
          time:
              "${snacksTime.hour.toString().padLeft(2, '0')}:${snacksTime.minute.toString().padLeft(2, '0')}",
        ),
        dinner: MealSetting(
          enabled: dinnerEnabled,
          time:
              "${dinnerTime.hour.toString().padLeft(2, '0')}:${dinnerTime.minute.toString().padLeft(2, '0')}",
        ),
      );

      final current = userStore.userProfile;
      userStore.setUserProfile(
        UserProfile(
          id: current?.id,
          age: current?.age,
          weight: current?.weight,
          weightUnit: current?.weightUnit,
          height: current?.height,
          heightUnit: current?.heightUnit,
          address: current?.address,
          userId: current?.userId,
          createdAt: current?.createdAt,
          updatedAt: current?.updatedAt,
          activity: current?.activity,
          goal: current?.goal,
          macroType: current?.macroType,
          waterReminderSettings: current?.waterReminderSettings,
          mealReminderSettings: newMealSettings,
        ),
      );
      await ReminderNotificationService.scheduleMealReminders(newMealSettings);

      toast(languages.lblDatasaved);
      if (mounted) {
        finish(context);
      }
    } on Exception catch (e) {
      toast(e.toString());
    } finally {
      appStore.setLoading(false);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      'Meals Reminders',
      context: context,
      actions: [
        TextButton(
          onPressed: _isSaving ? null : _saveSettings,
          child: Text(languages.lblSave, style: primaryTextStyle()),
        ).paddingRight(8),
      ],
    ),
    body: Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _mealSection(
                title: languages.lblBreakfast,
                enabled: breakfastEnabled,
                onToggle: (v) => setState(() => breakfastEnabled = v),
                time: breakfastTime,
                onPickTime: () async {
                  await _pickTime(
                    current: breakfastTime,
                    onSelected: (t) => setState(() => breakfastTime = t),
                  );
                },
              ),
              _mealSection(
                title: languages.lblSnacks,
                enabled: snacksEnabled,
                onToggle: (v) => setState(() => snacksEnabled = v),
                time: snacksTime,
                onPickTime: () async {
                  await _pickTime(
                    current: snacksTime,
                    onSelected: (t) => setState(() => snacksTime = t),
                  );
                },
              ),
              _mealSection(
                title: languages.lblLunch,
                enabled: lunchEnabled,
                onToggle: (v) => setState(() => lunchEnabled = v),
                time: lunchTime,
                onPickTime: () async {
                  await _pickTime(
                    current: lunchTime,
                    onSelected: (t) => setState(() => lunchTime = t),
                  );
                },
              ),
              _mealSection(
                title: languages.lblDinner,
                enabled: dinnerEnabled,
                onToggle: (v) => setState(() => dinnerEnabled = v),
                time: dinnerTime,
                onPickTime: () async {
                  await _pickTime(
                    current: dinnerTime,
                    onSelected: (t) => setState(() => dinnerTime = t),
                  );
                },
              ),
            ],
          ),
        ),
        if (_isSaving)
          Positioned.fill(
            child: AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Loader(),
              ),
            ),
          ),
      ],
    ),
  );
}
