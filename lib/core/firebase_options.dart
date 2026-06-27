import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3MYurYbPaYX3AvugfFMCcq29zKgLYCL0',
    appId: '1:758426640302:ios:1421c70a21fc3cd899323f',
    messagingSenderId: '758426640302',
    projectId: 'cubby-63191',
    storageBucket: 'cubby-63191.firebasestorage.app',
    iosBundleId: 'com.cubby.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPX4-VcWNlohNq8w_itkKwb-an3vswiOE',
    appId: '1:758426640302:android:0c44ee532fd13a6599323f',
    messagingSenderId: '758426640302',
    projectId: 'cubby-63191',
    storageBucket: 'cubby-63191.firebasestorage.app',
  );
}
