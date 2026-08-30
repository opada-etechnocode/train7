import '../utils/food_image_helper.dart';
import '../utils/shared_import.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  final int? foodRecognitionLimit;

  const CalorieCalculatorScreen({super.key, this.foodRecognitionLimit});

  @override
  State<CalorieCalculatorScreen> createState() =>
      _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<FoodRecognitionHistory> _historyList = [];

  int _page = 1;
  int? _totalPages;
  bool _isLoadingMore = false;
  bool _isRecognizing = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        !appStore.isLoading &&
        !_isRecognizing) {
      if (_totalPages != null && _page < _totalPages!) {
        _page++;
        _loadHistory(isLoadMore: true);
      }
    }
  }

  Future<void> _loadHistory({bool isLoadMore = false}) async {
    if (isLoadMore) {
      _isLoadingMore = true;
      setState(() {});
    } else {
      appStore.setLoading(true);
    }

    await getFoodRecognitionListApi(page: _page)
        .then((value) {
      _totalPages = value.pagination?.totalPages;
      if (_page == 1) {
        _historyList.clear();
      }
      if (value.data != null) {
        _historyList.addAll(value.data!);
      }
      appStore.setLoading(false);
      _isLoadingMore = false;
      setState(() {});
    }).catchError((Object e) {
      appStore.setLoading(false);
      _isLoadingMore = false;
      toast(e.toString());
      setState(() {});
    });
  }

  Future<void> _showImageSourceSheet() async {
    if (_isRecognizing) return;

    if (widget.foodRecognitionLimit != null &&
        widget.foodRecognitionLimit! <= 0) {
      toast(
        appStore.selectedLanguageCode == 'ar'
            ? 'لا توجد محاولات متبقية لحساب السعرات'
            : 'No food recognition attempts remaining',
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: appStore.isDarkMode ? cardDarkColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radiusOnly(topRight: 18, topLeft: 18),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languages.lblSelectImageSource,
                style: boldTextStyle(size: 16),
              ),
              16.height,
              ListTile(
                leading: const Icon(Icons.camera_alt, color: primaryColor),
                title: Text(languages.lblCamera, style: primaryTextStyle()),
                onTap: () {
                  finish(context);
                  _pickAndRecognize(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: primaryColor),
                title: Text(languages.lblGallery, style: primaryTextStyle()),
                onTap: () {
                  finish(context);
                  _pickAndRecognize(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndRecognize(ImageSource source) async {
    if (_isRecognizing) return;

    try {
      final XFile? picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 100,
      );
      if (picked == null) return;

      // Crop & resize to API-required 544x544 before upload.
      final File cropped = await prepareFoodRecognitionImage(File(picked.path));

      final bool? confirmed = await _showCropPreview(cropped);
      if (confirmed != true) return;

      if (!mounted) return;
      setState(() => _isRecognizing = true);

      final FoodRecognitionResponse result = await foodRecognitionApi(cropped);

      if (!mounted) return;
      setState(() => _isRecognizing = false);

      if (result.success == true && result.data != null) {
        await FoodRecognitionResultScreen(
          recognitionData: result.data!,
          localImagePath: cropped.path,
          remainingRequests: result.remainingRequests,
        ).launch<void>(context);

        _page = 1;
        await _loadHistory();
      } else {
        toast(languages.lblFoodNotRecognized);
      }
    } on Exception catch (e) {
      if (mounted) setState(() => _isRecognizing = false);
      toast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<bool?> _showCropPreview(File cropped) async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: appStore.isDarkMode ? cardDarkColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radiusOnly(topRight: 18, topLeft: 18),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languages.lblCalorieCalculator,
                style: boldTextStyle(size: 16),
              ),
              8.height,
              Text(
                appStore.selectedLanguageCode == 'ar'
                    ? 'تم قص الصورة إلى 544×544 — تأكيد الإرسال؟'
                    : 'Image cropped to 544×544 — confirm upload?',
                style: secondaryTextStyle(),
                textAlign: TextAlign.center,
              ),
              16.height,
              ClipRRect(
                borderRadius: radius(12),
                child: Image.file(
                  cropped,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              20.height,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => finish(context, false),
                      child: Text(languages.lblCancel),
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => finish(context, true),
                      child: Text(languages.lblSubmit),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date.isEmptyOrNull) return '';
    try {
      return DateFormat('dd MMM yyyy, hh:mm a')
          .format(DateTime.parse(date!).toLocal());
    } on FormatException {
      return date.validate();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBarWidget(languages.lblCalorieCalculator, context: context),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _isRecognizing ? null : _showImageSourceSheet,
          backgroundColor: primaryColor,
          disabledElevation: 0,
          icon: _isRecognizing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.restaurant_menu, color: Colors.white),
          label: Text(
            _isRecognizing
                ? (appStore.selectedLanguageCode == 'ar'
                    ? 'جاري التحليل...'
                    : 'Analyzing...')
                : languages.lblCalculateCalories,
            style: boldTextStyle(color: Colors.white, size: 14),
          ),
        ),
        body: Column(
          children: [
            if (widget.foodRecognitionLimit != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: radius(12),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: primaryColor, size: 20),
                    8.width,
                    Expanded(
                      child: Text(
                        '${languages.lblFoodRecognitionLimit}: ${widget.foodRecognitionLimit}',
                        style: boldTextStyle(size: 13, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Stack(
                children: [
            RefreshIndicator(
              onRefresh: () async {
                _page = 1;
                await _loadHistory();
              },
              child: _historyList.isEmpty && !appStore.isLoading
                  ? NoDataScreen(mTitle: languages.lblNoFoodHistory)
                      .center()
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: _historyList.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _historyList.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final FoodRecognitionHistory item = _historyList[index];
                        return _historyCard(item);
                      },
                    ),
            ),
            if (_isRecognizing)
              Container(
                color: Colors.black26,
                child: const Loader().center(),
              ),
            const Loader().visible(appStore.isLoading && !_isRecognizing),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _historyCard(FoodRecognitionHistory item) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: appStore.isDarkMode
            ? boxDecorationWithRoundedCorners(borderRadius: radius(16))
            : boxDecorationRoundedWithShadow(16),
        child: Row(
          children: [
            cachedImage(
              item.image.validate(),
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRectOnly(
              topLeft: 16,
              bottomLeft: 16,
            ),
            12.width,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.topFoodName.validate(value: '-'),
                      style: boldTextStyle(size: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.height,
                    Text(
                      item.topGroup.validate(),
                      style: secondaryTextStyle(size: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.height,
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            size: 16, color: primaryColor),
                        4.width,
                        Text(
                          '${item.formattedCalories} ${languages.lblKcal}',
                          style: boldTextStyle(size: 13, color: primaryColor),
                        ),
                      ],
                    ),
                    4.height,
                    Text(
                      _formatDate(item.createdAt),
                      style: secondaryTextStyle(size: 11),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: primaryColor)
                .paddingSymmetric(horizontal: 8),
          ],
        ),
      ).onTap(() {
        if (_isRecognizing) return;
        FoodRecognitionResultScreen(
          recognitionData: item.responseJson ??
              FoodRecognitionData(
                isFood: item.isFood,
                results: [
                  FoodRecognitionGroup(
                    group: item.topGroup,
                    items: [
                      FoodRecognitionItem(
                        name: item.topFoodName,
                        group: item.topGroup,
                        score: item.topScore,
                        nutrition: FoodNutrition(
                          calories:
                              double.tryParse(item.calories.validate()),
                          protein: double.tryParse(item.protein.validate()),
                          totalFat:
                              double.tryParse(item.totalFat.validate()),
                          totalCarbs:
                              double.tryParse(item.totalCarbs.validate()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          networkImageUrl: item.image,
          historyItem: item,
        ).launch<void>(context);
      });
}
