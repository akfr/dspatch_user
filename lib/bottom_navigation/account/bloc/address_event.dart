import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchAddressesEvent extends AddressEvent {}
