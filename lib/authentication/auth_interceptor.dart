import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  SharedPreferences prefs;

  // @override
  // Future onRequest(RequestOptions options) async {
  //   final hasAuthHeader = options.headers.containsKey(HeaderKeys.authHeaderKey);
  //   final hasNoAuthHeader =
  //       options.headers.containsKey(HeaderKeys.noAuthHeaderKey);
  //   if (hasNoAuthHeader) {
  //     options.headers.remove(HeaderKeys.authHeaderKey);
  //     options.headers.remove(HeaderKeys.noAuthHeaderKey);
  //     return;
  //   }
  //   if (hasAuthHeader) {
  //     options.headers[HeaderKeys.authHeaderKey] =
  //         await Helper().getAuthenticationToken();
  //   }
  // }
}
