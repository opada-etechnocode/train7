import '../utils/shared_import.dart';

class ExerciseDetailHeader extends StatelessWidget {
  final ExerciseDetailResponse? mExerciseModel;
  final String mode;

  const ExerciseDetailHeader({
    super.key,
    required this.mExerciseModel,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    if (mExerciseModel == null) return const SizedBox.shrink();

    return Stack(
      children: [
        mExerciseModel!.data!.videoUrl.validate().contains("https://youtu") ||
                mExerciseModel!.data!.videoUrl.validate().contains("https://www.youtu")
            ? AspectRatio(
                aspectRatio: mode == "portrait" ? 12 / 7 : 15 / 7,
                child: YoutubePlayerScreen(
                  url: mExerciseModel!.data!.videoUrl.validate(),
                  img: mExerciseModel!.data!.exerciseImage.validate(),
                  hideControl: true,
                ),
              )
            : ChewieScreen(
                url: mExerciseModel!.data!.videoUrl.validate(),
                image: mExerciseModel!.data!.exerciseImage.validate(),
              ).center(),
        Positioned(
          left: 16,
          top: 16,
          child: userStore.subscription == "1"
              ? mExerciseModel!.data!.isPremium == 1
                  ? mPro()
                  : const SizedBox()
              : const SizedBox(),
        ),
      ],
    );
  }
}
