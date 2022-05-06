import 'package:dspatch_user/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_request_check_existence.g.dart';

@JsonSerializable()
class AuthRequestCheckExistence {
  String mobile_number;
  String role;

  AuthRequestCheckExistence(String mobile_number) {
    this.mobile_number = mobile_number;
    this.role = Constants.ROLE_USER;
  }

  /// A necessary factory constructor for creating a new AuthRequestCheckExistence instance
  /// from a map. Pass the map to the generated `_$AuthRequestCheckExistenceFromJson()` constructor.
  /// The constructor is named after the source class, in this case, AuthRequestCheckExistence.
  factory AuthRequestCheckExistence.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestCheckExistenceFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AuthRequestCheckExistenceToJson`.
  Map<String, dynamic> toJson() => _$AuthRequestCheckExistenceToJson(this);
}
