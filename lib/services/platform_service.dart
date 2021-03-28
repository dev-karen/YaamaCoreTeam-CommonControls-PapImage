import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class IPlatformService {
  bool isWeb();
  bool isIOS();
  bool isAndroid();
}

class PlatformService implements IPlatformService {
  bool isWeb() {
    return kIsWeb;
  }

  bool isIOS() {
    return Platform.isIOS;
  }

  bool isAndroid() {
    return Platform.isAndroid;
  }
}
