import 'package:flutter/material.dart';
import 'package:instrument/app.dart';
import 'package:wom_package/wom_package.dart' show Config, Flavor, UserRepository, UserType;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  Config.appFlavor = Flavor.RELEASE;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(App(
    userRepository: UserRepository(UserType.Instrument),
  ));
}
