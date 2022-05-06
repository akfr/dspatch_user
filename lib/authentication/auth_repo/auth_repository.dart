import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dspatch_user/authentication/verification/cubit/verification_cubit.dart';
import 'package:dspatch_user/models/auth/auth_request_check_existence.dart';
import 'package:dspatch_user/models/auth/auth_request_login.dart';
import 'package:dspatch_user/models/auth/auth_request_login_social.dart';
import 'package:dspatch_user/models/auth/auth_request_register.dart';
import 'package:dspatch_user/models/auth/responses/auth_response_login_social.dart';
import 'package:dspatch_user/models/auth/responses/login_response.dart';
import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:dspatch_user/models/setting.dart';
import 'package:dspatch_user/models/support.dart';
import 'package:dspatch_user/network/test_status_code.dart';
import 'package:dspatch_user/utils/constants.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_client.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  int _resendToken;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );

  //final FacebookLogin _facebookLogin = FacebookLogin();

  final Dio dio;
  final AuthClient client;

  AuthRepo._(this.dio, this.client);

  factory AuthRepo() {
    Dio dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    AuthClient client = AuthClient(dio);
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json',
    };
    return AuthRepo._(dio, client);
  }

  ///check whether the user is registered or not
  Future<bool> isRegistered(String number) {
    return client
        .checkUser(AuthRequestCheckExistence(number))
        .then((value) => true)
        .catchError((Object obj) => false,
            test: (obj) => TestStatusCode.check(obj, 422));
  }

  ///register user
  Future<LoginResponse> registerUser(AuthRequestRegister registerUser) {
    return client.registerUser(registerUser);
  }

  ///phone number Sign In
  Future<LoginResponse> signInWithPhoneNumber(String fireToken) async {
    return await client.login(AuthRequestLogin(fireToken));
  }

  Future<void> logout() async {
    // return Future.wait([
    //   Helper().clearPrefs(),
    //   _firebaseAuth.signOut(),
    //   _googleSignIn.signOut(),
    //   //_facebookLogin.logOut(),
    // ]);
  }

  Future<AuthResponseSocial> signInWithGoogle() async {
    GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      LoginResponse authResponse = await client.socialLogin(
          AuthRequestLoginSocial("google", googleAuth.idToken,
              Platform.isAndroid ? "android" : "ios"));
      return AuthResponseSocial(null, null, null, authResponse);
    } catch (e) {
      String userName, userEmail, userImageUrl;

      try {
        if (e is DioError) {
          Response<dynamic> response = (e).response;
          if (response.statusCode == 404 && response.data != null) {
            Map<String, dynamic> errorResponse = response.data;
            if (errorResponse.containsKey("message")) {
              if (errorResponse.containsKey("name")) {
                userName = errorResponse["name"];
              } else if (googleUser != null && googleUser.displayName != null) {
                userName = googleUser.displayName;
              }

              if (errorResponse.containsKey("email")) {
                userEmail = errorResponse["email"];
              } else if (googleUser != null && googleUser.email != null) {
                userEmail = googleUser.email;
              }

              if (errorResponse.containsKey("image_url")) {
                userImageUrl = errorResponse["image_url"];
              } else if (googleUser != null && googleUser.photoUrl != null) {
                userImageUrl = googleUser.photoUrl;
              }
            }
          }
        }
      } catch (e) {
        print(e);
      }

      try {
        logout();
      } catch (le) {
        print(le);
      }

      return AuthResponseSocial(userName, userEmail, userImageUrl, null);
    }
  }

  Future<bool> userWithPhoneAndPasswordExists(
      String phone, String passWord) async {
    var exists = false;
    var authenticateResult = (await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: '$phone@dspatch.com', password: passWord)
        .catchError((errMsg) {
      exists = errMsg.code != "user-not-found";
    }));

    exists = authenticateResult != null;
    return exists;
  }

  Future<LoginResponse> signinPhoneEmail(String phone, String passWord) async {
    var authenticateResult = (await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: '$phone@dspatch.com', password: passWord)
        .catchError((errMsg) {}));

    if (authenticateResult == null) {
      return null;
    }
    var fireToken = await authenticateResult.user.getIdToken();

    return await client.login(AuthRequestLogin(fireToken));
  }

  Future<UserCredential> signupPhoneEmail(String phone, String passWord) async {
    var authenticateResult = (await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: '$phone@dspatch.com', password: passWord)
        .catchError((errMsg) {}));

    if (authenticateResult == null) {
      return null;
    }

    return authenticateResult;
  }

  // Future<AuthResponseSocial> signInWithFacebook() async {
  //   FacebookAccessToken accessToken;
  //   try {
  //     final facebookLogin = FacebookLogin();
  //     facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //     final result = await facebookLogin.logIn(['email', 'public_profile']);
  //     accessToken = result.accessToken;
  //     LoginResponse authResponse = await client.socialLogin(
  //         AuthRequestLoginSocial("facebook", accessToken.token,
  //             Platform.isAndroid ? "android" : "ios"));
  //     return AuthResponseSocial(null, null, null, authResponse);
  //   } catch (e) {
  //     String userName, userEmail, userImageUrl;

  //     try {
  //       if (e is DioError) {
  //         final graphResponse = await dio.get(
  //             'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${accessToken.token}');
  //         final profile = jsonDecode(graphResponse.data);

  //         Response<dynamic> response = (e).response;
  //         if (response.statusCode == 404 && response.data != null) {
  //           Map<String, dynamic> errorResponse = response.data;
  //           if (errorResponse.containsKey("message")) {
  //             if (errorResponse.containsKey("name")) {
  //               userName = errorResponse["name"];
  //             } else {
  //               userImageUrl = profile["name"];
  //             }

  //             if (errorResponse.containsKey("email")) {
  //               userName = errorResponse["email"];
  //             } else {
  //               userImageUrl = profile["email"];
  //             }

  //             if (errorResponse.containsKey("image_url")) {
  //               userName = errorResponse["image_url"];
  //             } else {
  //               userImageUrl = profile["picture"]["data"]["url"];
  //             }
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       print(e);
  //     }

  //     try {
  //       logout();
  //     } catch (le) {
  //       print(le);
  //     }

  //     return AuthResponseSocial(userName, userEmail, userImageUrl, null);
  //   }
  // }

  Future<String> getPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('photo');
  }

  Future<Null> support(String message) async {
    UserInformation userInformation = await Helper().getUserMe();
    Support support = Support(
      name: userInformation.name,
      email: userInformation.email,
      message: message,
    );
    await client.createSupport(support);
  }

  Future<UserInformation> updateUser(String name, String imageUrl) async {
    String token = await Helper().getAuthenticationToken();
    return client.updateUser({"name": name, "image_url": imageUrl}, token);
  }

  Future<UserInformation> updateUserNotification(String playerId) async {
    String token = await Helper().getAuthenticationToken();
    return client.updateUserNotification({
      "notification": "{\"" + Constants.ROLE_USER + "\":\"" + playerId + "\"}"
    }, token);
  }

  Future<UserInformation> getUser() async {
    String token = await Helper().getAuthenticationToken();
    return client.getUser(token);
  }

  Future<List<Setting>> getSettings() async {
    var settings = await client.getSettings();
    await Helper().saveSettings(settings);
    return settings;
  }

  Future<void> otpSend(
      String phoneNumberFull, VerificationCallbacks verificationCallback) {
    return _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumberFull,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        if (Platform.isAndroid) {
          verificationCallback.onCodeVerifying();
          _fireSignIn(credential, verificationCallback);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print("FirebaseAuthException: $e");
        print("FirebaseAuthException_message: ${e.message}");
        print("FirebaseAuthException_code: ${e.code}");
        print("FirebaseAuthException_phoneNumber: ${e.phoneNumber}");
        verificationCallback.onCodeSendError();
      },
      codeSent: (String verificationId, int resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        verificationCallback.onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  otpVerify(String otp, VerificationCallbacks verificationCallback) {
    _fireSignIn(
        PhoneAuthProvider.credential(
            verificationId: _verificationId, smsCode: otp),
        verificationCallback);
  }

  _fireSignIn(AuthCredential credential,
      VerificationCallbacks verificationCallback) async {
    try {
      // await _firebaseAuth.signInWithCredential(credential);
      try {
        var user = _firebaseAuth.currentUser;
        var idToken = await user.getIdToken();

        final loggedInResponse = await signInWithPhoneNumber(idToken);
        verificationCallback.onCodeVerified(loggedInResponse);
      } catch (e) {
        print("signInWithCredential - ${e.runtimeType}: $e");
        String errorToReturn = "something_wrong";
        if (e is DioError) {
          //signout of social accounts.
          try {
            logout();
          } catch (le) {
            print(le);
          }
          if ((e).response != null) {
            Map<String, dynamic> errorResponse = (e).response.data;
            if (errorResponse.containsKey("message")) {
              String errorMessage = errorResponse["message"] as String;
              print("errorMessage: $errorMessage");
              if (errorMessage.toLowerCase().contains("role")) {
                errorToReturn = "role_exists";
              }
            }
          }
        }
        verificationCallback.onCodeVerificationError(errorToReturn);
      }
    } catch (e) {
      print("signInWithCredential - ${e.runtimeType}: $e");
      verificationCallback.onCodeVerificationError("unable_otp_verification");
    }
  }
}
