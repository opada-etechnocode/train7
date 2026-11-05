import '../utils/shared_import.dart';

class UgcDietFormScreen extends StatefulWidget {
  const UgcDietFormScreen({super.key});

  @override
  State<UgcDietFormScreen> createState() => _UgcDietFormScreenState();
}

class _UgcDietFormScreenState extends State<UgcDietFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleCont = TextEditingController();
  final descCont = TextEditingController();
  final ingredientsCont = TextEditingController();
  final caloriesCont = TextEditingController(text: '2000');
  final proteinCont = TextEditingController(text: '150');
  final carbsCont = TextEditingController(text: '200');
  final fatCont = TextEditingController(text: '70');

  List<CategoryDietModel> categories = [];
  int? categoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      categories = (await getUserCategoryDietListApi()).data ?? [];
      if (categories.isEmpty) {
        categories = (await getDietCategoryApi()).data ?? [];
      }
      if (categories.isNotEmpty) categoryId = categories.first.id;
      if (mounted) setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    titleCont.dispose();
    descCont.dispose();
    ingredientsCont.dispose();
    caloriesCont.dispose();
    proteinCont.dispose();
    carbsCont.dispose();
    fatCont.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (categoryId == null) {
      toast(languages.lblUgcNeedCategory);
      return;
    }

    final Map<String, dynamic> req = UgcDietPayload(
      title: titleCont.text.trim(),
      categoryDietId: categoryId,
      calories: num.tryParse(caloriesCont.text.trim()),
      protein: num.tryParse(proteinCont.text.trim()),
      carbs: num.tryParse(carbsCont.text.trim()),
      fat: num.tryParse(fatCont.text.trim()),
      description: descCont.text.trim(),
      ingredients: ingredientsCont.text.trim(),
    ).toJson();

    appStore.setLoading(true);
    try {
      final res = await saveUgcDietApi(req);
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
      appBar: appBarWidget(languages.lblUgcCreateDiet, context: context),
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
                DropdownButtonFormField<int>(
                  initialValue: categoryId,
                  decoration: defaultInputDecoration(
                    context,
                    hint: languages.lblUgcDietCategory,
                  ),
                  items: categories
                      .where((e) => e.id != null)
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.title.validate()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => categoryId = v),
                ),
                12.height,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: caloriesCont,
                        textFieldType: TextFieldType.PHONE,
                        keyboardType: TextInputType.number,
                        decoration: defaultInputDecoration(
                          context,
                          hint: languages.lblCalories,
                        ),
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: AppTextField(
                        controller: proteinCont,
                        textFieldType: TextFieldType.PHONE,
                        keyboardType: TextInputType.number,
                        decoration: defaultInputDecoration(
                          context,
                          hint: languages.lblProtein,
                        ),
                      ),
                    ),
                  ],
                ),
                12.height,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: carbsCont,
                        textFieldType: TextFieldType.PHONE,
                        keyboardType: TextInputType.number,
                        decoration: defaultInputDecoration(
                          context,
                          hint: languages.lblCarbs,
                        ),
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: AppTextField(
                        controller: fatCont,
                        textFieldType: TextFieldType.PHONE,
                        keyboardType: TextInputType.number,
                        decoration: defaultInputDecoration(
                          context,
                          hint: languages.lblFat,
                        ),
                      ),
                    ),
                  ],
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
                AppTextField(
                  controller: ingredientsCont,
                  textFieldType: TextFieldType.MULTILINE,
                  minLines: 2,
                  maxLines: 4,
                  decoration: defaultInputDecoration(
                    context,
                    hint: languages.lblUgcIngredients,
                  ),
                ),
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
