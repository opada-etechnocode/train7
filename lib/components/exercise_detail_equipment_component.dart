import 'dart:ui';
import '../utils/shared_import.dart';

class ExerciseDetailEquipmentComponent extends StatelessWidget {
  final ExerciseDetailResponse? mExerciseModel;

  const ExerciseDetailEquipmentComponent({
    super.key,
    required this.mExerciseModel,
  });

  @override
  Widget build(BuildContext context) {
    if (mExerciseModel?.data?.equipmentTitle.isEmptyOrNull ?? true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Text(
          languages.lblEquipments,
          style: secondaryTextStyle(),
        ).paddingSymmetric(horizontal: 16),
        16.height,
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            cachedImage(
              mExerciseModel!.data!.equipmentImg.validate(),
              height: 145,
              width: context.width() * 0.32,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(12),
            ClipRRect(
              borderRadius: radius(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: context.width() * 0.32,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(12),
                    backgroundColor:
                        Colors.grey.shade100.withValues(alpha: 0.5),
                  ),
                  child: Text(
                    mExerciseModel!.data!.equipmentTitle.validate(),
                    style: primaryTextStyle(
                      size: 12,
                      color: Colors.black,
                    ),
                  ).center(),
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
        30.height,
      ],
    );
  }
}
