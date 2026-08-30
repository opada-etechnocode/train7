import 'dart:ui';

import '../utils/shared_import.dart';

class EquipmentComponent extends StatefulWidget {
  final bool isGrid;
  final bool isSearch;
  final int? isEquId;
  final Function? onCall;

  final EquipmentModel? mEquipmentModel;

  const EquipmentComponent({
    super.key,
    this.mEquipmentModel,
    this.isGrid = false,
    this.isSearch = false,
    this.isEquId,
    this.onCall,
  });

  @override
  State<EquipmentComponent> createState() => _EquipmentComponentState();
}

class _EquipmentComponentState extends State<EquipmentComponent> {
  bool isEquipment = false;
  List<int>? mId = [];

  @override
  Widget build(BuildContext context) {
    final double width = widget.isGrid == true
        ? (context.width() - 48) / 2
        : context.width() * 0.4;
    final double height = widget.isGrid == true ? 190 : 185;
    return Column(
      children: [
        widget.isSearch == true
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(12),
                      border: Border.all(
                        color: widget.mEquipmentModel!.isSelected == true
                            ? primaryColor
                            : Colors.transparent,
                      ),
                    ),
                    child: cachedImage(
                      widget.mEquipmentModel!.equipmentImage.validate(),
                      height: 135,
                      width: (context.width() - 54) / 3,
                      fit: BoxFit.fill,
                    ).cornerRadiusWithClipRRect(12),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 1),
                      width: (context.width() - 54) / 3,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: Colors.grey.shade200.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      child: Text(
                        widget.mEquipmentModel!.title.validate(),
                        style: boldTextStyle(color: Colors.black),
                      ).center(),
                    ),
                  ),
                ],
              ).onTap(() {
                if (widget.isSearch == true) {
                  widget.mEquipmentModel!.isSelected =
                      !widget.mEquipmentModel!.isSelected!;
                  if (widget.mEquipmentModel!.isSelected == true) {
                    mId!.add(widget.mEquipmentModel!.id.validate());
                  } else {
                    mId!.remove(widget.mEquipmentModel!.id.validate());
                  }
                  widget.onCall!.call(mId);
                } else {
                  ExerciseListScreen(
                    mTitle: widget.mEquipmentModel!.title.validate(),
                    isEquipment: true,
                    id: widget.mEquipmentModel!.id.validate(),
                  ).launch<void>(context);
                }
              })
            : Stack(
                children: [
                  cachedImage(
                    widget.mEquipmentModel!.equipmentImage.validate(),
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(20),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        ic_dumbbell,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.75),
                          ],
                        ),
                      ),
                      child: Text(
                        widget.mEquipmentModel!.title.validate(),
                        style: boldTextStyle(color: Colors.white, size: 13),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ).onTap(() {
                if (userStore.isLoggedIn) {
                  ExerciseListScreen(
                    mTitle: widget.mEquipmentModel!.title.validate(),
                    isEquipment: true,
                    id: widget.mEquipmentModel!.id.validate(),
                  ).launch<void>(context);
                } else {
                  const SignInScreen().launch<void>(context);
                }
              }),
      ],
    );
  }
}
