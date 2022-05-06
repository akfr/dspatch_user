// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AuthClient implements AuthClient {
  _AuthClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://admin.dspatch.app/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<void> checkUser(checkUser) async {
    ArgumentError.checkNotNull(checkUser, 'checkUser');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(checkUser?.toJson() ?? <String, dynamic>{});
    await _dio.request<void>('${this.baseUrl}api/check-user',
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'POST',
        //     headers: <String, dynamic>{},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    return null;
  }

  @override
  Future<LoginResponse> registerUser(authRequestRegister) async {
    ArgumentError.checkNotNull(authRequestRegister, 'authRequestRegister');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(authRequestRegister?.toJson() ?? <String, dynamic>{});
    final _result =
        await _dio.request<Map<String, dynamic>>('${this.baseUrl}api/register',
            queryParameters: queryParameters,
            options: Options(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'POST',
            //     headers: <String, dynamic>{},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = LoginResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<LoginResponse> login(loginRequest) async {
    ArgumentError.checkNotNull(loginRequest, 'loginRequest');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(loginRequest?.toJson() ?? <String, dynamic>{});
    final _result =
        await _dio.request<Map<String, dynamic>>('${this.baseUrl}api/login',
            queryParameters: queryParameters,
            options: Options(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'POST',
            //     headers: <String, dynamic>{},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = LoginResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<LoginResponse> socialLogin(socialLoginUser) async {
    ArgumentError.checkNotNull(socialLoginUser, 'socialLoginUser');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(socialLoginUser?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        '${this.baseUrl}api/social/login',
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'POST',
        //     headers: <String, dynamic>{},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    final value = LoginResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<void> createSupport(support) async {
    ArgumentError.checkNotNull(support, 'support');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(support?.toJson() ?? <String, dynamic>{});
    await _dio.request<void>('${this.baseUrl}api/support',
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'POST',
        //     headers: <String, dynamic>{},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    return null;
  }

  @override
  Future<UserInformation> updateUser(updateUserRequest, bearerToken) async {
    ArgumentError.checkNotNull(updateUserRequest, 'updateUserRequest');
    ArgumentError.checkNotNull(bearerToken, 'bearerToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUserRequest ?? <String, dynamic>{});
    final _result =
        await _dio.request<Map<String, dynamic>>('${this.baseUrl}api/user',
            queryParameters: queryParameters,
            options: Options(
              method: 'PUT',
              headers: <String, dynamic>{r'Authorization': bearerToken},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'PUT',
            //     headers: <String, dynamic>{r'Authorization': bearerToken},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = UserInformation.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserInformation> updateUserNotification(
      updateUserNotificationRequest, bearerToken) async {
    ArgumentError.checkNotNull(
        updateUserNotificationRequest, 'updateUserNotificationRequest');
    ArgumentError.checkNotNull(bearerToken, 'bearerToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateUserNotificationRequest ?? <String, dynamic>{});
    final _result =
        await _dio.request<Map<String, dynamic>>('${this.baseUrl}api/user',
            queryParameters: queryParameters,
            options: Options(
              method: 'PUT',
              headers: <String, dynamic>{r'Authorization': bearerToken},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'PUT',
            //     headers: <String, dynamic>{r'Authorization': bearerToken},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = UserInformation.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserInformation> getUser(bearerToken) async {
    ArgumentError.checkNotNull(bearerToken, 'bearerToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<Map<String, dynamic>>('${this.baseUrl}api/user',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{r'Authorization': bearerToken},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{r'Authorization': bearerToken},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = UserInformation.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<Setting>> getSettings() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<List<dynamic>>('${this.baseUrl}api/settings',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    var value = _result.data
        .map((dynamic i) => Setting.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
