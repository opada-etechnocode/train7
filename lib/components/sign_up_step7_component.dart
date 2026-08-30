import '../utils/registration_data.dart';
import '../utils/shared_import.dart';

class SignUpStep7Component extends StatefulWidget {
  final Future<void> Function()? onSave;
  final bool isEdit;
  final void Function(String, Map<String, int>)? onSelect;

  const SignUpStep7Component({
    super.key,
    this.onSave,
    this.isEdit = false,
    this.onSelect,
  });

  @override
  State<SignUpStep7Component> createState() => _SignUpStep7ComponentState();
}

class _SignUpStep7ComponentState extends State<SignUpStep7Component> {
  String selectedMacro = '';
  bool _isLoading = false;

  int customCarbs = 40;
  int customProtein = 30;
  int customFat = 30;

  @override
  void initState() {
    super.initState();
    if (userStore.macroType.isNotEmpty) {
      selectedMacro = userStore.macroType;
    }
    customCarbs = userStore.customCarbs;
    customProtein = userStore.customProtein;
    customFat = userStore.customFat;
    _normalizeMacros();
  }

  void _updateMacro(String type, int newValue) {
    int oldValue;
    if (type == 'carbs') {
      oldValue = customCarbs;
    } else if (type == 'protein') {
      oldValue = customProtein;
    } else {
      oldValue = customFat;
    }

    final int diff = newValue - oldValue;
    if (diff == 0) return;

    setState(() {
      if (type == 'carbs') {
        customCarbs = newValue;
        _distributeDiff(diff, ['protein', 'fat']);
      } else if (type == 'protein') {
        customProtein = newValue;
        _distributeDiff(diff, ['carbs', 'fat']);
      } else if (type == 'fat') {
        customFat = newValue;
        _distributeDiff(diff, ['carbs', 'protein']);
      }
    });
  }

  void _distributeDiff(int diff, List<String> otherTypes) {
    // Distribute diff to other two macros proportionally
    int v1, v2;
    if (otherTypes[0] == 'carbs') {
      v1 = customCarbs;
    } else if (otherTypes[0] == 'protein') {
      v1 = customProtein;
    } else {
      v1 = customFat;
    }

    if (otherTypes[1] == 'carbs') {
      v2 = customCarbs;
    } else if (otherTypes[1] == 'protein') {
      v2 = customProtein;
    } else {
      v2 = customFat;
    }

    final int totalOther = v1 + v2;

    if (totalOther == 0) {
      // If both others are 0, split diff evenly
      final int change = (diff / 2).round();
      _applyChange(otherTypes[0], -change);
      _applyChange(otherTypes[1], -(diff - change));
    } else {
      final int change1 = (diff * v1 / totalOther).round();
      final int change2 = diff - change1;
      _applyChange(otherTypes[0], -change1);
      _applyChange(otherTypes[1], -change2);
    }

    // Ensure sum is exactly 100 and values are >= 5
    _normalizeMacros();
  }

  void _applyChange(String type, int change) {
    if (type == 'carbs') {
      customCarbs += change;
    } else if (type == 'protein') {
      customProtein += change;
    } else {
      customFat += change;
    }
  }

  void _normalizeMacros() {
    customCarbs = customCarbs.clamp(5, 90);
    customProtein = customProtein.clamp(5, 90);
    customFat = customFat.clamp(5, 90);

    final int total = customCarbs + customProtein + customFat;
    if (total != 100) {
      final int diff = 100 - total;
      // Add diff to the largest one to minimize relative impact
      if (customCarbs >= customProtein && customCarbs >= customFat) {
        customCarbs += diff;
      } else if (customProtein >= customCarbs && customProtein >= customFat) {
        customProtein += diff;
      } else {
        customFat += diff;
      }
    }
  }

