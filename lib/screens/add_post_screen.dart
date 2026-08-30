import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../utils/shared_import.dart';

class AddPostScreen extends StatefulWidget {
  final String? flow;
  final PostData? postData;
  const AddPostScreen({super.key, this.flow, this.postData});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();

  XFile? image;
  XFile? video;
  String? netWorkImage = '';
  String? netWorkVideo = '';
  List<AssetEntity> selectedAssets = [];
  List<String> existingImages = [];
  List<int> postIds = [];
  final Map<String, Future<Uint8List?>> _thumbnailCache = {};

  final Map<String, BoxFit> _fitModes = {};

  Future<void> deletePostMedia(int? id, List<int> mediaId) async {
    appStore.setLoading(true);
    final Map<String, dynamic> req = {"posting_id": id, "ids": mediaId};
    await deletePostMediaApi(req)
        .then((value) {
          appStore.setLoading(false);
          setState(() {});
        })
        .catchError((dynamic e) {
          appStore.setLoading(false);
          setState(() {});
        });
  }

  @override
  void initState() {
    super.initState();
    if (widget.flow == 'EditFlow') {
      _textController.text = widget.postData?.description ?? '';
      widget.postData?.postingMediaArray?.forEach((e) {
        existingImages.add(e.url.validate());
      });
    }
  }

  void removeExistingImage(int index) {
    setState(() {
      existingImages.removeAt(index);
    });
  }

  Future<File> convertToSquare(
    File originalFile, {
    required BoxFit fitMode,
  }) async {
    final bytes = await originalFile.readAsBytes();
    final img.Image? original = img.decodeImage(bytes);
    if (original == null) {
      throw Exception("Failed to decode image");
    }

    final int size = original.width > original.height
        ? original.width
        : original.height;

    if (fitMode == BoxFit.cover) {
      // Crop square
      final int x = (original.width - size) ~/ 2;
      final int y = (original.height - size) ~/ 2;

      final img.Image cropped = img.copyCrop(
        original,
        x: x < 0 ? 0 : x,
        y: y < 0 ? 0 : y,
        width: size > original.width ? original.width : size,
        height: size > original.height ? original.height : size,
      );

      final tempDir = await Directory.systemTemp.createTemp();
      final squareFile = File('${tempDir.path}/square_cover.png')
        ..writeAsBytesSync(img.encodePng(cropped));
      return squareFile;
    } else {
      // 🔹 Step 1: Create a square background by resizing + cropping
      img.Image background = img.copyResizeCropSquare(original, size: size);

      // 🔹 Step 2: Blur it
      background = img.gaussianBlur(background, radius: 55);

      // 🔹 Step 3: Overlay the original image in the center
      final int x = (size - original.width) ~/ 2;
      final int y = (size - original.height) ~/ 2;
      img.compositeImage(background, original, dstX: x, dstY: y);

      // 🔹 Step 4: Save
      final directory = await getTemporaryDirectory();
      final String newPath =
          '${directory.path}/square_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File newFile = File(newPath);
      await newFile.writeAsBytes(img.encodeJpg(background));
      return newFile;
    }
  }

