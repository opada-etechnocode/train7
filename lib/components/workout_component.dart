import '../utils/shared_import.dart';

class WorkoutComponent extends StatefulWidget {
  final WorkoutDetailModel? mWorkoutModel;
  final Function? onCall;
  final bool isView;

  const WorkoutComponent({
    super.key,
    this.mWorkoutModel,
    this.onCall,
    this.isView = false,
  });

  @override
  _WorkoutComponentState createState() => _WorkoutComponentState();
}

class _WorkoutComponentState extends State<WorkoutComponent> {
  Future<void> setWorkout(int? id) async {
    appStore.setLoading(true);
    final Map<String, dynamic> req = {"workout_id": id};
    await setWorkoutFavApi(req)
        .then((value) {
          toast(value.message);
          appStore.setLoading(false);
          widget.mWorkoutModel!.isFavourite = widget.mWorkoutModel!.isFavourite == 1 ? 0 : 1;
          widget.onCall?.call();
          setState(() {});
        })
        .catchError((Object e) {
          appStore.setLoading(false);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.isView == true
        ? context.width()
        : context.width() * 0.72;
    const height = 190.0;
    log("--------203>>>${userStore.subscription}");

    return Stack(
          children: [
            cachedImage(
              widget.mWorkoutModel!.workoutImage.validate(),
              height: height,
              fit: BoxFit.cover,
              width: width,
            ).cornerRadiusWithClipRRect(16),
            mBlackEffect(width, height),
            Positioned(
              left: 16,
              top: 8,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  userStore.subscription == "1"
                      ? widget.mWorkoutModel!.isPremium == 1
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
                      widget.mWorkoutModel!.isFavourite == 1
                          ? ic_favorite_fill
                          : ic_favorite,
                      color: widget.mWorkoutModel!.isFavourite == 1
                          ? primaryColor
                          : white,
                      width: 20,
                      height: 20,
                    ).center(),
                  ).visible(userStore.isLoggedIn).onTap(() {
                    setState(() {});
                    setWorkout(widget.mWorkoutModel!.id.validate());
                  }),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.mWorkoutModel!.title
                        .capitalizeFirstLetter()
                        .validate(),
                    style: boldTextStyle(color: white),
                  ),
                  4.height,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          height: 4,
                          width: 4,
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            backgroundColor: white,
                          ),
                        ),
                        Text(
                          widget.mWorkoutModel!.workoutTypeTitle.validate(),
                          style: secondaryTextStyle(color: white),
                        ),
                        8.width,
                        Container(height: 14, width: 2, color: primaryColor),
                        8.width,
                        Text(
                          widget.mWorkoutModel!.levelTitle.validate(),
                          style: secondaryTextStyle(color: white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        .onTap(() {
          _onWorkoutTap(context);
        })
        .paddingBottom(widget.isView == true ? 16 : 0);
  }

  void _onWorkoutTap(BuildContext context) {
    if (!userStore.isLoggedIn) {
      const SignInScreen().launch<void>(context);
      return;
    }

    final model = widget.mWorkoutModel!;
    final bool isPremiumWorkout = model.isPremium == 1;

    if (userStore.subscription == "1" && isPremiumWorkout && userStore.isSubscribe == 0) {
      const SubscribeScreen().launch<void>(context);
    } else {
      WorkoutDetailScreen(
        id: model.id,
        mWorkoutModel: model,
      ).launch<void>(context).then((value) {
        widget.onCall?.call();
      });
    }
  }
}
