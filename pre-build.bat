@echo off

:: Flutter get depends
flutter pub get &&

:: Rimuove cartella auto-generata
(EXISTS lib/api-client-generated && RMDIR /s /q lib/api-client-generated) &&

:: Genera API client
dart run build_runner build
