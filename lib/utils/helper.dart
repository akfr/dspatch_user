import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/auth/responses/login_response.dart';
import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:dspatch_user/models/order/get/address.dart';
import 'package:dspatch_user/models/setting.dart';
import 'package:dspatch_user/models/user/image_data.dart';
import 'package:dspatch_user/models/user/media_library.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  Helper._privateConstructor() {
    _initPref();
  }

  static final Helper _instance = Helper._privateConstructor();

  factory Helper() {
    return _instance;
  }

  static const String _KEY_SETTINGS = "key_settings";
  static const String _KEY_TOKEN = "key_token";
  static const String _KEY_USER = "key_user";
  static const String _KEY_CUR_LANG = "key_cur_lang";
  static const String _KEY_LAST_LOC = "key_last_loc";
  SharedPreferences _sharedPreferences;

  //holding frequently accessed sharedPreferences in memory.
  List<Setting> _settingsAll;
  String _authToken;
  UserInformation _userMe;

  _initPref() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future<bool> init() async {
    await _initPref();
    _settingsAll = await getSettings();
    await getAuthenticationToken();
    return true;
  }

  saveSettings(List<Setting> settings) async {
    if (settings != null) {
      _settingsAll = settings;
      await _initPref();
      _sharedPreferences.setString(_KEY_SETTINGS, json.encode(settings));
    }
  }

  Future<bool> isLanguageSelectionPromted() async {
    await _initPref();
    return _sharedPreferences.containsKey("language_selection_promted");
  }

  setLanguageSelectionPromted() async {
    await _initPref();
    _sharedPreferences.setBool("language_selection_promted", true);
  }

  Future<List<Setting>> getSettings() async {
    if (_settingsAll != null) {
      return _settingsAll;
    } else {
      await _initPref();
      String settingVal = _sharedPreferences.getString(_KEY_SETTINGS);
      if (settingVal != null && settingVal.isNotEmpty) {
        return (json.decode(settingVal) as List)
            .map((e) => Setting.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    }
  }

  Future<String> getCurrentLanguage() async {
    await _initPref();
    return _sharedPreferences.containsKey(_KEY_CUR_LANG)
        ? _sharedPreferences.getString(_KEY_CUR_LANG)
        : AppConfig.languageDefault;
  }

  Future<bool> setCurrentLanguage(String langCode) async {
    await _initPref();
    return _sharedPreferences.setString(_KEY_CUR_LANG, langCode);
  }

  Future<bool> setCurrentLocation(Address address) async {
    await _initPref();
    return _sharedPreferences.setString(_KEY_LAST_LOC, json.encode(address));
  }

  Future<Address> getCurrentLocation() async {
    await _initPref();
    return _sharedPreferences.containsKey(_KEY_LAST_LOC)
        ? Address.fromJson(
            json.decode(_sharedPreferences.getString(_KEY_LAST_LOC)))
        : null;
  }

  Future<String> getAuthenticationToken() async {
    await _initPref();
    if (_authToken == null && _sharedPreferences.containsKey(_KEY_TOKEN)) {
      _authToken = "Bearer ${_sharedPreferences.getString(_KEY_TOKEN)}";
      Helper.printConsoleWrapped("_authToken setup: $_authToken");
    }
    return _authToken;
  }

  String getSettingValue(String forKey) {
    String toReturn = "";
    if (_settingsAll != null) {
      for (Setting setting in _settingsAll) {
        if (setting.key == forKey) {
          toReturn = setting.value;
          break;
        }
      }
    }
    if (toReturn.isEmpty) {
      print(
          "getSettingValue returned empty value for: $forKey, when settings were: $_settingsAll");
    }
    return toReturn;
  }

  static void printConsoleWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }

    if (tokens.isEmpty) {
      tokens.add('${seconds}s');
    }

    return tokens.join(' ');
  }

  static String setupDate(String dateTimeStamp) {
    return Moment.parse(dateTimeStamp).format("dd MMM yyyy, HH:mm");
  }

  Future<UserInformation> getUserMe() async {
    if (this._userMe == null) {
      await _initPref();
      _userMe = _sharedPreferences.containsKey(_KEY_USER)
          ? UserInformation.fromJson(
              json.decode(_sharedPreferences.getString(_KEY_USER)))
          : null;
    }
    return _userMe != null && _userMe.id == null ? null : _userMe;
  }

  Future<bool> clearPrefs() async {
    await _initPref();
    //_settingsAll = null;
    _authToken = null;
    _userMe = null;
    bool cleared = await _sharedPreferences.clear(); //clearing everything
    saveSettings(_settingsAll); //except setting values
    return cleared;
  }

  saveAuthResponse(LoginResponse authResponse) async {
    await _initPref();
    _authToken = "Bearer ${authResponse.token}";
    _sharedPreferences.setString(_KEY_TOKEN, authResponse.token);
    setUserMe(authResponse.userInfo);
  }

  Future<UserInformation> setUserMe(UserInformation userMe) async {
    this._userMe = userMe;

    if (this._userMe.mediaurls == null ||
        this._userMe.mediaurls.images == null) {
      this._userMe.mediaurls = MediaLibrary([]);
    }
    if (this._userMe.image_url == null) {
      for (ImageData imgObj in this._userMe.mediaurls.images) {
        if (imgObj.defaultImage != null && imgObj.defaultImage.isNotEmpty) {
          this._userMe.image_url = imgObj.defaultImage;
          break;
        }
      }
    }

    await _initPref();
    _sharedPreferences.setString(_KEY_USER, json.encode(this._userMe.toJson()));
    return this._userMe;
  }

  static LatLngBounds getMarkerBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  static String formatPhone(String phone) {
    String toReturn = phone.replaceAll(" ", "");
    while (
        //toReturn.startsWith("0") ||
        toReturn.startsWith("+")) toReturn = toReturn.substring(1);
    return toReturn;
  }

  static void launchMapsUrl(
      LatLng pickup, LatLng drop, String origin, String dest) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showDirections(
      origin: Coords(pickup.latitude, pickup.longitude),
      originTitle: origin,
      destination: Coords(drop.latitude, drop.longitude),
      destinationTitle: dest,
    );
  }

  static Future<bool> launchUrl(String url) async {
    try {
      return launch(url);
    } catch (e) {
      print("launchUrl: $e");
      return false;
    }
    // bool couldLaunch = await canLaunch(url);
    // if (couldLaunch) {
    //   return launch(url);
    // } else {
    //   return false;
    // }
  }

  static openShareMediaIntent(BuildContext context) {
    Share.share(
      AppLocalizations.of(context).getTranslationOf("share_msg") +
          " " +
          AppConfig.appName +
          "\n" +
          "https://play.google.com/store/apps/details?id=" +
          AppConfig.packageName,
    );
  }

  static Future<BitmapDescriptor> getBitmapDescriptorFromIconData(
      IconData iconData, Color color) async {
    try {
      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      final iconStr = String.fromCharCode(iconData.codePoint);
      textPainter.text = TextSpan(
          text: iconStr,
          style: TextStyle(
            letterSpacing: 0.0,
            fontSize: 74.0,
            fontFamily: iconData.fontFamily,
            color: color,
          ));
      textPainter.layout();
      textPainter.paint(canvas, Offset(0.0, 0.0));
      final picture = pictureRecorder.endRecording();
      final image = await picture.toImage(74, 74);
      final bytes = await image.toByteData(format: ImageByteFormat.png);
      return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    } catch (e) {
      print("getBitmapDescriptorFromIconData: $e");
      return null;
    }
  }
}
