import '../utils/shared_import.dart';

class DashboardFloatingMenu extends StatelessWidget {
  final bool isExpanded;
  final Animation<double> animation;
  final VoidCallback onToggle;
  final CrispConfig? configData;

  const DashboardFloatingMenu({
    super.key,
    required this.isExpanded,
    required this.animation,
    required this.onToggle,
    this.configData,
  });

  @override
  Widget build(BuildContext context) => Column(
      children: [
        if (getBoolAsync(MOBILE_GAME_ENABLED))
          _buildAnimatedButton(
            animation: animation,
            offsetMultiplier: 23,
            onClick: () {
              const GameHomeScreen().launch<void>(context);
              onToggle();
            },
            image: ic_mental,
          ),
        if (getBoolAsync(CRISP_CHAT_ENABLED))
          _buildAnimatedButton(
            animation: animation,
            offsetMultiplier: 10,
            onClick: () async {
              onToggle();
              if (userStore.isLoggedIn) {
                if (configData != null) {
                  await FlutterCrispChat.openCrispChat(config: configData!);
                }
              } else {
                const SignInScreen().launch<void>(context);
              }
            },
            image: ic_support,
          ),
        _buildAnimatedButton(
          animation: animation,
          offsetMultiplier: -5,
          onClick: () async {
            if (userStore.isLoggedIn) {
              final isFirstTime = await getFirstTimeOpen();
              if (context.mounted) {
                if (isFirstTime == false || isFirstTime == null) {
                  const MainGoalScreen().launch<void>(context);
                } else {
                  const ChattingImageScreen(isDirect: true).launch<void>(context);
                }
              }
            } else {
              const SignInScreen().launch<void>(context);
            }
            onToggle();
          },
          image: ic_bot,
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
    );

  Widget _buildAnimatedButton({
    required Animation<double> animation,
    required double offsetMultiplier,
    required VoidCallback? onClick,
    required String image,
  }) => AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, offsetMultiplier * animation.value),
        child: Visibility(
          visible: isExpanded,
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: CircularButton(
              height: 53,
              width: 53,
              color: primaryColor,
              onClick: isExpanded ? onClick : null,
              image: image,
            ),
          ),
        ),
      ),
    );
}
