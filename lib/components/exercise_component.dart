import '../utils/shared_import.dart';

class ExerciseComponent extends StatefulWidget {
  final ExerciseModel? mExerciseModel;
  final Function? onCall;

  const ExerciseComponent({super.key, this.mExerciseModel, this.onCall});

  @override
  State<ExerciseComponent> createState() => _ExerciseComponentState();
}

class _ExerciseComponentState extends State<ExerciseComponent> {
  List<String>? mSets = [];

  @override
  void initState() {
    if (widget.mExerciseModel!.type == SETS) {
      if (widget.mExerciseModel!.sets != null) {
        for (var element in widget.mExerciseModel!.sets!) {
          if (widget.mExerciseModel!.based.toString() == TIME) {
            mSets!.add("${element.time}s");
          } else {
            mSets!.add("${element.reps}x");
          }
          setState(() {});
        }
      }
    }
    super.initState();
  }

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
                cachedImage(
                  widget.mExerciseModel!.exerciseImage.validate(),
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(10),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    6.height,
                    Text(
                      widget.mExerciseModel!.title.validate(),
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    6.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.mExerciseModel!.type == DURATION)
                          Text(
                            "${widget.mExerciseModel!.duration.validate()} ${languages.lblDuration}",
                            style: secondaryTextStyle(size: 12),
                          ),
                        if (widget.mExerciseModel!.type == SETS)
                          Text(
                            mSets!.join(" ").toString(),
                            style: secondaryTextStyle(size: 12),
                          ),
                        if (userStore.subscription == "1")
                          if (widget.mExerciseModel!.isPremium == 1) mPro(),
                      ],
                    ),
                  ],
                ).expand(),
              ],
            ).expand(),
          ],
        ),
      ).onTap(() async {
        userStore.subscription == "1"
            ? widget.mExerciseModel!.isPremium == 1
                  ? userStore.isSubscribe == 0
                        ? await const SubscribeScreen().launch<void>(context)
                        : await ExerciseDetailScreen(
                            mExerciseName: widget.mExerciseModel!.title
                                .validate(),
                            mExerciseId: widget.mExerciseModel!.id.validate(),
                            // workOutId: widget.mExerciseModel!.id.toString(),
                          ).launch<void>(context)
                  : await ExerciseDetailScreen(
                      mExerciseName: widget.mExerciseModel!.title.validate(),
                      mExerciseId: widget.mExerciseModel!.id.validate(),
                    ).launch<void>(context)
            : await ExerciseDetailScreen(
                mExerciseName: widget.mExerciseModel!.title.validate(),
                mExerciseId: widget.mExerciseModel!.id.validate(),
              ).launch<void>(context);

        widget.onCall?.call();
      });
}
