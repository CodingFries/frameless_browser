// Main browser screen that displays web content with enhanced navigation controls.
//
// This file contains the primary screen for the frameless browser application.
// It provides a full-featured web browsing experience within a WebView component
// with comprehensive browser controls and navigation functionality.
//
// Key features:
// - WebView2 integration for optimal web content rendering
// - Enhanced browser top bar with URL entry and navigation controls
// - Homepage loading from user settings
// - Progress indication during page loading
// - URL validation and navigation handling
// - External URL handling for non-web content
//
// The implementation provides a complete browser experience while maintaining
// the frameless window design with hover-activated controls.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import '../../model/constants.dart';
import '../../model/settings_storage.dart';
import '../widgets/browser_top_bar.dart';

/// Main screen widget that displays web content in a WebView with browser controls.
///
/// This widget creates a full-screen WebView that loads and displays web content
/// with comprehensive browser functionality. It includes:
///
/// - Enhanced browser top bar with URL entry and navigation controls
/// - Homepage loading from user-configured settings
/// - Progress indication during page loading
/// - Automatic URL loading from saved homepage settings
/// - Permission handling for media playback and other web features
/// - External URL handling for non-web content
///
/// The widget integrates seamlessly with the browser top bar to provide
/// a complete browsing experience.
class BrowserPage extends StatefulWidget {
  /// Creates a new browser page instance.
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

/// State class for BrowserPage managing WebView lifecycle and browser interactions.
///
/// This state class handles all aspects of the browser functionality including:
/// - WebView controller management and initialization
/// - URL loading and navigation
/// - Progress tracking and display
/// - Settings change handling and homepage updates
/// - Integration with the browser top bar for navigation controls
///
/// The class maintains the WebView state and coordinates with the browser
/// top bar to provide comprehensive browsing functionality.
class _BrowserPageState extends State<BrowserPage> {
  /// Controller for the WebView instance, providing access to WebView operations.
  InAppWebViewController? webViewController;

  /// Reference to the browser top bar for URL updates and navigation control.
  final GlobalKey _browserTopBarKey = GlobalKey();

  /// WebView configuration settings optimized for general web browsing.
  ///
  /// These settings enable:
  /// - Inspector access in debug mode for development
  /// - Automatic media playback without user gesture requirement
  /// - Inline media playback support
  /// - Fullscreen iframe support for video content
  /// - JavaScript execution for modern web applications
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
    javaScriptEnabled: true,
    domStorageEnabled: true,
    databaseEnabled: true,
    clearCache: false,
    cacheEnabled: true,
    supportZoom: true,
    builtInZoomControls: false,
    displayZoomControls: false,
  );

  /// Current page loading progress (0.0 to 1.0).
  ///
  /// Used to display a progress indicator while pages are loading.
  /// Updated through the onProgressChanged callback.
  double progress = 0;

  /// The currently configured homepage URL.
  ///
  /// Loaded from settings storage and used to navigate the WebView
  /// to the user's preferred homepage.
  String? homepageUrl;

  /// Reference to the browser top bar widget for URL updates.
  BrowserTopBar? browserTopBar;

  /// Initializes the widget state and loads the saved homepage URL.
  @override
  void initState() {
    super.initState();
    _loadHomepageUrl();
  }

  /// Loads the saved homepage URL from settings storage.
  ///
  /// This method retrieves the user-configured homepage URL from
  /// persistent storage and updates the widget state.
  void _loadHomepageUrl() {
    final savedUrl = SettingsStorage.getHomepageUrl();
    setState(() {
      homepageUrl = savedUrl;
    });
  }

  /// Loads the configured homepage URL in the WebView.
  ///
  /// This method navigates the WebView to the saved homepage URL, but only
  /// if both the WebView controller is initialized and a valid homepage URL
  /// is available. This is typically called after the WebView is created.
  void _loadUrlInWebView() {
    if (webViewController != null &&
        homepageUrl != null &&
        homepageUrl!.isNotEmpty) {
      webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(homepageUrl!)),
      );
    }
  }

  /// Handles settings changes by reloading the WebView with the new homepage URL.
  ///
  /// This callback is triggered when the user returns from the settings page.
  /// It checks if the homepage URL has changed and, if so, updates the local
  /// state and navigates the WebView to the new homepage URL.
  ///
  /// This ensures the WebView immediately reflects any homepage URL changes
  /// without requiring an application restart.
  void _onSettingsChanged() {
    final newUrl = SettingsStorage.getHomepageUrl();
    if (newUrl != homepageUrl) {
      setState(() {
        homepageUrl = newUrl;
      });
      // Navigate to the new homepage URL immediately
      if (webViewController != null) {
        webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(newUrl)));
      }
    }
  }

  /// Updates the browser top bar with the current URL.
  ///
  /// This method is called when the WebView navigates to a new URL to keep
  /// the browser top bar's URL field synchronized with the current page.
  void _updateTopBarUrl(String url) {
    // The browser top bar will handle URL updates through its own mechanisms
    // This is a placeholder for future URL synchronization if needed
  }

  @override
  Widget build(BuildContext context) {
    return DragToResizeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Main WebView
            InAppWebView(
              webViewEnvironment: K.webViewEnvironment,
              initialUrlRequest: URLRequest(
                url: WebUri(homepageUrl ?? SettingsStorage.defaultHomepageUrl),
              ),
              initialSettings: settings,
              onWebViewCreated: (controller) {
                webViewController = controller;
                // Load homepage URL if available
                _loadUrlInWebView();
              },
              onLoadStart: (controller, url) {
                // Update the top bar URL when navigation starts
                if (url != null) {
                  _updateTopBarUrl(url.toString());
                }
              },
              onLoadStop: (controller, url) async {
                // Update the top bar URL when navigation completes
                if (url != null) {
                  _updateTopBarUrl(url.toString());
                }
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                // Handle external URLs that should be opened in system browser
                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about",
                ].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    // Launch the external app
                    await launchUrl(uri);
                    // Cancel the request in our WebView
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                // Update the top bar URL when history changes
                if (url != null) {
                  _updateTopBarUrl(url.toString());
                }
              },
            ),

            // Progress indicator
            progress < 1.0
                ? Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.withAlpha(128),
                      ),
                    ),
                  )
                : Container(),

            // Browser top bar with controls
            BrowserTopBar(
              key: _browserTopBarKey,
              webViewController: webViewController,
              onSettingsChanged: _onSettingsChanged,
            ),
          ],
        ),
      ),
    );
  }
}
