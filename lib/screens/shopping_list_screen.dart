import '../utils/shared_import.dart';
import 'shopping_list_detail_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<ShoppingListData> _shoppingLists = [];
  bool _isLoading = true;
  int _page = 1;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    _fetchShoppingLists();
  }

  Future<void> _fetchShoppingLists({bool isRefresh = false}) async {
    if (isRefresh) {
      _page = 1;
      _shoppingLists.clear();
      _isLastPage = false;
    }

    if (_isLastPage) return;

    if (!isRefresh) {
      appStore.setLoading(true);
    }
    
    await getShoppingListApi(page: _page).then((value) {
      if (value.data != null) {
        _shoppingLists.addAll(value.data!);
        _isLastPage = value.data!.length < 10; // Assuming 10 per page
        _page++;
      }
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      _isLoading = false;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> _openAddListScreen({required bool isSpecificDate}) async {
    final bool? result = await AddShoppingListScreen(isDefaultSpecificDate: isSpecificDate).launch(context);
    if (result == true) {
      _fetchShoppingLists(isRefresh: true);
    }
  }

  void _showGenerateBottomSheet() {
    int selectedOption = 0; // 0 for Date, 1 for Date range

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
          builder: (context, setBottomState) => Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radiusOnly(topLeft: 24, topRight: 24),
                backgroundColor: context.scaffoldBackgroundColor,
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: Colors.grey.shade400,
                        borderRadius: radius(4),
                      ),
                    ),
                  ),
                  24.height,
                  Text(languages.lblGenerateshoppinglist, style: boldTextStyle(size: 24)),
                  8.height,
                  Text(languages.lblChoosewhichplannedmealstoinclude, style: secondaryTextStyle(size: 16)),
                  32.height,
                  _buildBottomSheetOption(
                    title: languages.lblDate,
                    subtitle: languages.lblSelectaspecificdate,
                    icon: Icons.calendar_today_outlined,
                    isSelected: selectedOption == 0,
                    onTap: () {
                      setBottomState(() => selectedOption = 0);
                    },
                  ),
                  16.height,
                  _buildBottomSheetOption(
                    title: languages.lblDaterange,
                    subtitle: languages.lblPickstartenddates,
                    icon: Icons.date_range_outlined,
                    isSelected: selectedOption == 1,
                    onTap: () {
                      setBottomState(() => selectedOption = 1);
                    },
                  ),
                  32.height,
                  AppButton(
                    text: 'Continue', // todo
                    width: context.width(),
                    color: primaryColor,
                    textColor: Colors.white,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(16)),
                    onTap: () {
                      Navigator.pop(context);
                      _openAddListScreen(isSpecificDate: selectedOption == 0);
                    },
                  ),
                  16.height,
                  Center(
                    child: Text(languages.lblCancel, style: secondaryTextStyle(size: 16)).onTap(() {
                      Navigator.pop(context);
                    }),
                  ),
                  8.height,
                ],
              ),
            )
        ),
    );
  }

  Widget _buildBottomSheetOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) => Container(
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(16),
        backgroundColor: isSelected ? primaryColor.withValues(alpha: 0.1) : context.cardColor,
        border: Border.all(
          color: isSelected ? primaryColor : context.dividerColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(12),
              backgroundColor: isSelected ? primaryColor.withValues(alpha: 0.2) : context.scaffoldBackgroundColor,
            ),
            child: Icon(icon, color: isSelected ? primaryColor : textSecondaryColorGlobal, size: 24),
          ),
          20.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: boldTextStyle(size: 18, color: isSelected ? primaryColor : textPrimaryColorGlobal)),
              4.height,
              Text(subtitle, style: secondaryTextStyle()),
            ],
          ).expand(),
          if (isSelected)
            const Icon(Icons.check_circle, color: primaryColor, size: 24)
          else
            Icon(Icons.chevron_right, color: textSecondaryColorGlobal, size: 24),
        ],
      ),
    ).onTap(onTap);

  Future<void> _addShoppingList() async {
    _showGenerateBottomSheet();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: appBarWidget(
        languages.lblShoppingLists,
        color: context.scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: textPrimaryColorGlobal),
            onPressed: _addShoppingList,
          ),
        ], context: context,
      ),
      body: Stack(
        children: [
          if (!_isLoading && _shoppingLists.isEmpty)
            NoDataScreen(
              mTitle: languages.lblNoShoppingListsFound,
            )
          else
            AnimatedListView(
              padding: const EdgeInsets.all(16),
              itemCount: _shoppingLists.length,
              onNextPage: () {
                _fetchShoppingLists();
              },
              onSwipeRefresh: () async {
                await _fetchShoppingLists(isRefresh: true);
              },
              itemBuilder: (context, index) {
                final list = _shoppingLists[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: context.cardColor,
                    borderRadius: radius(12),
                    border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(list.title.validate(), style: boldTextStyle()),
                          4.height,
                          Text(
                            '${list.itemsCount.validate()} items',
                            style: secondaryTextStyle(),
                          ),
                        ],
                      ).expand(),
                      // Removed Edit Button
                      Icon(Icons.chevron_right, color: textSecondaryColorGlobal),
                    ],
                  ),
                ).onTap(() async {
                   final bool? result = await ShoppingListDetailScreen(shoppingListId: list.id.validate()).launch(context);
                   if (result == true) {
                     _fetchShoppingLists(isRefresh: true);
                   }
                });
              },
            ),
          if (_isLoading) const Loader(),
        ],
      ),
    );
}
