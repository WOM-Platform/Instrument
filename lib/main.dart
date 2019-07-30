import 'package:flutter/material.dart';
import 'package:instrument/app.dart';
import 'package:wom_package/wom_package.dart';

void main() {
  Config.appFlavor = Flavor.RELEASE;
  runApp(App(
    userRepository: UserRepository(UserType.Instrument),
  ));
}
