# eam_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


-Please Change Dependencies on Barcode scan in BUILD.GRADLE LIKE THIS BELLOW
dependencies {
    implementation 'androidx.appcompat:appcompat:1.1.0'
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation 'me.dm7.barcodescanner:zxing:1.9.8'
    implementation 'com.google.protobuf:protobuf-lite:3.0.1'
    api 'com.google.android.material:material:1.1.0'
}