  Future<void> _submitPost() async {
    appStore.setLoading(true);

    final MultipartRequest multiPartRequest = await getMultiPartRequest(
      'save-userpost',
    );
    multiPartRequest.fields['description'] = _textController.text;
    final List<String> path = [];

    for (AssetEntity e in selectedAssets) {
      final file = await e.file;
      if (file != null) {
        final assetId = e.id;
        final fitMode = _fitModes[assetId] ?? BoxFit.cover;
        if (e.type == AssetType.image) {
          final squareFile = await convertToSquare(file, fitMode: fitMode);
          path.add(squareFile.path);
        } else {
          path.add(file.path);
        }
      }
    }

    for (String filePath in path) {
      multiPartRequest.files.add(
        await MultipartFile.fromPath('posting_media[]', filePath),
      );
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        finish(context, 'refresh');
      },
      onError: (error) {
        log(multiPartRequest.toString());
        toast(error.toString());
        appStore.setLoading(false);
      },
    ).catchError((dynamic e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> _editPost(int? id) async {
    appStore.setLoading(true);

    final MultipartRequest multiPartRequest = await getMultiPartRequest(
      'update-userpost',
    );
    multiPartRequest.fields['id'] = id.toString();
    multiPartRequest.fields['description'] = _textController.text;

    for (AssetEntity e in selectedAssets) {
      final file = await e.file;
      if (file != null && await file.exists()) {
        final assetId = e.id;
        final fitMode = _fitModes[assetId] ?? BoxFit.cover;
        if (e.type == AssetType.image) {
          final squareFile = await convertToSquare(file, fitMode: fitMode);
          multiPartRequest.files.add(
            await MultipartFile.fromPath('posting_media[]', squareFile.path),
          );
        } else {
          multiPartRequest.files.add(
            await MultipartFile.fromPath('posting_media[]', file.path),
          );
        }
      } else {
        log("Skipping null or non-existent file: $e");
      }
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        finish(context, 'refresh');
      },
      onError: (error) {
        log(multiPartRequest.toString());
        toast(error.toString());
        appStore.setLoading(false);
      },
    ).catchError((dynamic e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> pickMedia(BuildContext context) async {
    final photoStatus = await Permission.photos.request();
    final videoStatus = await Permission.videos.request();

    if (!context.mounted) return;
    if (!photoStatus.isGranted || !videoStatus.isGranted) {
      showConfirmDialogCustom(
        context,
        title: languages.lblPermissionDescription,
        positiveText: languages.lblOpen,
        image: ic_logout,
        onAccept: (buildContext) async {
          await openAppSettings();
        },
      );
      return;
    }

    if (!context.mounted) return;
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        pickerTheme: AssetPicker.themeData(primaryColor, light: true),
        maxAssets: 10,
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedAssets = result;
        for (AssetEntity asset in selectedAssets) {
          if (!_thumbnailCache.containsKey(asset.id)) {
            _thumbnailCache[asset.id] = asset.thumbnailDataWithSize(
              const ThumbnailSize.square(200),
              quality: 80,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBarWidget(
      widget.flow == "EditFlow" ? languages.lblEditPost : languages.lblNewPost,
      context: context,
    ),
    body: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Column(
                  children: [
                    PostDescriptionField(controller: _textController),
                    20.height,
                    PostMediaList(
                      existingMedia: widget.flow == "EditFlow"
                          ? widget.postData?.postingMediaArray
                          : null,
                      selectedAssets: selectedAssets,
                      thumbnailCache: _thumbnailCache,
                      fitModes: _fitModes,
                      onRemoveExisting: (index) {
                        setState(() {
                          postIds.add(
                            widget.postData!.postingMediaArray![index].id
                                .validate(),
                          );
                          widget.postData!.postingMediaArray!.removeAt(index);
                        });
                      },
                      onRemoveSelected: (index, assetId) {
                        setState(() {
                          selectedAssets.removeAt(index);
                          _thumbnailCache.remove(assetId);
                        });
                      },
                      onToggleFit: (assetId) {
                        setState(() {
                          _fitModes[assetId] =
                              (_fitModes[assetId] == BoxFit.cover)
                                  ? BoxFit.contain
                                  : BoxFit.cover;
                        });
                      },
                    ).visible(
                      (widget.flow == "EditFlow" &&
                              widget.postData?.postingMediaArray != null &&
                              widget.postData!.postingMediaArray!.isNotEmpty) ||
                          selectedAssets.isNotEmpty,
                    ),
                    10.height,
                    PostMediaUploadButton(
                      onTap: () => pickMedia(context),
                    ),
                    20.height,
                    AppButton(
                      text: widget.flow == "EditFlow"
                          ? languages.lblEditPost
                          : languages.lblSharePost,
                      width: context.width(),
                      color: primaryColor,
                      onTap: () async {
                        if (_textController.text.isNotEmpty ||
                            selectedAssets.isNotEmpty ||
                            (widget.flow == "EditFlow" &&
                                widget.postData?.postingMediaArray != null &&
                                widget.postData!.postingMediaArray!.isNotEmpty)) {
                          if (widget.flow == "EditFlow") {
                            deletePostMedia(widget.postData!.id, postIds);
                            _editPost(widget.postData?.id ?? 0);
                          } else {
                            _submitPost();
                          }
                        } else {
                          toast(languages.lblEmptyMsg);
                        }
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),
                Observer(
                  builder: (context) => SizedBox(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height,
                    child: const Loader().visible(appStore.isLoading).center(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
