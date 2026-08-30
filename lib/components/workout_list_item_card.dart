import '../utils/shared_import.dart';

/// A card widget displaying a workout item with image, premium badge,
/// favorite button, and metadata information.
///
/// Developer: Ashika Bhanderi
/// Updated: 2026-03-12 12:21:00
///
/// Reasoning:
/// - Extracted from ExerciseListScreen to comply with the 200-line widget rule
/// - Makes workout card reusable across different screens
class WorkoutListItemCard extends StatelessWidget {
  final WorkoutDetailModel workout;
  final double width;
  final double height;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const WorkoutListItemCard({
    super.key,
    required this.workout,
    required this.width,
    required this.height,
    this.onFavoriteToggle,
    this.onTap,
  });

  bool get _isFavorite =>
      workout.isFavouriteLocally == 1 || workout.isFavourite == 1;

  @override
  Widget build(BuildContext context) => InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Stack(
        children: [
          cachedImage(
            workout.workoutImage.validate(),
            height: height,
            fit: BoxFit.cover,
            width: width,
          ).cornerRadiusWithClipRRect(16),
          mBlackEffect(width, height),
          _buildHeader(),
          _buildFooter(),
        ],
      ).paddingBottom(16),
    );

  Widget _buildHeader() => Positioned(
      left: 16,
      top: 8,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          userStore.subscription == "1"
              ? workout.isPremium == 1
                    ? mPro()
                    : const SizedBox()
              : const SizedBox(),
          Container(
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: Colors.white.withValues(alpha: 0.5),
              boxShape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              _isFavorite ? ic_favorite_fill : ic_favorite,
              color: _isFavorite ? primaryColor : white,
              width: 20,
              height: 20,
            ).center(),
          ).onTap(() {
            onFavoriteToggle?.call();
          }),
        ],
      ),
    );

  Widget _buildFooter() => Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.title.capitalizeFirstLetter().validate(),
            style: boldTextStyle(color: white),
          ),
          2.height,
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 6),
                height: 6,
                width: 6,
                decoration: boxDecorationWithRoundedCorners(
                  boxShape: BoxShape.circle,
                  backgroundColor: white,
                ),
              ),
              Text(
                workout.workoutTypeTitle.validate(),
                style: secondaryTextStyle(color: white),
              ),
              8.width,
              Container(height: 14, width: 2, color: primaryColor),
              8.width,
              Text(
                workout.levelTitle.validate(),
                style: secondaryTextStyle(color: white),
              ),
            ],
          ),
        ],
      ),
    );
}
