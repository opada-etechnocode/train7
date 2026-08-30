import '../utils/shared_import.dart';

class PostDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const PostDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => AppTextField(
      controller: controller,
      textFieldType: TextFieldType.MULTILINE,
      isValidationRequired: true,
      decoration: defaultInputDecoration(
        context,
        label: languages.writeSomeThing,
      ),
      onChanged: (value) {},
    );
}
