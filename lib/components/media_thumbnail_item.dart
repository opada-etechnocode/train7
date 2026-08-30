import 'dart:ui';
import '../utils/shared_import.dart';

class MediaThumbnailItem extends StatelessWidget {
  final Uint8List thumbnailData;
  final bool isVideo;
  final BoxFit fitMode;
  final VoidCallback onRemove;
  final VoidCallback? onToggleFit;

  const MediaThumbnailItem({
    super.key,
    required this.thumbnailData,
    required this.isVideo,
    required this.fitMode,
    required this.onRemove,
    this.onToggleFit,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Image.memory(
                  thumbnailData,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black.withValues(alpha: 0.2),
                width: 150,
                height: 150,
              ),
              Center(
                child: Image.memory(
                  thumbnailData,
                  width: 150,
                  height: 150,
                  fit: fitMode,
                ),
              ),
            ],
          ),
        ),
        if (isVideo)
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.videocam, color: Colors.white, size: 18),
          ),
        _buildCloseButton(),
        if (!isVideo && onToggleFit != null)
          _buildFitToggleButton(),
      ],
    ),
  );

  Widget _buildCloseButton() => Positioned(
    top: 4,
    right: 4,
    child: GestureDetector(
      onTap: onRemove,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 16),
      ),
    ),
  );

  Widget _buildFitToggleButton() => Positioned(
    bottom: 4,
    left: 4,
    child: GestureDetector(
      onTap: onToggleFit,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.fit_screen, color: Colors.white, size: 16),
      ),
    ),
  );
}
