// Settings storage management using Hive database for persistent data.
// 
// This file provides a simple interface for storing and retrieving application
// settings using the Hive NoSQL database. Currently manages the browser homepage
// URL configuration, with the ability to easily extend for additional settings.
// 
// The storage is initialized during application startup and persists data
// between application sessions.

import 'package:hive_ce/hive.dart';

/// Manages persistent storage of application settings using Hive database.
/// 
/// This class provides static methods for storing and retrieving application
/// configuration data. It uses Hive for lightweight, fast local storage that
/// persists between application sessions.
/// 
/// Currently supports:
/// - Homepage URL storage for browser default page configuration
/// 
/// Usage:
/// ```dart
/// await SettingsStorage.init(); // Initialize during app startup
/// await SettingsStorage.setHomepageUrl('https://www.google.com');
/// String? url = SettingsStorage.getHomepageUrl();
/// ```
class SettingsStorage {
  /// The Hive box instance used for storing settings data.
  /// 
  /// This box is initialized during [init()] and provides access to the
  /// persistent storage. It's marked as late final since it's guaranteed
  /// to be initialized before any other methods are called.
  static late final Box box;

  /// Storage key for the browser homepage URL setting.
  /// 
  /// This constant defines the key used to store and retrieve the homepage URL
  /// in the Hive database. Using a constant ensures consistency and helps
  /// prevent typos in key names.
  static const String keyHomepageUrl = 'homepageUrl';

  /// Default homepage URL used when no custom homepage is set.
  /// 
  /// This provides a sensible default for users who haven't configured
  /// a custom homepage yet.
  static const String defaultHomepageUrl = 'https://www.google.com';

  /// Initializes the settings storage by opening the Hive box.
  /// 
  /// This method must be called during application startup before any other
  /// settings operations. It opens the 'browser_settings' box in the Hive database
  /// and makes it available for read/write operations.
  /// 
  /// Throws [HiveError] if the box cannot be opened.
  static Future<void> init() async {
    box = await Hive.openBox('browser_settings');
  }

  /// Retrieves the stored browser homepage URL.
  /// 
  /// Returns the previously saved homepage URL, or the default URL if no custom
  /// homepage has been configured. The URL should include the protocol 
  /// (http:// or https://) and be a valid web address.
  /// 
  /// Returns:
  ///   The stored homepage URL string, or default URL if not set.
  static String getHomepageUrl() {
    return box.get(keyHomepageUrl, defaultValue: defaultHomepageUrl);
  }

  /// Stores the browser homepage URL for future use.
  /// 
  /// Saves the provided homepage URL to persistent storage. The URL should be
  /// a valid HTTP/HTTPS URL pointing to the desired homepage.
  /// 
  /// Parameters:
  ///   [url] - The homepage URL to store (e.g., 'https://www.example.com')
  /// 
  /// Throws [HiveError] if the data cannot be written to storage.
  static Future<void> setHomepageUrl(String url) async {
    await box.put(keyHomepageUrl, url);
  }

  /// Resets the homepage URL to the default value.
  /// 
  /// This method removes any custom homepage setting and reverts to the
  /// default homepage URL.
  static Future<void> resetHomepageUrl() async {
    await box.delete(keyHomepageUrl);
  }
}