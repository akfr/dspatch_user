import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:dspatch_user/models/banner/banner_list.dart';
import 'package:dspatch_user/models/base_list_response.dart';
import 'package:dspatch_user/models/category.dart';
import 'package:dspatch_user/models/order/get/order_data.dart';
import 'package:dspatch_user/models/vendors/list_vendors.dart';
import 'package:dspatch_user/models/wallet_balance.dart';
import 'package:dspatch_user/models/wallet_transaction.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'config/app_config.dart';
import 'models/address/getaddress_json.dart';
import 'models/address/postaddress_json.dart';
import 'models/custom_delivery/custom_delivery.dart';
import 'models/custom_delivery/list_delivery_mode.dart';
import 'models/order/get/list_order.dart';
import 'models/order/get/payment.dart';
import 'models/payment_method/payment_method.dart';
import 'models/payment_method/wallet_payment_response.dart';

part 'home_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class HomeClient {
  factory HomeClient(Dio dio, {String baseUrl}) = _HomeClient;

  @GET('api/payment/stripe/{id}')
  Future<WalletPaymentResponse> payThroughStripe(
      @Path('id') int id, @Query('token') String stripeToken,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @POST('api//user/wallet/deposit')
  Future<Payment> depositWallet(@Body() Map<String, String> map,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/payment/wallet/{id}')
  Future<WalletPaymentResponse> payThroughWallet(@Path('id') int id,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/payment/methods')
  Future<List<PaymentMethod>> getPaymentMethods(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @POST('api/orders')
  Future<OrderData> createCustomOrder(@Body() CustomDelivery customDelivery,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/addresses')
  Future<List<GetAddress>> getAddresses(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @POST('api/addresses')
  Future<void> postAddress(@Body() PostAddress address,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/orders')
  Future<BaseListResponse<OrderData>> getOrdersAll(@Query('page') int page,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/orders?active=1')
  Future<ListOrder> getActiveOrderList(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/orders?past=1')
  Future<ListOrder> getPastOrderList(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/delivery-modes')
  Future<ListDeliveryMode> getDeliveryModes(
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/vendors/list')
  Future<ListVendors> getVendors(
      @Query('lat') double lat, @Query('long') double long,
      [@Query('category') String category]);

  @PUT('api/user')
  Future<UserInformation> updateUserMe(
      @Body() Map<String, String> updateUserRequest,
      [@Header(HeaderKeys.authHeaderKey) String token]);

  @GET('api/user/wallet/balance')
  Future<WalletBalance> getBalance(
      [@Header(HeaderKeys.authHeaderKey) String token,
      @CancelRequest() CancelToken cancelToken]);

  @GET('api/user/wallet/transactions')
  Future<BaseListResponse<WalletTransaction>> walletTransactions(
      @Query('page') int page,
      [@Header(HeaderKeys.authHeaderKey) String token,
      @CancelRequest() CancelToken cancelToken]);

  @GET('api/banners')
  Future<BannerList> getBannerList(
    @Query('scope') String scope, [
    @Header(HeaderKeys.authHeaderKey) String token,
  ]);

  @GET('api/categories?pagination=0')
  Future<List<Category>> getCategories([@Query('scope') String scope]);
}
