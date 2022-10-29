# Ligretto Calculator

## Release to Google play

1. Make sure the `key.properties` file is located in the `./android` directory.
version: "1.2.0+3"
2. Increment the build number in `pubspec.yaml`. For example, from `version: "1.2.0+3"` to `version: "1.2.1+4"`
2. Run `flutter build appbundle`. Don't use the Generate Signed Bundle / APK option in Android Studio as Flutter handles build and signing with the `flutter build appbundle` command.
3. Upload the `./build/app/outputs/bundle/release/app.aab` file to Google Play
