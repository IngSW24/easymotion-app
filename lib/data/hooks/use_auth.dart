import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/common/login_response.dart';
import 'package:easymotion_app/data/hooks/use_api.dart';
import 'package:flutter/material.dart';

BaseAuthUserDto? Function() useUserInfo(BuildContext ctx) {
  final api = useApi(ctx);

  return () => api.getUser();
}

bool Function() useIsLoading(BuildContext ctx) {
  final api = useApi(ctx);

  return () => api.isLoading();
}

Future<LoginResponse> Function(SignInDto user) useLoginFn(BuildContext ctx) {
  final api = useApi(ctx);

  return (SignInDto user) => api.login(user);
}

Future<bool> Function(OtpLoginDto user) useLoginOtpFn(BuildContext ctx) {
  final api = useApi(ctx);

  return (OtpLoginDto user) => api.loginOtp(user);
}

Future<bool> Function() useLogoutFn(BuildContext ctx) {
  final api = useApi(ctx);

  return () => api.logout();
}
