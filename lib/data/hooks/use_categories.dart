import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';

const String categoriesQueryKey = "categories";

UseQueryResult<List<CourseCategoryDto>?, dynamic> useCategories(
    BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx, listen: false);
  return useQuery(
      [categoriesQueryKey],
      refetchInterval: Duration(seconds: 3),
      () async => (await apiProvider.schema.categoriesGet()).body);
}
