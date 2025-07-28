// Application constants and global configuration values.
//
// This file contains constant values and global configuration used
// throughout the frameless browser application. It provides centralized
// access to important configuration values and prevents magic numbers
// or strings scattered throughout the codebase.
//
// The constants include:
// - WebView environment configuration
// - Application metadata
// - Default configuration values
//
// This approach ensures consistency and makes it easy to modify
// configuration values from a single location.

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Application constants and global configuration.
///
/// This class provides static access to important configuration values
/// used throughout the frameless browser application. It includes WebView
/// environment settings, application metadata, and other global constants.
///
/// All constants are defined as static members to provide easy access
/// without requiring class instantiation.
class K {
  /// WebView environment instance for the application.
  ///
  /// This environment is initialized during application startup and provides
  /// the WebView2 runtime configuration for all WebView instances in the app.
  /// It's set up with a custom user data folder to ensure proper isolation
  /// and persistence of web data.
  static late WebViewEnvironment webViewEnvironment;

  /// Application name for display purposes.
  ///
  /// This constant defines the human-readable name of the application
  /// used in window titles, about dialogs, and other user-facing text.
  static const String appName = 'Frameless Browser';

  /// Application version string.
  ///
  /// This version string should be kept in sync with the version
  /// defined in pubspec.yaml for consistency across the application.
  static const String appVersion = '1.0.0';

  /// Default window width in pixels.
  ///
  /// This defines the initial width of the application window when
  /// first launched, providing a reasonable default size for most users.
  static const double defaultWindowWidth = 1920.0;

  /// Default window height in pixels.
  ///
  /// This defines the initial height of the application window when
  /// first launched, providing a reasonable default size for most users.
  static const double defaultWindowHeight = 1080.0;
}