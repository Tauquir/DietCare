# DietCare App with Google Sign-In

A Flutter application for diet and nutrition management with Google authentication.

## ✅ Features Implemented

### Authentication
- **Splash Screen**: Welcome screen with app branding and automatic navigation
- **Login Page**: Email/password login with Google Sign-In option
- **Signup Page**: User registration with Google Sign-In option
- **Home Page**: User dashboard with profile information and logout
- **Google Sign-In**: Complete Google authentication integration

### Google Sign-In Features
- ✅ Google Sign-In button with proper styling
- ✅ User profile data retrieval (name, email, photo)
- ✅ Persistent login state (remembers user between app sessions)
- ✅ Proper sign-out functionality
- ✅ Error handling and user feedback
- ✅ Debug test page for troubleshooting

## 🚀 Getting Started

### Prerequisites
1. Flutter SDK installed
2. Google Cloud Console project set up
3. Google Sign-In configured for Android/iOS

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Google Sign-In (see setup instructions below)
4. Run `flutter run` to start the app

## 📱 App Flow

1. **Splash Screen** → Shows app branding for 3 seconds
2. **Authentication Check** → Checks if user is already signed in
3. **Login/Signup** → User can sign in with email/password or Google
4. **Home Page** → Shows user profile and app features

## 🔧 Google Sign-In Setup

### Android Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google Sign-In API
4. Create OAuth 2.0 credentials
5. Add your app's SHA-1 fingerprint
6. Download `google-services.json` and place in `android/app/`

### iOS Setup
1. In Google Cloud Console, add iOS app
2. Download `GoogleService-Info.plist`
3. Place in `ios/Runner/` directory
4. Add to Xcode project

### Web Setup (Optional)
1. Add web app in Google Cloud Console
2. Configure authorized JavaScript origins
3. Add client ID to web configuration

## 📁 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants
│   ├── theme/                      # App theming
│   ├── routes/                     # Navigation routes
│   └── utils/                      # Utility functions
├── features/                       # Feature-based modules
│   ├── auth/                       # Authentication feature
│   │   └── presentation/pages/
│   │       ├── splash_page.dart
│   │       ├── login_page.dart
│   │       ├── signup_page.dart
│   │       └── google_signin_test_page.dart
│   └── profile/                    # User profile feature
│       └── presentation/pages/
│           └── home_page.dart
└── shared/                         # Shared components
    ├── services/                   # Google authentication service
    │   └── google_auth_service.dart
    └── widgets/                    # Reusable widgets
        └── google_sign_in_button.dart
```

## 🔑 Key Files

### Google Authentication Service
- **File**: `lib/shared/services/google_auth_service.dart`
- **Purpose**: Handles all Google Sign-In operations
- **Features**: Sign-in, sign-out, user data storage, persistent login

### Google Sign-In Button Widget
- **File**: `lib/shared/widgets/google_sign_in_button.dart`
- **Purpose**: Reusable Google Sign-In button component
- **Features**: Loading states, custom text, proper styling

### Test Page
- **File**: `lib/features/auth/presentation/pages/google_signin_test_page.dart`
- **Purpose**: Debug and test Google Sign-In functionality
- **Access**: Available via debug button on login page

## 🛠️ Dependencies

```yaml
dependencies:
  google_sign_in: ^6.2.1      # Google Sign-In SDK
  shared_preferences: ^2.2.2   # Local data storage
```

## 🧪 Testing Google Sign-In

1. Run the app
2. Go to Login page
3. Tap "Debug: Test Google Sign-In" button
4. Use the test page to verify Google Sign-In functionality

## 🚨 Troubleshooting

### Common Issues
1. **"Sign-in failed"**: Check Google Cloud Console configuration
2. **"SHA-1 fingerprint"**: Ensure correct SHA-1 is added to Google Console
3. **"Package name mismatch"**: Verify package name in Google Console matches app

### Debug Steps
1. Use the Google Sign-In test page
2. Check console logs for detailed error messages
3. Verify Google Cloud Console configuration
4. Test on physical device (Google Sign-In doesn't work on emulator)

## 🔄 Next Steps

- [ ] Add Firebase integration for backend
- [ ] Implement user profile management
- [ ] Add diet tracking features
- [ ] Implement nutrition logging
- [ ] Add exercise tracking
- [ ] Create goal setting system

## 📝 Notes

- Google Sign-In requires physical device testing
- SHA-1 fingerprint must be correctly configured
- User data is stored locally using SharedPreferences
- App automatically checks for existing login on startup






