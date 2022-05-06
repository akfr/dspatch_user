import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/models/custom_delivery/delivery_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'delivery_mode_event.dart';
import 'delivery_mode_state.dart';

class DeliveryModeBloc extends Bloc<DeliveryModeEvent, DeliveryModeState> {
  HomeRepository _repository = HomeRepository();

  DeliveryModeBloc() : super(LoadingDeliveryModeState());

  @override
  Stream<DeliveryModeState> mapEventToState(DeliveryModeEvent event) async* {
    if (event is FetchDeliveryModeEvent) {
      yield* _mapFetchStoreToState();
    }
  }

  Stream<DeliveryModeState> _mapFetchStoreToState() async* {
    yield LoadingDeliveryModeState();
    try {
      List<DeliveryMode> listDeliveryModes =
          await _repository.listDeliveryModes();
      yield SuccessDeliveryModeState(listDeliveryModes);
    } catch (e) {
      print(e);
      yield FailureDeliveryModeState(e);
    }
  }
}
