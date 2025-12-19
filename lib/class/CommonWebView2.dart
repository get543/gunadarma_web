
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
//
//
//
// class CommonWebView2 extends StatefulWidget {
//   final String url;
//   final String title;
//
//   // Use modern constructor syntax with 'const' for better performance.
//   const CommonWebView2({
//     super.key,
//     required this.url,
//     required this.title,
//   });
//
//   @override
//   State<CommonWebView2> createState() => _CommonWebViewState();
// }
//
// class _CommonWebViewState extends State<CommonWebView2> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 1. Create the platform-specific params
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is AndroidWebViewPlatform) {
//       params = AndroidWebViewControllerCreationParams();
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     // 2. Initialize the controller
//     _controller = WebViewController.fromPlatformCreationParams(params);
//
//     // 3. Handle Native Android Dark Mode (For Android 10-12)
//     // Note: This often does nothing on Android 13+ due to the missing API.
//     if (_controller.platform is AndroidWebViewController) {
//       final androidController = _controller.platform as AndroidWebViewController;
//       final isDarkMode = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
//       // 2 = FORCE_DARK_ON, 0 = FORCE_DARK_OFF
//       androidController.setForceDark(isDarkMode ? 2 : 0);
//     }
//
//     _controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // You can use this to show a loading indicator.
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//
//             // 4. MANUAL DARK MODE INJECTION (For Android 13+)
//             // Since we can't call setAlgorithmicDarkeningAllowed, we use JS
//             // to simulate it if the device is in dark mode.
//             _injectDarkMode();
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
//               Page resource error:
//               code: ${error.errorCode}
//               description: ${error.description}
//               errorType: ${error.errorType}
//               isForMainFrame: ${error.isForMainFrame}
//             ''');
//           },
//         ),
//       )
//       // The 'initialUrl' parameter is replaced by this method call.
//       ..loadRequest(Uri.parse(widget.url));
//   }
//
//   // This function checks if the WebView can go back. If so, it navigates back.
//   // If not, it navigates back to the previous screen in your Flutter app.
//   void backNavigationHandler() async {
//     if (await _controller.canGoBack()) {
//       await _controller.goBack();
//     } else {
//       // If the WebView can't go back, pop the current screen (CommonWebView)
//       // to return to the previous page (MyHomePage).
//       if (mounted) {
//         Navigator.of(context).pop();
//       }
//     }
//   }
//
//   // Helper function to inject CSS that inverts colors
//   void _injectDarkMode() {
//     final isDarkMode = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
//
//     if (isDarkMode) {
//       // This CSS inverts the whole page (white becomes black),
//       // but re-inverts images/videos so they look normal.
//       const String darkCss = '''
//         if (!document.getElementById('flutter_dark_mode')) {
//           var style = document.createElement('style');
//           style.id = 'flutter_dark_mode';
//           style.innerHTML = `
//             html {
//               filter: invert(100%) hue-rotate(180deg) !important;
//               background-color: #121212 !important;
//             }
//             /* Re-invert media so they look normal */
//             img, video, iframe, canvas, svg {
//               filter: invert(100%) hue-rotate(180deg) !important;
//             }
//           `;
//           document.head.appendChild(style);
//         }
//       ''';
//
//       // Inject immediately in case page is already loaded
//       _controller.runJavaScript(darkCss);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // Use WillPopScope to intercept the physical back button on Android
//         leading: BackButton(
//           onPressed: backNavigationHandler,
//         ),
//         title: Text(widget.title),
//         actions: [
//           Row(
//             children: <Widget>[
//               IconButton(
//                 icon: const Icon(Icons.arrow_back_ios),
//                 onPressed: () async {
//                   final messenger = ScaffoldMessenger.of(context);
//                   if (await _controller.canGoBack()) {
//                     await _controller.goBack();
//                   } else {
//                     messenger.showSnackBar(
//                       const SnackBar(
//                           duration: Duration(milliseconds: 200),
//                           content: Text(
//                             'Can\'t go back',
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           )),
//                     );
//                     return;
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.arrow_forward_ios),
//                 onPressed: () async {
//                   final messenger = ScaffoldMessenger.of(context);
//                   if (await _controller.canGoForward()) {
//                     await _controller.goForward();
//                   } else {
//                     messenger.showSnackBar(
//                       const SnackBar(
//                           duration: Duration(milliseconds: 200),
//                           content: Text(
//                             'No forward history item',
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           )),
//                     );
//                     return;
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.replay),
//                 onPressed: () {
//                   _controller.reload();
//                 },
//               ),
//             ],
//           )
//         ]
//       ),
//       body: WebViewWidget(
//         controller: _controller,
//       ),
//     );
//   }
// }
//
// extension on AndroidWebViewController {
//   void setForceDark(param0) {}
// }
