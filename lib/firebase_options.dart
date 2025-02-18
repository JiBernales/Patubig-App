// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyA0OAmeYUwGP4tTHqtsoriI0gw7SUhrGcw',
    appId: '1:874376046993:web:07bc84a6fce9d9fc73d230',
    messagingSenderId: '874376046993',
    projectId: 'patubig-6b04f',
    authDomain: 'patubig-6b04f.firebaseapp.com',
    databaseURL: 'https://patubig-6b04f-default-rtdb.firebaseio.com',
    storageBucket: 'patubig-6b04f.firebasestorage.app',
    measurementId: 'G-7E4EC4BCZE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxI-daKNDh-EcSLzt3047G0GUDBsrvBj0',
    appId: '1:874376046993:android:f5e14b2746686c4d73d230',
    messagingSenderId: '874376046993',
    projectId: 'patubig-6b04f',
    databaseURL: 'https://patubig-6b04f-default-rtdb.firebaseio.com',
    storageBucket: 'patubig-6b04f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAABId6gHIz9htoVK3-uIYFuiLjT_k0G0',
    appId: '1:874376046993:ios:0c1bbf77ee530e5073d230',
    messagingSenderId: '874376046993',
    projectId: 'patubig-6b04f',
    databaseURL: 'https://patubig-6b04f-default-rtdb.firebaseio.com',
    storageBucket: 'patubig-6b04f.firebasestorage.app',
    iosBundleId: 'com.example.patubigApp',
  );

}