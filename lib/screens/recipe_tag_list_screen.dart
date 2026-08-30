import '../utils/shared_import.dart';

class RecipeTagListScreen extends StatefulWidget {
  const RecipeTagListScreen({super.key});

  @override
  _RecipeTagListScreenState createState() => _RecipeTagListScreenState();
}

class _RecipeTagListScreenState extends State<RecipeTagListScreen> {
  List<RecipeTag> mTagList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getTagData();
  }

  Future<void> getTagData() async {
    appStore.setLoading(true);
    try {
      int page = 1;
      num totalPages = 1;
      while (page <= totalPages) {
        final value = await getRecipeTagListApi(page: page);
        totalPages = value.pagination?.totalPages ?? 1;
        mTagList.addAll(value.data.validate());
        page++;
      }
      setState(() {});
    } catch (e) {
      toast(e.toString());
    } finally {
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      "Tags",
      color: primaryColor,
      textColor: Colors.white,
      context: context,
    ),
    body: Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedWrap(
            itemCount: mTagList.length,
            spacing: 16,
            runSpacing: 16,
            itemBuilder: (context, index) {
              final RecipeTag item = mTagList[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(20),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.5)),
                  backgroundColor: context.cardColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title.validate(),
                      style: primaryTextStyle(color: primaryColor),
                    ),
                    if (item.recipeTagImage.validate().isNotEmpty) ...[
                      8.width,
                      cachedImage(
                        item.recipeTagImage.validate(),
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ],
                ),
              ).onTap(() {
                RecipeListScreenV2(
                  tagId: item.id,
                  title: item.title.validate(),
                ).launch<void>(context);
              });
            },
          ),
        ).visible(mTagList.isNotEmpty),
        const NoDataScreen(mTitle: "No tags found").center().visible(mTagList.isEmpty && !appStore.isLoading),
        const Loader().center().visible(appStore.isLoading),
      ],
    ),
  );
}
