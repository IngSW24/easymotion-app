import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthInterceptor implements Interceptor {
  AuthInterceptor(this.ctx);

  BuildContext ctx;

  @override
  FutureOr<Response<T>> intercept<T>(Chain<T> chain) async {
    final ApiProvider apiProvider = Provider.of(ctx);
    Request request = chain.request;

    final token = await apiProvider.getAccessToken();

    if (token != null) {
      request = request.copyWith(headers: {
        ...request.headers,
        'Authorization': 'Bearer $token',
      });
    }

    return chain.proceed(request); // Continua con la richiesta modificata
  }
}
