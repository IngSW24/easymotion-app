import 'package:easymotion_app/api-client-generated/schema.models.swagger.dart';
import 'package:easymotion_app/data/providers/api.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';

const String courseQueryKey = "course";

UseQueryResult<PaginatedResponseOfCourseEntity?, dynamic> useCourses(
    BuildContext ctx) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx);
  return useQuery(
      [courseQueryKey],
      () async =>
          (await apiProvider.schema.coursesGet(page: 0, perPage: 100)).body);
}

UseQueryResult<CourseEntity?, dynamic> useCourse(BuildContext ctx, String id) {
  ApiProvider apiProvider = Provider.of<ApiProvider>(ctx);
  return useQuery([courseQueryKey, id],
      () async => (await apiProvider.schema.coursesIdGet(id: id)).body);
}
