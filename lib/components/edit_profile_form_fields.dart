import '../utils/shared_import.dart';

class EditProfileFormFields extends StatelessWidget {
  final TextEditingController fNameCont;
  final TextEditingController lNameCont;
  final TextEditingController emailCont;
  final TextEditingController phoneNumberCont;
  final TextEditingController ageCont;
  final TextEditingController weightCont;
  final TextEditingController heightCont;
  final FocusNode fNameFocus;
  final FocusNode lNameFocus;
  final FocusNode emailFocus;
  final FocusNode phoneNumberFocus;
  final FocusNode ageFocus;
  final FocusNode weightFocus;
  final FocusNode heightFocus;
  final GlobalKey<FormState> formKey;
  final List<GenderModel> genderList;
  final int selectGender;
  final VoidCallback onAgeTap;
  final VoidCallback onWeightTap;
  final VoidCallback onHeightTap;
  final ValueChanged<GenderModel?> onGenderChanged;
  final VoidCallback onSave;

  const EditProfileFormFields({
    super.key,
    required this.fNameCont,
    required this.lNameCont,
    required this.emailCont,
    required this.phoneNumberCont,
    required this.ageCont,
    required this.weightCont,
    required this.heightCont,
    required this.fNameFocus,
    required this.lNameFocus,
    required this.emailFocus,
    required this.phoneNumberFocus,
    required this.ageFocus,
    required this.weightFocus,
    required this.heightFocus,
    required this.formKey,
    required this.genderList,
    required this.selectGender,
    required this.onAgeTap,
    required this.onWeightTap,
    required this.onHeightTap,
    required this.onGenderChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      20.height,
      _buildField(
        label: languages.lblFirstName,
        controller: fNameCont,
        type: TextFieldType.NAME,
        focus: fNameFocus,
        nextFocus: lNameFocus,
        icon: ic_user,
        hint: languages.lblEnterFirstName,
        context: context,
      ),
      16.height,
      _buildField(
        label: languages.lblLastName,
        controller: lNameCont,
        type: TextFieldType.NAME,
        focus: lNameFocus,
        nextFocus: phoneNumberFocus,
        icon: ic_user,
        hint: languages.lblEnterLastName,
        context: context,
      ),
      16.height,
      _buildField(
        label: languages.lblEmail,
        controller: emailCont,
        type: TextFieldType.EMAIL,
        focus: emailFocus,
        nextFocus: phoneNumberFocus,
        icon: ic_mail,
        hint: languages.lblEnterEmail,
        readOnly: true,
        context: context,
      ),
      16.height,
      _buildField(
        label: languages.lblPhoneNumber,
        controller: phoneNumberCont,
        type: TextFieldType.PHONE,
        focus: phoneNumberFocus,
        nextFocus: ageFocus,
        icon: ic_call,
        hint: languages.lblEnterPhoneNumber,
        readOnly: true,
        context: context,
      ),
      16.height,
      Text(languages.lblAge, style: secondaryTextStyle()),
      4.height,
      AppTextField(
        readOnly: true,
        onTap: onAgeTap,
        controller: ageCont,
        textFieldType: TextFieldType.NUMBER,
        isValidationRequired: true,
        focus: ageFocus,
        nextFocus: weightFocus,
        keyboardType: TextInputType.number,
        suffix: mSuffixTextFieldIconWidget(ic_user),
        decoration: defaultInputDecoration(
          context,
          label: languages.lblEnterAge,
        ),
      ),
      16.height,
      Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(languages.lblWeight, style: secondaryTextStyle()),
            4.height,
            AppTextField(
              readOnly: true,
              onTap: onWeightTap,
              controller: weightCont,
              textFieldType: TextFieldType.NUMBER,
              focus: weightFocus,
              nextFocus: heightFocus,
              decoration: defaultInputDecoration(
                context,
                label: languages.lblEnterWeight,
              ),
            ),
            16.height,
            Text(languages.lblHeight, style: secondaryTextStyle()),
            4.height,
            AppTextField(
              readOnly: true,
              onTap: onHeightTap,
              controller: heightCont,
              textFieldType: TextFieldType.NUMBER,
              focus: heightFocus,
              decoration: defaultInputDecoration(
                context,
                label: languages.lblEnterHeight,
              ),
            ),
          ],
        ),
      ),
      16.height,
      Text(languages.lblGender, style: secondaryTextStyle()),
      4.height,
      DropdownButtonFormField<GenderModel>(
        items: genderList
            .map(
              (e) => DropdownMenuItem<GenderModel>(
                value: e,
                child: Text(
                  e.name.validate().capitalizeFirstLetter(),
                  style: primaryTextStyle(),
                ),
              ),
            )
            .toList(),
        initialValue: genderList.isNotEmpty
            ? genderList[selectGender]
            : null,
        borderRadius: radius(),
        decoration: defaultInputDecoration(context),
        onChanged: onGenderChanged,
      ),
      24.height,
      AppButton(
        text: languages.lblSave,
        width: context.width(),
        color: primaryColor,
        onTap: onSave,
      ),
      24.height,
    ],
  ).paddingSymmetric(horizontal: 16);

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required TextFieldType type,
    required FocusNode focus,
    FocusNode? nextFocus,
    required String icon,
    required String hint,
    required BuildContext context,
    bool readOnly = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: secondaryTextStyle()),
      4.height,
      AppTextField(
        controller: controller,
        textFieldType: type,
        isValidationRequired: true,
        focus: focus,
        nextFocus: nextFocus,
        readOnly: readOnly,
        suffix: mSuffixTextFieldIconWidget(icon),
        decoration: defaultInputDecoration(context, label: hint),
      ),
    ],
  );
}
