import '../utils/shared_import.dart';

class ExerciseHistoryScreen extends StatefulWidget {
  static String tag = '/ExerciseHistoryScreen';

  const ExerciseHistoryScreen({super.key});

  @override
  ExerciseHistoryScreenState createState() => ExerciseHistoryScreenState();
}

class ExerciseHistoryScreenState extends State<ExerciseHistoryScreen> {
  List<ExerciseModel> mExerciseList = [];
  ScrollController scrollController = ScrollController();

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
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  Future<void> init() async {
    getExerciseData();
  }

  Future<void> getExerciseData() async {
    appStore.setLoading(true);
    await getExerciseListApi(page: page)
        .then((value) {
          appStore.setLoading(false);
          numPage = value.pagination!.totalPages;
          isLastPage = false;
          if (page == 1) {
            mExerciseList.clear();
          }
          final Iterable<dynamic> it = value.data!;
          it.map((e) => mExerciseList.add(e)).toList();
          setState(() {});
        })
        .catchError((e) {
          isLastPage = true;
          appStore.setLoading(false);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget('Exercise History', context: context),
    body: Stack(
      children: [
        mExerciseList.isNotEmpty
            ? AnimatedListView(
                controller: scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                itemCount: mExerciseList.length,
                itemBuilder: (context, index) {
                  log("---------->>>${mExerciseList[index].id}");
                  return ExerciseComponent(
                    mExerciseModel: mExerciseList[index],
                  );
                },
              )
            : NoDataScreen(
                mTitle: languages.lblExerciseNoFound,
              ).visible(!appStore.isLoading),
        const Loader().center().visible(appStore.isLoading),
      ],
    ),
  );
}
