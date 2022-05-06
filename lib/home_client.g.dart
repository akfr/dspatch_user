// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _HomeClient implements HomeClient {
  _HomeClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://admin.dspatch.app/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<WalletPaymentResponse> payThroughStripe(id, stripeToken,
      [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(stripeToken, 'stripeToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'token': stripeToken};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<Map<String, dynamic>>('api/payment/stripe/$id',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{r'Authorization': token},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{r'Authorization': token},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = WalletPaymentResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<Payment> depositWallet(map, [token]) async {
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final _result =
        await _dio.request<Map<String, dynamic>>('api//user/wallet/deposit',
            queryParameters: queryParameters,
            options: Options(
              method: 'POST',
              headers: <String, dynamic>{r'Authorization': token},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'POST',
            //     headers: <String, dynamic>{r'Authorization': token},
            //     extra: _extra,
            //     baseUrl: baseUrl
            // ),
            data: _data);
    final value = Payment.fromJson(_result.data);
    return value;
  }

  @override
  Future<WalletPaymentResponse> payThroughWallet(id, [token]) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<Map<String, dynamic>>('api/payment/wallet/$id',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{r'Authorization': token},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{r'Authorization': token},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = WalletPaymentResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('api/payment/methods',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{r'Authorization': token},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'GET',
        //     headers: <String, dynamic>{r'Authorization': token},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => PaymentMethod.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<OrderData> createCustomOrder(customDelivery, [token]) async {
    ArgumentError.checkNotNull(customDelivery, 'customDelivery');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(customDelivery?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('api/orders',
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{r'Authorization': token},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'POST',
        //     headers: <String, dynamic>{r'Authorization': token},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    final value = OrderData.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<GetAddress>> getAddresses([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('api/addresses',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{r'Authorization': token},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'GET',
        //     headers: <String, dynamic>{r'Authorization': token},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => GetAddress.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<void> postAddress(address, [token]) async {
    ArgumentError.checkNotNull(address, 'address');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(address?.toJson() ?? <String, dynamic>{});
    await _dio.request<void>('api/addresses',
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{r'Authorization': token},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'POST',
        //     headers: <String, dynamic>{r'Authorization': token},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    return null;
  }

  @override
  Future<BaseListResponse<OrderData>> getOrdersAll(page, [token]) async {
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('api/orders',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{r'Authorization': token},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'GET',
        //     headers: <String, dynamic>{r'Authorization': token},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    final value = BaseListResponse<OrderData>.fromJson(
      _result.data,
      (json) => OrderData.fromJson(json),
    );
    return value;
  }

  @override
  Future<ListOrder> getActiveOrderList([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<Map<String, dynamic>>('api/orders?active=1',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{r'Authorization': token},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{r'Authorization': token},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = ListOrder.fromJson(_result.data);
    return value;
  }

  @override
  Future<ListOrder> getPastOrderList([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<Map<String, dynamic>>('api/orders?past=1',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{r'Authorization': token},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{r'Authorization': token},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = ListOrder.fromJson(_result.data);
    return value;
  }

  @override
  Future<ListDeliveryMode> getDeliveryModes([token]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<Map<String, dynamic>>('api/delivery-modes',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{r'Authorization': token},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{r'Authorization': token},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    final value = ListDeliveryMode.fromJson(_result.data);
    return value;
  }

  @override
  Future<ListVendors> getVendors(lat, long, [category]) async {
    ArgumentError.checkNotNull(lat, 'lat');
    ArgumentError.checkNotNull(long, 'long');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'lat': lat,
      r'long': long,
      r'category': category
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('api/vendors/list',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'GET',
        //     headers: <String, dynamic>{},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    final value = ListVendors.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserInformation> updateUserMe(updateUserRequest, [token]) async {
    ArgumentError.checkNotNull(updateUserRequest, 'updateUserRequest');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(updateUserRequest ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('api/user',
        queryParameters: queryParameters,
        options: Options(
          method: 'PUT',
          headers: <String, dynamic>{r'Authorization': token},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'PUT',
        //     headers: <String, dynamic>{r'Authorization': token},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    final value = UserInformation.fromJson(_result.data);
    return value;
  }

  @override
  Future<WalletBalance> getBalance([token, cancelToken]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<Map<String, dynamic>>('api/user/wallet/balance',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{r'Authorization': token},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{r'Authorization': token},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data,
            cancelToken: cancelToken);
    final value = WalletBalance.fromJson(_result.data);
    return value;
  }

  @override
  Future<BaseListResponse<WalletTransaction>> walletTransactions(page,
      [token, cancelToken]) async {
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<Map<String, dynamic>>('api/user/wallet/transactions',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{r'Authorization': token},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{r'Authorization': token},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data,
            cancelToken: cancelToken);
    final value = BaseListResponse<WalletTransaction>.fromJson(
      _result.data,
      (json) => WalletTransaction.fromJson(json),
    );
    return value;
  }

  @override
  Future<BannerList> getBannerList(scope, [token]) async {
    ArgumentError.checkNotNull(scope, 'scope');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'scope': scope};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('api/banners',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{r'Authorization': token},
          extra: _extra,
        ),
        // options: RequestOptions(
        //     method: 'GET',
        //     headers: <String, dynamic>{r'Authorization': token},
        //     extra: _extra,
        //     baseUrl: baseUrl),
        data: _data);
    final value = BannerList.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<Category>> getCategories([scope]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'scope': scope};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.request<List<dynamic>>('api/categories?pagination=0',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
            ),
            // options: RequestOptions(
            //     method: 'GET',
            //     headers: <String, dynamic>{},
            //     extra: _extra,
            //     baseUrl: baseUrl),
            data: _data);
    var value = _result.data
        .map((dynamic i) => Category.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
