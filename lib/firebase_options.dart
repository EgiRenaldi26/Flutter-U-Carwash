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
        return macos;
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
    apiKey: 'AIzaSyC2YudGzHljooytj4gZzfeU9YHkC5CaEnI',
    appId: '1:932064285652:web:cbc258fead503fbb3f7c41',
    messagingSenderId: '932064285652',
    projectId: 'cucimobil-24e83',
    authDomain: 'cucimobil-24e83.firebaseapp.com',
    databaseURL: 'https://cucimobil-24e83-default-rtdb.firebaseio.com',
    storageBucket: 'cucimobil-24e83.appspot.com',
    measurementId: 'G-419S7LJ174',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdWwdFM7VNTKu1hkfHVL_pde4kT2s550g',
    appId: '1:932064285652:android:3bfc77b2094310ab3f7c41',
    messagingSenderId: '932064285652',
    projectId: 'cucimobil-24e83',
    databaseURL: 'https://cucimobil-24e83-default-rtdb.firebaseio.com',
    storageBucket: 'cucimobil-24e83.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChAEBKFfO3h6qOZy69j2rlxVGIrhaG0Z8',
    appId: '1:932064285652:ios:ff92c1c0741969e23f7c41',
    messagingSenderId: '932064285652',
    projectId: 'cucimobil-24e83',
    databaseURL: 'https://cucimobil-24e83-default-rtdb.firebaseio.com',
    storageBucket: 'cucimobil-24e83.appspot.com',
    iosBundleId: 'com.example.cucimobilApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChAEBKFfO3h6qOZy69j2rlxVGIrhaG0Z8',
    appId: '1:932064285652:ios:60e48bb8b19f193f3f7c41',
    messagingSenderId: '932064285652',
    projectId: 'cucimobil-24e83',
    databaseURL: 'https://cucimobil-24e83-default-rtdb.firebaseio.com',
    storageBucket: 'cucimobil-24e83.appspot.com',
    iosBundleId: 'com.example.cucimobilApp.RunnerTests',
  );
}
