import 'package:easymotion_app/api-client-generated/schema.models.swagger.dart';
import 'package:flutter/cupertino.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';
import '../providers/api.provider.dart';

UseMutationResult<IntersectionAccessTokenDtoAuthUserDto?, Exception, SignInDto>
    useLoginFn(BuildContext ctx) {
  final apiProvider = Provider.of<ApiProvider>(ctx);
  return useMutation<IntersectionAccessTokenDtoAuthUserDto?, Exception,
      SignInDto, Null>((SignInDto loginInfo) async {
    final response = await apiProvider.schema.authLoginPost(body: loginInfo);
    return response.body;
  });
}

UseMutationResult<IntersectionAccessTokenDtoAuthUserDto?, Exception, SignInDto>
    useLogoutFn(BuildContext ctx) {
  final apiProvider = Provider.of<ApiProvider>(ctx);
  return useMutation<IntersectionAccessTokenDtoAuthUserDto?, Exception,
      SignInDto, Null>((SignInDto loginInfo) async {
    final response = await apiProvider.schema.authLogoutPost();
    return response.body;
  });
}
