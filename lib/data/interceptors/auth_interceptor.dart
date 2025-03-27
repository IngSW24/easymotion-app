import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';

class AuthInterceptor implements Interceptor {
  AuthInterceptor(this.apiProvider);

  final ApiProvider apiProvider;

  @override
  FutureOr<Response<T>> intercept<T>(Chain<T> chain) async {
    Request request = chain.request;

    final accessToken = await apiProvider.getAccessToken();
    final refreshToken = await apiProvider.getAccessToken();

    if (accessToken != null) {
      request = request.copyWith(headers: {
        ...request.headers,
        'Authorization': 'Bearer $accessToken',
      });
    }

    final response = await chain.proceed(request); // Try with old access token
    if (response.statusCode != 401) {
      return response;
    }

    final refreshTokenResponse = await apiProvider.schema.authRefreshPost(body: RefreshTokenDto(refreshToken: refreshToken));
    final newAccessToken = refreshTokenResponse.body?.accessToken;
    if (newAccessToken != null) {
      apiProvider.setAccessToken(newAccessToken);
      request = request.copyWith(headers: {
        ...request.headers,
        'Authorization': 'Bearer $newAccessToken',
      });
      return chain.proceed(request);
    }

    return response; // will throw an Exception
  }
}
