import 'package:chopper/chopper.dart';
import 'package:easymotion_app/data/common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../api-client-generated/api_schema.swagger.dart';
import '../interceptors/auth_interceptor.dart';

const String ACCESS_TOKEN_KEY = "access_token";
const String REFRESH_TOKEN_KEY = "refresh_token";

class ApiProvider extends ChangeNotifier {
  ApiProvider(this.ctx) {
    schema = ApiSchema.create(client: _getChopperClient());

    _initialRefresh();
  }

  final BuildContext ctx;

  late final ApiSchema schema;

  static final baseUrl = Uri.parse(API_URL);
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  AuthUserDto? _user;

  AuthUserDto? getUser() {
    return _user;
  }

  void _setUser(AuthUserDto? user) {
    _user = user;
    notifyListeners();
  }

  ChopperClient _getChopperClient() {
    return ChopperClient(
      baseUrl: baseUrl,
      converter:
          $JsonSerializableConverter(), // TODO: estratto dal codice auto generato, no documentazione
      interceptors: [AuthInterceptor(this)],
    );
  }

  Future<String?> getAccessToken() {
    return secureStorage.read(key: ACCESS_TOKEN_KEY);
  }

  Future<void> setAccessToken(String? accessToken) {
    return secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
  }

  Future<String?> getRefreshToken() {
    return secureStorage.read(key: REFRESH_TOKEN_KEY);
  }

  Future<void> setRefreshToken(String? refreshToken) {
    return secureStorage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
  }

  // refresh access token
  Future<void> _initialRefresh() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken != null) {
      final response = await schema.authRefreshPost(
          body: RefreshTokenDto(refreshToken: refreshToken));
      final newAccessToken = response.body?.tokens?.accessToken;
      final newRefreshToken = response.body?.tokens?.refreshToken;
      if (newAccessToken != null && newRefreshToken != null) {
        setAccessToken(newAccessToken);
        setRefreshToken(newRefreshToken);
      } else {
        setAccessToken(null);
        setRefreshToken(null);
        _setUser(null); // force re-login
      }
    }
  }

  Future<bool> login(SignInDto data) async {
    try {
      final response = await schema.authLoginPost(body: data);
      final responseBody = response.body;
      if (responseBody != null) {
        setRefreshToken(responseBody.tokens?.refreshToken);
        setAccessToken(responseBody.tokens?.accessToken);
        _setUser(responseBody.user);
        return true;
      }
      return false;
    } on Exception catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await schema.authLogoutPost();
      return true;
    } on Exception catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return false;
    }
  }
}
