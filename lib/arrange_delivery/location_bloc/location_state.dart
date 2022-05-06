import 'package:equatable/equatable.dart';

class LocationState extends Equatable {
  final String pickupAddress;
  LocationState(this.pickupAddress);
  @override
  List<Object> get props => [pickupAddress];
  @override
  bool get stringify => true;
}