import 'package:dspatch_user/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_request_login.g.dart';

@JsonSerializable()
class AuthRequestLogin {
  String token;
  String role;

  AuthRequestLogin(String token) {
    this.token = token;
    this.role = Constants.ROLE_USER;
  }

  /// A necessary factory constructor for creating a new AuthRequestLogin instance
  /// from a map. Pass the map to the generated `_$AuthRequestLoginFromJson()` constructor.
  /// The constructor is named after the source class, in this case, AuthRequestLogin.
  factory AuthRequestLogin.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestLoginFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AuthRequestLoginToJson`.
  Map<String, dynamic> toJson() => _$AuthRequestLoginToJson(this);
}
