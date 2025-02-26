import 'package:easymotion_app/api-client-generated/client_index.dart';
import 'package:easymotion_app/api-client-generated/schema.models.swagger.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';

UseQueryResult<PaginatedResponseOfCourseEntity?, dynamic> useCourses(
    BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx);
  return useQuery(["courses"], () => getCourses(apiProvider.schema));
}

Future<PaginatedResponseOfCourseEntity?> getCourses(Schema schema) async {
  return (await schema.coursesGet(page: 0, perPage: 100)).body;
}
