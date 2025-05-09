import 'package:chopper/chopper.dart';
import 'package:easymotion_app/data/common/constants.dart';
import 'package:flutter/material.dart';
import '../../api-client-generated/api_schema.swagger.dart';
import '../interceptors/auth_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String accessTokenKey = "access_token";
const String refreshTokenKey = "refresh_token";

class ApiProvider extends ChangeNotifier {
  ApiProvider(this.ctx) {
    schema = ApiSchema.create(client: _getChopperClient());

    _initialRefresh();
  }

  final BuildContext ctx;

  late final ApiSchema schema;

  static final baseUrl = Uri.parse(apiURL!);

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

  Future<String?> getAccessToken() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(accessTokenKey);
  }

  Future<bool> setAccessToken(String? accessToken) async {
    final storage = await SharedPreferences.getInstance();
    if (accessToken == null) {
      return await storage.remove(accessTokenKey);
    }
    return await storage.setString(accessTokenKey, accessToken);
  }

  Future<String?> getRefreshToken() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(refreshTokenKey);
  }

  Future<bool> setRefreshToken(String? refreshToken) async {
    final storage = await SharedPreferences.getInstance();
    if (refreshToken == null) {
      return await storage.remove(refreshTokenKey);
    }
    return await storage.setString(refreshTokenKey, refreshToken);
  }

  // refresh access token
  Future<void> _initialRefresh() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      setAccessToken(null);
      return;
    }

    final response = await schema.authRefreshPost(
        body: RefreshTokenDto(refreshToken: refreshToken));
    final newAccessToken = response.body?.tokens?.accessToken;
    final newRefreshToken = response.body?.tokens?.refreshToken;
    if (newAccessToken != null && newRefreshToken != null) {
      setAccessToken(newAccessToken);
      setRefreshToken(newRefreshToken);
      _setUser(response.body?.user);
    } else {
      setAccessToken(null);
      setRefreshToken(null);
      _setUser(null); // force re-login
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
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await schema.authLogoutPost();
      setRefreshToken(null);
      setAccessToken(null);
      _setUser(null);
      return true;
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }
}
