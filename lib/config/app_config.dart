import 'package:dspatch_user/locale/arabic.dart';
import 'package:dspatch_user/locale/english.dart';
import 'package:dspatch_user/locale/french.dart';
import 'package:dspatch_user/locale/indonesia.dart';
import 'package:dspatch_user/locale/italian.dart';
import 'package:dspatch_user/locale/portuguese.dart';
import 'package:dspatch_user/locale/spanish.dart';
import 'package:dspatch_user/locale/swahili.dart';
import 'package:dspatch_user/locale/turkey.dart';

class AppConfig {
  static final String appName = "Dispatch";
  static const String packageName = "com.dispatch.app";
  static const String baseUrl = 'https://admin.dspatch.app/';
  static final String oneSignalAppId = "e14f0540-4b2d-4834-9995-e2df4fdf7859";
  static const String mapsApiKey = 'AIzaSyBsHIW6ICGUBE36qkSZBOajaJh1uZjR6U8';
  static final bool isDemoMode = false;
  static final String languageDefault = "en";
  static final Map<String, AppLanguage> languagesSupported = {
    'en': AppLanguage("English", english()),
    'ar': AppLanguage("عربى", arabic()),
    'pt': AppLanguage("Portugal", portuguese()),
    'fr': AppLanguage("Français", french()),
    'id': AppLanguage("Bahasa Indonesia", indonesian()),
    'es': AppLanguage("Español", spanish()),
    'it': AppLanguage("italiano", italian()),
    'sw': AppLanguage("Kiswahili", swahili()),
    'tr': AppLanguage("Türk", turkey()),
  };
}

class AppLanguage {
  final String name;
  final Map<String, String> values;

  AppLanguage(this.name, this.values);
}

class HeaderKeys {
  static const String authHeaderKey = "Authorization";
  static const String noAuthHeaderKey = 'NoAuth';
}
