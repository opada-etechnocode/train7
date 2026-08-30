import '../utils/shared_import.dart';

class PostMediaList extends StatelessWidget {
  final List<PostingMediaArray>? existingMedia;
  final List<AssetEntity> selectedAssets;
  final Map<String, Future<Uint8List?>> thumbnailCache;
  final Map<String, BoxFit> fitModes;
  final void Function(int) onRemoveExisting;
  final void Function(int, String) onRemoveSelected;
  final void Function(String) onToggleFit;

  const PostMediaList({
    super.key,
    this.existingMedia,
    required this.selectedAssets,
    required this.thumbnailCache,
    required this.fitModes,
    required this.onRemoveExisting,
    required this.onRemoveSelected,
    required this.onToggleFit,
  });

  @override
  Widget build(BuildContext context) {
    final int existingCount = existingMedia?.length ?? 0;
    final int selectedCount = selectedAssets.length;

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: existingCount + selectedCount,
        itemBuilder: (context, index) {
          if (index < existingCount) {
            final asset = existingMedia![index];
            final assetId = asset.id.toString();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  cachedImage(
                    asset.url.validate(),
                    width: 150,
                    height: 150,
                    fit: fitModes[assetId] ?? BoxFit.cover,
                  ).cornerRadiusWithClipRRect(10),
                  if (asset.mimeType == "video/mp4")
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => onRemoveExisting(index),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final asset = selectedAssets[index - existingCount];
            final assetId = asset.id;

            return FutureBuilder<Uint8List?>(
              future: thumbnailCache[assetId],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return MediaThumbnailItem(
                    thumbnailData: snapshot.data!,
                    isVideo: asset.type == AssetType.video,
                    fitMode: fitModes[assetId] ?? BoxFit.cover,
                    onRemove: () => onRemoveSelected(index - existingCount, assetId),
                    onToggleFit: asset.type != AssetType.video
                        ? () => onToggleFit(assetId)
                        : null,
                  );
                } else {
                  return Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
