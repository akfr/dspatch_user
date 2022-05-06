import 'dart:math';

import 'package:dspatch_user/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_request_register.g.dart';

@JsonSerializable()
class AuthRequestRegister {
  String name;
  String email;
  String password;
  String mobile_number;
  String image_url;
  String role;

  AuthRequestRegister(String name, String email, String password,
      String mobile_number, String image_url) {
    this.name = name;
    this.email = email;
    this.password = (password != null && password.isNotEmpty)
        ? password
        : (Random().nextInt(9000) + 1000).toString();
    this.mobile_number = mobile_number;
    this.image_url = image_url;
    this.role = Constants.ROLE_USER;
  }

  /// A necessary factory constructor for creating a new AuthRequestRegister instance
  /// from a map. Pass the map to the generated `_$AuthRequestRegisterFromJson()` constructor.
  /// The constructor is named after the source class, in this case, AuthRequestRegister.
  factory AuthRequestRegister.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestRegisterFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AuthRequestRegisterToJson`.
  Map<String, dynamic> toJson() => _$AuthRequestRegisterToJson(this);
}
