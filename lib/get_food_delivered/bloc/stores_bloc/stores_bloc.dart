import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_event.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_state.dart';
import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/models/vendors/list_vendors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  HomeRepository _repository = HomeRepository();
  MapRepository _mapRepository = MapRepository();

  StoreBloc() : super(null);

  StoreState get initialState => InitialState();

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is FetchStoreEvent) {
      yield* _mapFetchStoreToState(event.catagorySlug);
    } else if (event is StoresFilterEvent) {
      yield SuccessStoreState((state as SuccessStoreState).vendors,
          event.vendors, event.filterText);
    }
  }

  Stream<StoreState> _mapFetchStoreToState(String catagorySlug) async* {
    try {
      yield LoadingState();
      Position position = await _mapRepository.getCurrentLocation();
      ListVendors listVendors =
          await _repository.listOfVendors(position, catagorySlug);
      yield SuccessStoreState(listVendors.listOfData, [], "");
    } catch (e) {
      yield FailureState(e);
    }
  }

  // Marker _getMarker(LatLng latLng, String id, BitmapDescriptor descriptor, bool isTapped) {
  //   MarkerId markerId = MarkerId(id);
  //   Marker marker =
  //       Marker(markerId: markerId, icon: descriptor, position: latLng, onTap: (){
  //         for(int i=0;i<succeesState.listOfVendorData.length;i++){
  //           if(latLng==LatLng(succeesState.listOfVendorData[i].latitude, succeesState.listOfVendorData[i].longitude)){
  //             succeesState.vendorActive = succeesState.listOfVendorData[i];
  //             yield SuccessStoreState.from(succeesState);
  //             break;
  //           }
  //         }
  //       });
  //   return marker;
  // }
}
