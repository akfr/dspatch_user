import 'package:dspatch_user/models/vendors/vendordata.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class StoreState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class InitialState extends StoreState {}

class LoadingState extends StoreState {}

// ignore: must_be_immutable
class SuccessStoreState extends StoreState {
  final List<Vendor> vendors, showOnly;
  final String filterText;
  Vendor vendorActive;

  SuccessStoreState(this.vendors, this.showOnly, this.filterText);
  @override
  List<Object> get props => [vendors, showOnly, filterText, vendorActive];
}

class FailureState extends StoreState {
  final e;
  FailureState(this.e);

  @override
  List<Object> get props => [e];
}
