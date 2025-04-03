@echo off

echo Recupero dipendenze
call flutter pub get

if EXIST "lib\api-client-generated" (
    RMDIR /s /q "lib\api-client-generated"
)

echo Generazione API client...
call dart run build_runner build
