// Enhanced browser top bar with URL entry and navigation controls.
//
// This widget provides a comprehensive browser control bar that appears as an 
// overlay at the top of the window. It includes:
// - Browser navigation controls (back, forward, refresh, home)
// - URL entry field for direct navigation
// - Settings navigation button
// - Window management controls (minimize, maximize/restore, close)
// - Drag-to-move functionality for window positioning
// - Smooth animations for show/hide behavior
//
// The bar is designed to be unobtrusive, appearing only when the user hovers
// over the top area of the window, maintaining a clean interface while
// providing comprehensive browser functionality for the frameless window design.

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import '../../model/settings_storage.dart';
import '../routing/app_routes.dart';

/// A stateful widget that provides browser controls and navigation in an overlay bar.
///
/// This widget creates a top overlay bar that becomes visible when the user hovers
/// over the top area of the window. It provides comprehensive browser functionality
/// for the frameless window design, including:
///
/// - Browser navigation controls (back, forward, refresh, home)
/// - URL entry field for direct navigation
/// - Settings button for configuration access
/// - Window minimize, maximize/restore, and close controls
/// - Drag-to-move areas for repositioning the window
/// - Smooth fade-in/out animations based on hover state
///
/// The bar is positioned absolutely at the top of the window and uses mouse
/// regions to detect hover events for showing/hiding the controls.
class BrowserTopBar extends StatefulWidget {
  /// WebView controller for browser navigation operations.
  final InAppWebViewController? webViewController;
  
  /// Optional callback function triggered when returning from settings.
  final VoidCallback? onSettingsChanged;

  /// Creates a browser top bar with WebView controller and optional settings callback.
  ///
  /// Parameters:
  ///   [webViewController] - Controller for WebView navigation operations
  ///   [onSettingsChanged] - Callback triggered when returning from settings
  const BrowserTopBar({
    super.key, 
    this.webViewController,
    this.onSettingsChanged,
  });

  @override
  State<BrowserTopBar> createState() => _BrowserTopBarState();
}

/// State class for the BrowserTopBar widget managing hover animations and browser interactions.
class _BrowserTopBarState extends State<BrowserTopBar> {
  /// Tracks whether the user is currently hovering over the top area.
  bool isHoveringTop = false;
  
  /// Controller for the URL input field.
  final TextEditingController _urlController = TextEditingController();
  
  /// Focus node for the URL input field.
  final FocusNode _urlFocusNode = FocusNode();
  
  /// Current page URL for display in the URL bar.
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();
    _loadHomepageUrl();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  /// Loads the homepage URL into the URL controller.
  void _loadHomepageUrl() {
    final homepageUrl = SettingsStorage.getHomepageUrl();
    setState(() {
      _currentUrl = homepageUrl;
      _urlController.text = homepageUrl;
    });
  }

  /// Updates the current URL display.
  void updateCurrentUrl(String url) {
    setState(() {
      _currentUrl = url;
      if (!_urlFocusNode.hasFocus) {
        _urlController.text = url;
      }
    });
  }

  /// Navigates to the URL entered in the URL field.
  void _navigateToUrl() {
    String url = _urlController.text.trim();
    if (url.isEmpty) return;

    // Add protocol if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      // Check if it looks like a domain or search query
      if (url.contains('.') && !url.contains(' ')) {
        url = 'https://$url';
      } else {
        // Treat as search query
        url = 'https://www.google.com/search?q=${Uri.encodeComponent(url)}';
      }
    }

    widget.webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(url)),
    );
    _urlFocusNode.unfocus();
  }

  /// Navigates back in browser history.
  void _goBack() {
    widget.webViewController?.goBack();
  }

  /// Navigates forward in browser history.
  void _goForward() {
    widget.webViewController?.goForward();
  }

  /// Refreshes the current page.
  void _refresh() {
    widget.webViewController?.reload();
  }

  /// Navigates to the homepage.
  void _goHome() {
    final homepageUrl = SettingsStorage.getHomepageUrl();
    widget.webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(homepageUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left drag area (reduced to make room for browser controls)
          Expanded(
            flex: 2,
            child: MouseRegion(
              onEnter: (_) => setState(() => isHoveringTop = true),
              onExit: (_) => setState(() => isHoveringTop = false),
              child: DragToMoveArea(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    height: 40,
                    duration: const Duration(milliseconds: 200),
                    color: isHoveringTop ? Colors.black26 : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          
          // Main browser controls area
          MouseRegion(
            onEnter: (_) => setState(() => isHoveringTop = true),
            onExit: (_) => setState(() => isHoveringTop = false),
            child: AnimatedOpacity(
              opacity: isHoveringTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                  color: Colors.black26,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Browser navigation controls
                    IconButton(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Back',
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: _goForward,
                      icon: const Icon(Icons.arrow_forward),
                      tooltip: 'Forward',
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: _goHome,
                      icon: const Icon(Icons.home),
                      tooltip: 'Home',
                      iconSize: 20,
                    ),
                    
                    // Separator
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.white.withAlpha(77),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    
                    // URL input field
                    Container(
                      width: 400,
                      height: 32,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withAlpha(51),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _urlController,
                        focusNode: _urlFocusNode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter URL or search...',
                          hintStyle: TextStyle(
                            color: Colors.white.withAlpha(128),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          suffixIcon: IconButton(
                            onPressed: _navigateToUrl,
                            icon: const Icon(
                              Icons.search,
                              size: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _navigateToUrl(),
                        onTap: () {
                          // Select all text when tapping the URL field
                          _urlController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _urlController.text.length,
                          );
                        },
                      ),
                    ),
                    
                    // Separator
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.white.withAlpha(77),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    
                    // Settings button
                    IconButton(
                      onPressed: () async {
                        await context.push(AppRoutes.settings);
                        if (widget.onSettingsChanged != null) {
                          widget.onSettingsChanged!();
                        }
                      },
                      icon: const Icon(Icons.settings),
                      tooltip: 'Settings',
                      iconSize: 20,
                    ),
                    
                    // Separator
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.white.withAlpha(77),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    
                    // Window controls
                    IconButton(
                      onPressed: () {
                        windowManager.minimize();
                      },
                      icon: const Icon(Icons.minimize),
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: () async {
                        if (await windowManager.isMaximized()) {
                          windowManager.unmaximize();
                        } else {
                          windowManager.maximize();
                        }
                      },
                      icon: const Icon(Icons.crop_square),
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        windowManager.close();
                      },
                      icon: const Icon(Icons.close),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Right drag area (reduced)
          Expanded(
            flex: 1,
            child: MouseRegion(
              onEnter: (_) => setState(() => isHoveringTop = true),
              onExit: (_) => setState(() => isHoveringTop = false),
              child: DragToMoveArea(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    height: 40,
                    duration: const Duration(milliseconds: 200),
                    color: isHoveringTop ? Colors.black26 : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}