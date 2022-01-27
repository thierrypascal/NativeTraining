
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> inizialization;

  AdState(this.inizialization);

  //TODO: change to live ads
  static String get finishedWorkoutAdId {
    if (Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/1033173712';
      //return 'ca-app-pub-9906245966081790/7951698556';
    }else{
      throw new UnsupportedError("Unsupported platform");
    }
  }
}