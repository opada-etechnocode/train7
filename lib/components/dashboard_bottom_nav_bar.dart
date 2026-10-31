import '../utils/shared_import.dart';

class DashboardBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final VoidCallback onFabTap;

  const DashboardBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
  });

  void _handleTap(BuildContext context, int index) {
    if ((index == 3 || index == 4 || index == 5) && !userStore.isLoggedIn) {
      const SignInScreen().launch<void>(context);
      return;
    }
    if (index == 5 && userStore.isLoggedIn && userStore.weight.isEmptyOrNull) {
      toast(languages.lblPleaseenteryourageweightandhei);
      return;
    }
    onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = appStore.isDarkMode;
    final Color barColor = isDark ? const Color(0xFF12151C) : Colors.white;
    final Color inactive = isDark ? Colors.white54 : const Color(0xFF8A8A8A);

    return Container(
      decoration: BoxDecoration(
        color: barColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                children: [
                  _navItem(
                    context,
                    index: 0,
                    icon: ic_home_outline,
                    activeIcon: ic_home_fill,
                    label: languages.lblHome,
                    inactiveColor: inactive,
                  ),
                  _navItem(
                    context,
                    index: 1,
                    icon: ic_diet_outline,
                    activeIcon: ic_diet_fill,
                    label: languages.lblDiet,
                    inactiveColor: inactive,
                  ),
                  _navItem(
                    context,
                    index: 2,
                    icon: ic_store_outline,
                    activeIcon: ic_store_fill,
                    label: languages.lblShop,
                    inactiveColor: inactive,
                  ),
                  const SizedBox(width: 40),
                  _navItem(
                    context,
                    index: 3,
                    icon: ic_community2,
                    activeIcon: ic_community_filled,
                    label: languages.lblCommunity,
                    inactiveColor: inactive,
                    height: 22,
                  ),
                  _navItem(
                    context,
                    index: 4,
                    icon: ic_schedule,
                    activeIcon: ic_fill_schedule,
                    label: languages.lblSchedule,
                    inactiveColor: inactive,
                    height: 22,
                  ),
                  _navItem(
                    context,
                    index: 5,
                    iconData: Icons.assignment_outlined,
                    activeIconData: Icons.assignment,
                    label: languages.plan,
                    inactiveColor: inactive,
                  ),
                ],
              ),
              Positioned(
                top: -15,
                child: GestureDetector(
                  onTap: onFabTap,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryLightColor, primaryColor],
                      ),

                    ),
                    child: const Icon(Icons.add, color: Colors.black, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required int index,
    String? icon,
    String? activeIcon,
    IconData? iconData,
    IconData? activeIconData,
    required String label,
    required Color inactiveColor,
    double height = 24,
  }) {
    final bool selected = currentIndex == index;
    final Color color = selected ? primaryColor : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null && activeIcon != null)
              Image.asset(
                selected ? activeIcon : icon,
                color: color,
                height: height,
              )
            else
              Icon(
                selected ? activeIconData : iconData,
                color: color,
                size: 24,
              ),
            4.height,
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: selected ? 12 : 11,
                color: color,
                fontFamily: 'Cairo',
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
