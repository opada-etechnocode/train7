import '../utils/shared_import.dart';

class OtherUserProfileAppbar extends StatelessWidget {
  final String title;

  const OtherUserProfileAppbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(
            appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_forward_ios : Octicons.chevron_left,
            color: white,
            size: 28,
          ).onTap(() {
            Navigator.pop(context);
          }),
          16.width,
          Text(
            title,
            style: boldTextStyle(size: 20, color: white),
          ),
        ],
      ).paddingOnly(
        top: context.statusBarHeight + 16,
        left: 16,
        right: appStore.selectedLanguageCode == 'ar' ? 16 : 0,
      ),
    );
}
