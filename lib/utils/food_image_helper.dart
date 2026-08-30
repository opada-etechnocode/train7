import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../utils/shared_import.dart';

const int kFoodRecognitionImageSize = 544;

/// Center-crops to a square and resizes to exactly 544x544 (API requirement).
Future<File> prepareFoodRecognitionImage(File source) async {
  final bytes = await source.readAsBytes();
  final img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw Exception(languages.lblFailedToLoadImage);
  }

  final img.Image resized = img.copyResizeCropSquare(
    decoded,
    size: kFoodRecognitionImageSize,
  );

  final Directory dir = await getTemporaryDirectory();
  final File out = File(
    '${dir.path}/food_${kFoodRecognitionImageSize}_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );
  await out.writeAsBytes(img.encodeJpg(resized, quality: 90));
  return out;
}
