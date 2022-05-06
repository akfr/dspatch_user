import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateUserMeState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingUpdateUserMeState extends UpdateUserMeState {}

class SuccessUpdateUserMeState extends UpdateUserMeState {
  final UserInformation userInformation;

  SuccessUpdateUserMeState(this.userInformation);

  @override
  List<Object> get props => [userInformation];
}

class FailureUpdateUserMeState extends UpdateUserMeState {
  final e;

  FailureUpdateUserMeState(this.e);

  @override
  List<Object> get props => [e];
}
