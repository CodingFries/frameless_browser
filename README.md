# Frameless Browser

A modern, minimalist desktop web browser built with Flutter that features a frameless window design with customizable homepage and enhanced navigation controls.

## Overview

Frameless Browser is a lightweight desktop web browser application that provides a clean, distraction-free browsing experience. Built using Flutter and WebView2 technology, it offers a frameless window interface with hover-activated controls and customizable settings.

## Features

### Core Browser Functionality
- **WebView2 Integration**: Optimal web content rendering using Microsoft's WebView2 engine
- **Frameless Window Design**: Clean, minimal interface without traditional window borders
- **Enhanced Navigation Controls**: Intuitive browser controls with URL entry and navigation buttons
- **Progress Indication**: Visual feedback during page loading
- **URL Validation**: Smart URL handling with automatic protocol detection

### Customization & Settings
- **Customizable Homepage**: Set and save your preferred homepage URL
- **Real-time URL Validation**: Instant feedback on URL format and validity
- **Persistent Settings**: Your preferences are saved using local storage
- **Reset to Defaults**: Easy option to restore default settings

### Media & Web Standards Support
- **Automatic Media Playback**: No user gesture required for media content
- **Inline Media Support**: Seamless video and audio playback
- **Fullscreen Support**: Full iframe and video fullscreen capabilities
- **JavaScript Enabled**: Full support for modern web applications
- **DOM Storage & Database**: Complete web storage API support
- **Zoom Controls**: Built-in zoom functionality for better accessibility

### Technical Features
- **Dark Theme**: Modern Material 3 dark theme design
- **External URL Handling**: Smart handling of non-web content
- **Cache Management**: Intelligent caching for improved performance
- **Debug Inspector**: Development tools available in debug mode

## System Requirements

### Prerequisites
- **Windows 10/11**: Required for WebView2 support
- **WebView2 Runtime**: Must be installed (usually included with modern Windows)
- **Flutter SDK**: Version 3.8.1 or higher
- **Dart SDK**: Compatible version with Flutter

### Hardware Requirements
- **RAM**: Minimum 4GB recommended
- **Storage**: At least 100MB free space
- **Display**: 1920x1080 recommended (default window size)

## Installation

### Option 1: Download Pre-built Release
1. Download the latest release from the releases page
2. Run the installer (if available) or extract the executable
3. Ensure WebView2 Runtime is installed on your system
4. Launch the application

### Option 2: Build from Source

#### Prerequisites
```bash
# Install Flutter SDK (if not already installed)
# Download from: https://flutter.dev/docs/get-started/install

# Verify Flutter installation
flutter doctor
```

#### Clone and Build
```bash
# Clone the repository
git clone <repository-url>
cd frameless_browser

# Get dependencies
flutter pub get

# Build for Windows
flutter build windows --release
```

#### Create Installer (Optional)
If you have Inno Setup installed:
```bash
# After building, use the Inno Setup script
# Open inno/script.iss in Inno Setup Compiler
# Compile to create an installer
```

## Usage

### First Launch
1. Launch the Frameless Browser application
2. The browser will open with the default homepage
3. Use the top navigation bar to enter URLs or navigate

### Navigation
- **URL Bar**: Click the address bar to enter a new URL
- **Back/Forward**: Use navigation buttons to move through history
- **Refresh**: Reload the current page
- **Settings**: Access settings to customize your homepage

### Customizing Homepage
1. Click the settings button (gear icon) in the top bar
2. Enter your preferred homepage URL
3. Ensure the URL includes `http://` or `https://`
4. Click "Save" to apply changes
5. Use "Reset to Default" to restore the original homepage

### Keyboard Shortcuts
- **Ctrl+R**: Refresh current page
- **Alt+Left**: Go back
- **Alt+Right**: Go forward
- **Ctrl+L**: Focus URL bar

## Configuration

### Settings Storage
Settings are automatically saved to:
```
%USERPROFILE%\Documents\FramelessBrowser\
```

### Default Configuration
- **Default Homepage**: Can be customized in settings
- **Window Size**: 1920x1080 pixels
- **Theme**: Dark mode with Material 3 design
- **Cache**: Enabled for better performance

## Development

### Project Structure
```
lib/
├── main.dart                 # Application entry point
├── model/
│   ├── constants.dart        # App constants and configuration
│   └── settings_storage.dart # Settings persistence
└── view/
    ├── routing/
    │   └── app_routes.dart   # Navigation routing
    ├── screens/
    │   ├── browser_page.dart # Main browser interface
    │   └── settings_page.dart# Settings configuration
    └── widgets/
        └── browser_top_bar.dart # Navigation controls
```

### Key Dependencies
- **flutter_inappwebview**: WebView functionality
- **window_manager**: Frameless window management
- **go_router**: Navigation and routing
- **hive_ce**: Local storage for settings
- **path_provider**: File system access
- **url_launcher**: External URL handling

### Building for Development
```bash
# Run in debug mode
flutter run -d windows

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Troubleshooting

### Common Issues

**WebView2 Runtime Not Found**
- Download and install WebView2 Runtime from Microsoft
- Restart the application after installation

**Application Won't Start**
- Ensure Flutter is properly installed
- Check that all dependencies are available
- Verify Windows version compatibility

**Settings Not Saving**
- Check write permissions to Documents folder
- Ensure the application has proper file system access

**Performance Issues**
- Clear browser cache through settings
- Restart the application
- Check available system memory

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Uses [WebView2](https://developer.microsoft.com/en-us/microsoft-edge/webview2/) for web rendering
- Material Design 3 theming
- Thanks to the Flutter community for excellent packages and support

## Version History

- **v1.0.0**: Initial release with core browser functionality
  - Frameless window design
  - WebView2 integration
  - Customizable homepage
  - Settings persistence
  - Enhanced navigation controls
