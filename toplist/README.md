# TopList - Music Sharing Platform

A modern Flutter app for sharing, rating, and discussing your favorite music from YouTube, Spotify, TikTok, and more.

## 🎵 Features

✅ **Share Music** - Post songs from YouTube, Spotify, TikTok, SoundCloud
✅ **Rate & Review** - 5-star rating system with detailed reviews
✅ **Comments & Discussion** - Community engagement on every track
✅ **User Profiles** - Follow/Unfollow system, custom albums
✅ **Tier System** - Free, PRO (Rp 45k), PREMIUM (Rp 79k) with exclusive features
✅ **Dark Mode** - Beautiful dark theme with red/orange accents
✅ **Google Sign-In** - One-tap authentication

## 🎯 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Video Integration**: YouTube Player Flutter
- **Authentication**: Google Sign-In
- **State Management**: Provider
- **Database**: Firestore

## 📱 Supported Platforms

- Android 8.0+ (APK)
- iOS (coming soon)
- Web (coming soon)

## 🚀 Quick Start

### Prerequisites

- Flutter 3.16.0+ ([install here](https://flutter.dev/docs/get-started/install))
- Dart SDK (bundled with Flutter)
- Android SDK (for Android development)
- Firebase Account ([create here](https://firebase.google.com))
- Google Cloud Project ([create here](https://console.cloud.google.com))

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/OzLL-BeeP/toplist.git
   cd toplist
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase** (See SETUP.md for detailed instructions)
   - Create Firebase project
   - Download google-services.json
   - Update firebase_options.dart

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Build APK**
   ```bash
   flutter build apk --release
   ```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── firebase_options.dart              # Firebase configuration
├── models/
│   ├── user_model.dart               # User data model
│   └── music_model.dart              # Music/song data model
├── services/
│   ├── auth_service.dart             # Authentication & user management
│   └── music_service.dart            # Music CRUD operations
├── screens/
│   ├── auth_screen.dart              # Login screen
│   ├── home_screen.dart              # Feed & music list
│   └── music_detail_screen.dart      # Player & comments
└── widgets/
    └── [custom widgets]

assets/
├── images/
│   └── logo.png
└── icons/
    └── google.png
```

## 🔧 Configuration

### Firebase Setup

1. Create Firebase project at https://console.firebase.google.com
2. Enable:
   - Authentication (Google provider)
   - Firestore Database
   - Cloud Storage

3. Download `google-services.json` from Firebase Console
4. Place in `android/app/` folder

### Environment Variables

Update `lib/firebase_options.dart` with your Firebase credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'toplist-project',
  storageBucket: 'toplist-project.appspot.com',
);
```

## 🎨 Color Scheme

- **Primary**: #ff5722 (Red-Orange)
- **Secondary**: #ff9100 (Orange)
- **Tertiary**: #ffc107 (Yellow)
- **Background**: #121212 (Dark)
- **Surface**: #1E1E1E (Slightly lighter)

## 📊 Database Schema

### Users Collection
```
users/
├── uid
├── username (unique)
├── displayName
├── photoUrl
├── bio
├── tier (free/pro/premium)
├── followers
├── following
├── followingList []
├── followersList []
├── createdAt
├── isAdmin
└── chatBubbleColors
```

### Music Collection
```
music/
├── id
├── userId
├── username
├── title
├── artist
├── musicUrl
├── source (youtube/spotify/tiktok/soundcloud)
├── videoId (for YouTube)
├── albumId
├── description
├── rating (avg)
├── ratingCount
├── likes
├── likedBy []
├── createdAt
└── commentCount
```

### Comments Collection
```
comments/
├── id
├── musicId
├── userId
├── username
├── userPhotoUrl
├── content
├── createdAt
└── likes
```

## 🔐 Security Rules

Firestore rules restrict access:
- Users can only modify their own profile
- Comments must be from authenticated users
- Music posts are readable by all, editable by owner only

## 🌐 Supported Music Sources

- YouTube (`youtube.com`, `youtu.be`)
- Spotify (`spotify.com`)
- TikTok (`tiktok.com`)
- SoundCloud (`soundcloud.com`)
- Instagram (`instagram.com`) - limited support

## 📦 Building & Deployment

### Build APK (for manual installation)
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-app/release/app-release.apk` (~80MB)

### Build AAB (for Play Store)
```bash
flutter build appbundle --release
```

### GitHub Actions (Automated)
Push to GitHub and GitHub Actions will automatically:
1. Build APK
2. Upload as artifact
3. Create release

See `.github/workflows/build-apk.yml` for CI/CD configuration.

## 🚀 Distribution

### Installation Methods

1. **Direct APK Download** (From landing page)
   - User downloads APK from web
   - Installs on Android device
   - Allows unknown sources in Settings

2. **Play Store** (Coming soon)
   - Official release
   - Auto-updates
   - User ratings & reviews

3. **TestFlight** (iOS, coming soon)
   - Beta testing for iOS users

## 📝 API Endpoints

All backend operations use Firestore. No REST API currently.

Future endpoints may include:
- Search service (Algolia)
- Analytics
- Payment gateway (Midtrans/Xendit)

## 🐛 Troubleshooting

### Build Fails
```bash
# Clean everything
flutter clean

# Get dependencies again
flutter pub get

# Run with verbose
flutter run -v
```

### Firebase Auth Not Working
- Verify API key in firebase_options.dart
- Check Google Sign-In credentials
- Ensure SHA1 key is added in Firebase Console

### YouTube Player Not Loading
- Check internet connection
- Verify YouTube URL format
- Check if video is not restricted/private

## 📞 Support

For issues or questions:
- Open GitHub issue
- Contact: your-email@example.com
- Discord: [coming soon]

## 📄 License

This project is proprietary. All rights reserved.

## 👨‍💻 Author

**OzLL-BeeP**
- GitHub: https://github.com/OzLL-BeeP
- Instagram: [@ozllbeep](https://instagram.com/ozllbeep)

## 🎉 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- YouTube for video embedding
- Community contributors

---

**Last Updated**: January 2025
**Version**: 1.0.0
**Status**: Active Development
