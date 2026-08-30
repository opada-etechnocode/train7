import '../models/recipe_filter_model.dart';
import '../utils/shared_import.dart';

class RecipeFilterBottomSheet extends StatefulWidget {
  final RecipeFilterModel filter;
  final void Function(RecipeFilterModel) onApply;

  const RecipeFilterBottomSheet({
    super.key,
    required this.filter,
    required this.onApply,
  });

  @override
  State<RecipeFilterBottomSheet> createState() =>
      _RecipeFilterBottomSheetState();
}

class _RecipeFilterBottomSheetState extends State<RecipeFilterBottomSheet> {
  late RecipeFilterModel tempFilter;
  bool isLoading = false;

  List<RecipeCategory> categories = [];
  List<RecipeTag> tags = [];

  final TextEditingController startCalCont = TextEditingController();
  final TextEditingController endCalCont = TextEditingController();
  final TextEditingController startProteinCont = TextEditingController();
  final TextEditingController endProteinCont = TextEditingController();
  final TextEditingController startCarbsCont = TextEditingController();
  final TextEditingController endCarbsCont = TextEditingController();
  final TextEditingController startFatsCont = TextEditingController();
  final TextEditingController endFatsCont = TextEditingController();
  final TextEditingController minPrepCont = TextEditingController();
  final TextEditingController maxPrepCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    tempFilter = RecipeFilterModel(
      startCalories: widget.filter.startCalories,
      endCalories: widget.filter.endCalories,
      startProtein: widget.filter.startProtein,
      endProtein: widget.filter.endProtein,
      startCarbs: widget.filter.startCarbs,
      endCarbs: widget.filter.endCarbs,
      startFats: widget.filter.startFats,
      endFats: widget.filter.endFats,
      minPreparationTime: widget.filter.minPreparationTime,
      maxPreparationTime: widget.filter.maxPreparationTime,
      recipeCategoryIds: List.from(widget.filter.recipeCategoryIds ?? []),
      recipeTagIds: List.from(widget.filter.recipeTagIds ?? []),
      mealTypes: List.from(widget.filter.mealTypes ?? []),
      isFavourite: widget.filter.isFavourite,
    );


    startCalCont.text = tempFilter.startCalories?.toString() ?? '';
    endCalCont.text = tempFilter.endCalories?.toString() ?? '';
    startProteinCont.text = tempFilter.startProtein?.toString() ?? '';
    endProteinCont.text = tempFilter.endProtein?.toString() ?? '';
    startCarbsCont.text = tempFilter.startCarbs?.toString() ?? '';
    endCarbsCont.text = tempFilter.endCarbs?.toString() ?? '';
    startFatsCont.text = tempFilter.startFats?.toString() ?? '';
    endFatsCont.text = tempFilter.endFats?.toString() ?? '';
    minPrepCont.text = tempFilter.minPreparationTime?.toString() ?? '';
    maxPrepCont.text = tempFilter.maxPreparationTime?.toString() ?? '';

