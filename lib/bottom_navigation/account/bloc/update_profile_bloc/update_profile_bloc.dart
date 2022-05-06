import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'update_profile_event.dart';
import 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateUserMeState> {
  UpdateProfileBloc() : super(LoadingUpdateUserMeState());

  HomeRepository repo = HomeRepository();

  @override
  Stream<UpdateUserMeState> mapEventToState(UpdateProfileEvent event) async* {
    if (event is PutUpdateProfileEvent) {
      yield* _mapPutUpdateProfileEventToState(event.name, event.image);
    }
  }

  Stream<UpdateUserMeState> _mapPutUpdateProfileEventToState(
      String userName, String userImage) async* {
    yield LoadingUpdateUserMeState();
    try {
      UserInformation myProfileResponse =
          await repo.updateUserMe(userName, userImage);
      yield SuccessUpdateUserMeState(myProfileResponse);
    } catch (e) {
      yield FailureUpdateUserMeState(e);
    }
  }
}