  Future<void> saveData() async {
    hideKeyboard(context);
    final UserProfile userProfile = UserProfile();
    userProfile.age = userStore.age.validate();
    userProfile.heightUnit = userStore.heightUnit.validate();
    userProfile.height = userStore.height.validate();
    userProfile.weight = userStore.weight.validate();
    userProfile.weightUnit = userStore.weightUnit.validate();
    userProfile.activity = userStore.activityLevel.validate();
    userProfile.goal = userStore.goal.validate();
    userProfile.macroType = userStore.macroType.validate();
    if (selectedMacro == 'custom') {
      userProfile.carbs = customCarbs;
      userProfile.protein = customProtein;
      userProfile.fat = customFat;
    }

    Map<String, dynamic> req;

    req = {
      'first_name': userStore.fName.validate(),
      'last_name': userStore.lName.validate(),
      'username': getBoolAsync(IS_OTP) != true
          ? userStore.email.validate()
          : userStore.phoneNo.validate(),
      'email': userStore.email.validate(),
      'password': userStore.password.validate(),
      'user_type': LoginUser,
      'status': statusActive,
      'phone_number': userStore.phoneNo.validate(),
      'gender': userStore.gender.validate().toLowerCase(),
      'user_profile': userProfile.toJson(),
      "player_id": getStringAsync(PLAYER_ID).validate(),
      if (getBoolAsync(IS_OTP) != false) "login_type": LoginTypeOTP,
    };

    setState(() => _isLoading = true);
    await registerApi(req)
        .then((value) async {
          userStore.setLogin(true);
          userStore.setToken(value.data!.apiToken.validate());
          if (!mounted) return;
          getUSerDetail(context, value.data!.id)
              .then((value) {
                if (!mounted) return;
                const DashboardScreen().launch<void>(context, isNewTask: true);
              })
              .catchError((Object e) {
                if (mounted) setState(() => _isLoading = false);
                log("error=>$e");
              });
        })
        .catchError((Object e) {
          if (mounted) setState(() => _isLoading = false);
          toast(e.toString());
        });
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(languages.lblWhichtypeofdietdoyouwant, style: boldTextStyle(size: 22)),
        24.height,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: RegistrationData.getMacroRatios().length + 1,
          itemBuilder: (BuildContext context, int index) {
            String key;
            Map<String, int> value;

            final Map<String, Map<String, int>> macroRatios =
                RegistrationData.getMacroRatios();

            if (index < macroRatios.length) {
              key = macroRatios.keys.elementAt(index);
              value = macroRatios.values.elementAt(index);
            } else {
              key = 'custom';
              value = {
                'carbs': customCarbs,
                'protein': customProtein,
                'fat': customFat,
              };
            }

            final bool isSelected = selectedMacro == key;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: isSelected
                    ? primaryColor
                    : primaryColor.withValues(alpha: (0.1)),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.transparent,
                ),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: key,
                    groupValue: selectedMacro,
                    onChanged: (val) {
                      setState(() {
                        selectedMacro = val!;
                      });
                    },
                    title: Text(
                      key == 'custom'
                          ? languages.lblCustom
                          : key.capitalizeFirstLetter().replaceAll('_', ' '),
                      style: boldTextStyle(
                        color: isSelected
                            ? Colors.white
                            : textPrimaryColorGlobal,
                      ),
                    ),
                    subtitle: Text(
                      "Carbs: ${value['carbs']}%, Protein: ${value['protein']}%, Fat: ${value['fat']}%",
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
                  if (isSelected && key == 'custom')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          _buildMacroRow(
                            label: languages.lblProteins,
                            percentage: customProtein,
                            onChanged: (val) =>
                                _updateMacro('protein', val.round()),
                          ),
                          16.height,
                          _buildMacroRow(
                            label: languages.lblCarbs,
                            percentage: customCarbs,
                            onChanged: (val) =>
                                _updateMacro('carbs', val.round()),
                          ),
                          16.height,
                          _buildMacroRow(
                            label: languages.lblFats,
                            percentage: customFat,
                            onChanged: (val) =>
                                _updateMacro('fat', val.round()),
                          ),
                          8.height,
                        ],
                      ),
                    ),
                ],
              ),
            ).onTap(() {
              setState(() {
                selectedMacro = key;
              });
            });
          },
        ),
        24.height,
        AppButton(
          text: widget.isEdit ? languages.lblSave : languages.lblDone,
          width: context.width(),
          color: primaryColor,
          onTap: () {
            if (selectedMacro.isNotEmpty) {
              userStore.setMacroType(selectedMacro);
              if (selectedMacro == 'custom') {
                userStore.setCustomMacros(
                  carbs: customCarbs,
                  protein: customProtein,
                  fat: customFat,
                );
              }
              if (widget.isEdit && widget.onSelect != null) {
                widget.onSelect!.call(selectedMacro, {
                  'carbs_pct': customCarbs,
                  'protein_pct': customProtein,
                  'fat_pct': customFat,
                });
              } else if (widget.onSave != null) {
                widget.onSave!.call();
              } else {
                saveData();
              }
            } else {
              toast(languages.lblPleaseselectadiettype);
            }
          },
        ),
      ],
        ),
      ),
      const Loader().center().visible(_isLoading),
    ],
  );

  Widget _buildMacroRow({
    required String label,
    required int percentage,
    required ValueChanged<double> onChanged,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: boldTextStyle(
              color: selectedMacro == 'custom'
                  ? Colors.white
                  : textPrimaryColorGlobal,
            ),
          ),
          _buildValueBox("$percentage %"),
        ],
      ),
      8.height,
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white.withValues(alpha: (0.3)),
          thumbColor: Colors.white,
          overlayColor: Colors.white.withValues(alpha: 0.2),
          trackHeight: 4,
        ),
        child: Slider(
          value: percentage.toDouble().clamp(5, 90),
          min: 5,
          max: 90,
          onChanged: onChanged,
        ),
      ),
    ],
  );

  Widget _buildValueBox(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: boxDecorationWithRoundedCorners(
      backgroundColor: context.cardColor,
      border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      borderRadius: radius(8),
    ),
    child: Text(text, style: primaryTextStyle(size: 14)),
  );
}
