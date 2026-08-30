import '../utils/shared_import.dart';

class ViewLevelScreen extends StatefulWidget {
  const ViewLevelScreen({super.key});

  @override
  _ViewLevelScreenState createState() => _ViewLevelScreenState();
}

class _ViewLevelScreenState extends State<ViewLevelScreen> {
  ScrollController scrollController = ScrollController();

  List<LevelModel> mLevelList = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero).then((val) {
      getLevelData();
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !appStore.isLoading) {
          if (page < numPage!) {
            page++;
            getLevelDataPagination();
          }
        }
      });
    });
  }

  Future<void> getLevelData() async {
    appStore.setLoading(true);
    await getLevelListApi(page: page)
        .then((value) {
          numPage = value.pagination!.totalPages;
          isLastPage = false;
          if (page == 1) {
            mLevelList.clear();
          }
          final Iterable<LevelModel> it = value.data!;
          it.map((e) => mLevelList.add(e)).toList();
          appStore.setLoading(false);
          setState(() {});
        })
        .catchError((Object e) {
          isLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  Future<void> getLevelDataPagination() async {
    appStore.setLoading(true);
    await getLevelListApi(page: page)
        .then((value) {
          numPage = value.pagination!.totalPages;
          isLastPage = false;
          if (page == 1) {
            mLevelList.clear();
          }
          final Iterable<LevelModel> it = value.data!;
          it.map((e) => mLevelList.add(e)).toList();
          appStore.setLoading(false);
          setState(() {});
        })
        .catchError((Object e) {
          isLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(languages.lblLevels, elevation: 0, context: context),
    body: Stack(
      children: [
        AnimatedListView(
          controller: scrollController,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: mLevelList.length,
          itemBuilder: (context, index) =>
              LevelComponent(mLevelModel: mLevelList[index]),
        ),
        Observer(
          builder: (context) =>
              const Loader().center().visible(appStore.isLoading),
        ),
      ],
    ),
    bottomNavigationBar:
        userStore.adsBannerDetailShowBannerOnLevel == 1 &&
            userStore.isSubscribe == 0
        ? showBannerAds(context)
        : const SizedBox(),
  );
}
