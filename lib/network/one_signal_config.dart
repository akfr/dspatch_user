import 'package:dspatch_user/config/app_config.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalConfig {
  static Future<void> initOneSignal() async {
    // await OneSignal.shared.setAppId(AppConfig.oneSignalAppId);
  }

  static getPlayerId() async {
    // await initOneSignal(); //just in case if this was uninitialized
    // var status = await OneSignal.shared.getDeviceState();
    // return (status.userId != null) ? status.userId : null;
  }
}
