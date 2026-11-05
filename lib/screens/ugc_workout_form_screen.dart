import '../utils/shared_import.dart';

class UgcWorkoutFormScreen extends StatefulWidget {
  const UgcWorkoutFormScreen({super.key});

  @override
  State<UgcWorkoutFormScreen> createState() => _UgcWorkoutFormScreenState();
}

class _UgcWorkoutFormScreenState extends State<UgcWorkoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleCont = TextEditingController();
  final descCont = TextEditingController();
  final exerciseIdCont = TextEditingController();
  final repsCont = TextEditingController(text: '10');
  final weightCont = TextEditingController(text: '20');

  List<LevelModel> levels = [];
  List<WorkoutTypeModel> types = [];
  int? levelId;
  int? typeId;
  bool isRest = false;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    try {
      levels = (await getUserLevelListApi()).data ?? [];
      types = (await getUserWorkoutTypeListApi()).data ?? [];
      if (levels.isEmpty) levels = (await getLevelListApi()).data ?? [];
      if (types.isEmpty) types = (await getWorkoutTypeListApi()).data ?? [];
      if (levels.isNotEmpty) levelId = levels.first.id;
      if (types.isNotEmpty) typeId = types.first.id;
      if (mounted) setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    titleCont.dispose();
    descCont.dispose();
    exerciseIdCont.dispose();
    repsCont.dispose();
    weightCont.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (levelId == null || typeId == null) {
      toast(languages.lblUgcNeedLevelType);
      return;
    }

    final Map<String, dynamic> req = UgcWorkoutPayload(
      title: titleCont.text.trim(),
      description: descCont.text.trim(),
      levelId: levelId,
      workoutTypeId: typeId,
      days: [
        UgcWorkoutDay(
          isRest: isRest,
          exercises: isRest
              ? []
              : [
                  UgcWorkoutExercise(
                    exerciseId: int.tryParse(exerciseIdCont.text.trim()),
                    sets: [
                      UgcWorkoutSet(
                        reps: int.tryParse(repsCont.text.trim()),
                        weight: num.tryParse(weightCont.text.trim()),
                      ),
                    ],
                  ),
                ],
        ),
      ],
    ).toJson();

    appStore.setLoading(true);
    try {
      final res = await saveUgcWorkoutApi(req);
      toast(res.message.validate(value: languages.lblDone));
      if (mounted) finish(context, true);
    } catch (e) {
      toast(e.toString());
    }
    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblUgcCreateWorkout, context: context),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                12.height,
                AppTextField(
                  controller: descCont,
                  textFieldType: TextFieldType.MULTILINE,
                  minLines: 2,
                  maxLines: 4,
                  decoration: defaultInputDecoration(
                    context,
                    hint: languages.lblDescription,
                  ),
                ),
                12.height,
                DropdownButtonFormField<int>(
                  initialValue: levelId,
                  decoration: defaultInputDecoration(
                    context,
                    hint: languages.lblLevels,
                  ),
                  items: levels
                      .where((e) => e.id != null)
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.title.validate()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => levelId = v),
                ),
                12.height,
                DropdownButtonFormField<int>(
                  initialValue: typeId,
                  decoration: defaultInputDecoration(
                    context,
                    hint: languages.lblWorkoutType,
                  ),
                  items: types
                      .where((e) => e.id != null)
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.title.validate()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => typeId = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(languages.lblUgcRestDay, style: boldTextStyle()),
                  value: isRest,
                  activeThumbColor: primaryColor,
                  onChanged: (v) => setState(() => isRest = v),
                ),
                if (!isRest) ...[
                  AppTextField(
                    controller: exerciseIdCont,
                    textFieldType: TextFieldType.PHONE,
                    keyboardType: TextInputType.number,
                    decoration: defaultInputDecoration(
                      context,
                      hint: languages.lblUgcExerciseId,
                    ),
                  ),
                  12.height,
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: repsCont,
                          textFieldType: TextFieldType.PHONE,
                          keyboardType: TextInputType.number,
                          decoration: defaultInputDecoration(
                            context,
                            hint: languages.lblUgcReps,
                          ),
                        ),
                      ),
                      8.width,
                      Expanded(
                        child: AppTextField(
                          controller: weightCont,
                          textFieldType: TextFieldType.PHONE,
                          keyboardType: TextInputType.number,
                          decoration: defaultInputDecoration(
                            context,
                            hint: languages.lblUgcWeight,
                          ),
                        ),
                      ),
                    ],
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
          ),
          Observer(
            builder: (_) => const Loader().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
