import '../utils/registration_data.dart';
import '../utils/shared_import.dart';

class SignUpStep5Component extends StatefulWidget {
  final bool isEdit;
  final void Function(String)? onSelect;

  const SignUpStep5Component({super.key, this.isEdit = false, this.onSelect});

  @override
  State<SignUpStep5Component> createState() => _SignUpStep5ComponentState();
}

class _SignUpStep5ComponentState extends State<SignUpStep5Component> {
  String selectedGoal = '';

  @override
  void initState() {
    super.initState();
    if (userStore.goal.isNotEmpty) {
      selectedGoal = userStore.goal;
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(languages.lblWhatsYourGoal, style: boldTextStyle(size: 22)),
        8.height,
        Text(
          languages.lblGoalSubtitle,
          style: secondaryTextStyle(),
        ),
        24.height,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: RegistrationData.getAvailableFitnessGoals().length,
          itemBuilder: (BuildContext context, int index) {
            final String key = RegistrationData.getAvailableFitnessGoals().keys
                .elementAt(index);
            final String value = RegistrationData.getAvailableFitnessGoals()
                .values
                .elementAt(index);
            final bool isSelected = selectedGoal == key;

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
                groupValue: selectedGoal,
                onChanged: (val) {
                  setState(() {
                    selectedGoal = val!;
                  });
                  if (!widget.isEdit && widget.onSelect != null) {
                    widget.onSelect!.call(selectedGoal);
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
                selectedGoal = key;
              });
              if (!widget.isEdit && widget.onSelect != null) {
                widget.onSelect!.call(selectedGoal);
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
            if (selectedGoal.isNotEmpty) {
              if (widget.isEdit && widget.onSelect != null) {
                widget.onSelect!.call(selectedGoal);
              } else {
                userStore.setGoal(selectedGoal);
                appStore.signUpIndex = 5;
                setState(() {});
              }
            } else {
              toast(languages.lblSelectGoal);
            }
          },
        ),
      ],
    ),
  );
}
