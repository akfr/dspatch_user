import 'package:dspatch_user/models/vendors/vendordata.dart';
import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchStoreEvent extends StoreEvent {
  final String catagorySlug;
  FetchStoreEvent(this.catagorySlug);
  @override
  List<Object> get props => [catagorySlug];
}

class StoresFilterEvent extends StoreEvent {
  final List<Vendor> vendors;
  final String filterText;
  StoresFilterEvent(this.vendors, this.filterText);
  @override
  List<Object> get props => [vendors, filterText];
}
