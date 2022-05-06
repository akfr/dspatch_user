import 'package:dspatch_user/models/banner/banner_list.dart';
import 'package:equatable/equatable.dart';

abstract class BannerState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingBannerState extends BannerState {}

class SuccessBannerState extends BannerState {
  final BannerList listOfBanners;
  SuccessBannerState(this.listOfBanners);

  @override
  List<Object> get props => [listOfBanners];
}

class FailureBannerState extends BannerState {
  final e;
  FailureBannerState(this.e);

  @override
  List<Object> get props => [e];
}
