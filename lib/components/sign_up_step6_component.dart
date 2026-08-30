import '../utils/registration_data.dart';
import '../utils/shared_import.dart';

class SignUpStep6Component extends StatefulWidget {
  final bool isEdit;
  final void Function(String)? onSelect;

  const SignUpStep6Component({super.key, this.isEdit = false, this.onSelect});

  @override
  State<SignUpStep6Component> createState() => _SignUpStep6ComponentState();
}

class _SignUpStep6ComponentState extends State<SignUpStep6Component> {
  String selectedActivity = '';

  @override
  void initState() {
    super.initState();
    if (userStore.activityLevel.isNotEmpty) {
      selectedActivity = userStore.activityLevel;
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(languages.lblWhatsYourActivityLevel, style: boldTextStyle(size: 22)),
        24.height,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: RegistrationData.getAvailableActivityLevels().length,
          itemBuilder: (BuildContext context, int index) {
            final String key = RegistrationData.getAvailableActivityLevels()
                .keys
                .elementAt(index);
            final String value = RegistrationData.getAvailableActivityLevels()
                .values
                .elementAt(index);
            final bool isSelected = selectedActivity == key;

            String title = value;
            String subTitle = '';

            if (value.contains('|')) {
              title = value.split('|').first;
              subTitle = value.split('|').last;
            } else {
              title = value;
              subTitle = '';
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: isSelected
                    ? primaryColor
                    : primaryColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.transparent,
                ),
              ),
              child: RadioListTile<String>(
                value: key,
                groupValue: selectedActivity,
                onChanged: (val) {
                  setState(() {
                    selectedActivity = val!;
                  });
                  if (!widget.isEdit && widget.onSelect != null) {
                    widget.onSelect!.call(selectedActivity);
                  }
                },
                title: Text(
                  title,
                  style: boldTextStyle(
                    color: isSelected ? Colors.white : textPrimaryColorGlobal,
                  ),
                ),
                subtitle: Text(
                  subTitle,
                  style: secondaryTextStyle(
                    size: 14,
                    color: isSelected
                        ? Colors.white70
                        : textSecondaryColorGlobal,
                  ),
                ),
                activeColor: isSelected ? Colors.white : primaryColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ).onTap(() {
              setState(() {
                selectedActivity = key;
              });
              if (!widget.isEdit && widget.onSelect != null) {
                widget.onSelect!.call(selectedActivity);
              }
            });
          },
        ),
        24.height,
        AppButton(
          text: widget.isEdit ? languages.lblSave : languages.lblNext,
          width: context.width(),
          color: primaryColor,
          onTap: () {
            if (selectedActivity.isNotEmpty) {
              if (widget.isEdit && widget.onSelect != null) {
                widget.onSelect!.call(selectedActivity);
              } else {
                userStore.setActivityLevel(selectedActivity);
                appStore.signUpIndex = 6;
                setState(() {});
              }
            } else {
              toast(languages.lblSelectActivityLevel);
            }
          },
        ),
      ],
    ),
  );
}
