import 'package:flutter/material.dart';

class DownloadScreenProvider extends ChangeNotifier {
  factory DownloadScreenProvider.instance() {
    return _internal;
  }

  DownloadScreenProvider.internal();

  static final DownloadScreenProvider _internal = DownloadScreenProvider.internal();
}
