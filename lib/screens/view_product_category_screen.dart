import '../utils/shared_import.dart';

class ViewProductCategoryScreen extends StatefulWidget {
  const ViewProductCategoryScreen({super.key});

  @override
  State<ViewProductCategoryScreen> createState() =>
      _ViewProductCategoryScreenState();
}

class _ViewProductCategoryScreenState extends State<ViewProductCategoryScreen> {
  ScrollController scrollController = ScrollController();

  List<ProductCategoryModel> mProductCategoryList = [];

  ProductCategoryModel? mCategoryProductModel;

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (numPage != null && page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  Future<void> init() async {
    getProductCategoryData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> getProductCategoryData() async {
    appStore.setLoading(true);
    await getProductCategoryApi(page: page)
        .then((value) {
          appStore.setLoading(false);
          numPage = value.pagination!.totalPages;
          isLastPage = false;
          if (page == 1) {
            mProductCategoryList.clear();
          }
          if (value.data != null) {
            mProductCategoryList.addAll(value.data!);
          }
          setState(() {});
        })
        .catchError((Object e) {
          isLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      languages.lblProductCategory,
      elevation: 0,
      context: context,
    ),
    body: Stack(
      children: [
        mProductCategoryList.isNotEmpty
            ? SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: AnimatedWrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: List.generate(
                    mProductCategoryList.length,
                    (index) => ProductCategoryComponent(
                      mProductCategoryModel: mProductCategoryList[index],
                      isGrid: true,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16),
              )
            : NoDataScreen(mTitle: languages.lblNoFoundData)
                .center()
                .visible(!appStore.isLoading),
        const Loader().center().visible(appStore.isLoading),
      ],
    ),
  );
}
