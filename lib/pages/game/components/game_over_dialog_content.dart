
import '../../../utils/shared_import.dart';

class GameOverDialogContent extends StatefulWidget {
  final int level;
  final VoidCallback onExit;

  const GameOverDialogContent({
    super.key,
    required this.level,
    required this.onExit,
  });

  @override
  State<GameOverDialogContent> createState() => _GameOverDialogContentState();
}

class _GameOverDialogContentState extends State<GameOverDialogContent> {
  final List<bool> _starVisibilities = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _startStarAnimation();
  }

  Future<void> _startStarAnimation() async {
    for (int i = 0; i < _starVisibilities.length; i++) {
      if (!mounted) return;
      setState(() {
        _starVisibilities[i] = true;
      });
    }
  }

  Widget _buildStar(int index) => AnimatedOpacity(
    opacity: _starVisibilities[index] ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 100),
    child: Lottie.asset(
      'assets/star.json',
      width: 90,
      height: 90,
      repeat: false,
    ),
  );

  @override
  Widget build(BuildContext context) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildStarRow(),
              Lottie.asset('assets/gameover.json', width: 180, height: 180),
              Text(
                languages.lblBetterLuckNextTime,
                textAlign: TextAlign.center,
                style: primaryTextStyle(
                  size: 16,
                  weight: FontWeight.bold,
                  color: appStore.isDarkMode
                      ? Colors.white
                      : scaffoldColorDark,
                ),
              ),
              10.height,
              AppButton(
                text: languages.lblExit,
                width: context.width(),
                color: Colors.red,
                onTap: widget.onExit,
              ).paddingSymmetric(horizontal: 20, vertical: 13),
              10.height,
            ],
          ),
        ),
      ),
    );

  Widget _buildStarRow() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.level > 5)
          SizedBox(width: 50, height: 50, child: _buildStar(0)),
        if (widget.level > 15)
          SizedBox(width: 50, height: 50, child: _buildStar(1)),
        if (widget.level > 30)
          SizedBox(width: 50, height: 50, child: _buildStar(2)),
        if (widget.level > 40)
          SizedBox(width: 50, height: 50, child: _buildStar(3)),
        if (widget.level > 50)
          SizedBox(width: 50, height: 50, child: _buildStar(4)),
      ],
    );
}
