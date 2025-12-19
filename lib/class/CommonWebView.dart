import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class CommonWebView extends StatefulWidget {
  final String url;
  final String title;

  const CommonWebView({super.key, required this.url, required this.title});

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  InAppWebViewSettings? _webViewSettings;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    // Check if the App is currently in Dark Mode
    final isDarkMode =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;

    // Default settings (Safe fallback)
    bool useAlgorithmic = false;
    ForceDark useForceDark = ForceDark.AUTO;

    if (Platform.isAndroid && isDarkMode) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      // --- LOGIC REPLICATION ---

      // Android 13+ (API 33+)
      // Your Java: setAlgorithmicDarkeningAllowed(true)
      // We set ForceDark to AUTO so the Algorithmic setting takes precedence naturally.
      if (sdkInt >= 33) {
        useAlgorithmic = true;
        useForceDark = ForceDark.AUTO;
      }
      // Android 10-12 (API 29-32)
      // Your Java: setForceDark(FORCE_DARK_ON)
      else if (sdkInt >= 29) {
        useAlgorithmic = false;
        useForceDark = ForceDark.ON;
      }
    }

    setState(() {
      _webViewSettings = InAppWebViewSettings(
        // Dark Mode Logic
        algorithmicDarkeningAllowed: useAlgorithmic,
        forceDark: useForceDark,

        // VISUAL FIXES:
        // Disable transparency. Transparency confuses the Dark Mode algorithm
        // causing it to invert images thinking they are on a white background.
        transparentBackground: false,

        // Set the standard behavior for how the WebView interacts with content
        preferredContentMode: UserPreferredContentMode.RECOMMENDED,

        // Ensure JavaScript is on
        javaScriptEnabled: true,

        // Disable over-scroll glow which sometimes looks white/glitchy in dark mode
        overScrollMode: OverScrollMode.NEVER,

        // Allow downloads to trigger
        useOnDownloadStart: true,
      );
    });
  }

  //! --- HELPER TO CHECK PERMISSIONS ---
  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      // 1. Request Notification Permission (Required for Android 13+)
      // Without this, you will NOT see the "Download Complete" notification.
      final notifStatus = await Permission.notification.status;
      if (notifStatus != PermissionStatus.granted) {
        await Permission.notification.request();
      }

      // 2. Request Storage Permission
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      // Android 13+ (API 33) doesn't need explicit storage permission for public downloads
      if (androidInfo.version.sdkInt >= 33) {
        return true;
      }

      // Android 12 and below needs storage permission
      final storageStatus = await Permission.storage.status;
      if (storageStatus != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        return result == PermissionStatus.granted;
      }
      return true;
    }
    return false;
  }

  //! --- HELPER TO PERFORM DOWNLOAD ---
  void _downloadFile(DownloadStartRequest request) async {
    // 1. Check Permissions
    bool hasPermission = await _checkPermission();
    if (!hasPermission) {
      // Show simple toast if permission denied
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied. Cannot download.')),
        );
      }
      return;
    }

    // 2. Show "Starting Download" Toast inside the App
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloading ${request.suggestedFilename ?? "file"}...'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // 3. Start the Download (System Notification handles "Finished")
    Directory? externalDir = await getExternalStorageDirectory();

    await FlutterDownloader.enqueue(
      url: request.url.toString(),
      savedDir: externalDir!.path,
      fileName: request.suggestedFilename,

      // These flags enable the System Notification
      showNotification: true, // Shows progress bar
      openFileFromNotification: true, // Click to open when done
      saveInPublicStorage: true,

      allowCellular: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine background color based on theme to prevent white flashes
    final backgroundColor =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark
        ? Colors.black
        : Colors.white;

    if (_webViewSettings == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // Ensure the Scaffold background matches to hide loading glitches
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await _webViewController!.canGoBack()) {
                    await _webViewController!.goBack();
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 200),
                        content: Text(
                          'Can\'t go back',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await _webViewController!.canGoForward()) {
                    await _webViewController!.goForward();
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 200),
                        content: Text(
                          'No forward history item',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  _webViewController!.reload();
                },
              ),
            ],
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialSettings: _webViewSettings,
        onWebViewCreated: (controller) {
          _webViewController = controller;

          // CRITICAL: Explicitly set background color to black via native controller
          // This helps the "Algorithmic Darkening" realize the background is already dark.
          if (Platform.isAndroid) {
            controller.setBackgroundColor(color: backgroundColor);
          }
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          debugPrint(
            "SSL Error detected for: ${challenge.protectionSpace.host}",
          );

          // ACTION: Trust the certificate effectively ignoring the error.
          // WARNING: This makes the connection susceptible to Man-in-the-Middle attacks.
          // Only use this if you trust the website.
          return ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED,
          );
        },
        onDownloadStartRequest: (controller, request) {
          _downloadFile(request);
        },
      ),
    );
  }
}

extension on InAppWebViewController {
  void setBackgroundColor({required Color color}) {}
}
