import 'package:flutter/material.dart';

class ProfileScreenProvider extends ChangeNotifier {
  factory ProfileScreenProvider.instance() {
    return _internal;
  }

  ProfileScreenProvider.internal();

  static final ProfileScreenProvider _internal = ProfileScreenProvider.internal();
}
