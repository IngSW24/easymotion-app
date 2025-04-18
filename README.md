# Easymotion mobile app (Flutter)

## Setup development environment

- Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Test the installation by opening Android Studio, then Terminal, then type `flutter doctor` and that command should exit with no errors

## Run app on an emulator (or on other supported platforms)

- Open Android Studio, then this project
- Linux/macOS only: run pre-build.sh (open file and press Ctrl+Shift+F10)
- Windows only: run pre-build.bat (open file and press Ctrl+Shift+F10)
- Copy `.env.example` into `.env`
- Select device in the top app bar to the left of the green run icon button (select an Android device or an another supported platform)
- Run (click on the run icon button or press Shift+F10)

### dotenv file

The `.env` file allows you to change some environment variables read by the mobile app:

- API_URL: API's URL without trailing slash
- STATIC_URL: Static resource server URL without trailing slash

## Deploy

### Versioning

To deploy a release, you need to tag the corresponding commit with the following syntax:

- `v<MAJOR>.<MINOR>.<PATCH>`: Production release
- `v<MAJOR>.<MINOR>.<PATCH>-beta`: Staging release

which have to match the following regex:

`v[0-9]+\.[0-9]+\.[0-9]+(-beta)?`

then you need to create a new release from GitHub:

- Click on `Create a new release`
- Choose the tag you just created
- Add the changelog
- Click on `Publish release`

#### Changelog example

```
Release 1.2.3

- Introdotta autenticazione OAuth2
- Risolto bug navigazione tra schermate
- Ottimizzate le query per migliorare le performance
```

#### Valid tags

- `v0.30.23`
- `v0.30.24-beta`
- `v1.14.23`
- `v1.14.24-beta`

### Build the release version

- Android (APK):
  - `flutter build appbundle`: Creates an [App Bundle](https://developer.android.com/guide/app-bundle)
  - `flutter build apk --split-per-abi`: Creates an APK for each target ABI (armeabi-v7a, arm64-v8a, x86_64)
  - `flutter build apk`: Creates a fat APK that includes all the target ABIs.
- iOS: `flutter build ipa`: See [iOS | Flutter](https://docs.flutter.dev/deployment/ios)
- Linux: `flutter build linux`
