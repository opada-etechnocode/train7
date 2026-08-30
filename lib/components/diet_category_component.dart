import '../utils/shared_import.dart';

class DietCategoryComponent extends StatefulWidget {
  final CategoryDietModel? mCategoryDietModel;
  final bool isGrid;

  final Function? onCall;

  const DietCategoryComponent({
    super.key,
    this.mCategoryDietModel,
    this.isGrid = false,
    this.onCall,
  });

  @override
  State<DietCategoryComponent> createState() => _DietCategoryComponentState();
}

class _DietCategoryComponentState extends State<DietCategoryComponent> {
  @override
  Widget build(BuildContext context) =>
      Container(
        width: widget.isGrid
            ? (context.width() - 48) / 2
            : context.width() * 0.38,
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(12),
          backgroundColor: appStore.isDarkMode
              ? context.cardColor
              : cardBackground,
        ),
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            cachedImage(
              widget.mCategoryDietModel!.categorydietImage!.validate(),
              fit: BoxFit.contain,
              width: context.width(),
              height: 100,
            ).cornerRadiusWithClipRRectOnly(topRight: 12, topLeft: 12),
            4.height,
            Text(
              widget.mCategoryDietModel!.title!.validate(),
              style: primaryTextStyle(size: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ).paddingSymmetric(horizontal: 16),
            16.height,
          ],
        ),
      ).paddingOnly(bottom: 8, right: widget.isGrid ? 0 : 10).onTap(() {
        if (userStore.isLoggedIn) {
          ViewAllDiet(
            isCategory: true,
            mCategoryId: widget.mCategoryDietModel!.id,
            mTitle: widget.mCategoryDietModel!.title,
          ).launch<void>(context);
        } else {
          const SignInScreen().launch<void>(context);
        }
      });
}
