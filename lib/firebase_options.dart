// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCpFAKMHkJK76-Xf0vVTVocyo8UFLdZCnQ',
    appId: '1:460297041918:web:4a3c9db9fde7e7a76bb2af',
    messagingSenderId: '460297041918',
    projectId: 'aibot-a245c',
    authDomain: 'aibot-a245c.firebaseapp.com',
    storageBucket: 'aibot-a245c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjmxcKuH4DpiLnRDpSg05NBZ3DvCRDsuY',
    appId: '1:460297041918:android:9ed3590ff5b042c56bb2af',
    messagingSenderId: '460297041918',
    projectId: 'aibot-a245c',
    storageBucket: 'aibot-a245c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXrat2vMMZf_dlntTS5vK94FmHrDgpr9Q',
    appId: '1:460297041918:ios:7b2d6f8766ba04ea6bb2af',
    messagingSenderId: '460297041918',
    projectId: 'aibot-a245c',
    storageBucket: 'aibot-a245c.appspot.com',
    iosBundleId: 'com.example.bot',
  );
}