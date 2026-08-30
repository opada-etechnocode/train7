import '../utils/shared_import.dart';

class FavouriteRecipeScreen extends StatefulWidget {
  const FavouriteRecipeScreen({super.key});

  @override
  State<FavouriteRecipeScreen> createState() => _FavouriteRecipeScreenState();
}

class _FavouriteRecipeScreenState extends State<FavouriteRecipeScreen> {
  List<RecipeItem> recipeList = [];
  bool isLoading = false;
  int page = 1;
  bool isLastPage = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLastPage && !isLoading) {
          page++;
          _fetchRecipes();
        }
      }
    });
  }

  Future<void> _fetchRecipes() async {
    if (page == 1) {
      setState(() => isLoading = true);
    }

    await getFavouriteRecipeApi(page: page)
        .then((value) {
          if (page == 1) {
            recipeList.clear();
          }

            recipeList.addAll(value.data);
            isLastPage =
                value.pagination?.currentPage == value.pagination?.totalPages;
          setState(() => isLoading = false);
        })
        .catchError((Object e) {
          setState(() => isLoading = false);
          toast(e.toString());
        });
  }

  Future<void> _showRecipeDetailBottomSheet(RecipeItem item) async {
    // Assuming we need item details here.
    // Favourite recipes might not have a dailyPlanId associated directly in the list,
    // but the RecipeDetailBottomSheet expects it in dailyPlanRecipeItem.
    // However, if we're just viewing favorite recipes, we might not be adding them to a plan.
    // The user's request didn't specify adding to plan from here, but the bottom sheet allows it if dailyPlanId is provided.

    final dailyPlanRecipeItem = DailyPlanRecipeItem(
      recipeId: item.id,
      calories: item.calories,
      protein: item.protein?.toInt(),
      carbs: item.carbs?.toInt(),
      fats: item.fats?.toInt(),
      recipe: Recipe(
        id: item.id,
        title: item.title,
        recipeImage: item.recipeImage,
        calories: item.calories,
        protein: item.protein?.toInt(),
        carbs: item.carbs?.toInt(),
        fats: item.fats?.toInt(),
      ),
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeDetailBottomSheet(
        recipeItem: dailyPlanRecipeItem,
        mealType: '', // Empty or default
      ),
    );

    // Refresh list in case it was un-favourited in the bottom sheet
    page = 1;
    _fetchRecipes();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget('Favourite Recipe', context: context),
    body: Stack(
      children: [
        if (recipeList.isNotEmpty)
          AnimatedListView(
            itemCount: recipeList.length,
            padding: const EdgeInsets.all(16),
            controller: _scrollController,
            itemBuilder: (context, index) {
              final item = recipeList[index];
              final String subtitle = (item.recipeCategory?.isNotEmpty ?? false)
                  ? item.recipeCategory!
                        .map((e) => e.title.validate())
                        .where((t) => t.isNotEmpty)
                        .join(', ')
                  : '';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(12),
                  backgroundColor: context.cardColor,
                  boxShadow: defaultBoxShadow(),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: cachedImage(
                        item.recipeImage.validate(),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    12.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.validate(),
                          style: boldTextStyle(size: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.height,
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: secondaryTextStyle(size: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ).expand(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${item.calories.validate()} kcal',
                          style: secondaryTextStyle(size: 12),
                        ),
                        4.height,
                        if (item.preparationTime.validate().isNotEmpty)
                          Text(
                            '${item.preparationTime.validate()} min',
                            style: secondaryTextStyle(size: 12),
                          ),
                      ],
                    ),
                  ],
                ).paddingAll(12),
              ).onTap(() => _showRecipeDetailBottomSheet(item));
            },
          ),
        if (isLoading) const Loader(),
        if (!isLoading && recipeList.isEmpty)
          const NoDataScreen(mTitle: "No favourite recipes found").center(),
      ],
    ),
  );
}
