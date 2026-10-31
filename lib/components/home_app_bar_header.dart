import '../utils/shared_import.dart';

class HomeAppBarHeader extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onPersonTap;

  const HomeAppBarHeader({
    super.key,
    required this.onProfileTap,
    required this.onNotificationTap,
    required this.onPersonTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = appStore.isDarkMode;
    final Color iconBg = isDark ? const Color(0xFF1C222D) : Colors.white;
    final Color iconBorder = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : context.dividerColor.withValues(alpha: 0.9);
    final Color iconColor = isDark ? Colors.white : Colors.grey.shade700;

    return Padding(
      padding: EdgeInsets.only(
        top: context.statusBarHeight + 10,
        left: 16,
        right: 16,
        bottom: 6,
      ),
      child: Row(
        children: [
          Observer(
            builder: (context) => GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 1.6),
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: cachedImage(
                    userStore.profileImage.validate(),
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ).visible(userStore.isLoggedIn),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Observer(
                  builder: (context) => Text(
                    '${languages.lblHey}${userStore.fName.validate().capitalizeFirstLetter()} ${userStore.lName.capitalizeFirstLetter()}👋',
                    style: boldTextStyle(
                      size: 16,
                      color: isDark ? Colors.white : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                3.height,
                Text(
                  languages.lblHomeWelMsg,
                  style: secondaryTextStyle(
                    size: 12,
                    color: isDark ? const Color(0xFF9AA0A6) : null,
                  ),
                ),
              ],
            ),
          ),
          _circleIcon(
            child: Image.asset(
              ic_notification,
              width: 20,
              height: 20,
              color: iconColor,
            ),
            bg: iconBg,
            border: iconBorder,
            onTap: onNotificationTap,
            badgeCount: 2,
          ),
          8.width,
          _circleIcon(
            child: Icon(Icons.person_outline_rounded, size: 22, color: iconColor),
            bg: iconBg,
            border: iconBorder,
            onTap: onPersonTap,
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({
    required Widget child,
    required Color bg,
    required Color border,
    required VoidCallback onTap,
    int? badgeCount,
  }) => GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bg,
              border: Border.all(color: border, width: 1),
            ),
            alignment: Alignment.center,
            child: child,
          ),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              top: -3,
              right: -2,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    height: 1.1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
}
