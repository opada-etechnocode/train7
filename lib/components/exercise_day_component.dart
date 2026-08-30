import '../utils/shared_import.dart';

class ExerciseDayComponent extends StatefulWidget {
  static String tag = '/ExerciseDayComponent';
  final DayExerciseModel? mDayExerciseModel;
  final List<String>? mSets;
  final String? workOutId;
  final int? workoutDayId;
  final void Function(int workoutDayId)? onRefreshWorkout;

  const ExerciseDayComponent({
    super.key,
    this.mDayExerciseModel,
    this.workOutId,
    this.mSets,
    this.workoutDayId,
    this.onRefreshWorkout,
  });

  @override
  ExerciseDayComponentState createState() => ExerciseDayComponentState();
}

class ExerciseDayComponentState extends State<ExerciseDayComponent> {
  @override
  Widget build(BuildContext context) =>
      Container(
        decoration: appStore.isDarkMode
            ? boxDecorationWithRoundedCorners(borderRadius: radius(12))
            : boxDecorationRoundedWithShadow(12),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        margin: const EdgeInsets.only(bottom: 8, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    cachedImage(
                      widget.mDayExerciseModel!.exerciseImage.validate(),
                      width: 55,
                      height: 55,
                      fit: BoxFit.fill,
                    ).cornerRadiusWithClipRRect(10),
                    if (widget.mDayExerciseModel!.isCompleted!)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    if (widget.mDayExerciseModel!.isCompleted!)
                      Image.asset(
                        ic_completed,
                        width: 35,
                        height: 35,
                        color: Colors.green,
                      ),
                  ],
                ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    6.height,
                    Text(
                      widget.mDayExerciseModel!.exerciseTitle.validate(),
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    6.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.mDayExerciseModel?.exercise?.type ==
                            DURATION)
                         Text(
                          '${widget.mDayExerciseModel?.exercise?.duration ?? ''} ${languages.lblDuration}',
                          style: secondaryTextStyle(size: 12),
                        ),
                        if (widget.mDayExerciseModel?.exercise?.type == SETS)
                          Text(
                            widget.mSets!.join(" ").toString(),
                            style: secondaryTextStyle(size: 12),
                          ),
                        if (userStore.subscription == "1")
                          if (widget.mDayExerciseModel?.exercise?.isPremium ==
                              1)
                            mPro(),
                      ],
                    ),
                  ],
                ).expand(),
              ],
            ).expand(),
          ],
        ),
      ).onTap(() async {
        if (userStore.subscription == "1") {
          if (widget.mDayExerciseModel!.exercise!.isPremium == 1) {
            if (userStore.isSubscribe == 0) {
              await const SubscribeScreen().launch<void>(context);
            } else {
              final result = await ExerciseDetailScreen(
                mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(),
                mExerciseId: widget.mDayExerciseModel!.exerciseId.validate(),
                workOutId: widget.workOutId,
                workoutDayId: widget.workoutDayId,
                isCompleted: widget.mDayExerciseModel!.isCompleted!,
              ).launch<Map<String, dynamic>?>(context);
              if (result != null && result['action'] == 'refreshWorkout') {
                widget.onRefreshWorkout?.call(result['workoutDayId']);
              }
            }
          } else {
            final result = await ExerciseDetailScreen(
              mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(),
              mExerciseId: widget.mDayExerciseModel!.exerciseId.validate(),
              workOutId: widget.workOutId,
              workoutDayId: widget.workoutDayId,
              isCompleted: widget.mDayExerciseModel!.isCompleted!,
            ).launch<Map<String, dynamic>?>(context);
            if (result != null && result['action'] == 'refreshWorkout') {
              widget.onRefreshWorkout?.call(result['workoutDayId']);
            }
          }
        } else {
          final result = await ExerciseDetailScreen(
            mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(),
            mExerciseId: widget.mDayExerciseModel!.exerciseId.validate(),
            workOutId: widget.workOutId,
            workoutDayId: widget.workoutDayId,
            isCompleted: widget.mDayExerciseModel!.isCompleted!,
          ).launch<Map<String, dynamic>?>(context);
          if (result != null && result['action'] == 'refreshWorkout') {
            widget.onRefreshWorkout?.call(result['workoutDayId']);
          }
        }
        }
        /*userStore.isSubscribe == "1"
          ? ExerciseDetailScreen(mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(), mExerciseId: widget.mDayExerciseModel!.exerciseId.validate()).launch(context)
          : widget.mDayExerciseModel!.exercise!.isPremium == 1
              ? userStore.isSubscribe == 0
                  ? SubscribeScreen().launch(context)
                  : ExerciseDetailScreen(mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(), mExerciseId: widget.mDayExerciseModel!.exerciseId.validate()).launch(context)
              : ExerciseDetailScreen(mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(), mExerciseId: widget.mDayExerciseModel!.exerciseId.validate()).launch(context);*/
      );
}
