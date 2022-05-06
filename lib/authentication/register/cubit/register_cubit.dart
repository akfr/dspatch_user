import 'package:dspatch_user/authentication/auth_repo/auth_repository.dart';
import 'package:dspatch_user/models/auth/auth_request_register.dart';
import 'package:dspatch_user/models/auth/responses/login_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  AuthRepo _userRepository = AuthRepo();

  RegisterCubit() : super(RegisterInitial());

  void initRegistration(String dialCode, String phoneNumber, String name,
      String email, String pass, String imageUrl) async {
    emit(RegisterLoading());
    try {
      String normalizedNumber = dialCode + phoneNumber;
      var signupResponse =
          await _userRepository.signupPhoneEmail(normalizedNumber, pass);
      if (signupResponse == null) {
        emit(RegisterError("Something went wrong", "something_wrong"));
      }
      final registeredState = await _userRepository.registerUser(
          AuthRequestRegister(name, email, pass, normalizedNumber, imageUrl));
      emit(RegisterLoaded(registeredState));
      // bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
      //     phoneNumber: phoneNumber, isoCode: isoCode);
      // if (isValid) {
      //   String normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
      //       phoneNumber: phoneNumber, isoCode: isoCode);

      //   final registeredState = await _userRepository.registerUser(
      //       AuthRequestRegister(name, email, pass, normalizedNumber, imageUrl));
      //   emit(RegisterLoaded(registeredState));
      // } else {
      //   emit(RegisterError("Invalid phone number", "invalid_phone"));
      // }
    } catch (e) {
      RegisterError errorState =
          RegisterError("Something went wrong", "something_wrong");
      try {
        Response<dynamic> response = (e as DioError).response;
        if (response.statusCode == 422 && response.data != null) {
          Map<String, dynamic> errorResponse = response.data;
          if (errorResponse.containsKey("errors")) {
            if ((errorResponse['errors'] as Map<String, dynamic>)
                .containsKey("email")) {
              errorState = RegisterError(
                  (errorResponse['errors']['email'] as List<dynamic>).isNotEmpty
                      ? (errorResponse['errors']['email'] as List<dynamic>)[0]
                      : "Something went wrong",
                  "err_email");
            } else if ((errorResponse['errors'] as Map<String, dynamic>)
                .containsKey("mobile_number")) {
              errorState = RegisterError(
                  (errorResponse['errors']['mobile_number'] as List<dynamic>)
                          .isNotEmpty
                      ? (errorResponse['errors']['mobile_number']
                          as List<dynamic>)[0]
                      : "Something went wrong",
                  "err_phone");
            }
          }
        }
      } catch (e) {
        print(e);
      }
      emit(errorState);
    }
  }
}
