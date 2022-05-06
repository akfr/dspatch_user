import 'package:equatable/equatable.dart';

class UpdateProfileEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class PutUpdateProfileEvent extends UpdateProfileEvent {
  final String name, image;

  PutUpdateProfileEvent(this.name, this.image);

  @override
  List<Object> get props => [name, image];
}
