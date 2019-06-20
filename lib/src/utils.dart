import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const String lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod "
    "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim "
    "veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea "
    "commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
    "velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
    "cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
    "est laborum.";

String generateGUID(){
  var uuid = new Uuid();
  final guid = uuid.v1buffer(List(16));
  return Base64Encoder().convert(guid);
}