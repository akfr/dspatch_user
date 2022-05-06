import 'package:dspatch_user/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_request_login_social.g.dart';

@JsonSerializable()
class AuthRequestLoginSocial {
  String platform;
  String token;
  String os;
  String role;

  AuthRequestLoginSocial(String platform, String token, String os) {
    this.platform = platform;
    this.token = token;
    this.os = os;
    this.role = Constants.ROLE_USER;
  }

  /// A necessary factory constructor for creating a new AuthRequestLoginSocial instance
  /// from a map. Pass the map to the generated `_$AuthRequestLoginSocialFromJson()` constructor.
  /// The constructor is named after the source class, in this case, AuthRequestLoginSocial.
  factory AuthRequestLoginSocial.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestLoginSocialFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AuthRequestLoginSocialToJson`.
  Map<String, dynamic> toJson() => _$AuthRequestLoginSocialToJson(this);
}
