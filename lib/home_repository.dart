import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:dspatch_user/models/banner/banner_list.dart';
import 'package:dspatch_user/models/base_list_response.dart';
import 'package:dspatch_user/models/category.dart';
import 'package:dspatch_user/models/order/get/order_data.dart';
import 'package:dspatch_user/models/vendors/list_vendors.dart';
import 'package:dspatch_user/models/wallet_balance.dart';
import 'package:dspatch_user/models/wallet_transaction.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'authentication/auth_interceptor.dart';
import 'home_client.dart';
import 'models/address/getaddress_json.dart';
import 'models/address/postaddress_json.dart';
import 'models/custom_delivery/custom_delivery.dart';
import 'models/custom_delivery/delivery_mode.dart';
import 'models/order/get/list_order.dart';
import 'models/order/get/payment.dart';
import 'models/payment_method/payment_method.dart';
import 'models/payment_method/wallet_payment_response.dart';

class HomeRepository {
  final Dio dio;
  final HomeClient client;

  HomeRepository._(this.dio, this.client);

  DatabaseReference _firebaseDbRef = FirebaseDatabase.instance.reference();

  factory HomeRepository() {
    Dio dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    dio.interceptors.add(AuthInterceptor());
    HomeClient client = HomeClient(dio);
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json'
    };
    return HomeRepository._(dio, client);
  }

  Future<void> postUrl(String url) {
    return dio.post(url, data: {});
  }

  Future<void> getUrl(String url) {
    return dio.get(url);
  }

  Future<WalletPaymentResponse> payThroughWallet(int id) async {
    return client.payThroughWallet(id);
  }

  Future<WalletPaymentResponse> payThroughStripe(
      int paymentId, String stripeToken) async {
    return client.payThroughStripe(paymentId, stripeToken);
  }

  Future<Payment> depositWallet(String amount, String paymentMethodSlug) {
    return client.depositWallet(
        {"amount": amount, "payment_method_slug": paymentMethodSlug});
  }

  Future<List<PaymentMethod>> getPaymentMethod() async {
    return client.getPaymentMethods();
  }

  Future<WalletBalance> getBalance([CancelToken cancelToken]) {
    return client.getBalance("", cancelToken);
  }

  Future<BaseListResponse<WalletTransaction>> walletTransactions(
      int pageNo, CancelToken cancelToken) {
    return client.walletTransactions(pageNo, "", cancelToken);
  }

  Future<OrderData> createCustomOrder(CustomDelivery customDelivery) async {
    return client.createCustomOrder(customDelivery);
  }

  Future<List<GetAddress>> getAddress() async {
    return client.getAddresses();
  }

  Future<void> postAddress(String title, String formattedAddress,
      double latitude, double longitude) async {
    PostAddress address = PostAddress(
      title,
      formattedAddress,
      longitude,
      latitude,
    );
    await client.postAddress(address);
  }

  Future<UserInformation> updateUserMe(
      String userName, String userImage) async {
    UserInformation userInformation =
        await client.updateUserMe({"name": userName, "image_url": userImage});
    return await Helper().setUserMe(userInformation);
  }

  Future<ListOrder> listActiveOrders() {
    return client.getActiveOrderList();
  }

  Stream<Event> getOrderDeliveryLocationFirebaseDbRef(int deliveryId) async* {
    print("getOrderDeliveryLocationFirebaseDbRef: $deliveryId");
    yield* _firebaseDbRef.child("deliveries/$deliveryId/location").onValue;
  }

  Stream<Event> getOrderFirebaseDbRef(int userId, int orderId) async* {
    print("getOrderFirebaseDbRef: $userId");
    yield* _firebaseDbRef.child("users/$userId/orders/$orderId").onValue;
  }

  Stream<Event> getOrdersFirebaseDbRef(int userId) async* {
    print("getOrdersFirebaseDbRef: $userId");
    yield* _firebaseDbRef.child('users/$userId/orders').onChildChanged;
  }

  Future<BaseListResponse<OrderData>> listOrdersAll(int page) {
    return client.getOrdersAll(page);
  }

  Future<ListOrder> listPastOrders() {
    return client.getPastOrderList();
  }

  Future<List<DeliveryMode>> listDeliveryModes() {
    return client.getDeliveryModes().then((value) => value.data);
  }

  Future<ListVendors> listOfVendors(Position position, [String category]) {
    return client.getVendors(position.latitude, position.longitude, category);
  }

  Future<BannerList> getBannerList() async {
    return client.getBannerList('ecommerce');
  }

  Future<List<Category>> fetchCategories([String scope]) {
    return client.getCategories(scope);
  }
}
