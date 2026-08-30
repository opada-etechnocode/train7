import 'package:cached_network_image/cached_network_image.dart';

import '../utils/shared_import.dart';

class RecipeDetailBottomSheet extends StatefulWidget {
  final DailyPlanRecipeItem recipeItem;
  final String mealType;
  final String? date;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  const RecipeDetailBottomSheet({
    super.key,
    required this.recipeItem,
    required this.mealType,
    this.date,
    this.onDelete,
    this.onUpdate,
  });

  @override
  State<RecipeDetailBottomSheet> createState() =>
      _RecipeDetailBottomSheetState();
}

class _RecipeDetailBottomSheetState extends State<RecipeDetailBottomSheet> {
  TextEditingController quantityController = TextEditingController(text: '1');
  String servingUnit =
      'medium (40 g)'; // Default static for now as data isn't in model
  bool isComplete = false;
  bool isSaving = false;
  bool isFavourite = false;
  bool isFavLoading = false;

  RecipeDetailResponse? recipeDetail;
  bool isDetailLoading = true;
  bool isStepsExpanded = false;
  bool isIngredientsExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchRecipeDetail();
  }

  Future<void> _fetchRecipeDetail() async {
    final recipeId = widget.recipeItem.recipeId;
    if (recipeId == null) {
      setState(() => isDetailLoading = false);
      return;
    }

    try {
      final res = await getRecipeDetailApi(recipeId: recipeId);
      if (!mounted) return;
      setState(() {
        recipeDetail = res;
        isDetailLoading = false;
        isFavourite = res.data?.isFavourite == 1;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => isDetailLoading = false);
      toast(e.toString());
    }
  }

  Future<void> _toggleFavourite() async {
    final recipeId = widget.recipeItem.recipeId;
    if (recipeId == null) return;

    setState(() => isFavLoading = true);

    final Map<String, dynamic> req = {'recipe_id': recipeId};

    try {
      await setFavouriteRecipeApi(req);
      setState(() {
        isFavourite = !isFavourite;
        isFavLoading = false;
      });
    } on Exception catch (e) {
      setState(() => isFavLoading = false);
      toast(e.toString());
    }
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.dividerColor, width: 0.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: boldTextStyle(size: 14)).expand(),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 16).onTap(onToggle),
        if (isExpanded) Divider(height: 1, color: context.dividerColor),
        if (isExpanded) child,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipeItem.recipe;
    if (recipe == null) return const SizedBox.shrink();

    final bool isPlanMode = widget.onDelete != null || widget.onUpdate != null;

    final calories = widget.recipeItem.calories ?? 0;
    final protein = widget.recipeItem.protein ?? 0;
    final carbs = widget.recipeItem.carbs ?? 0;
    final fats = widget.recipeItem.fats ?? 0;

    // Calculate percentages for the bar graph
    final totalMacros = protein + carbs + fats;
    final proteinPercent = totalMacros > 0 ? (protein / totalMacros) : 0.0;
    final carbsPercent = totalMacros > 0 ? (carbs / totalMacros) : 0.0;
    final fatsPercent = totalMacros > 0 ? (fats / totalMacros) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            16.height,

            // Favourite Button on top
            if (userStore.isLoggedIn)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: isFavLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        )
                      : Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: isFavourite ? Colors.red : Colors.grey,
                        ),
                ).onTap(_toggleFavourite),
              ),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: recipe.recipeImage.validate(),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                placeHolderWidget(height: 80, width: 80),
                            errorWidget: (_, __, ___) =>
                                placeHolderWidget(height: 80, width: 80),
                          ),
                        ),
                      ) /*
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),*/,
                    ],
                  ),
                  12.height,
                  Text(
                    recipe.title.validate(),
                    style: boldTextStyle(size: 20),
                    textAlign: TextAlign.center,
                  ),
                  4.height,
                  Text(
                    languages.lblGeneric,
                    style: secondaryTextStyle(size: 14),
                  ),
                ],
              ),
            ),
            20.height,

            // Nutritional Facts (4 Bordered Boxes)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNutrientBox('$calories', 'kcal'),
                  12.width,
                  _buildNutrientBox('$protein g', 'protein'),
                  12.width,
                  _buildNutrientBox('$carbs g', 'carbs'),
                  12.width,
                  _buildNutrientBox('$fats g', 'fat'),
                ],
              ),
            ),
            24.height,
            // Macros Graph
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: [
                        if (proteinPercent > 0)
                          Expanded(
                            flex: (proteinPercent * 100).toInt(),
                            child: Container(height: 8, color: Colors.brown),
                          ),
                        if (proteinPercent > 0) 2.width,
                        if (carbsPercent > 0)
                          Expanded(
                            flex: (carbsPercent * 100).toInt(),
                            child: Container(
                              height: 8,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        if (carbsPercent > 0) 2.width,
                        if (fatsPercent > 0)
                          Expanded(
                            flex: (fatsPercent * 100).toInt(),
                            child: Container(
                              height: 8,
                              color: Colors.amber.shade200,
                            ),
                          ),
                      ],
                    ),
                  ),
                  12.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem(
                        'Proteins',
                        (proteinPercent * 100).toInt(),
                        Colors.brown,
                      ),
                      _buildLegendItem(
                        'Carbs',
                        (carbsPercent * 100).toInt(),
                        Colors.orangeAccent,
                      ),
                      _buildLegendItem(
                        'Fats',
                        (fatsPercent * 100).toInt(),
                        Colors.amber.shade200,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            24.height,

            // Collapsible Sections from API
            if (isDetailLoading)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Loader(),
              )
            else ...[
              _buildExpandableSection(
                title: languages.lblRecipesteps,
                isExpanded: isStepsExpanded,
                onToggle: () {
                  setState(() => isStepsExpanded = !isStepsExpanded);
                },
                child: (recipeDetail?.recipeSteps?.isNotEmpty ?? false)
                    ? Column(
                        children: recipeDetail!.recipeSteps!
                            .map(
                              (s) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${s.sequence ?? ''}'.trim().isNotEmpty
                                        ? '${s.sequence}.'
                                        : '-',
                                    style: boldTextStyle(size: 12),
                                  ),
                                  12.width,
                                  Text(
                                    s.instruction.validate(),
                                    style: primaryTextStyle(size: 12),
                                  ).expand(),
                                ],
                              ).paddingSymmetric(horizontal: 16, vertical: 10),
                            )
                            .toList(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No steps found',
                          style: secondaryTextStyle(),
                        ),
                      ),
              ),
              _buildExpandableSection(
                title: languages.lblIngredients,
                isExpanded: isIngredientsExpanded,
                onToggle: () {
                  setState(
                    () => isIngredientsExpanded = !isIngredientsExpanded,
                  );
                },
                child: (recipeDetail?.recipeIngredients?.isNotEmpty ?? false)
                    ? Column(
                        children: recipeDetail!.recipeIngredients!
                            .map(
                              (i) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i.ingredientName.validate().isNotEmpty
                                        ? i.ingredientName.validate()
                                        : 'Ingredient',
                                    style: primaryTextStyle(size: 12),
                                  ).expand(),
                                  12.width,
                                  Text(
                                    '${i.quantity ?? ''} ${i.measurementUnitName.validate()}'
                                        .trim(),
                                    style: secondaryTextStyle(size: 12),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 16, vertical: 10),
                            )
                            .toList(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No ingredients found',
                          style: secondaryTextStyle(),
                        ),
                      ),
              ),
            ],
            24.height,

            /*   // Quantity & Serving Inputs
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages.lblQuantity, style: boldTextStyle(size: 12)),
                        8.height,
                        AppTextField(
                          controller: quantityController,
                          textFieldType: TextFieldType.NUMBER,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  16.width,
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages.lblServing, style: boldTextStyle(size: 12)),
                        8.height,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                                servingUnit,
                                style: primaryTextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            24.height,*/

            // Bottom Action Buttons
            if (userStore.isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(16),
              child: isPlanMode
                  ? AppButton(
                      text: languages.lblDelete,
                color: primaryColor,
                textColor: Colors.black,
                width: double.infinity,
                      onTap: widget.onDelete,
                      shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isComplete = !isComplete;
                                });
                              },
                              child: Icon(
                                isComplete == true
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: isComplete == true
                                    ? primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            8.width,
                            Text(
                              languages.lblMarkThisRecipeAsCompleted,
                              style: primaryTextStyle(),
                            ).expand(),
                          ],
                        ),
                        12.height,
                        AppButton(
                          text:
                              'Add to ${widget.mealType.capitalizeFirstLetter()}', // todo
                          color: primaryColor,
                          textColor: Colors.black,
                          width: double.infinity,
                          onTap: isSaving
                              ? null
                              : () async {
                                  if (widget.recipeItem.dailyPlanId == null ||
                                      widget.recipeItem.recipeId == null) {
                                    toast(languages.lblInvalidrecipedata);
                                    return;
                                  }
                                  setState(() => isSaving = true);
                                  final req = {
                                    'id': null,
                                    'daily_plan_id':
                                        widget.recipeItem.dailyPlanId,
                                    'recipe_id': widget.recipeItem.recipeId,
                                    'meal_type': widget.mealType,
                                    'is_complete': isComplete,
                                    'date': widget.date,
                                  };

                                    try {
                                      await saveDailyPlanRecipeApi(req);
                                      toast(languages.lblRecipeaddedsuccessfully);
                                      if (!context.mounted) return;
                                      Navigator.pop(context, true);
                                      Navigator.pop(context, true);
                                    } on Exception catch (e) {
                                      toast(e.toString());
                                    } finally {
                                      if (mounted) {
                                        setState(() => isSaving = false);
                                      }
                                    }
                                  },
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          12.height,
                        ],
                      ),
            ),
            6.height,
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientBox(String value, String label) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: context.dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: boldTextStyle(size: 14),
            textAlign: TextAlign.center,
          ),
          4.height,
          Text(
            label,
            style: secondaryTextStyle(size: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  Widget _buildLegendItem(String label, int percent, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      6.width,
      Text('$label $percent%', style: primaryTextStyle(size: 12)),
    ],
  );
}
