import 'package:dspatch_user/models/address/getaddress_json.dart';
import 'package:equatable/equatable.dart';

class AddressState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingAddressState extends AddressState {}

class SuccessAddressState extends AddressState {
  final List<GetAddress> addresses;

  SuccessAddressState(this.addresses);
  @override
  List<Object> get props => [addresses];
}

class FailureAddressState extends AddressState {
  final e;

  FailureAddressState(this.e);
  @override
  List<Object> get props => [e];
}
