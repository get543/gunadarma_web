// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:gunadarma_web/constants/text_constants.dart';
//
// void main() => runApp(MaterialApp(
//   home: WebViewScreen(),
// ));
//
// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen({super.key});
//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }
// class _WebViewScreenState extends State<WebViewScreen> {
//   late WebViewController controller;
//   var loadingPercentage = 0;
//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageStarted: (url) {
//           setState(() {
//             loadingPercentage = 0;
//           });
//         },
//         onProgress: (progress) {
//           setState(() {
//             loadingPercentage = progress;
//           });
//         },
//         onPageFinished: (url) {
//           setState(() {
//             loadingPercentage = 100;
//           });
//         },
//       ))
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(
//         Uri.parse('https://studentsite.gunadarma.ac.id'),
//       );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           centerTitle: true,
//           title: const Text(TextConstants.appBarTitle),
//           actions: [
//             Row(
//               children: <Widget>[
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios),
//                   onPressed: () async {
//                     final messenger = ScaffoldMessenger.of(context);
//                     if (await controller.canGoBack()) {
//                       await controller.goBack();
//                     } else {
//                       messenger.showSnackBar(
//                         const SnackBar(
//                           duration: Duration(milliseconds: 200),
//                           content: Text(
//                             'Can\'t go back',
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           )),
//                       );
//                       return;
//                     }
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.arrow_forward_ios),
//                   onPressed: () async {
//                     final messenger = ScaffoldMessenger.of(context);
//                     if (await controller.canGoForward()) {
//                       await controller.goForward();
//                     } else {
//                       messenger.showSnackBar(
//                         const SnackBar(
//                           duration: Duration(milliseconds: 200),
//                           content: Text(
//                             'No forward history item',
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           )),
//                       );
//                       return;
//                     }
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.replay),
//                   onPressed: () {
//                     controller.reload();
//                   },
//                 ),
//               ],
//             )
//           ]),
//
//       body: Stack(
//         children: [
//           WebViewWidget(
//             controller: controller,
//           ),
//           loadingPercentage < 100
//               ? LinearProgressIndicator(
//             color: Colors.red,
//             value: loadingPercentage / 100.0,
//           )
//               : Container()
//         ],
//       ),
//     );
//   }
// }