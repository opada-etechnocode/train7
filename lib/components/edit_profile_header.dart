import '../utils/shared_import.dart';

class EditProfileHeader extends StatelessWidget {
  final VoidCallback onBack;

  const EditProfileHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(
            appStore.selectedLanguageCode == 'ar'
                ? MaterialIcons.arrow_forward_ios
                : Octicons.chevron_left,
            color: white,
            size: 28,
          ).onTap(onBack),
          16.width,
          Text(
            languages.lblEditProfile,
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
