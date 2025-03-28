import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/common/constants.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';

import '../../api-client-generated/api_schema.swagger.dart';

class AuthInterceptor implements Interceptor {
  AuthInterceptor(this.apiProvider);

  final ApiProvider apiProvider;

  @override
  FutureOr<Response<T>> intercept<T>(Chain<T> chain) async {
    print("Intercept1");
    Request request = chain.request;

    final accessToken = await apiProvider.getAccessToken();
    final refreshToken = await apiProvider.getRefreshToken();

    if (accessToken != null) {
      request = request.copyWith(headers: {
        ...request.headers,
        'Authorization': 'Bearer $accessToken',
      });
    }

    final response = await chain.proceed(request); // Try with old access token
    print("Intercept2: $accessToken + $refreshToken");
    if (refreshToken == null || response.statusCode != 401) {
      return response;
    }

    return response;

    /*final newSchema = ApiSchema.create(baseUrl: Uri.parse(API_URL));

    print("Intercept3");
    final refreshTokenResponse = await newSchema.authRefreshPost(
        body: RefreshTokenDto(refreshToken: refreshToken));

    print("Intercept4");
    final newAccessToken = refreshTokenResponse.body?.tokens?.accessToken;
    final newRefreshToken = refreshTokenResponse.body?.tokens?.refreshToken;
    if (newAccessToken != null && newRefreshToken != null) {
      apiProvider.setAccessToken(newAccessToken);
      apiProvider.setRefreshToken(newRefreshToken);

      request = request.copyWith(headers: {
        ...request.headers,
        'Authorization': 'Bearer $newAccessToken',
      });
      return chain.proceed(request);
    }

    return response; // will throw an Exception*/
  }
}
