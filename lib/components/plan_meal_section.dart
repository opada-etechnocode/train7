import 'package:cached_network_image/cached_network_image.dart';
import '../utils/shared_import.dart';

class PlanMealSection extends StatelessWidget {
  final String mealType;
  final String title;
  final int kcal;
  final int p;
  final int c;
  final int f;
  final List<DailyPlanRecipeItem> recipes;
  final VoidCallback onAddMeal;
  final void Function(DailyPlanRecipeItem, String) onMoveRecipe;
  final void Function(String) onDeleteAll;
  final void Function(DailyPlanRecipeItem, String) onToggleCompletion;
  final void Function(DailyPlanRecipeItem, String) onShowRecipeDetail;

  const PlanMealSection({
    super.key,
    required this.mealType,
    required this.title,
    required this.kcal,
    required this.p,
    required this.c,
    required this.f,
    required this.recipes,
    required this.onAddMeal,
    required this.onMoveRecipe,
    required this.onDeleteAll,
    required this.onToggleCompletion,
    required this.onShowRecipeDetail,
  });

  @override
  Widget build(BuildContext context) => DragTarget<DailyPlanRecipeItem>(
      onWillAcceptWithDetails: (details) => details.data.mealType != mealType,
      onAcceptWithDetails: (details) {
        onMoveRecipe(details.data, mealType);
      },
      builder: (context, candidateData, rejectedData) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: candidateData.isNotEmpty
              ? primaryColor.withValues(alpha: 0.1)
              : context.cardColor,
          borderRadius: radius(12),
          border: candidateData.isNotEmpty
              ? Border.all(color: primaryColor)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Text(title, style: boldTextStyle(size: 18))),
                if (recipes.isNotEmpty)
                  SizedBox(
                    width: 30,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 22,
                      icon: Icon(Icons.more_vert, color: textSecondaryColorGlobal),
                      onSelected: (value) async {
                        if (value == 'delete_all') {
                          showConfirmDialogCustom(
                            context,
                            dialogType: DialogType.DELETE,
                            title: 'Delete all recipes in $title?', // todo
                            positiveText: 'Delete', // todo
                            negativeText: 'Cancel', // todo
                            onAccept: (c) {
                              onDeleteAll(mealType);
                            },
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          height: 1,
                          value: 'delete_all',
                          child: Text(languages.lblDeleteall, style: primaryTextStyle()),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            6.height,
            Text(
              '$kcal ${languages.lblKcal.validate()} | $p P | $c C | $f F',
              style: secondaryTextStyle(size: 13),
            ),
            12.height,
            ...recipes.map(
              (item) => LongPressDraggable<DailyPlanRecipeItem>(
                data: item,
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: context.width() - 40,
                    padding: const EdgeInsets.all(12),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: context.cardColor,
                      borderRadius: radius(12),
                      boxShadow: defaultBoxShadow(),
                    ),
                    child: Row(
                      children: [
                        if (item.recipe?.recipeImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.recipe!.recipeImage!,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        12.width,
                        Expanded(
                          child: Text(
                            item.recipe?.title ?? '',
                            style: boldTextStyle(size: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _buildRecipeItem(item, mealType, context),
                ),
                child: _buildRecipeItem(item, mealType, context),
              ),
            ),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [6, 4],
              color: Colors.grey.shade400,
              child: Material(
                color:
                    (appStore.isDarkMode
                            ? Colors.grey.shade900
                            : Colors.grey.shade100)
                        .withValues(alpha: 0.5),
                borderRadius: radius(12),
                child: InkWell(
                  onTap: onAddMeal,
                  borderRadius: radius(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Icon(
                      Icons.add,
                      size: 26,
                      color: textSecondaryColorGlobal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildRecipeItem(
    DailyPlanRecipeItem item,
    String mealType,
    BuildContext context,
  ) => GestureDetector(
    onTap: () => onShowRecipeDetail(item, mealType),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.transparent,
      child: Row(
        children: [
          if (item.recipe?.recipeImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.recipe!.recipeImage!,
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
            ),
          12.width,
          Expanded(
            child: Text(
              item.recipe?.title ?? '',
              style: boldTextStyle(size: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.calories} ${languages.lblKcal.validate()}',
                style: secondaryTextStyle(size: 12),
              ),
            ],
          ),
          12.width,
          GestureDetector(
            onTap: () => onToggleCompletion(item, mealType),
            child: Icon(
              item.isComplete == true
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              color: item.isComplete == true ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}
