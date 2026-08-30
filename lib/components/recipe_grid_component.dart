import '../utils/shared_import.dart';

class RecipeGridComponent extends StatelessWidget {
  final RecipeItem recipe;
  final Function? onTap;

  const RecipeGridComponent({super.key, required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) =>
      SizedBox(
        width: context.width() / 2 - 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cachedImage(
              recipe.recipeImage.validate(),
              height: 150,
              width: context.width() / 2 - 24,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(12),
            8.height,
            Text(
              recipe.title.validate(),
              style: boldTextStyle(size: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            4.height,
            Text(
              "${recipe.calories ?? recipe.kcal.validate()} kCal",
              style: secondaryTextStyle(size: 12),
            ),
          ],
        ),
      ).onTap(() {
        if (onTap != null) {
          onTap?.call();
        } else {
          showRecipeDetailBottomSheetCustom(context, recipeItem: recipe);
        }
      });
}
