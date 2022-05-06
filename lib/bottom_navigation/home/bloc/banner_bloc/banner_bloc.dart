import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/models/banner/banner_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'banner_event.dart';
import 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  HomeRepository _repository = HomeRepository();

  BannerBloc() : super(LoadingBannerState());

  @override
  Stream<BannerState> mapEventToState(BannerEvent event) async* {
    yield* _mapFetchBannerToState();
  }

  Stream<BannerState> _mapFetchBannerToState() async* {
    yield LoadingBannerState();
    try {
      BannerList listBanner = await _repository.getBannerList();
      yield SuccessBannerState(listBanner);
    } catch (e) {
      yield FailureBannerState(e);
    }
  }
}
