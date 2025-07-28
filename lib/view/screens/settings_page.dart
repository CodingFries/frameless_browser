// Settings page for configuring browser homepage and other preferences.
//
// This page provides a user interface for configuring the frameless browser
// settings, primarily focused on homepage URL configuration. The page features
// a clean, modern design with input validation and real-time feedback.
//
// Key features:
// - Homepage URL configuration with validation
// - Real-time URL format checking
// - Save/cancel functionality with loading states
// - Reset to default homepage option
// - Responsive design with proper error handling
//
// The settings are persisted using the SettingsStorage class and take effect
// immediately when saved.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/settings_storage.dart';

/// Settings page widget for configuring browser preferences.
///
/// This page allows users to configure their browser settings, primarily
/// the homepage URL. It provides a clean interface with input validation,
/// loading states, and proper error handling.
///
/// The page includes:
/// - Homepage URL input field with validation
/// - Save and cancel buttons with loading states
/// - Reset to default functionality
/// - Helpful tips and guidance for users
/// - Responsive design that works across different screen sizes
class SettingsPage extends StatefulWidget {
  /// Creates a new settings page instance.
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// State class for the SettingsPage managing form input and validation.
///
/// This state class handles:
/// - Form input management and validation
/// - Loading states during save operations
/// - URL format validation and user feedback
/// - Integration with settings storage for persistence
/// - Navigation and user interaction handling
class _SettingsPageState extends State<SettingsPage> {
  /// Controller for the homepage URL input field.
  final TextEditingController _urlController = TextEditingController();

  /// Form key for validation and form management.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Loading state indicator for save operations.
  bool _isLoading = false;

  /// Error message for display when validation fails.
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  /// Loads the current homepage URL from settings storage.
  ///
  /// This method retrieves the saved homepage URL and populates the
  /// input field with the current value, allowing users to see and
  /// modify their existing settings.
  void _loadCurrentSettings() {
    final currentUrl = SettingsStorage.getHomepageUrl();
    _urlController.text = currentUrl;
  }

  /// Validates the entered URL format.
  ///
  /// This method checks if the entered URL is in a valid format,
  /// supporting both HTTP and HTTPS protocols. It provides user-friendly
  /// error messages for common formatting issues.
  ///
  /// Parameters:
  ///   [value] - The URL string to validate
  ///
  /// Returns:
  ///   Error message string if validation fails, null if valid
  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a homepage URL';
    }

    final trimmedValue = value.trim();
    
    // Check if it's a valid URL format
    try {
      final uri = Uri.parse(trimmedValue);
      
      // Must have a scheme (http or https)
      if (!uri.hasScheme) {
        return 'URL must include http:// or https://';
      }
      
      // Must be http or https
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return 'URL must use http:// or https://';
      }
      
      // Must have a host
      if (uri.host.isEmpty) {
        return 'Please enter a valid website address';
      }
      
      return null; // Valid URL
    } catch (e) {
      return 'Please enter a valid URL format';
    }
  }

  /// Saves the homepage URL to persistent storage.
  ///
  /// This method validates the form input and, if valid, saves the
  /// homepage URL to persistent storage. It provides loading feedback
  /// and error handling for a smooth user experience.
  Future<void> _saveHomepageUrl() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = _urlController.text.trim();
      await SettingsStorage.setHomepageUrl(url);
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Homepage URL saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Navigate back to browser
        context.pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save settings. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Resets the homepage URL to the default value.
  ///
  /// This method resets the homepage URL to the default Google homepage
  /// and updates the input field to reflect the change.
  void _resetToDefault() {
    setState(() {
      _urlController.text = SettingsStorage.defaultHomepageUrl;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Browser Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Settings form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Homepage URL section
                      const Text(
                        'Homepage URL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      const Text(
                        'Set the default page that opens when you start the browser or click the home button.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // URL input field
                      TextFormField(
                        controller: _urlController,
                        validator: _validateUrl,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'https://www.example.com',
                          hintStyle: TextStyle(
                            color: Colors.white.withAlpha(128),
                          ),
                          filled: true,
                          fillColor: Colors.white.withAlpha(13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.white.withAlpha(51),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.white.withAlpha(51),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            onPressed: _resetToDefault,
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white70,
                            ),
                            tooltip: 'Reset to default',
                          ),
                        ),
                      ),
                      
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : () => context.pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withAlpha(128),
                                  width: 1,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveHomepageUrl,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withAlpha(204),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Save Settings',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Help section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withAlpha(26),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tips_and_updates_outlined,
                              color: Colors.white.withAlpha(179),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tip: Use HTTPS URLs for secure connections. Popular choices include Google, Bing, DuckDuckGo, or your favorite news site.',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(179),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}