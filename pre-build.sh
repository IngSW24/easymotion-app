#!/usr/bin/env sh

flutter pub get &&
#curl -f https://api.staging.easymotion.it/swagger/json > lib/schemas/api-schema.json &&
rm -rf lib/api-client-generated && # the following command overwrite no files
dart run build_runner build --delete-conflicting-outputs
