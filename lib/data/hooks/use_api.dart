import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api.provider.dart';

ApiProvider useApi(BuildContext ctx) {
  return Provider.of<ApiProvider>(ctx, listen: true);
}
