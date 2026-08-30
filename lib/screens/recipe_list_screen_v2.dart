import '../models/recipe_filter_model.dart';
import '../utils/shared_import.dart';


class RecipeListScreenV2 extends StatefulWidget {
  final int? categoryId;
  final int? tagId;
  final String title;

  const RecipeListScreenV2({
    super.key,
    this.categoryId,
    this.tagId,
    required this.title,
  });

  @override
  _RecipeListScreenV2State createState() => _RecipeListScreenV2State();
}

class _RecipeListScreenV2State extends State<RecipeListScreenV2> {
  ScrollController scrollController = ScrollController();
  List<RecipeItem> recipeList = [];
  int page = 1;
  bool isLoading = false;
  bool isLastPage = false;
  RecipeFilterModel filter = RecipeFilterModel();


  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLastPage && !isLoading) {
          page++;
          init();
        }
      }
    });
  }

  Future<void> init() async {
    setState(() => isLoading = true);
    await getRecipeFilterListApi(
          mealTypes: filter.mealTypes ?? [],
          recipeCategoryIds: filter.recipeCategoryIds ?? (widget.categoryId != null ? [widget.categoryId!] : null),
          recipeTagIds: filter.recipeTagIds ?? (widget.tagId != null ? [widget.tagId!] : null),
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
        )

        .then((value) {
          if (page == 1) recipeList.clear();
          recipeList.addAll(value.data.validate());
          isLastPage =
              value.data.validate().length < 10; // Assuming 10 per page
          setState(() => isLoading = false);
        })
        .catchError((Object e) {
          setState(() => isLoading = false);
          toast(e.toString());
        });
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
      widget.title,
      color: primaryColor,
      textColor: Colors.white,
      context: context,
    ),
    body: Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: AnimatedWrap(
            itemCount: recipeList.length,
            spacing: 16,
            runSpacing: 16,
            itemBuilder: (context, index) {
              final RecipeItem item = recipeList[index];
              return RecipeGridComponent(recipe: item);
            },
          ),
        ),
        if (isLoading && page == 1) const Loader(),
        if (!isLoading && recipeList.isEmpty)
          Center(child: Text(languages.lblNorecipesfound, style: secondaryTextStyle())),
        Positioned(
          right: 16,
          top: 10,
          child: Row(
            children: [
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
                  init();
                },
                icon: Icon(
                  filter.isFavourite == 1 ? Icons.favorite : Icons.favorite_border,
                  color: filter.isFavourite == 1 ? Colors.red : Colors.white,
                ),



              ),
              IconButton(
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
                        init();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.filter_list, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),

  );
}
