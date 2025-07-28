// Application routing configuration using GoRouter for navigation.
//
// This file defines the navigation structure for the frameless browser
// application, providing declarative routing between the main browser
// screen and settings page.
//
// The routing system supports:
// - Declarative route definitions with type-safe navigation
// - Smooth transitions between screens
// - Proper back navigation handling
// - Route-based state management
//
// Routes are defined as static constants for easy reference throughout
// the application, ensuring consistency and preventing typos.

import 'package:go_router/go_router.dart';

import '../screens/browser_page.dart';
import '../screens/settings_page.dart';

/// Application routes configuration and navigation management.
///
/// This class provides centralized route definitions and GoRouter configuration
/// for the frameless browser application. It defines the navigation structure
/// and handles transitions between different screens.
///
/// The routing system includes:
/// - Main browser page as the home route
/// - Settings page for configuration
/// - Proper navigation transitions and back button handling
/// - Type-safe route references through static constants
class AppRoutes {
  /// Route path for the main browser page.
  ///
  /// This is the default route that users see when the application starts.
  /// It displays the main browser interface with WebView and navigation controls.
  static const String browser = '/';

  /// Route path for the settings page.
  ///
  /// This route provides access to the application settings, primarily
  /// for configuring the homepage URL and other browser preferences.
  static const String settings = '/settings';

  /// GoRouter configuration for the application.
  ///
  /// This router defines the navigation structure and handles route transitions.
  /// It includes all application routes with their corresponding widgets and
  /// provides smooth navigation between screens.
  ///
  /// The router configuration includes:
  /// - Initial route set to the browser page
  /// - Route definitions with path and widget mappings
  /// - Proper error handling for unknown routes
  /// - Transition animations for smooth user experience
  static final GoRouter router = GoRouter(
    initialLocation: browser,
    routes: [
      /// Main browser route - displays the primary browser interface.
      ///
      /// This route serves as the application's home screen, providing
      /// the main browser functionality with WebView, navigation controls,
      /// and the hover-activated top bar.
      GoRoute(
        path: browser,
        builder: (context, state) => const BrowserPage(),
      ),

      /// Settings route - provides access to application configuration.
      ///
      /// This route displays the settings page where users can configure
      /// their homepage URL and other browser preferences. Navigation to
      /// this route is typically triggered from the settings button in
      /// the browser top bar.
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],

    /// Error handling for unknown routes.
    ///
    /// If a user navigates to an undefined route, they will be redirected
    /// to the main browser page to ensure a consistent user experience.
    errorBuilder: (context, state) => const BrowserPage(),
  );
}