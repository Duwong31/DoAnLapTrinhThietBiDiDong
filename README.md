
# SoundFlow

SoundFlow is a modern music app that delivers a fantastic listening experience for users. With its user-friendly interface and ease of use, SoundFlow allows you to explore, listen to, and manage your music effortlessly.

## Screenshots

<img src="https://github.com/Duwong31/DoAnLapTrinhThietBiDiDong/blob/main/assets/images/Screenshot%202026-07-26%20210913.png" alt="project-screenshot" width="600" height="400/">



## Tech Stack

**Client:** Flutter, Dart, GetX (state, routing, DI), Dio (HTTP client)

**Backend Services:** Firebase (Auth, Crashlytics, Analytics, FCM)

**Server:** PHP, Laravel (REST API)

**Local Storage:** SharedPreferences, GetStorage

## Features

- Light/dark mode toggle
- Browse and stream your favorite tracks
- Create and manage custom playlists
- Quickly find songs, artists, or albums
- Cross platform


## Run Locally

###  System Requirements

- **Flutter SDK**: Stable channel, version `3.32.2`
- **Java**: Version `17`

---

### 🚀 Run the Application

```shell
flutter run
```


Update iOS Pods
```shell
cd ios
pod init
pod update
pod install
cd ..
```

Clean Pub Cache
```shell
flutter clean
flutter pub cache clean
flutter pub get
```

Repair Pub Cache
```shell
flutter clean
flutter pub cache repair
flutter pub get
```



Generate Android APK
```shell
flutter build apk --split-per-abi
open  build/app/outputs/flutter-apk/
```

You can learn more about SoundFlow's user interface and user experience through the following links:https://www.figma.com/design/djq89XkXyIXXfsrNDxXKaK/Project-App-SoundFlow?node-id=0-1&p=f&t=7MPXtoUQIuVJ48MM-0

Give SoundFlow a try and enjoy your music in a whole new way! 🎶

