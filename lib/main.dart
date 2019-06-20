import 'package:flutter/material.dart';
import 'package:instrument/app.dart';
import 'package:wom_package/wom_package.dart';

void main() => runApp(App(userRepository: UserRepository(UserType.Instrument),));