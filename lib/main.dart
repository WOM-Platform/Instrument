import 'package:flutter/material.dart';
import 'package:instrument/app.dart';

import 'src/services/user_repository.dart';

void main() => runApp(App(userRepository: UserRepository(),));