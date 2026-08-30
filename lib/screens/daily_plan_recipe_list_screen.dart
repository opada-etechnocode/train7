import 'package:cached_network_image/cached_network_image.dart';

import '../models/recipe_filter_model.dart';
import '../utils/shared_import.dart';

class DailyPlanRecipeListScreen extends StatefulWidget {
  final String mealType;
  final int? dailyPlanId;
  final String? date;

  const DailyPlanRecipeListScreen({
    super.key,
    required this.mealType,
    this.dailyPlanId,
    this.date,
  });

  @override
  State<DailyPlanRecipeListScreen> createState() =>
      _DailyPlanRecipeListScreenState();
}

class _DailyPlanRecipeListScreenState extends State<DailyPlanRecipeListScreen> {
  TextEditingController searchCont = TextEditingController();
  List<RecipeItem> recipeList = [];
  bool isLoading = false;
  int page = 1;
  bool isLastPage = false;
  final ScrollController _scrollController = ScrollController();
  RecipeFilterModel filter = RecipeFilterModel();
  Timer? _debounce;

  Future<void> _showRecipeDetailBottomSheet(RecipeItem item) async {
    final dailyPlanRecipeItem = DailyPlanRecipeItem(
      dailyPlanId: widget.dailyPlanId,
      recipeId: item.id,
      calories: item.calories,
      protein: item.protein?.toInt(),
      carbs: item.carbs?.toInt(),
      fats: item.fats?.toInt(),
      mealType: widget.mealType,
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

    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeDetailBottomSheet(
        recipeItem: dailyPlanRecipeItem,
        mealType: widget.mealType,
        date: widget.date,
      ),
    );

    if (result == true && mounted) {
      page = 1;
      recipeList.clear();
      _fetchRecipes();
    }
  }

  @override
  void initState() {
    super.initState();
    filter.mealTypes = [widget.mealType];
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

    searchCont.addListener(() {
      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }
      _debounce = Timer(const Duration(milliseconds: 500), () {
        page = 1;
        recipeList.clear();
        _fetchRecipes();
      });
    });
  }

  Future<void> _fetchRecipes({String? searchTerm}) async {
    if (page == 1) setState(() => isLoading = true);

    await getRecipeFilterListApi(
          mealTypes: filter.mealTypes ?? [widget.mealType],
          recipeCategoryIds: filter.recipeCategoryIds,
          recipeTagIds: filter.recipeTagIds,
          startCalories: filter.startCalories,
          endCalories: filter.endCalories,
          startProtein: filter.startProtein,
          endProtein: filter.endProtein,
          startCarbs: filter.startCarbs,
          endCarbs: filter.endCarbs,
          startFats: filter.startFats,
          endFats: filter.endFats,
          minPreparationTime: filter.minPreparationTime,
          maxPreparationTime: filter.maxPreparationTime,
          isFavourite: filter.isFavourite,
          page: page,
          mSearch: searchTerm ?? searchCont.text,
        )
        .then((value) {
          if (page == 1) recipeList.clear();

            recipeList.addAll(value.data);
            isLastPage =
                value.pagination?.currentPage == value.pagination?.totalPages;
          setState(() => isLoading = false);
        })
        .catchError((dynamic e, StackTrace s) {
          log("Errrrrrr   => ${s.toString()}");
          setState(() => isLoading = false);
          toast(e.toString());
        });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    searchCont.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.mealType.capitalizeFirstLetter(),
        style: boldTextStyle(size: 18),
      ),
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              if (filter.isFavourite == 1) {
                filter.isFavourite = null;
              } else {
                filter.isFavourite = 1;
              }
              page = 1;
              recipeList.clear();
            });
            _fetchRecipes();
          },
          icon: Icon(
            filter.isFavourite == 1 ? Icons.favorite : Icons.favorite_border,
            color: filter.isFavourite == 1 ? Colors.red : null,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            showModalBottomSheet<dynamic>(
              context: context,
              isScrollControlled: true,
              builder: (context) => RecipeFilterBottomSheet(
                filter: filter,
                onApply: (newFilter) {
                  setState(() {
                    filter = newFilter;
                    page = 1;
                    recipeList.clear();
                  });
                  _fetchRecipes();
                },
              ),
            );
          },
        ),
      ],

    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppTextField(
            controller: searchCont,
            textFieldType: TextFieldType.OTHER,
            decoration: InputDecoration(
              hintText: languages.lblSearch,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onFieldSubmitted: (val) {
              page = 1;
              recipeList.clear();
              _fetchRecipes(searchTerm: val);
            },
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              if (recipeList.isNotEmpty)
                ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: recipeList.length,
                  separatorBuilder: (_, __) => 16.height,
                  itemBuilder: (context, index) {
                    final item = recipeList[index];
                    final String subtitle =
                        (item.recipeCategory?.isNotEmpty ?? false)
                        ? item.recipeCategory!
                              .map((e) => e.title.validate())
                              .where((t) => t.isNotEmpty)
                              .join(', ')
                        : '';
                    return Container(
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(12),
                        backgroundColor: context.cardColor,
                        boxShadow: defaultBoxShadow(),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: item.recipeImage.validate(),
                              height: 48,
                              width: 48,
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
                Center(
                  child: Text(languages.lblNodatafound, style: secondaryTextStyle()),
                ),
            ],
          ),
        ),
      ],
    ),


  );
}
