import 'package:flutter_html/flutter_html.dart';

import '../utils/shared_import.dart';

class VimeoEmbedWidget extends StatelessWidget {
  final String videoId;

  const VimeoEmbedWidget(this.videoId, {super.key});

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(
        child: Html(
          data:
              '''
    <iframe 
      src="https://player.vimeo.com/video/$videoId" 
      width="640" 
      height="230" 
      style="border:0;" 
      allow="autoplay; fullscreen" 
      allowfullscreen>
    </iframe>
  ''',
        ),

        // child: Html(
        //  data: '<iframe src="https://player.vimeo.com/video/$videoId" width="640" height="230" frameborder="0" allow="autoplay; fullscreen" allowfullscreen="allowfullscreen"></iframe>',
        // ),
      ).onTap(() {
        launchUrls(
          'https://player.vimeo.com/video/$videoId',
          forceWebView: true,
        );
      });
}
