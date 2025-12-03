import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // ============================================
  // CONFIGURE YOUR BACKEND URL HERE
  // ============================================
  // If your backend is LIVE/DEPLOYED, set this to your server URL:
  // Example: 'https://api.yourdomain.com/api' or 'https://your-backend.herokuapp.com/api'
  
  // Set to null to use platform-specific localhost URLs
  static const String? liveBackendUrl = null;
  
  // ============================================
  // FOR LOCAL DEVELOPMENT TROUBLESHOOTING:
  // ============================================
  // If 10.0.2.2 doesn't work, try using your computer's IP address instead
  // Find your IP: 
  //   - Windows: Open CMD → type "ipconfig" → look for "IPv4 Address"
  //   - Mac/Linux: Open Terminal → type "ifconfig" → look for "inet"
  // Then set manualLocalIp below (e.g., '192.168.1.100')
  // Leave as null to use default 10.0.2.2 for Android emulator
  // For Docker Compose backends, you may need to use your computer's IP
  static const String? manualLocalIp = '192.168.0.152';  // Your computer's IP address
  
  // For local development (when liveBackendUrl is null):
  // - Android Emulator: http://10.0.2.2:8000/api (or use manualLocalIp if set)
  // - iOS Simulator: https://backend.soaraat.com/api
  // - Physical Device: http://YOUR_COMPUTER_IP:8000/api
  
  static String? _cachedBaseUrl;
  
  static String get baseUrl {
    if (_cachedBaseUrl != null) {
      return _cachedBaseUrl!;
    }
    
    String url;
    
    // If live backend URL is configured, use it for all platforms
    if (liveBackendUrl != null && liveBackendUrl!.isNotEmpty) {
      url = liveBackendUrl!;
      print('🌐 Using LIVE backend URL: $url');
    } else {
      // Otherwise, use platform-specific localhost URLs
      if (kIsWeb) {
        url = 'https://backend.soaraat.com/api';
      } else if (Platform.isAndroid) {
        // For Android emulator
        // Use localhost with ADB port forwarding (adb reverse tcp:8000 tcp:8000)
        // This is the most reliable method for Docker Compose backends
        url = 'https://backend.soaraat.com/api';
        print('💡 Using backend.soaraat.com');
      } else if (Platform.isIOS) {
        // For iOS simulator, localhost works
        url = 'https://backend.soaraat.com/api';
      } else {
        // Default fallback
        url = 'https://backend.soaraat.com/api';
      }
      print('🌐 Using LOCAL backend URL: $url');
      print('💡 TROUBLESHOOTING:');
      print('   - Android Emulator: Make sure backend binds to 0.0.0.0:8000 (not localhost)');
      print('   - Physical Device: Use your computer IP (e.g., http://192.168.1.100:8000/api)');
      print('   - Check firewall allows port 8000');
    }
    
    _cachedBaseUrl = url;
    return url;
  }
  
  // Helper method to get the base URL for logging
  static String getBaseUrlForLogging() {
    return baseUrl;
  }
}

