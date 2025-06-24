import 'package:chopper/chopper.dart';
import 'package:easymotion_app/data/common/constants.dart';
import 'package:easymotion_app/data/common/login_response.dart';
import 'package:flutter/material.dart';
import '../../api-client-generated/api_schema.swagger.dart';
import '../interceptors/auth_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String refreshTokenKey = "refresh_token";

class ApiProvider extends ChangeNotifier {
  ApiProvider(this.ctx) {
    schema = ApiSchema.create(client: _getChopperClient());
    _initialSetup();
  }

  late final SharedPreferences storage;
  final BuildContext ctx;
  late final ApiSchema schema;
  static final baseUrl = Uri.parse(apiURL!);
  BaseAuthUserDto? _user;
  PatientDto? _patient;
  bool _isLoading = true;
  String? _accessToken;

  BaseAuthUserDto? getUser() {
    return _user;
  }

  PatientDto? getPatient() {
    return _patient;
  }

  bool isLoading() {
    return _isLoading;
  }

  void _setUser(BaseAuthUserDto? user) {
    _user = user;
    notifyListeners();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
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

  String? getAccessToken() {
    return _accessToken;
  }

  void setAccessToken(String? accessToken) {
    _accessToken = accessToken;
  }

  Future<String?> getRefreshToken() async {
    return storage.getString(refreshTokenKey);
  }

  Future<bool> setRefreshToken(String? refreshToken) async {
    if (refreshToken == null) {
      return await storage.remove(refreshTokenKey);
    }
    return await storage.setString(refreshTokenKey, refreshToken);
  }

  // refresh access token
  Future<void> _initialSetup() async {
    storage = await SharedPreferences.getInstance();
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      setAccessToken(null);
      _setUser(null); // force re-login
      _setLoading(false);
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
      _setLoading(false);
    } else {
      setAccessToken(null);
      setRefreshToken(null);
      _setUser(null); // force re-login
      _setLoading(false);
    }
  }

  Future<LoginResponse> login(SignInDto data) async {
    try {
      final response = await schema.authLoginPost(body: data);
      final responseBody = response.body;
      if (responseBody != null) {
        setRefreshToken(responseBody.tokens?.refreshToken);
        setAccessToken(responseBody.tokens?.accessToken);
        _setUser(responseBody.user);
        _setLoading(false);
        return responseBody.requiresOtp
            ? LoginResponse.needOtp
            : LoginResponse.success;
      }
      return LoginResponse.error;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      return LoginResponse.error;
    }
  }

  Future<bool> loginOtp(OtpLoginDto data) async {
    try {
      final response = await schema.authLoginOtpPost(body: data);
      final responseBody = response.body;
      final tokens = responseBody?.tokens;
      if (responseBody != null && tokens != null && !responseBody.requiresOtp) {
        setRefreshToken(tokens.refreshToken);
        setAccessToken(tokens.accessToken);
        _setUser(responseBody.user);
        _setLoading(false);
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
