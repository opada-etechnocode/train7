import '../utils/shared_import.dart';

class ExerciseDetailSetsComponent extends StatelessWidget {
  final ExerciseDetailResponse? mExerciseModel;
  final bool isLBSClicked;
  final bool isKGClicked;
  final Widget Function(String, {String? value2}) mSetText;
  final Widget Function() mSets1;
  final Widget Function() mSets2;

  const ExerciseDetailSetsComponent({
    super.key,
    required this.mExerciseModel,
    required this.isLBSClicked,
    required this.isKGClicked,
    required this.mSetText,
    required this.mSets1,
    required this.mSets2,
  });

  @override
  Widget build(BuildContext context) {
    if (mExerciseModel?.data?.type != SETS) return const SizedBox.shrink();

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                languages.lblRepsWeight,
                style: secondaryTextStyle(
                  weight: FontWeight.bold,
                  size: 12,
                ),
              ),
            ),
            4.height,
            Container(
              width: context.width(),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(),
                backgroundColor: appStore.isDarkMode
                    ? cardDarkColor
                    : GreyLightColor.withValues(alpha: 0.3),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: mSets1(),
            ),
          ],
        ),
        4.height,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                languages.lblRest,
                style: secondaryTextStyle(
                  weight: FontWeight.bold,
                  size: 12,
                ),
              ),
            ),
            4.height,
            Container(
              width: context.width(),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(),
                backgroundColor: appStore.isDarkMode
                    ? cardDarkColor
                    : GreyLightColor.withValues(alpha: 0.3),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: mSets2(),
            ),
          ],
        ),
      ],
    );
  }
}
