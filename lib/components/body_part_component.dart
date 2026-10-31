import '../utils/shared_import.dart';

class BodyPartComponent extends StatefulWidget {
  final bool isGrid;
  final bool isFilter;
  final BodyPartModel? bodyPartModel;

  const BodyPartComponent({
    super.key,
    this.bodyPartModel,
    this.isGrid = false,
    this.isFilter = false,
  });

  @override
  State<BodyPartComponent> createState() => _BodyPartComponentState();
}

class _BodyPartComponentState extends State<BodyPartComponent> {
  bool isBody = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isGrid && !widget.isFilter) {
      return _buildHomeCard(context);
    }

    final double width = widget.isGrid == true
        ? (context.width() - 64) / 3
        : context.width() * 0.15;
    final double height = widget.isGrid == true
        ? (context.width() - 64) / 3
        : context.width() * 0.15;

    return SizedBox(
      width: widget.isFilter == true ? context.width() * 0.24 : width,
      child: Column(
        children: [
          cachedImage(
            widget.bodyPartModel!.bodypartImage.validate(),
            fit: BoxFit.fill,
            width: width,
            height: height,
          ).cornerRadiusWithClipRRect(150),
          6.height,
          Text(
            widget.bodyPartModel!.title.validate(),
            style: primaryTextStyle(
              size: 12,
              color: isBody == true
                  ? primaryColor
                  : appStore.isDarkMode
                  ? Colors.white
                  : Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    ).onTap(_onTap);
  }

  Widget _buildHomeCard(BuildContext context) {
    final bool isDark = appStore.isDarkMode;
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: 108,
        height: 128,
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A22) : context.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: isDark
              ? null
              : Border.all(color: lightDividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: cachedImage(
                  widget.bodyPartModel!.bodypartImage.validate(),
                  fit: BoxFit.contain,
                  width: 62,
                  height: 62,
                ),
              ),
            ),
            8.height,
            Text(
              widget.bodyPartModel!.title.validate(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
                fontFamily: 'Cairo',
                height: 1.15,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    if (userStore.isLoggedIn) {
      setState(() {
        widget.isFilter == true
            ? widget.bodyPartModel!.select = true
            : const SizedBox();
      });
      widget.isFilter == true
          ? const SizedBox()
          : ExerciseListScreen(
              mTitle: widget.bodyPartModel!.title.validate(),
              isBodyPart: true,
              id: widget.bodyPartModel!.id.validate(),
            ).launch<void>(context);
    } else {
      const SignInScreen().launch<void>(context);
    }
  }
}
