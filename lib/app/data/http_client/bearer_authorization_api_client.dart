import 'dart:async';

import 'package:get/get.dart';

import '../../core/utilities/app_utils.dart';

class BearerAuthorizationApiClient extends GetConnect implements GetxService {
  String token;
  BearerAuthorizationApiClient({required this.token}) {
    timeout = const Duration(seconds: 30);
  }

  Map<String, String> get _mainHeaders => {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  //GET
  Future<dynamic> getData(String url) async {
    AppUtils.log('GET: ${baseUrl ?? ''}$url');
    Response response = await get(url, headers: _mainHeaders);
    AppUtils.log('DATA RESPONSE: ${response.bodyString}');
    return _processResponse(response);
  }

  //POST
  Future<dynamic> postData(String url, dynamic payloadObj) async {
    AppUtils.log('POST: ${baseUrl ?? ''}$url');
    AppUtils.log('PAYLOAD: $payloadObj');
    AppUtils.log('Headers: $_mainHeaders');
    Response response = await post(url, payloadObj, headers: _mainHeaders);
    AppUtils.log('DATA RESPONSE: ${response.bodyString}');
    return _processResponse(response);
  }

  //PUT
  Future<dynamic> putData({required String url, dynamic payloadObj}) async {
    AppUtils.log('PUT: ${baseUrl ?? ''}$url');
    AppUtils.log('PAYLOAD: $payloadObj');
    Response response = await put(url, payloadObj, headers: _mainHeaders);
    AppUtils.log('DATA RESPONSE: ${response.bodyString}');
    return _processResponse(response);
  }

  //DELETE
  Future<dynamic> deleteData({required String url}) async {
    AppUtils.log('DELETE: ${baseUrl ?? ''}$url');
    Response response = await delete(url, headers: _mainHeaders);
    AppUtils.log('DATA RESPONSE: ${response.bodyString}');
    return _processResponse(response);
  }

  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 201:
        return response;
      case 202:
        return response;
      default:
        throw Exception('Unknown exception');
    }
  }
}
