# TopList Setup Guide

Complete step-by-step guide to setup TopList project from scratch.

## Prerequisites

- Flutter 3.16.0+ installed on your laptop
- Android Studio or VS Code
- Gmail/Google account
- GitHub account
- ~1-2 hours for complete setup

## Part 1: Firebase Setup

### Step 1.1: Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click "Create Project"
3. Project name: `toplist-project`
4. Disable Google Analytics (or enable, doesn't matter)
5. Click "Create Project"
6. Wait for setup to complete

### Step 1.2: Setup Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Select **Google**
4. Toggle **Enable**
5. Add email support (your email)
6. Click **Save**

### Step 1.3: Setup Firestore Database

1. Go to **Firestore Database**
2. Click **Create Database**
3. Select region: `asia-southeast1` (closest to Indonesia)
4. Select **Start in test mode** (for development)
5. Click **Create**

### Step 1.4: Setup Storage

1. Go to **Storage**
2. Click **Get Started**
3. Choose same region: `asia-southeast1`
4. Click **Done**

### Step 1.5: Download Configuration Files

1. Go to **Project Settings** (gear icon)
2. Go to **Your apps** section
3. Select/Create **Android app**
4. Download `google-services.json`
5. Also note your:
   - Project ID
   - API Key
   - Messaging Sender ID

## Part 2: Android Configuration

### Step 2.1: Setup Android Project

1. In your TopList project folder, go to `android/app/`
2. Paste `google-services.json` here

### Step 2.2: Update build.gradle

Open `android/build.gradle`:

```gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.3.15' // Add this
  }
}
```

Open `android/app/build.gradle`:

```gradle
plugins {
  id 'com.google.gms.google-services' // Add this at top
}

android {
  compileSdk 34 // Update if needed
  
  defaultConfig {
    minSdkVersion 21 // For Firebase compatibility
  }
}

dependencies {
  // Firebase dependencies (pubspec.yaml handles most)
}
```

### Step 2.3: Get Android SHA1 Key

**On your laptop terminal:**

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Find the line starting with `SHA1:` and copy it.

**On Windows (if keystore is elsewhere):**

```bash
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Step 2.4: Register SHA1 in Firebase

1. Go back to Firebase Console → Project Settings
2. Under Android app, click "Add fingerprint"
3. Paste your SHA1 key
4. Click "Save"

## Part 3: Update Firebase Configuration

### Step 3.1: Update firebase_options.dart

Open `lib/firebase_options.dart` and update with your Firebase credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY', // From Firebase Console
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'toplist-project',
  storageBucket: 'toplist-project.appspot.com',
);
```

**Where to find these values:**
- Firebase Console → Project Settings → Your apps → Android
- Look for each value in the configuration section

### Step 3.2: Update AndroidManifest.xml

Open `android/app/src/main/AndroidManifest.xml`:

Add your package name if not already there:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.ozllbeep.toplist">
```

## Part 4: Setup Google Sign-In

### Step 4.1: Create OAuth Client

1. Go to https://console.cloud.google.com
2. Select your TopList project
3. Go to **APIs & Services** → **Credentials**
4. Click **Create Credentials** → **OAuth 2.0 Client ID**
5. Select **Android**
6. Package name: `com.ozllbeep.toplist`
7. Add your SHA1 key
8. Create

This will generate your OAuth Client ID (save this).

### Step 4.2: Add to Project

The google_sign_in package in pubspec.yaml handles most of this automatically.

## Part 5: Setup GitHub

### Step 5.1: Initialize Git Repository

```bash
cd toplist
git init
git add .
git commit -m "Initial TopList project setup"
git branch -M main
```

### Step 5.2: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `toplist`
3. Description: "Music sharing platform with Flutter"
4. Select **Private** (for security, since you have API keys)
5. Create repository

### Step 5.3: Push to GitHub

```bash
git remote add origin https://github.com/OzLL-BeeP/toplist.git
git push -u origin main
```

### Step 5.4: Add GitHub Actions Workflow

1. In your repo, create folder: `.github/workflows/`
2. Create file: `.github/workflows/build-apk.yml`
3. Copy content from `build-apk.yml` (provided separately)
4. Commit and push:

```bash
git add .github/workflows/build-apk.yml
git commit -m "Add GitHub Actions workflow"
git push
```

## Part 6: Test & Build

### Step 6.1: Test on Emulator

```bash
flutter pub get
flutter run -d <emulator_name>
```

### Step 6.2: Manual Build (Local)

```bash
flutter build apk --release
```

Output will be at: `build/app/outputs/flutter-app/release/app-release.apk`

### Step 6.3: Trigger GitHub Actions Build

1. Go to your GitHub repo
2. Click **Actions** tab
3. Select **Build APK** workflow
4. Click **Run workflow** → **Run workflow**
5. Wait ~15 minutes for build to complete

### Step 6.4: Download APK from GitHub

1. Once build completes, go to the workflow run
2. Scroll to **Artifacts** section
3. Download `toplist-apk`
4. Extract and get `app-release.apk`

## Part 7: Setup Landing Page

### Step 7.1: Create Landing Page

Use the provided `toplist_landing.html` file.

Edit this line with your APK download link:

```javascript
const apkUrl = 'https://github.com/OzLL-BeeP/toplist/releases/download/v1.0/toplist_v1.0.apk';
```

### Step 7.2: Host Landing Page

**Option A: GitHub Pages (Free)**

1. Create new branch: `gh-pages`
2. Push landing page HTML
3. Go to Settings → Pages → Select gh-pages branch
4. Your site: `https://ozllbeep.github.io/toplist`

**Option B: Netlify (Free)**

1. Go to https://netlify.com
2. Create account
3. Drag & drop folder with HTML
4. Get instant URL

**Option C: Vercel (Free)**

1. Go to https://vercel.com
2. Import GitHub repo
3. Deploy
4. Get automatic URL

## Part 8: Share & Distribute

### Step 8.1: Create Release on GitHub

```bash
git tag v1.0.0
git push origin v1.0.0
```

This will trigger automatic APK upload to GitHub Releases.

### Step 8.2: Update Landing Page Link

Update APK URL to:
```
https://github.com/OzLL-BeeP/toplist/releases/download/v1.0.0/app-release.apk
```

### Step 8.3: Share Link

Share your landing page URL:
- `https://ozllbeep.github.io/toplist` (GitHub Pages)
- Or your Netlify/Vercel URL

Users can download and install directly!

## Troubleshooting

### Firebase Connection Failed

**Solution:**
- Verify API key in firebase_options.dart
- Check internet connection
- Ensure Firestore is enabled in Firebase Console

### Google Sign-In Not Working

**Solution:**
- Verify SHA1 key is added in Firebase Console
- Check package name matches exactly
- Ensure Google Sign-In provider is enabled

### APK Build Fails

**Solution:**
```bash
flutter clean
flutter pub get
flutter build apk --release -v # verbose mode
```

### GitHub Actions Build Timeout

**Solution:**
- Wait up to 30 minutes for first build
- Check workflow logs for specific errors
- Ensure all Firebase configs are correct

## Next Steps

After successful setup:

1. ✅ Test app locally
2. ✅ Test Google Sign-In
3. ✅ Test Firestore operations
4. ✅ Build and test APK on real device
5. ✅ Share landing page with friends
6. ✅ Collect feedback
7. ✅ Publish to Play Store (later)

## Security Notes

⚠️ **Important:**
- Keep `google-services.json` private (don't commit to public repo)
- Use Firestore security rules in production
- Rotate API keys periodically
- Enable Cloud Audit Logs in Firebase

Example Firestore Rules:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Anyone can read music
    match /music/{docId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
  }
}
```

## Resources

- Flutter Docs: https://flutter.dev/docs
- Firebase Docs: https://firebase.google.com/docs
- GitHub Actions: https://docs.github.com/en/actions
- Android Build: https://developer.android.com/studio/build

## Support

If you get stuck:
1. Check the troubleshooting section
2. Review Firebase Console for errors
3. Check GitHub Actions logs for build errors
4. Read official docs for the tool you're having issues with

---

**Last Updated**: January 2025
**Version**: 1.0.0
