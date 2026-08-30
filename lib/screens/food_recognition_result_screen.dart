import '../utils/shared_import.dart';

class FoodRecognitionResultScreen extends StatelessWidget {
  final FoodRecognitionData recognitionData;
  final String? localImagePath;
  final String? networkImageUrl;
  final int? remainingRequests;
  final FoodRecognitionHistory? historyItem;

  const FoodRecognitionResultScreen({
    super.key,
    required this.recognitionData,
    this.localImagePath,
    this.networkImageUrl,
    this.remainingRequests,
    this.historyItem,
  });

  FoodRecognitionItem? get _topItem =>
      historyItem != null
          ? FoodRecognitionItem(
              name: historyItem!.topFoodName,
              group: historyItem!.topGroup,
              score: historyItem!.topScore,
              nutrition: FoodNutrition(
                calories: double.tryParse(historyItem!.calories.validate()),
                protein: double.tryParse(historyItem!.protein.validate()),
                totalFat: double.tryParse(historyItem!.totalFat.validate()),
                totalCarbs: double.tryParse(historyItem!.totalCarbs.validate()),
              ),
            )
          : recognitionData.topItem;

  String _formatNum(num? value, {int decimals = 1}) {
    if (value == null) return '0';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(decimals);
  }

  @override
  Widget build(BuildContext context) {
    final FoodRecognitionItem? top = _topItem;
    final List<FoodRecognitionItem> allItems = [];
    recognitionData.results?.forEach((group) {
      if (group.items != null) allItems.addAll(group.items!);
    });
    allItems.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));

    return Scaffold(
      appBar: appBarWidget(languages.lblFoodRecognitionResult, context: context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            if (recognitionData.isFood == false)
              _infoBanner(
                languages.lblFoodNotRecognized,
                Icons.info_outline,
              )
            else if (top != null) ...[
              16.height,
              Text(
                top.name.validate(),
                style: boldTextStyle(size: 20),
              ).paddingSymmetric(horizontal: 16),
              4.height,
              Text(
                top.group.validate(),
                style: secondaryTextStyle(size: 14),
              ).paddingSymmetric(horizontal: 16),
              if (top.score != null)
                Text(
                  '${languages.lblConfidence}: ${top.score}',
                  style: secondaryTextStyle(size: 12),
                ).paddingSymmetric(horizontal: 16).paddingTop(4),
              16.height,
              _nutritionRow(top.nutrition).paddingSymmetric(horizontal: 16),
              if (remainingRequests != null)
                Text(
                  '${languages.lblRemainingRequests}: $remainingRequests',
                  style: secondaryTextStyle(size: 12),
                ).paddingSymmetric(horizontal: 16).paddingTop(12),
              if (allItems.length > 1) ...[
                24.height,
                Text(
                  languages.lblOtherSuggestions,
                  style: boldTextStyle(size: 16),
                ).paddingSymmetric(horizontal: 16),
                8.height,
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allItems.length > 10 ? 10 : allItems.length,
                  itemBuilder: (context, index) {
                    final item = allItems[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: appStore.isDarkMode
                          ? boxDecorationWithRoundedCorners(
                              borderRadius: radius(12),
                            )
                          : boxDecorationRoundedWithShadow(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name.validate(),
                                  style: boldTextStyle(size: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                2.height,
                                Text(
                                  item.group.validate(),
                                  style: secondaryTextStyle(size: 12),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${_formatNum(item.nutrition?.calories, decimals: 0)} ${languages.lblKcal}',
                                style: boldTextStyle(
                                  size: 13,
                                  color: primaryColor,
                                ),
                              ),
                              if (item.score != null)
                                Text(
                                  '${languages.lblConfidence}: ${item.score}',
                                  style: secondaryTextStyle(size: 11),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (localImagePath != null) {
      return Image.file(
        File(localImagePath!),
        width: context.width(),
        height: 220,
        fit: BoxFit.cover,
      );
    }
    return cachedImage(
      networkImageUrl.validate(),
      width: context.width(),
      height: 220,
      fit: BoxFit.cover,
    );
  }

  Widget _nutritionRow(FoodNutrition? nutrition) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: appStore.isDarkMode
            ? boxDecorationWithRoundedCorners(borderRadius: radius(12))
            : boxDecorationRoundedWithShadow(12),
        child: Row(
          children: [
            _macroItem(
              languages.lblCalories,
              _formatNum(nutrition?.calories, decimals: 0),
              Icons.local_fire_department,
            ),
            _macroItem(
              languages.lblProtein,
              _formatNum(nutrition?.protein),
              Icons.restaurant,
            ),
            _macroItem(
              languages.lblFat,
              _formatNum(nutrition?.totalFat),
              Icons.opacity,
            ),
            _macroItem(
              languages.lblCarbs,
              _formatNum(nutrition?.totalCarbs),
              Icons.grain,
            ),
          ],
        ),
      );

  Widget _macroItem(String label, String value, IconData icon) => Expanded(
        child: Column(
          children: [
            Icon(icon, size: 20, color: primaryColor),
            6.height,
            Text(value, style: boldTextStyle(size: 14)),
            2.height,
            Text(label, style: secondaryTextStyle(size: 11)),
          ],
        ),
      );

  Widget _infoBanner(String text, IconData icon) => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(14),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(12),
          backgroundColor: primaryColor.withValues(alpha: 0.1),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            10.width,
            Expanded(child: Text(text, style: primaryTextStyle())),
          ],
        ),
      );
}
