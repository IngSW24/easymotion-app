#!/usr/bin/env sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
