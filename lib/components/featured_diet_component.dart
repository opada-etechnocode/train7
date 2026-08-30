import 'dart:ui';

import '../utils/shared_import.dart';

class FeaturedDietComponent extends StatefulWidget {
  final bool isList;
  final DietModel? mDietModel;

  final bool? isFeatured;
  final bool? isCategory;

  final int? mCategoryId;

  final Function? onCall;

  const FeaturedDietComponent({
    super.key,
    this.mDietModel,
    this.isList = false,
    this.isFeatured,
    this.isCategory,
    this.mCategoryId,
    this.onCall,
  });

  @override
  State<FeaturedDietComponent> createState() => _FeaturedDietComponentState();
}

class _FeaturedDietComponentState extends State<FeaturedDietComponent> {
  int? numPage;

  bool isLastPage = false;

  List<DietModel> mDietList = [];

  Future<void> setDiet(int? id) async {
    appStore.setLoading(true);
    final Map<String, dynamic> req = {"diet_id": id};
    await setDietFavApi(req)
        .then((value) {
          toast(value.message);
          if (widget.mDietModel!.isFavourite == 1) {
            widget.mDietModel!.isFavourite = 0;
          } else {
            widget.mDietModel!.isFavourite = 1;
          }
          appStore.setLoading(false);
          widget.onCall!.call();
          setState(() {});
        })
        .catchError((Object e) {
          appStore.setLoading(false);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) => widget.isList
      ? Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: context.width(),
          decoration: appStore.isDarkMode
              ? boxDecorationWithRoundedCorners(borderRadius: radius(16))
              : boxDecorationRoundedWithShadow(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  cachedImage(
                    widget.mDietModel!.dietImage.validate(),
                    width: context.width(),
                    height: 190,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRectOnly(topRight: 16, topLeft: 16),
                  Positioned(
                    top: 12,
                    right: 12,
                    child:
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          child: Image.asset(
                            widget.mDietModel!.isFavourite == 1
                                ? ic_favorite_fill
                                : ic_favorite,
                            height: 20,
                            width: 20,
                            color: widget.mDietModel!.isFavourite == 1
                                ? primaryColor
                                : white,
                          ),
                        ).onTap(() {
                          setState(() {});
                          setDiet(widget.mDietModel!.id.validate());
                        }),
                  ).visible(userStore.isLoggedIn),
                  userStore.subscription == "1"
                      ? widget.mDietModel!.isPremium == 1
                            ? Positioned(top: 12, left: 12, child: mPro())
                            : const SizedBox()
                      : const SizedBox(),
                ],
              ),
              Text(
                widget.mDietModel!.title.validate(),
                style: primaryTextStyle(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).paddingSymmetric(horizontal: 16, vertical: 12),
            ],
          ),
        ).onTap(() async {
          if (userStore.isLoggedIn) {
            userStore.subscription == "1"
                ? widget.mDietModel!.isPremium == 1
                      ? userStore.isSubscribe == 0
                            ? await const SubscribeScreen().launch<void>(context)
                            : await DietDetailScreen(
                                dietModel: widget.mDietModel!,
                              ).launch<void>(context)
                      : await DietDetailScreen(
                          dietModel: widget.mDietModel!,
                        ).launch<void>(context)
                : await DietDetailScreen(
                    dietModel: widget.mDietModel!,
                  ).launch<void>(context);

            log("fgffhfhfhfhf");

            widget.onCall?.call();
            setState(() {});
          } else {
            const SignInScreen().launch<void>(context);
          }
        })
      : Container(
          margin: const EdgeInsets.only(bottom: 16, right: 8),
          width: context.width() * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  cachedImage(
                    widget.mDietModel!.dietImage.validate(),
                    width: context.width() * 0.65,
                    height: 240,
                    fit: BoxFit.fill,
                  ).cornerRadiusWithClipRRect(16),
                  Positioned(
                    top: 12,
                    right: 12,
                    child:
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          child: Image.asset(
                            widget.mDietModel!.isFavourite == 1
                                ? ic_favorite_fill
                                : ic_favorite,
                            height: 20,
                            width: 20,
                            color: widget.mDietModel!.isFavourite == 1
                                ? primaryColor
                                : white,
                          ),
                        ).onTap(() {
                          setState(() {});
                          setDiet(widget.mDietModel!.id.validate());
                        }),
                  ).visible(userStore.isLoggedIn),
                  userStore.subscription == "1"
                      ? widget.mDietModel!.isPremium == 1
                            ? Positioned(top: 12, left: 12, child: mPro())
                            : const SizedBox()
                      : const SizedBox(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: radiusOnly(
                        bottomRight: 16,
                        bottomLeft: 16,
                        topLeft: 8,
                        topRight: 8,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radiusOnly(
                              bottomRight: 16,
                              bottomLeft: 16,
                              topLeft: 8,
                              topRight: 8,
                            ),
                            backgroundColor: Colors.grey.shade100.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          child: Text(
                            widget.mDietModel!.title.validate(),
                            style: primaryTextStyle(color: black),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ).paddingSymmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).onTap(() async {
          if (userStore.isLoggedIn) {
            userStore.subscription == "1"
                ? widget.mDietModel!.isPremium == 1
                      ? userStore.isSubscribe == 0
                            ? const SubscribeScreen().launch<void>(context)
                            : DietDetailScreen(
                                dietModel: widget.mDietModel!,
                              ).launch<void>(context)
                      : await DietDetailScreen(
                          dietModel: widget.mDietModel!,
                        ).launch<void>(context)
                : DietDetailScreen(
                    dietModel: widget.mDietModel!,
                  ).launch<void>(context);
            setState(() {});
          } else {
            const SignInScreen().launch<void>(context);
          }
        });
}
