import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/api.provider.dart';

ApiProvider useApi(BuildContext ctx) {
  return Provider.of<ApiProvider>(ctx, listen: true);
}
