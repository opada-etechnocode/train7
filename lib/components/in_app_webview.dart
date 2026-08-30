import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../extensions/constants.dart';
import '../extensions/loader_widget.dart';
import '../extensions/shared_pref.dart';
import '../main.dart';
import '../utils/app_colors.dart';

class InAppWebPage extends StatefulWidget {
  final String url;
  final String title;

  const InAppWebPage({super.key, required this.url, required this.title});

  @override
  _InAppWebPageState createState() => _InAppWebPageState();
}

class _InAppWebPageState extends State<InAppWebPage> {
  InAppWebViewController? webController;
  bool isPageReady = false;
  bool isInitialLoad = true; // Track if this is the first load
  late final PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        // Reload the page without showing loader
        await webController?.reload();
      },
    );
  }

  Future<void> applyWebsiteTheme(InAppWebViewController controller) async {
    final theme = appStore.isDarkMode ? "dark" : "light";

    await controller.evaluateJavascript(
      source:
          """
    try {
      // Save theme so website behaves same as browser version
      localStorage.setItem('theme', '$theme');

      // If the website theme function exists, use it
      if (typeof setTheme === 'function') {
        setTheme('$theme');
      } else {
        // Fallback: apply real website classes
        document.body.classList.remove('light-mode', 'dark-mode');
        document.documentElement.classList.remove('light-mode', 'dark-mode');
        document.body.classList.add('$theme-mode');
        document.documentElement.classList.add('$theme-mode');
      }
    } catch (e) { 
      console.log('Theme sync failed:', e); 
    }
  """,
    );
  }

  final String cleanupScript = """
(function() {
  function removeElements() {
    const selectors = [
      "header","header *","nav",".navbar",".navbar *","#navbar",".header",".header *",
      ".top-bar",".top-bar *",".menu",".menu *",".site-header",".sticky",".sticky-top",
      ".fixed-top","footer","footer *",".site-footer",".footer",".footer *","#footer",
      ".bottom-bar",".wp-block-footer"
    ];
    
    selectors.forEach(selector => {
      document.querySelectorAll(selector).forEach(el => {
        el.style.setProperty('display', 'none', 'important');
        el.remove();
      });
    });

    // Remove horizontal scroll and hide scrollbars completely
    document.body.style.margin = "0";
    document.body.style.padding = "0";
    document.body.style.overflowX = "hidden";
    document.documentElement.style.overflowX = "hidden";
    
    // Hide scrollbars with CSS and force dark mode
    const style = document.createElement('style');
    style.textContent = `
      * {
        -webkit-overflow-scrolling: touch;
      }
      ::-webkit-scrollbar {
        display: none !important;
        width: 0 !important;
        height: 0 !important;
      }
      * {
        scrollbar-width: none !important;
        -ms-overflow-style: none !important;
      }
      body, html {
        overflow-x: hidden !important;
        background-color: transparent !important;
      }
      /* Force dark mode styles */
      body {
        color-scheme: dark;
      }
    `;
    document.head.appendChild(style);
  }

  removeElements();
  new MutationObserver(removeElements).observe(document.body, { childList: true, subtree: true });
})();
""";

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: appStore.isDarkMode ? Colors.black : primaryColor,
        statusBarBrightness: Brightness.light,
      ),
      title: Text(widget.title),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
    ),
    body: Stack(
      children: [
        Opacity(
          opacity: isPageReady ? 1 : 0,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: InAppWebView(
              pullToRefreshController: pullToRefreshController,

              initialUrlRequest: URLRequest(
                url: WebUri(widget.url),
                headers: {
                  "data-value": "",
                  "Accept-Language": getStringAsync(SELECTED_LANGUAGE_CODE),
                },
              ),

              initialSettings: InAppWebViewSettings(
                supportZoom: false,
                disableDefaultErrorPage: true,
                transparentBackground: true,

                // Hide scrollbars
                verticalScrollBarEnabled: false,
                horizontalScrollBarEnabled: false,

                // Remove scroll glow + scroll loading
                disallowOverScroll: true,
                overScrollMode: OverScrollMode.NEVER,

                // Disable horizontal scroll
                disableHorizontalScroll: true,

                // Force dark mode
                forceDark: ForceDark.ON,
              ),

              onWebViewCreated: (controller) => webController = controller,

              onLoadStop: (controller, url) async {
                // End pull-to-refresh animation
                pullToRefreshController.endRefreshing();

                await Future<void>.delayed(const Duration(milliseconds: 500));

                // Remove banners, header/footer, scroll tweaks
                await controller.evaluateJavascript(source: cleanupScript);

                // Add clean, controlled top padding
                controller.evaluateJavascript(
                  source: """
    document.body.style.paddingTop = "0px";
    document.documentElement.style.paddingTop = "0px";
    document.body.style.marginTop = "16px";
    document.documentElement.style.marginTop = "16px";
  """,
                );

                // Apply identical website theme
                applyWebsiteTheme(controller);

                if (!mounted) {
                  return;
                }

                // Only set isPageReady on initial load
                if (isInitialLoad) {
                  setState(() {
                    isPageReady = true;
                    isInitialLoad = false;
                  });
                }
              },
            ),
          ),
        ),

        // Only show loader on initial load
        if (!isPageReady && isInitialLoad) const Center(child: Loader()),
      ],
    ),
  );
}
