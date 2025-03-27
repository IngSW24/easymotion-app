#!/usr/bin/env sh

flutter pub get &&
#curl -f https://api.staging.easymotion.it/swagger/json > lib/schemas/api-schema.json &&
dart run build_runner build --delete-conflicting-outputs
