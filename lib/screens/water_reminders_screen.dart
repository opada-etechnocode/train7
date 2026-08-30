import '../service/reminder_notification_service.dart';
import '../utils/shared_import.dart';

class WaterRemindersScreen extends StatefulWidget {
  const WaterRemindersScreen({super.key});

  @override
  State<WaterRemindersScreen> createState() => _WaterRemindersScreenState();
}

class _WaterRemindersScreenState extends State<WaterRemindersScreen> {
  bool enabled = true;
  int everyHours = 1;

  TimeOfDay fromTime = TimeOfDay.now();
  TimeOfDay untilTime = TimeOfDay.now();
  TimeOfDay atTime = TimeOfDay.now();

  bool get is24Hours => everyHours == 24;

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

  Future<void> _pickEvery() async {
    final res = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Container(
          color: ctx.cardColor,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: 24,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final v = i + 1;
              final title = v == 1 ? '1 hour' : '$v hours';
              return ListTile(
                title: Text(title, style: primaryTextStyle()),
                trailing: v == everyHours
                    ? const Icon(Icons.check, color: primaryColor)
                    : null,
                onTap: () => Navigator.pop(ctx, v),
              );
            },
          ),
        ),
      ),
    );

    if (res != null) {
      setState(() {
        everyHours = res;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (userStore.userProfile?.waterReminderSettings != null) {
      enabled = userStore.userProfile!.waterReminderSettings!.enabled ?? true;
      final String start =
          userStore.userProfile!.waterReminderSettings!.start ?? "08:00";
      final String end =
          userStore.userProfile!.waterReminderSettings!.end ?? "20:00";
      final int interval =
          userStore.userProfile!.waterReminderSettings!.interval ?? 1;

      fromTime = TimeOfDay(
        hour: int.parse(start.split(":")[0]),
        minute: int.parse(start.split(":")[1]),
      );
      untilTime = TimeOfDay(
        hour: int.parse(end.split(":")[0]),
        minute: int.parse(end.split(":")[1]),
      );

      if (interval >= 60) {
        everyHours = interval ~/ 60;
      } else {
        everyHours =
            1; // Default if interval is less than 1 hour, though UI handles hours
      }

      if (everyHours == 24) {
        atTime = TimeOfDay(
          hour: int.parse(
            (userStore.userProfile!.waterReminderSettings!.atTime ?? "08:00")
                .split(":")[0],
          ),
          minute: int.parse(
            (userStore.userProfile!.waterReminderSettings!.atTime ?? "08:00")
                .split(":")[1],
          ),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_isSaving) {
      return;
    }
    final Map<String, dynamic> request = {
      "water_reminder_settings": {
        "enabled": enabled,
        "interval": everyHours * 60,
      },
    };

    if (is24Hours) {
      request["water_reminder_settings"]["at_time"] =
          "${atTime.hour.toString().padLeft(2, '0')}:${atTime.minute.toString().padLeft(2, '0')}";
    } else {
      request["water_reminder_settings"]["start"] =
          "${fromTime.hour.toString().padLeft(2, '0')}:${fromTime.minute.toString().padLeft(2, '0')}";
      request["water_reminder_settings"]["end"] =
          "${untilTime.hour.toString().padLeft(2, '0')}:${untilTime.minute.toString().padLeft(2, '0')}";
    }

    setState(() => _isSaving = true);
    appStore.setLoading(true);
    try {
      await setReminderSettingsApi(request);

      // Build water settings from current screen state so store is up to date even if API doesn't return updated user_profile
      final newWaterSettings = WaterReminderSettings(
        enabled: enabled,
        interval: everyHours * 60,
        start: is24Hours
            ? null
            : "${fromTime.hour.toString().padLeft(2, '0')}:${fromTime.minute.toString().padLeft(2, '0')}",
        end: is24Hours
            ? null
            : "${untilTime.hour.toString().padLeft(2, '0')}:${untilTime.minute.toString().padLeft(2, '0')}",
        atTime: is24Hours
            ? "${atTime.hour.toString().padLeft(2, '0')}:${atTime.minute.toString().padLeft(2, '0')}"
            : null,
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
          waterReminderSettings: newWaterSettings,
          mealReminderSettings: current?.mealReminderSettings,
        ),
      );
      await ReminderNotificationService.scheduleWaterReminders(
        newWaterSettings,
      );

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

  Widget _row({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) => ListTile(
    title: Text(title, style: primaryTextStyle()),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: secondaryTextStyle()),
        8.width,
        const Icon(Icons.chevron_right),
      ],
    ),
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      'Water Reminders',
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
        Padding(
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
                  title: Text(languages.lblReminders, style: primaryTextStyle()),
                  trailing: Switch(
                    value: enabled,
                    activeThumbColor: Colors.amber.shade700,
                    onChanged: (v) => setState(() => enabled = v),
                  ),
                ),
                const Divider(height: 1),
                _row(
                  title: languages.lblEvery,
                  value: everyHours == 1 ? '1 hour' : '$everyHours hours',
                  onTap: enabled ? _pickEvery : null,
                ),
                const Divider(height: 1),
                if (!is24Hours) ...[
                  _row(
                    title: languages.lblFrom,
                    value: fromTime.format(context),
                    onTap: enabled
                        ? () async {
                            await _pickTime(
                              current: fromTime,
                              onSelected: (t) => setState(() => fromTime = t),
                            );
                          }
                        : null,
                  ),
                  const Divider(height: 1),
                  _row(
                    title: languages.lblUntil,
                    value: untilTime.format(context),
                    onTap: enabled
                        ? () async {
                            await _pickTime(
                              current: untilTime,
                              onSelected: (t) => setState(() => untilTime = t),
                            );
                          }
                        : null,
                  ),
                ] else ...[
                  _row(
                    title: languages.lblAt,
                    value: atTime.format(context),
                    onTap: enabled
                        ? () async {
                            await _pickTime(
                              current: atTime,
                              onSelected: (t) => setState(() => atTime = t),
                            );
                          }
                        : null,
                  ),
                ],
              ],
            ),
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