    _fetchFilterData();
  }

  Future<void> _fetchFilterData() async {
    setState(() => isLoading = true);
    try {
      await Future.wait<void>([
        getRecipeCategoryListApi().then(
          (value) => categories = value.data ?? [],
        ),
        getRecipeTagListApi().then((value) => tags = value.data ?? []),
      ]);
    } on Exception catch (e) {
      toast(e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    startCalCont.dispose();
    endCalCont.dispose();
    startProteinCont.dispose();
    endProteinCont.dispose();
    startCarbsCont.dispose();
    endCarbsCont.dispose();
    startFatsCont.dispose();
    endFatsCont.dispose();
    minPrepCont.dispose();
    maxPrepCont.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: boldTextStyle(size: 16),
  ).paddingOnly(bottom: 8, top: 16);

  Widget _buildRangeInput(
    String label,
    TextEditingController start,
    TextEditingController end,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: secondaryTextStyle()),
      4.height,
      Row(
        children: [
          AppTextField(
            controller: start,
            textFieldType: TextFieldType.NUMBER,
            decoration: const InputDecoration(
              hintText: 'Min',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ).expand(),
          16.width,
          AppTextField(
            controller: end,
            textFieldType: TextFieldType.NUMBER,
            decoration: const InputDecoration(
              hintText: 'Max',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ).expand(),
        ],
      ),
    ],
  );

  Widget _buildHorizontalList<T>({
    required List<T> items,
    required String Function(T) labelBuilder,
    required int Function(T) idBuilder,
    required List<int> selectedIds,
    required void Function(int) onToggle,
  }) => HorizontalList(
    itemCount: items.length,
    padding: EdgeInsets.zero,
    itemBuilder: (BuildContext context, int index) {
      final item = items[index];
      final id = idBuilder(item);
      final isSelected = selectedIds.contains(id);

      return ChoiceChip(
        label: Text(labelBuilder(item)),
        selected: isSelected,
        onSelected: (_) => onToggle(id),
        selectedColor: primaryColor,
        labelStyle: primaryTextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ).paddingRight(8);
    },
  );

  @override
  Widget build(BuildContext context) => Container(
    height: context.height() * 0.8,
    padding: const EdgeInsets.all(16),
    decoration: boxDecorationWithRoundedCorners(
      borderRadius: radiusOnly(topLeft: 20, topRight: 20),
      backgroundColor: context.cardColor,
    ),
    child: isLoading
        ? const Loader().center()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(languages.lblFilters, style: boldTextStyle(size: 20)),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        final List<String>? savedMealTypes =
                            tempFilter.mealTypes;
                        final int? savedIsFavourite = tempFilter.isFavourite;
                        tempFilter.clear();
                        tempFilter.mealTypes = savedMealTypes;
                        tempFilter.isFavourite = savedIsFavourite;
                        tempFilter.recipeCategoryIds = [];
                        tempFilter.recipeTagIds = [];

                        startCalCont.clear();
                        endCalCont.clear();
                        startProteinCont.clear();
                        endProteinCont.clear();
                        startCarbsCont.clear();
                        endCarbsCont.clear();
                        startFatsCont.clear();
                        endFatsCont.clear();
                        minPrepCont.clear();
                        maxPrepCont.clear();
                      });
                    },
                    child: Text(
                      'Reset', // todo
                      style: primaryTextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
              16.height,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (categories.isNotEmpty) ...[
                        _buildSectionTitle('Categories'), // todo
                        _buildHorizontalList<RecipeCategory>(
                          items: categories,
                          labelBuilder: (c) => c.title.validate(),
                          idBuilder: (c) => c.id.validate(),
                          selectedIds: tempFilter.recipeCategoryIds ?? [],
                          onToggle: (id) {
                            setState(() {
                              if (tempFilter.recipeCategoryIds!.contains(id)) {
                                tempFilter.recipeCategoryIds!.remove(id);
                              } else {
                                tempFilter.recipeCategoryIds!.add(id);
                              }
                            });
                          },
                        ),
                      ],
                      if (tags.isNotEmpty) ...[
                        _buildSectionTitle('Tags'), // todo
                        _buildHorizontalList<RecipeTag>(
                          items: tags,
                          labelBuilder: (t) => t.title.validate(),
                          idBuilder: (t) => t.id.validate(),
                          selectedIds: tempFilter.recipeTagIds ?? [],
                          onToggle: (id) {
                            setState(() {
                              if (tempFilter.recipeTagIds!.contains(id)) {
                                tempFilter.recipeTagIds!.remove(id);
                              } else {
                                tempFilter.recipeTagIds!.add(id);
                              }
                            });
                          },
                        ),
                      ],
                      _buildSectionTitle('Nutrients'), // todo
                      _buildRangeInput(
                        'Calories (kCal)',
                        startCalCont,
                        endCalCont,
                      ),
                      12.height,
                      _buildRangeInput(
                        'Protein (g)',
                        startProteinCont,
                        endProteinCont,
                      ),
                      12.height,
                      _buildRangeInput(
                        'Carbs (g)',
                        startCarbsCont,
                        endCarbsCont,
                      ),
                      12.height,
                      _buildRangeInput('Fats (g)', startFatsCont, endFatsCont),

                      _buildSectionTitle('Preparation Time (min)'),// todo
                      _buildRangeInput('Time', minPrepCont, maxPrepCont), // todo
                      32.height,
                    ],
                  ),
                ),
              ),
              AppButton(
                text: languages.lblApplyFilters,
                width: context.width(),
                color: primaryColor,
                onTap: () {
                  tempFilter.startCalories = int.tryParse(startCalCont.text);
                  tempFilter.endCalories = int.tryParse(endCalCont.text);
                  tempFilter.startProtein = int.tryParse(startProteinCont.text);
                  tempFilter.endProtein = int.tryParse(endProteinCont.text);
                  tempFilter.startCarbs = int.tryParse(startCarbsCont.text);
                  tempFilter.endCarbs = int.tryParse(endCarbsCont.text);
                  tempFilter.startFats = int.tryParse(startFatsCont.text);
                  tempFilter.endFats = int.tryParse(endFatsCont.text);
                  tempFilter.minPreparationTime = int.tryParse(
                    minPrepCont.text,
                  );
                  tempFilter.maxPreparationTime = int.tryParse(
                    maxPrepCont.text,
                  );

                  widget.onApply(tempFilter);
                  finish(context);
                },
              ),
              16.height,
            ],
          ),
  );
}
