import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingState extends AccountState {}

class SuccessState extends AccountState {
  final UserInformation userInformation;

  SuccessState(this.userInformation);

  @override
  List<Object> get props => [userInformation];
}

class FailureState extends AccountState {
  final Error e;
  FailureState(this.e);

  @override
  List<Object> get props => [e];
}
