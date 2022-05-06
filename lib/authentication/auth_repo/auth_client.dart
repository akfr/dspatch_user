import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/models/auth/auth_request_check_existence.dart';
import 'package:dspatch_user/models/auth/auth_request_login.dart';
import 'package:dspatch_user/models/auth/auth_request_login_social.dart';
import 'package:dspatch_user/models/auth/auth_request_register.dart';
import 'package:dspatch_user/models/auth/responses/login_response.dart';
import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:dspatch_user/models/setting.dart';
import 'package:dspatch_user/models/support.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST('api/check-user')
  Future<void> checkUser(@Body() AuthRequestCheckExistence checkUser);

  @POST('api/register')
  Future<LoginResponse> registerUser(
      @Body() AuthRequestRegister authRequestRegister);

  @POST('api/login')
  Future<LoginResponse> login(@Body() AuthRequestLogin loginRequest);

  @POST('api/social/login')
  Future<LoginResponse> socialLogin(
      @Body() AuthRequestLoginSocial socialLoginUser);

  @POST('api/support')
  Future<void> createSupport(@Body() Support support);

  @PUT('api/user')
  Future<UserInformation> updateUser(
      @Body() Map<String, String> updateUserRequest,
      @Header("Authorization") String bearerToken);

  @PUT('api/user')
  Future<UserInformation> updateUserNotification(
      @Body() Map<String, String> updateUserNotificationRequest,
      @Header("Authorization") String bearerToken);

  @GET('api/user')
  Future<UserInformation> getUser(@Header("Authorization") String bearerToken);

  @GET('api/settings')
  Future<List<Setting>> getSettings();
}
