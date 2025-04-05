# Easymotion mobile app (Flutter)

## Setup development environment

- Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Test the installation by open Android Studio, then Terminal, then type `flutter doctor` and that command should exit with no errors

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

- TODO: add deployment documentation
