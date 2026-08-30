import '../utils/shared_import.dart';

class ExerciseVideoControls extends StatelessWidget {
  final bool isShowController;
  final bool isPlaying;
  final bool isMuted;
  final bool isCurrentlyLandscape;
  final String currentTime;
  final String totalTime;
  final double videoProgress;
  final VoidCallback onTogglePlay;
  final VoidCallback onSkipBackward;
  final VoidCallback onSkipForward;
  final VoidCallback onToggleVolume;
  final VoidCallback onToggleOrientation;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onSliderChangeEnd;

  const ExerciseVideoControls({
    super.key,
    required this.isShowController,
    required this.isPlaying,
    required this.isMuted,
    required this.isCurrentlyLandscape,
    required this.currentTime,
    required this.totalTime,
    required this.videoProgress,
    required this.onTogglePlay,
    required this.onSkipBackward,
    required this.onSkipForward,
    required this.onToggleVolume,
    required this.onToggleOrientation,
    required this.onSliderChanged,
    required this.onSliderChangeEnd,
  });

  @override
  Widget build(BuildContext context) => Visibility(
      visible: isShowController,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 65),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularButton(ic_backward, onSkipBackward, isImage: true),
                20.width,
                _buildCircularButton(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  onTogglePlay,
                  isIcon: true,
                ),
                20.width,
                _buildCircularButton(ic_forward, onSkipForward, isImage: true),
              ],
            ).expand(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            currentTime,
                            style: boldTextStyle(color: Colors.white, size: 13),
                          ),
                          Text(
                            ' / $totalTime',
                            style: primaryTextStyle(color: Colors.white, size: 13),
                          ),
                          IconButton(
                            icon: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_up,
                              size: 30,
                            ),
                            onPressed: onToggleVolume,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          isCurrentlyLandscape ? Icons.fullscreen_exit : Icons.fullscreen,
                          color: Colors.white,
                        ),
                        onPressed: onToggleOrientation,
                      ),
                    ],
                  ),
                  _buildSlider(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildCircularButton(dynamic iconOrImage, VoidCallback onTap, {bool isIcon = false, bool isImage = false}) => Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: isIcon ? 0.6 : 0.9),
        shape: BoxShape.circle,
      ),
      child: isIcon
          ? IconButton(
              icon: Icon(iconOrImage as IconData, color: Colors.white),
              onPressed: onTap,
            )
          : GestureDetector(
              onTap: onTap,
              child: Image.asset(iconOrImage as String, height: 30, width: 30),
            ),
    );

  Widget _buildSlider(BuildContext context) => SizedBox(
      height: 5,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 5.0,
          overlayShape: SliderComponentShape.noOverlay,
          thumbColor: primaryColor,
          trackShape: SliderCustomTrackShape(),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        ),
        child: Slider(
          value: videoProgress,
          onChanged: onSliderChanged,
          onChangeEnd: onSliderChangeEnd,
        ),
      ),
    );
}
