part of 'login_cubit.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginExistsLoaded extends LoginState {
  final bool isRegistered;
  final PhoneNumber phoneNumber;

  const LoginExistsLoaded(this.isRegistered, this.phoneNumber);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginExistsLoaded &&
          runtimeType == other.runtimeType &&
          isRegistered == other.isRegistered &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => isRegistered.hashCode ^ phoneNumber.hashCode;
}

class LoginLoaded extends LoginState {
  final LoginResponse authResponse;

  const LoginLoaded(this.authResponse);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginLoaded &&
          runtimeType == other.runtimeType &&
          authResponse == other.authResponse;

  @override
  int get hashCode => authResponse.hashCode;
}

class LoginError extends LoginState {
  final String message, messageKey;

  const LoginError(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}

class LoginErrorSocial extends LoginError {
  String loginName, loginEmail, loginImageUrl;

  LoginErrorSocial(String loginName, String loginEmail, String loginImageUrl,
      String message, String messageKey)
      : super(message, messageKey) {
    this.loginName = loginName;
    this.loginEmail = loginEmail;
    this.loginImageUrl = loginImageUrl;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is LoginErrorSocial &&
          runtimeType == other.runtimeType &&
          loginName == other.loginName &&
          loginEmail == other.loginEmail &&
          loginImageUrl == other.loginImageUrl;

  @override
  int get hashCode =>
      super.hashCode ^
      loginName.hashCode ^
      loginEmail.hashCode ^
      loginImageUrl.hashCode;
}
