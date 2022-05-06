import 'package:bloc/bloc.dart';
import 'package:dspatch_user/authentication/auth_repo/auth_repository.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/account_bloc/account_event.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/account_bloc/account_state.dart';
import 'package:dspatch_user/models/auth/responses/user_info.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AuthRepo _authRepo = AuthRepo();
  AccountBloc() : super(LoadingState());

  // @override
  // AccountState get initialState => LoadingState();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is FetchEvent) {
      yield* _mapFetchDataToState();
    }
  }

  Stream<AccountState> _mapFetchDataToState() async* {
    yield LoadingState();
    try {
      UserInformation userInfo = await _authRepo.getUser();
      yield SuccessState(userInfo);
    } catch (e) {
      yield FailureState(e);
    }
  }
}
