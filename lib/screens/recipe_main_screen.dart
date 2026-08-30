import '../utils/shared_import.dart';

class RecipeMainScreen extends StatefulWidget {
  const RecipeMainScreen({super.key});

  @override
  _RecipeMainScreenState createState() => _RecipeMainScreenState();
}

class _RecipeMainScreenState extends State<RecipeMainScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      "Recipe",
      color: primaryColor,
      textColor: Colors.white,
      context: context,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(languages.lblTags, style: boldTextStyle(size: 18)),
              const Icon(Icons.chevron_right, color: grey),
            ],
          ).onTap(() {
            const RecipeTagListScreen().launch<void>(context);
          }),
          16.height,
          const _RecipeTagSection(),
          24.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(languages.lblCategories, style: boldTextStyle(size: 18)),
              const Icon(Icons.chevron_right, color: grey),
            ],
          ).onTap(() {
            const RecipeCategoryListScreen().launch<void>(context);
          }),
          16.height,
          const _RecipeCategorySection(),
          24.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(languages.lblRecipes, style: boldTextStyle(size: 18)),
              const Icon(Icons.chevron_right, color: grey),
            ],
          ).onTap(() {
            const RecipeListScreenV2(title: "Recipes").launch<void>(context);
          }),
          16.height,
          SnapHelperWidget<DailyPlanRecipeListResponse>(
            future: getRecipeFilterListApi(mealTypes: []),
            onSuccess: (data) {
              if (data.data.validate().isEmpty) {
                return const SizedBox();
              }
              return HorizontalList(
                itemCount: data.data.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final RecipeItem item = data.data[index];
                  return RecipeGridComponent(recipe: item).paddingRight(16);
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}

class _RecipeTagSection extends StatefulWidget {
  const _RecipeTagSection();

  @override
  State<_RecipeTagSection> createState() => _RecipeTagSectionState();
}

class _RecipeTagSectionState extends State<_RecipeTagSection> {
  final List<RecipeTag> _tags = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllTags();
  }

  Future<void> _fetchAllTags() async {
    setState(() => _isLoading = true);
    try {
      int page = 1;
      num totalPages = 1;
      while (page <= totalPages) {
        final response = await getRecipeTagListApi(page: page);
        totalPages = response.pagination?.totalPages ?? 1;
        _tags.addAll(response.data.validate());
        page++;
      }
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tags.isEmpty && _isLoading) return const Loader().center().paddingSymmetric(vertical: 16);
    if (_tags.isEmpty) return const SizedBox();

    return HorizontalList(
      itemCount: _tags.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final RecipeTag item = _tags[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radius(20),
            border: Border.all(color: primaryColor.withValues(alpha: 0.5)),
            backgroundColor: context.cardColor,
          ),
          child: Row(
            children: [
              Text(item.title.validate(), style: primaryTextStyle(color: primaryColor)),
              if (item.recipeTagImage.validate().isNotEmpty) ...[
                8.width,
                cachedImage(item.recipeTagImage.validate(), height: 20, width: 20, fit: BoxFit.cover),
              ],
            ],
          ),
        ).onTap(() {
          RecipeListScreenV2(tagId: item.id, title: item.title.validate()).launch<void>(context);
        });
      },
    );
  }
}

class _RecipeCategorySection extends StatefulWidget {
  const _RecipeCategorySection();

  @override
  State<_RecipeCategorySection> createState() => _RecipeCategorySectionState();
}

class _RecipeCategorySectionState extends State<_RecipeCategorySection> {
  final List<RecipeCategory> _categories = [];
  bool _isLoading = false;
  num _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _fetchAllCategories();
  }

  Future<void> _fetchAllCategories() async {
    setState(() => _isLoading = true);
    try {
      int page = 1;
      num totalPages = 1;
      while (page <= totalPages) {
        final response = await getRecipeCategoryListApi(page: page);
        totalPages = response.pagination?.totalPages ?? 1;
        _totalItems = response.pagination?.totalItems ?? 0;
        _categories.addAll(response.data.validate());
        if (_categories.length >= 9) break; // We only need enough to know if we show "View More"
        page++;
      }
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty && _isLoading) return const Loader().center().paddingSymmetric(vertical: 16);
    if (_categories.isEmpty) return const SizedBox();

    bool showViewMore = _totalItems > 8 || _categories.length > 8;

    return AnimatedWrap(
      itemCount: showViewMore ? 9 : _categories.length,
      spacing: 16,
      runSpacing: 16,
      itemBuilder: (context, index) {
        if (showViewMore && index == 8) {
          return SizedBox(
            width: context.width() / 3 - 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: context.width() / 3 - 22,
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(12),
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                  ),
                  child: const Icon(Icons.add, color: primaryColor),
                ),
                8.height,
                Text(languages.lblViewmore, style: boldTextStyle(size: 14)),
              ],
            ),
          ).onTap(() {
            const RecipeCategoryListScreen().launch<void>(context);
          });
        }
        final RecipeCategory item = _categories[index];
        return SizedBox(
          width: context.width() / 3 - 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(
                item.recipeCategoryImage.validate(),
                height: 100,
                width: context.width() / 3 - 22,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(12),
              8.height,
              Text(
                item.title.validate(),
                style: boldTextStyle(size: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ).onTap(() {
          RecipeListScreenV2(categoryId: item.id, title: item.title.validate()).launch<void>(context);
        });
      },
    );
  }
}
