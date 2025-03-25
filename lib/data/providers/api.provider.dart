import 'package:chopper/chopper.dart';
import 'package:easymotion_app/data/common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../api-client-generated/schema.swagger.dart';
import '../interceptors/auth_interceptor.dart';

const String ACCESS_TOKEN_KEY = "access_token";

class ApiProvider {
  ApiProvider(this.ctx) {
    schema = Schema.create(baseUrl: baseUrl, client: _getChopperClient());
  }

  final BuildContext ctx;
  static final baseUrl = Uri.parse(API_URL);
  late final Schema schema;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  ChopperClient _getChopperClient() {
    return ChopperClient(
      // Il tuo servizio API
      interceptors: [AuthInterceptor(ctx)], // Aggiungi l'interceptor
    );
  }

  Future<String?> getAccessToken() {
    return secureStorage.read(key: ACCESS_TOKEN_KEY);
  }

  Future<void> setAccessToken(String accessToken) {
    return secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
  }
}
