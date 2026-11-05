import '../utils/shared_import.dart';

enum UgcAttributeKind { level, workoutType, categoryDiet }

class UgcAttributeFormScreen extends StatefulWidget {
  final UgcAttributeKind kind;
  final dynamic item;

  const UgcAttributeFormScreen({
    super.key,
    required this.kind,
    this.item,
  });

  @override
  State<UgcAttributeFormScreen> createState() => _UgcAttributeFormScreenState();
}

class _UgcAttributeFormScreenState extends State<UgcAttributeFormScreen> {
  final titleCont = TextEditingController();
  final rateCont = TextEditingController(text: '1');

  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item is LevelModel) {
      titleCont.text = item.title.validate();
      rateCont.text = '${item.rate ?? 1}';
    } else if (item is WorkoutTypeModel) {
      titleCont.text = item.title.validate();
    } else if (item is CategoryDietModel) {
      titleCont.text = item.title.validate();
    }
  }

  @override
  void dispose() {
    titleCont.dispose();
    rateCont.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.kind) {
      case UgcAttributeKind.level:
        return isEdit ? languages.lblEdit : languages.lblUgcCreateLevel;
      case UgcAttributeKind.workoutType:
        return isEdit ? languages.lblEdit : languages.lblUgcCreateWorkoutType;
      case UgcAttributeKind.categoryDiet:
        return isEdit ? languages.lblEdit : languages.lblUgcCreateCategory;
    }
  }

  Future<void> _save() async {
    if (titleCont.text.trim().isEmpty) {
      toast(languages.lblUgcTitleRequired);
      return;
    }

    appStore.setLoading(true);
    try {
      FitnessBaseResponse res;
      switch (widget.kind) {
        case UgcAttributeKind.level:
          final Map<String, dynamic> req = {
            if (isEdit && widget.item is LevelModel)
              'id': (widget.item as LevelModel).id,
            'title': titleCont.text.trim(),
            'rate': int.tryParse(rateCont.text.trim()) ?? 1,
          };
          res = isEdit
              ? await updateUgcLevelApi(req)
              : await saveUgcLevelApi(req);
          break;
        case UgcAttributeKind.workoutType:
          final Map<String, dynamic> req = {
            if (isEdit && widget.item is WorkoutTypeModel)
              'id': (widget.item as WorkoutTypeModel).id,
            'title': titleCont.text.trim(),
            'rate': int.tryParse(rateCont.text.trim()) ?? 1,
          };
          res = isEdit
              ? await updateUgcWorkoutTypeApi(req)
              : await saveUgcWorkoutTypeApi(req);
          break;
        case UgcAttributeKind.categoryDiet:
          final Map<String, dynamic> req = {
            if (isEdit && widget.item is CategoryDietModel)
              'id': (widget.item as CategoryDietModel).id,
            'title': titleCont.text.trim(),
          };
          res = isEdit
              ? await updateUgcCategoryDietApi(req)
              : await saveUgcCategoryDietApi(req);
          break;
      }
      toast(res.message.validate(value: languages.lblDone));
      if (mounted) finish(context, true);
    } catch (e) {
      toast(e.toString());
    }
    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final bool showRate = widget.kind != UgcAttributeKind.categoryDiet;

    return Scaffold(
      appBar: appBarWidget(_title, context: context),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppTextField(
                  controller: titleCont,
                  textFieldType: TextFieldType.NAME,
                  decoration: defaultInputDecoration(
                    context,
                    hint: languages.lblName,
                  ),
                ),
                if (showRate) ...[
                  12.height,
                  AppTextField(
                    controller: rateCont,
                    textFieldType: TextFieldType.PHONE,
                    keyboardType: TextInputType.number,
                    decoration: defaultInputDecoration(
                      context,
                      hint: languages.lblUgcRate,
                    ),
                  ),
                ],
                24.height,
                AppButton(
                  text: languages.lblSave,
                  color: primaryColor,
                  width: context.width(),
                  onTap: _save,
                ),
              ],
            ),
          ),
          Observer(
            builder: (_) => const Loader().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
