import '../utils/shared_import.dart';

class DashboardFabMenu extends StatelessWidget {
  final Animation<double> animation;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onGameTap;
  final VoidCallback onChatTap;
  final VoidCallback onBotTap;

  const DashboardFabMenu({
    super.key,
    required this.animation,
    required this.isExpanded,
    required this.onToggle,
    required this.onGameTap,
    required this.onChatTap,
    required this.onBotTap,
  });

  @override
  Widget build(BuildContext context) => Positioned(
      bottom: 30,
      right: 25,
      child: Column(
        children: [
          if (getBoolAsync(MOBILE_GAME_ENABLED) == true)
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, 23 * animation.value),
                child: Visibility(
                  visible: isExpanded,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: CircularButton(
                      height: 53,
                      width: 53,
                      color: primaryColor,
                      onClick: isExpanded ? onGameTap : null,
                      image: ic_mental,
                    ),
                  ),
                ),
              ),
            ),
          if (getBoolAsync(CRISP_CHAT_ENABLED) == true)
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, 10 * animation.value),
                child: Visibility(
                  visible: isExpanded,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: CircularButton(
                      height: 53,
                      width: 53,
                      color: primaryColor,
                      onClick: isExpanded ? onChatTap : null,
                      image: ic_support,
                    ),
                  ),
                ),
              ),
            ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, -5 * animation.value),
              child: Visibility(
                visible: isExpanded,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: CircularButton(
                    height: 53,
                    width: 53,
                    color: primaryColor,
                    onClick: isExpanded ? onBotTap : null,
                    image: ic_bot,
                  ),
                ),
              ),
            ),
          ),
          CircularButton(
            height: 60,
            width: 60,
            onClick: onToggle,
            color: primaryColor,
            icon: Icon(
              isExpanded ? Icons.close : Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
}
