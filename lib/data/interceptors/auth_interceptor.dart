import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:flutter/foundation.dart';
import '../../api-client-generated/api_schema.swagger.dart';

class AuthInterceptor implements Interceptor {
  AuthInterceptor(this.apiProvider);

  final ApiProvider apiProvider;

  @override
  FutureOr<Response<T>> intercept<T>(Chain<T> chain) async {

    Request request = chain.request;

    final accessToken = apiProvider.getAccessToken();
    if (accessToken != null) {
      request = request.copyWith(headers: {
        ...request.headers,
        'Authorization': 'Bearer $accessToken',
      });
    }

    final response = await chain.proceed(request); // Try with the access token

    debugPrint("Auth interception: " + request.uri.toString());
    if (response.statusCode != 401) {
      return response;
    }


    final refreshToken = await apiProvider.getRefreshToken();
    if (refreshToken == null) {
      return response;
    }

    final newSchema = ApiSchema.create(baseUrl: ApiProvider.baseUrl);

    final refreshTokenResponse = await newSchema.authRefreshPost(
        body: RefreshTokenDto(refreshToken: refreshToken));

    final tokens = refreshTokenResponse.body?.tokens;
    if (tokens != null) {
      apiProvider.setAccessToken(tokens.accessToken);
      apiProvider.setRefreshToken(tokens.refreshToken);

      request = request.copyWith(headers: {
        ...request.headers,
        'Authorization': 'Bearer ${tokens.accessToken}',
      });
      return chain.proceed(request);
    }

    return response; // invalid refresh token, it will throw an Exception
  }
}
