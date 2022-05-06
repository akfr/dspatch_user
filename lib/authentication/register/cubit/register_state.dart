part of 'register_cubit.dart';

abstract class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterLoaded extends RegisterState {
  final LoginResponse authResponse;

  const RegisterLoaded(this.authResponse);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterLoaded &&
          runtimeType == other.runtimeType &&
          authResponse == other.authResponse;

  @override
  int get hashCode => authResponse.hashCode;
}

class RegisterError extends RegisterState {
  final String message, messageKey;

  const RegisterError(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}
