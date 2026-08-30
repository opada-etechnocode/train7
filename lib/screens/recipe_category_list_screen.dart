import '../utils/shared_import.dart';

class RecipeCategoryListScreen extends StatefulWidget {
  const RecipeCategoryListScreen({super.key});

  @override
  _RecipeCategoryListScreenState createState() =>
      _RecipeCategoryListScreenState();
}

class _RecipeCategoryListScreenState extends State<RecipeCategoryListScreen> {
  List<RecipeCategory> mCategoryList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getCategoryData();
  }

  Future<void> getCategoryData() async {
    appStore.setLoading(true);
    try {
      int page = 1;
      num totalPages = 1;
      while (page <= totalPages) {
        final value = await getRecipeCategoryListApi(page: page);
        totalPages = value.pagination?.totalPages ?? 1;
        mCategoryList.addAll(value.data.validate());
        page++;
      }
      setState(() {});
    } on Exception catch (e) {
      toast(e.toString());
    } finally {
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      "Categories",
      color: primaryColor,
      textColor: Colors.white,
      context: context,
    ),
    body: Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedWrap(
            itemCount: mCategoryList.length,
            spacing: 16,
            runSpacing: 16,
            itemBuilder: (context, index) {
              final RecipeCategory item = mCategoryList[index];
              return SizedBox(
                width: context.width() / 2 - 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cachedImage(
                      item.recipeCategoryImage.validate(),
                      height: 120,
                      width: context.width() / 2 - 24,
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
                RecipeListScreenV2(
                  categoryId: item.id,
                  title: item.title.validate(),
                ).launch<void>(context);
              });
            },
          ),
        ).visible(mCategoryList.isNotEmpty),
        const NoDataScreen(mTitle: "No categories found").center().visible(mCategoryList.isEmpty && !appStore.isLoading),
        const Loader().center().visible(appStore.isLoading),
      ],
    ),
  );
}
