import '../utils/shared_import.dart';

class ExerciseUpNextComponent extends StatelessWidget {
  final List<WorkoutDay>? mUpNextDayList;
  final ScrollController scrollController;
  final String? workOutId;
  final VoidCallback onRefresh;
  final bool isLoading;

  const ExerciseUpNextComponent({
    super.key,
    required this.mUpNextDayList,
    required this.scrollController,
    this.workOutId,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (mUpNextDayList == null || mUpNextDayList!.isEmpty) {
      return const SizedBox.shrink().visible(!isLoading);
    }

    return Stack(
      children: [
        AnimatedListView(
          controller: scrollController,
          itemCount: mUpNextDayList!.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final day = mUpNextDayList![index];

            if (day.isRest == 1 || day.exercise == null || day.exercise!.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${languages.lblDay}${day.sequence.validate() + 1}",
                  style: primaryTextStyle(
                    weight: FontWeight.w700,
                    size: 15,
                    color: primaryColor,
                  ),
                ).paddingSymmetric(horizontal: 10),
                5.height,
                ...day.exercise!.map((workoutExercise) {
                  final exercise = workoutExercise.exercise;
                  final List<String> mSets = [];

                  if (exercise?.type == "sets" && exercise?.sets?.isNotEmpty == true) {
                    for (final s in exercise!.sets!) {
                      mSets.add(exercise.based == "time" ? "${s.time}s" : "${s.reps}x");
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: UpNextExerciseComponent(
                      mDayExerciseModel: workoutExercise,
                      mSets: mSets,
                      workOutId: workOutId,
                      workoutDayId: day.workoutDayId,
                      onRefreshWorkout: (workoutDayId) {
                        onRefresh();
                      },
                    ),
                  );
                }),
                5.height,
              ],
            );
          },
        ),
        const Loader().center().paddingOnly(top: 50).visible(isLoading).center(),
      ],
    );
  }
}
